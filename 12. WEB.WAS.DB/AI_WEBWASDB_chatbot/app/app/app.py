# session: 서버와 클라이언트(브라우저) 사이의 연결 정보(접속 정보)
# 한번 로그인하면 브라우저 껐다 키거나 새로고침 해도 로그인 여전히 되어 있도록

from flask import *
import pymongo
import os # 파일 시스템 다룸. 랜덤 시크릿 키 만들기 위해 사용
from datetime import timedelta # 세션 설정 시 시간 계산해 설정하기 위함
import numpy as np # 반올림 위함
import pickle

app = Flask(__name__)
app.secret_key = os.urandom(24) # 24는 seed. 아무거나 넣어줘도 됨
# 세션에 대한 기능은 이미 플라스크 패키지에 들어있음 -> 사용하기 위해선 시크릿키를 Flask 객체에 추가해줘야 함
app.config['SECRET_KEY'] = app.secret_key
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=10) # 10분 동안 세션 유지하겠다는 의미 (10분 후엔 로그인 풀리게끔) default는 31일

uri = 'mongodb://yubin:qwer@43.203.195.144:27017/?authSource=admin'
client = pymongo.MongoClient(uri)

with open('static/models/model.pkl', 'rb') as file: # 바이너리(이진) 데이터니까 rb(read binary) 
    load_model = pickle.load(file)

@app.route('/')
def index():
    user = {}
    # 로그인한 상태일 경우 header에 Contents와 Logout 메뉴 보이도록 (header.html 수정)
    if is_login():
        user['name'] = session['email']
    return render_template('index.html', user = user) # 로그인 되어있을 경우에만 user가 비어있지 않음

@app.route('/join')
def join():
    return render_template('join.html')


@app.route('/login')
def login():
    return render_template('login.html')


@app.route('/contents')
def contents():
    # 컨텐츠 페이지는 로그인한 사람만 볼 수 있어야 함
    if is_login():
        return render_template('contents.html')
        # render_template: url은 /contents에 있으나 화면으로 contents.html 보여줌
    else:
        return redirect('login')
        # redirect: /login url로 이동


@app.route('/api/join', methods=['POST'])
def apt_join():
    account = dict(request.values)
    print(account)
    result = {}
    collection = client.mongo.users
    document = collection.find_one({'email': account['email']})
    if document:
        result['msg'] = 'hasAccount'
    else:
        save_result = collection.insert_one(account)
        print(save_result.inserted_id)
        result['msg'] = 'joinAccount'
    return jsonify(result), 200

# login (login.js 확인)
# 로그인 API 받아줄 라우터
@app.route('/api/login', methods = ['POST']) # 패스워드도 포함되기 때문에 url에 노출되지 않게끔 POST형식으로 받아야 함
def api_login():
    account = dict(request.values) # account 안엔 요청으로 받아온 ID와 pwd들어있을 것
    
    collection = client.mongo.users
    document = collection.find_one({'email': account['email'], 'pw': account['pw']})
    result = {}
    
    if document: # 계정을 DB에서 찾았다면
        result['msg'] = 'login'
        session['email'] = account['email']
        # 서버에 있는 세션 정보에 계정 정보 저장
    else:
        result['msg'] = 'noAccount'
    
    return jsonify(result) # Python 객체를 JSON 형식으로 변환해 string으로 return되게끔

def is_login(): # 브라우저가 서버에 로그인 되어있는지 확인
    # 세션정보에 email 없으면 에러 발생 (예외처리)
    try:
        session['email']
        return True
    except:
        return False
    
@app.route('/logout')
def logout():
    try:
        session.pop('email') # session에 있는 email 중 가장 마지막 것 제거
    except:
        pass
    return redirect('/')

@app.route('/api/category', methods=['POST'])
def api_category():
    data = dict(request.values)
    sentence = data['sentence']
    print(sentence)
    
    result = {}
 
    classification_dict = {100:"정치", 101:"경제", 102:"사회", 103:"생활/문화", 104:"세계", 105:"IT/과학"}
    proba = load_model.predict_proba([sentence])[0]
    result['predict'] = list(zip(classification_dict.values(), np.round(proba * 100, 2)))
    
    category = load_model.predict([sentence])[0]
    result['category'] = classification_dict[category]
    
    return jsonify(result)

@app.errorhandler(404)
def not_found(error):
    return render_template('error.html'), 404

app.run(debug=True)
