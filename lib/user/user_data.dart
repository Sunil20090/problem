import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/utils/storage_service.dart';

int USER_ID = 0;




Future<int> getUserId() async {
  var obj = await loadJson(STORAGE_KEY_USER);
   return  obj['user_id'];
}