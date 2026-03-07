import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/generated/app_localizations.dart';
import 'package:vibe_music_app/src/controllers/theme_controller.dart';
import 'package:vibe_music_app/src/pages/home/widgets/controller.dart';
import 'package:vibe_music_app/src/routes/app_routes.dart';
import 'package:vibe_music_app/src/utils/glass_morphism/responsive_layout.dart';
import 'package:vibe_music_app/src/utils/glass_morphism/sidebar_navigation.dart';
import 'package:vibe_music_app/src/pages/home/components/song_list_page.dart';
import 'package:vibe_music_app/src/pages/home/components/profile_page.dart';
import 'package:vibe_music_app/src/pages/home/components/currently_playing_bar.dart';
import 'package:vibe_music_app/src/pages/player/player_page.dart';
import 'package:vibe_music_app/src/pages/favorites/favorites_page.dart';
import 'package:vibe_music_app/src/pages/settings/settings_page.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildMobileLayout(context),
      tabletLayout: _buildTabletLayout(context),
      desktopLayout: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isGlassMorphism = themeController.isGlassMorphismTheme();

    return Scaffold(
      body: isGlassMorphism
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Obx(() => _getCurrentPage()),
                  Obx(() => controller.currentPage.value != 1
                      ? const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: CurrentlyPlayingBar(),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            )
          : Stack(
              children: [
                Obx(() => _getCurrentPage()),
                Obx(() => controller.currentPage.value != 1
                    ? const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CurrentlyPlayingBar(),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Obx(() => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: controller.currentPage.value > 3
                    ? 0
                    : controller.currentPage.value,
                onDestinationSelected: controller.changePage,
                destinations: [
                  NavigationDestination(
                      icon: Icon(Icons.music_note),
                      label: AppLocalizations.of(context)?.songs ?? '歌曲'),
                  NavigationDestination(
                      icon: Icon(Icons.play_circle),
                      label: AppLocalizations.of(context)?.player ?? '播放'),
                  NavigationDestination(
                      icon: Icon(Icons.favorite),
                      label: AppLocalizations.of(context)?.favorites ?? '收藏'),
                  NavigationDestination(
                      icon: Icon(Icons.person),
                      label: AppLocalizations.of(context)?.my ?? '我的'),
                ],
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            )),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isGlassMorphism = themeController.isGlassMorphismTheme();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isGlassMorphism
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Obx(() => SidebarNavigation(
                          currentIndex:
                              _getSidebarIndex(controller.currentPage.value),
                          onDestinationSelected: (index) =>
                              controller.changePage(_getMainPageIndex(index)),
                        )),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Obx(() => _getCurrentPage()),
                        Obx(() => controller.currentPage.value != 1
                            ? const Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CurrentlyPlayingBar(),
                              )
                            : const SizedBox.shrink()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Container(
                  width: 200,
                  child: Obx(() => SidebarNavigation(
                        currentIndex:
                            _getSidebarIndex(controller.currentPage.value),
                        onDestinationSelected: (index) =>
                            controller.changePage(_getMainPageIndex(index)),
                      )),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() => _getCurrentPage()),
                      Obx(() => controller.currentPage.value != 1
                          ? const Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CurrentlyPlayingBar(),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isGlassMorphism = themeController.isGlassMorphismTheme();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isGlassMorphism
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
              child: Row(
                children: [
                  AdaptiveSidebarWidth(
                    child: Obx(() => SidebarNavigation(
                          currentIndex:
                              _getSidebarIndex(controller.currentPage.value),
                          onDestinationSelected: (index) =>
                              controller.changePage(_getMainPageIndex(index)),
                        )),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Obx(() => controller.currentPage.value == 0
                            ? Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: TopNavigationBar(
                                  title: Text(''),
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.search,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Get.toNamed(AppRoutes.search),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink()),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(
                                  top: controller.currentPage.value == 0
                                      ? 70
                                      : 0),
                              child: _getCurrentPage(),
                            )),
                        Obx(() => controller.currentPage.value != 1
                            ? const Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CurrentlyPlayingBar(),
                              )
                            : const SizedBox.shrink()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                AdaptiveSidebarWidth(
                  child: Obx(() => SidebarNavigation(
                        currentIndex:
                            _getSidebarIndex(controller.currentPage.value),
                        onDestinationSelected: (index) =>
                            controller.changePage(_getMainPageIndex(index)),
                      )),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() => controller.currentPage.value == 0
                          ? Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: TopNavigationBar(
                                title: Text(''),
                                actions: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.search, color: Colors.white),
                                    onPressed: () =>
                                        Get.toNamed(AppRoutes.search),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink()),
                      Obx(() => Padding(
                            padding: EdgeInsets.only(
                                top:
                                    controller.currentPage.value == 0 ? 70 : 0),
                            child: _getCurrentPage(),
                          )),
                      Obx(() => controller.currentPage.value != 1
                          ? const Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CurrentlyPlayingBar(),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _getCurrentPage() {
    return IndexedStack(
      index: controller.currentPage.value,
      children: [
        const SongListPage(),
        const PlayerPage(),
        const FavoritesPage(),
        const ProfilePage(),
        const SettingsPage(),
      ],
    );
  }

  int _getSidebarIndex(int mainPageIndex) {
    switch (mainPageIndex) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 4;
      default:
        return 0;
    }
  }

  int _getMainPageIndex(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 4;
      default:
        return 0;
    }
  }
}

class TopNavigationBar extends StatelessWidget {
  final Widget title;
  final List<Widget>? actions;

  const TopNavigationBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title is Text ? (title as Text).data ?? '' : title.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            if (actions != null) Row(children: actions!),
          ],
        ),
      ),
    );
  }
}
