from flask import *
import pymongo

app = Flask(__name__)
uri = 'mongodb://kt:ktpw@52.78.161.24:27017/?authSource=admin'
client = pymongo.MongoClient(uri)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/join')
def join():
    return render_template('join.html')


@app.route('/login')
def login():
    return render_template('login.html')


@app.route('/contents')
def contents():
    return render_template('contents.html')


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


@app.errorhandler(404)
def not_found(error):
    return render_template('error.html'), 404


app.run(debug=True)
