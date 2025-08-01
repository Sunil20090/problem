import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/utils/storage_service.dart';

int USER_ID = 0;

var USER_NAME = "";
var USER_TYPE = "GUEST";
var USER_AVATAR_URL;

bool USER_SIGNED_IN = false;
var TOKEN = "";


getUserId() async {
  var obj = await loadJson(STORAGE_KEY_USER);
   return  obj['user_id'];
}