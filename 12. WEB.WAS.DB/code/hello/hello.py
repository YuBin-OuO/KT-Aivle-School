from flask import *

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, Flask! :D'

@app.route('/user/<name>')
def user(name):
    return render_template('index.html', name=name)

# jquery 이용해 ajax (비동기 통신)
# request(get:data) > WAS > response(json fomat으로)
@app.route('/people')
def people():
    data = dict(request.values)
    print(data)
    result = {'name':data['name'], 'age':data['age']}
    # 웹 상에서는 데이터를 문자열로만 주고받을 수 있음
    # 딕셔너리를 json 포맷으로 바꾸자
    return jsonify(result)

app.run(debug=True)