import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/generated/app_localizations.dart';
import 'package:vibe_music_app/src/components/glass_morphism_background.dart';
import 'package:vibe_music_app/src/controllers/theme_controller.dart';
import 'package:vibe_music_app/src/controllers/language_controller.dart';
import 'package:vibe_music_app/src/utils/glass_morphism/responsive_layout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentLevel = 0;

  void _navigateToLevel(int level) {
    setState(() {
      _currentLevel = level;
    });
  }

  void _goBack() {
    if (_currentLevel > 0) {
      setState(() {
        _currentLevel = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ResponsiveLayout(
      mobileLayout: _buildMobileLayout(context, localizations),
      tabletLayout: _buildDesktopLayout(context, localizations),
      desktopLayout: _buildDesktopLayout(context, localizations),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, AppLocalizations localizations) {
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();

    return GlassMorphismBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _currentLevel > 0
            ? AppBar(
                title: Text(_getPageTitle(localizations)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: isMusikeTheme ? Colors.black87 : Colors.white,
              )
            : AppBar(
                title: Text(localizations.settings),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: isMusikeTheme ? Colors.black87 : Colors.white,
              ),
        body: _buildCurrentPage(localizations),
      ),
    );
  }

  Widget _buildDesktopLayout(
      BuildContext context, AppLocalizations localizations) {
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();
    final textColor = isMusikeTheme ? Colors.black87 : Colors.white;
    final iconColor = isMusikeTheme ? const Color(0xFF6366F1) : Colors.white;

    return GlassMorphismBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentLevel > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: iconColor),
                      onPressed: _goBack,
                    ),
                  Icon(
                    _getPageIcon(),
                    size: 28,
                    color: iconColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getPageTitle(localizations),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildCurrentPage(localizations),
            ),
          ],
        ),
      ),
    );
  }

  String _getPageTitle(AppLocalizations localizations) {
    switch (_currentLevel) {
      case 1:
        return localizations.theme;
      case 2:
        return localizations.language;
      default:
        return localizations.settings;
    }
  }

  IconData _getPageIcon() {
    switch (_currentLevel) {
      case 1:
        return Icons.color_lens;
      case 2:
        return Icons.language;
      default:
        return Icons.settings;
    }
  }

  Widget _buildCurrentPage(AppLocalizations localizations) {
    switch (_currentLevel) {
      case 1:
        return _buildThemePage(localizations);
      case 2:
        return _buildLanguagePage(localizations);
      default:
        return _buildSettingsMenu(localizations);
    }
  }

  Widget _buildSettingsMenu(AppLocalizations localizations) {
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMenuItem(
          icon: Icons.color_lens,
          title: localizations.theme,
          isMusikeTheme: isMusikeTheme,
          onTap: () => _navigateToLevel(1),
        ),
        Divider(
          color: isMusikeTheme
              ? Colors.grey.shade300
              : Colors.white.withValues(alpha: 0.2),
        ),
        _buildMenuItem(
          icon: Icons.language,
          title: localizations.language,
          isMusikeTheme: isMusikeTheme,
          onTap: () => _navigateToLevel(2),
        ),
        Divider(
          color: isMusikeTheme
              ? Colors.grey.shade300
              : Colors.white.withValues(alpha: 0.2),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isMusikeTheme = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isMusikeTheme ? const Color(0xFF6366F1) : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isMusikeTheme ? Colors.black87 : Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isMusikeTheme ? Colors.black54 : Colors.white70,
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemePage(AppLocalizations localizations) {
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isMusikeTheme
              ? Colors.grey.shade100
              : Colors.white.withValues(alpha: 0.1),
        ),
        child: Obx(() => Column(
              children: [
                RadioListTile<ThemeType>(
                  value: ThemeType.musike,
                  groupValue: themeController.themeType.value,
                  onChanged: (value) {
                    if (value != null) {
                      themeController.changeTheme(value);
                    }
                  },
                  title: Text(
                    'Musike',
                    style: TextStyle(
                      color: isMusikeTheme ? Colors.black87 : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Modern Music UI',
                    style: TextStyle(
                      color: isMusikeTheme ? Colors.black54 : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  activeColor: const Color(0xFF6366F1),
                ),
                Divider(
                  color: isMusikeTheme
                      ? Colors.grey.shade300
                      : Colors.white.withValues(alpha: 0.2),
                  height: 1,
                ),
                RadioListTile<ThemeType>(
                  value: ThemeType.dark,
                  groupValue: themeController.themeType.value,
                  onChanged: (value) {
                    if (value != null) {
                      themeController.changeTheme(value);
                    }
                  },
                  title: Text(
                    localizations.darkMode,
                    style: TextStyle(
                      color: isMusikeTheme ? Colors.black87 : Colors.white,
                    ),
                  ),
                  activeColor: const Color(0xFF6366F1),
                ),
                Divider(
                  color: isMusikeTheme
                      ? Colors.grey.shade300
                      : Colors.white.withValues(alpha: 0.2),
                  height: 1,
                ),
                RadioListTile<ThemeType>(
                  value: ThemeType.glassMorphism,
                  groupValue: themeController.themeType.value,
                  onChanged: (value) {
                    if (value != null) {
                      themeController.changeTheme(value);
                    }
                  },
                  title: Text(
                    localizations.glassMorphismMode,
                    style: TextStyle(
                      color: isMusikeTheme ? Colors.black87 : Colors.white,
                    ),
                  ),
                  activeColor: const Color(0xFF6366F1),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildLanguagePage(AppLocalizations localizations) {
    final languageController = Get.find<LanguageController>();
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isMusikeTheme
              ? Colors.grey.shade100
              : Colors.white.withValues(alpha: 0.1),
        ),
        child: Obx(() => Column(
              children: languageController.languageOptions.map((option) {
                String displayName;
                switch (option.code) {
                  case 'system':
                    displayName = localizations.systemLanguage;
                    break;
                  case 'en':
                    displayName = localizations.english;
                    break;
                  case 'zh':
                    displayName = localizations.chinese;
                    break;
                  case 'zh_TW':
                    displayName = localizations.traditionalChinese;
                    break;
                  default:
                    displayName = option.code;
                }

                return Column(
                  children: [
                    RadioListTile<String>(
                      value: option.code,
                      groupValue: languageController.languageCode.value,
                      onChanged: (value) {
                        if (value != null) {
                          languageController.changeLanguage(value);
                        }
                      },
                      title: Text(
                        displayName,
                        style: TextStyle(
                          color: isMusikeTheme ? Colors.black87 : Colors.white,
                        ),
                      ),
                      activeColor: const Color(0xFF6366F1),
                    ),
                    if (option != languageController.languageOptions.last)
                      Divider(
                        color: isMusikeTheme
                            ? Colors.grey.shade300
                            : Colors.white.withValues(alpha: 0.2),
                        height: 1,
                      ),
                  ],
                );
              }).toList(),
            )),
      ),
    );
  }
}
