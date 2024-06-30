import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';

class ChangeLanguageController extends GetxController {
  Repo repo = Repo(WebService());
  var lang="";
}