import 'package:flutter/material.dart';

import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/helpers.dart';

class SILSmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SILSmallAppBar({
    Key? key,
    required this.title,
    this.tabTitles,
    this.backRoute,
    this.backButtonKey,
    this.tabBarKey,
    this.size,
    this.elevation,
    this.backRouteNavigationFunction,
    this.formatTitle = true,
  }) : super(key: key);

  final Key? backButtonKey;
  final String? backRoute;
  final double? elevation;
  final double? size;
  final Key? tabBarKey;
  final List<String>? tabTitles;
  final String title;
  final bool formatTitle;
  final Function? backRouteNavigationFunction;

  @override
  Size get preferredSize => Size.fromHeight(size ?? 60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: elevation ?? 5,
      leading: IconButton(
        key: backButtonKey,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (backRoute != null) {
            if (backRouteNavigationFunction != null) {
              backRouteNavigationFunction!();
            } else {
              Navigator.pushReplacementNamed(context, backRoute!);
            }
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      centerTitle: true,
      title: Text(formatTitle ? titleCase(title) : title,
          style: TextThemes.boldSize20Text()),
      bottom: tabTitles != null && tabTitles!.isNotEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: DefaultTabController(
                    length: tabTitles!.length,
                    child: TabBar(
                      key: tabBarKey,
                      indicatorColor: Theme.of(context).backgroundColor,
                      tabs: <Tab>[
                        ...tabTitles!.map(
                          (String tabTitle) => Tab(
                            child: Text(
                              tabTitle,
                              style: TextThemes.heavySize16Text(
                                  Theme.of(context).backgroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
