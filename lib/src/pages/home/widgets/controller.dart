import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentPage = 0.obs;

  final pageTitles = {
    0: '音乐库',
    1: '播放器',
    2: '我的收藏',
    3: '个人中心',
    4: '设置',
  };

  void changePage(int index) {
    currentPage.value = index;
  }

  String getCurrentPageTitle() {
    return pageTitles[currentPage.value] ?? 'Vibe Music Player';
  }

  void navigateToSettings() {
    currentPage.value = 4;
  }
}
