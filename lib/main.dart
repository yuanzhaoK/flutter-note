import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'feature/home/view/home_view.dart';
import 'theme.dart';
import 'platform_menus.dart';

Future<void> main() async {
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }
  runApp(const MacosUIGalleryApp());
}

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

class MacosUIGalleryApp extends StatelessWidget {
  const MacosUIGalleryApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'Flutter Motes',
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const WidgetGallery(),
        );
      },
    );
  }
}

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  int _pageIndex = 0;
  late final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: menuBarItems(),
      child: MacosWindow(
        sidebar: Sidebar(
          top: MacosSearchField(
            placeholder: 'Search',
            controller: searchFieldController,
            onResultSelected: (result) {
              switch (result) {
                case 'Home':
                  setState(() {
                    _pageIndex = 0;
                    searchFieldController.clear();
                  });
                  break;
                case 'Explore':
                  setState(() {
                    _pageIndex = 1;
                    searchFieldController.clear();
                  });
              }
            },
            results: const [
              SearchResultItem('Home'),
              SearchResultItem('Explore'),
            ],
          ),

          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: _pageIndex,
              onChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: const [
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.home),
                  label: Text('Home'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.search),
                  label: Text('Explore'),
                ),
              ],
            );
          },
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('Username'),
            subtitle: Text('username@gmail.com'),
          ),
        ),

        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 200,
          shownByDefault: false,
          builder: (context, scrollController) {
            return const Center(child: Text('End Sidebar'));
          },
        ),
        child: [
          const HomeView(),
          const Center(child: Text('Explore')),
        ][_pageIndex],
      ),
    );
  }
}
