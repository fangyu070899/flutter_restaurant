from flask import Flask, request, jsonify
import json
import certifi
from pymongo import MongoClient
from bson.objectid import ObjectId
from bson import json_util
import key

app = Flask(__name__)

def get_database():
   db_name = 'Cluster1'
   CONNECTION_STRING = key.CONNECTION_STRING
   client = MongoClient(CONNECTION_STRING, tlsCAFile=certifi.where())
   return client[db_name]

db = get_database()
posts = db.posts

@app.route('/restaurant/<uuid>', methods=['GET'])
def get_restaurant(uuid):
    print(uuid)
    if(uuid=='Bangkok'):
        j=posts.find_one({'_id': ObjectId('63af39a419f166d1f2b29d16')})
    elif(uuid == 'chaiyi'):
        j=posts.find_one({'_id': ObjectId('63af36cde4c8b0e0a1a8ddd9')})
    elif(uuid == 'hwalian'):
        j=posts.find_one({'_id': ObjectId('63af3ae7e55eabdd3395f01b')})
    elif(uuid == 'tainan'):
        j=posts.find_one({'_id': ObjectId('63af3b31f457f76384cdfa48')})
    elif(uuid == 'taipei'):
        j=posts.find_one({'_id': ObjectId('63af3b586a95b715c1f8718a')})
    
    return json.loads(json_util.dumps(j))

if __name__ == '__main__':
    app.run(host= '127.0.0.1',port='5000',debug=True)