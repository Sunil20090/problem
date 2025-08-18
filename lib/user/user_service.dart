import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/utils/storage_service.dart';

var USER_ID = 0;
var USER_NAME = 'GUEST_USER';
var USER_AVATAR_URL = null;
var USER_AVATAR_THUMBNAIL_URL = null;

saveUser(body) async {
  var obj = {
    "id": body['id'],
    "username": body['username'],
    "name": body['name'],
    "token": body['token'],
    "url": body['url'],
    "thumbnail": body['thumbnail'],
    "type": body['type']
  };

  _initUserService(obj);

  await saveJson(STORAGE_KEY_USER, obj);
}

_initUserService(obj) async {
  USER_ID = obj['id'];
  USER_NAME = obj['username'];
  USER_AVATAR_URL = obj['url'];
  USER_AVATAR_THUMBNAIL_URL = obj['thumbnail'];
}

loadUser() async {
  var obj = await loadJson(STORAGE_KEY_USER);

  print('loadUser : $obj');
  if (obj != null) {
    _initUserService(obj);
  }
  return obj;
}

deleteUser() async {
  await deleteJson(STORAGE_KEY_USER);
}

Future<int> getUserId() async {
  var obj = await loadJson(STORAGE_KEY_USER);
  return obj['user_id'];
}
