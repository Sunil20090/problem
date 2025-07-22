import 'package:election/components/floating_label_edit_box.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              ScreenActionBar(title: 'Create Profile'),

              addVerticalSpace(40),
            
                

              
            ],
          )
        ),
      ),
    );
  }
}




/*
import os
import sys
import DBhelper as dbh
import json
import uuid
from urllib.parse import parse_qs
from io import BytesIO
from PIL import Image
from Util import createDir, getRandomHash, getRandomNumber
import base64

sys.path.insert(0, os.path.dirname(__file__))

def Application(environ, start_response):
    start_response('200 OK', [
        ('Content-Type', 'application/json'),  
        ('Access-Control-Allow-Origin', '*'), 
        ('Access-Control-Allow-Methods', 'GET, POST, OPTIONS'),
        ('Access-Control-Allow-Headers', 'Content-Type, Authorization')])
    
    # authenticate(environ)
    
    localDomain  = '../../public_html/files/elections/problem/images/'
    public_domain = 'https://compacttoolbox.com/files/elections/problem/images/'
    
    route_path = environ['PATH_INFO']
    
    if route_path == '/applyNomination':
        response =  nomination(environ)
        
        return get_response(response)
        
    if route_path == '/postComment':
        
        payload = get_payload(environ)
        
        insert_query = dbh.insertQuery(f"""INSERT INTO elections.comments(user_name, content, user_url, problem_id) VALUES (
                                        %s, %s, %s, %s)""", (payload['user_name'], payload['content'], payload['user_url'], payload['problem_id'], ))
        
        res = {}                    
        if(insert_query['success']):
            return get_response(json.dumps(create_json('OK', "Success!")))
        
        return ['{"failed" : "failed"}'.encode()];
        
        
    if route_path == '/createUser':
        
        payload = get_payload(environ)
        
        if(payload.get('name') is None):
            payload = {}
            payload['profile_description'] = ""
            payload['profile_url'] = "https://static.vecteezy.com/system/resources/thumbnails/020/911/740/small/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png"
        
        
            insert_user_query = "INSERT INTO elections.users(name, user_name, profile_description, profile_url) VALUES (%s, user_name + id, %s, %s)"
        
        insert_response = dbh.insertQuery(insert_user_query, (payload['name'], payload['user_name'], payload['profile_description'], payload['profile_url']))
        
        return ['success'.encode()]
        
        
    if route_path == '/getUser':
        params = get_url_params(environ)
        
        get_user_query = "SELECT user_name, profile_description, profile_url, id, created_on FROM elections.users WHERE id = %s"
        
        query_res = dbh.selectQueryToJson(get_user_query, (params['id'][0],))
        
        json_obj = json.dumps(json.loads(query_res['json'])[0])
        
        return [json_obj.encode()]
        
    if route_path == '/getCommentList': 
        
        params = get_url_params(environ)
        
        return get_response_from_query("SELECT * FROM elections.comments Where problem_id = %s", (params['problem_id'][0],) )
        
    if route_path == '/createForm':
        payload = get_payload(environ)
        
        # print(payload)
        
        unique_id = get_unique_id()
        
        insert_response = dbh.insertQuery("""INSERT INTO elections.forms(form_id, mail_id, form_title, college_name, year_of_admission, semester, branch, mode)
        VALUES (%s, %s, %s,%s,%s,%s, %s, %s)""", 
                (unique_id, payload['username'], payload['title'], payload['collegeName'],payload['yearOfAdmission'],  payload['semester'], payload['branch'], 'nomination'))
                
        if (insert_response['success']):
            return get_response(json.dumps(create_json("OK", "Form created successfully")))
        else:
            return get_response(json.dumps(create_json("NOT OK", "Something went wrong!")))
    
    if route_path == '/addForm':
        
        payload = get_payload(environ)
        
        form_data = {}
        
        for key in ["fullName", "types", "collegeName"]:
            if key in payload:
                form_data[key] = payload[key]
        
        form_data_string = json.dumps(form_data)
        
        insert_response = dbh.insertQuery("INSERT INTO elections.forms(form_id, mail_id, forms_data) VALUES (%s, %s, %s)", (
                        unique_id, payload['mailId'], form_data_string))
                        
        return get_response(json.dumps(create_json("OK", "Form registered successfully")))
        
    if route_path == '/postProblem':
        
        payload = get_payload(environ)
        
        createDir(localDomain)
        
        file_name = f'image{getRandomHash(10)}.png'
        
        thumbnail_file_name = f'image_thumbnail_{getRandomHash(10)}.png'
        
        image_data = base64.b64decode(payload['image'])
        
        image = Image.open(BytesIO(image_data))
        
        image.save(localDomain + file_name)
        
        thumnail_max_size = (35, 40)
        
        image.thumbnail(thumnail_max_size)
        
        image.save(localDomain + thumbnail_file_name)
        
        image_url = public_domain + file_name
        
        thumbnail_url = public_domain + thumbnail_file_name
        
        response_json = create_json("OK", "Posted successfully!")
        
        
        insert_res = dbh.insertQuery("""INSERT INTO elections.problems (posted_by, avatar_url,title, description, image_url, thumbnail_url) VALUES 
                                        (%s, %s, %s, %s, %s, %s)""", (payload['user_name'], payload['avatar_url'], payload['title'], payload['description'], image_url,  thumbnail_url) )
        
        if(insert_res['success']):
        
            return [json.dumps(response_json).encode()] 
        else:
            return [json.dumps(create_json("NOT OK", "SOMETHING WENT WRONG!"))]
        
        
    if route_path == '/getElectionList':
        
        form_list = []
        
        query_string = """SELECT 
            forms.*, 
            n.count 
        FROM 
            elections.forms 
        LEFT JOIN (
            SELECT 
                foreign_form_id, 
                COUNT(*) AS count 
            FROM 
                elections.nomination 
            GROUP BY 
                foreign_form_id
        ) AS n 
        ON forms.form_id = n.foreign_form_id;"""
        
        form_list_db_response = dbh.selectQueryToJson(query_string + "%s", ('', ))
        
        if form_list_db_response['success']:
            form_list = form_list_db_response['json']
            
        response = form_list
        
        return [response.encode()]
    
    
    if route_path == '/email':
        return get_response(email())
        
    if route_path == '/problemList':
        
        query_problem = "SELECT id, title, description, image_url, avatar_url, thumbnail_url from  elections.problems where '1' = %s"
        
        query_res = dbh.selectQueryToJson(query_problem, ('1',))
        
        if query_res['success']:
            response = query_res['json']
        
        
    return [response.encode()]


def get_response_from_query(query, param):
    return get_response(dbh.selectQueryToJson(query, param)['json'])
    
def authenticate(environ):
    
    auth_header = environ.get('HTTP_AUTHORIZATION')

    if not auth_header:
        raise PermissionError("Missing Authorization Header")

    
    if not auth_header.startswith("Bearer "):
        raise PermissionError("Invalid Authorization Format")

    token = auth_header.split("Bearer ")[1]
    
    if token != "your-secret-token":
        raise PermissionError("Invalid Token")
    
def get_response(content):
    return [content.encode()]
    
def no_email_json():
    status = "NOT OK"
    message = "Email Id not provided"
    return create_json(status, message)
    
def create_json(status, message):
    return {"status" : status, "message" : message}
    
def get_url_params(environ):
    return parse_qs(environ['QUERY_STRING'])

def email():
    response = ''
    unique_id = get_unique_id()
    
    insert_response = dbh.insertQuery("INSERT INTO elections.forms(form_id, mail_id, forms_data) VALUES (%s, %s, %s)", (
        unique_id, 'sunil.kumar99', "{'data' : [{'edit' : {'hint' : 'student id'}}]}"))
    
    return unique_id
    

def get_unique_id():
    unique_id = str(uuid.uuid4())
    return unique_id
    

def nomination(environ):
    payload = get_payload(environ)
    
    insert_response = dbh.insertQuery("INSERT INTO elections.nomination(roll_number, position, foreign_form_id) VALUES (%s, %s, %s)", (
        payload['rollNumber'], payload['position'], payload['formId']))
    
    response = 'Failed'
    
    if insert_response['success']:
        response = json.dumps({'status': 'success', 'message' : 'Your nomination is applied!', 'data' : []})
    return response
    
    
def get_payload(environ):
    
    request_bytes = environ['wsgi.input'].read()
        
    return json.loads(request_bytes)


*/