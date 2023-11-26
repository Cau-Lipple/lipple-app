import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/bookmark_page.dart';
import 'package:lipple/home_page.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/practice_do_page.dart';
import 'package:lipple/practice_do_vid_page.dart';
import 'package:lipple/practice_page.dart';
import 'package:lipple/specific_category_page.dart';
import 'package:lipple/utils/custom_icons.dart';
import 'package:lipple/entire_category_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorCategoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellCategory');
final _shellNavigatorBookmarkKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellBookmark');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

final goRouter = GoRouter(
  initialLocation: '/',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCategoryKey,
          routes: [
            GoRoute(
              path: '/category',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: EntireCategoryPage(),
              ),
              routes: [
                GoRoute(
                  path: 'specific',
                  builder: (context, state) {
                    final Category category = state.extra as Category;
                    return SpecificCategoryPage(category: category);
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: 'practice',
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: PracticePage(),
                      ),
                    ),
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: 'practice-do',
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: PracticeDoPage(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBookmarkKey,
          routes: [
            GoRoute(
              path: '/bookmark',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: BookmarkPage(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'practice',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: PracticePage(),
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'practice-do',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: PracticeDoVidPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => NoTransitionPage(
                child: Container(
                  color: Colors.purple,
                  alignment: Alignment.center,
                  child: const Text('Page 4'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

// class BaseNavigationBar extends StatefulWidget {
//   const BaseNavigationBar({super.key});
//
//   @override
//   State<BaseNavigationBar> createState() => _BaseNavigationBarState();
// }
//
// class _BaseNavigationBarState extends State<BaseNavigationBar> {
//   int currentPageIndex = 0;
//   static const List<Destination> allDestinations = <Destination>[
//     Destination(0, '홈', CustomIcons.home),
//     Destination(1, '문장연습', CustomIcons.lnr_bubble),
//     Destination(2, '즐겨찾기', CustomIcons.star),
//     Destination(3, '환경설정', CustomIcons.cog),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 5),
//         ]),
//         child: NavigationBar(
//             onDestinationSelected: (int index) {
//               setState(() {
//                 currentPageIndex = index;
//               });
//             },
//             indicatorColor: const Color(0x00000000),
//             surfaceTintColor: Colors.white,
//             selectedIndex: currentPageIndex,
//             destinations: allDestinations.map((Destination destination) {
//               return NavigationDestination(
//                   selectedIcon: Icon(
//                     destination.icon,
//                     color: const Color(0xFF22BB66),
//                     shadows: const [
//                       Shadow(
//                         color: Color(0xFF22BB66),
//                         offset: Offset(0, 1),
//                         blurRadius: 5.0,
//                       )
//                     ],
//                   ),
//                   icon: Icon(
//                     destination.icon,
//                     shadows: const [
//                       Shadow(
//                         color: Color(0xFF938F99),
//                         offset: Offset(0, 1),
//                         blurRadius: 3.0,
//                       )
//                     ],
//                   ),
//                   label: destination.title);
//             }).toList()),
//       ),
//       body: <Widget>[
//         Container(
//           color: Colors.red,
//           alignment: Alignment.center,
//           child: const Text('Page 1'),
//         ),
//         const EntireCategoryPage(),
//         Container(
//           color: Colors.blue,
//           alignment: Alignment.center,
//           child: const Text('Page 3'),
//         ),
//         Container(
//           color: Colors.purple,
//           alignment: Alignment.center,
//           child: const Text('Page 4'),
//         ),
//       ][currentPageIndex],
//     );
//   }
// }

class Destination {
  const Destination(this.index, this.title, this.icon);

  final int index;
  final String title;
  final IconData icon;
}

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  static const List<Destination> allDestinations = <Destination>[
    Destination(0, '홈', CustomIcons.home),
    Destination(1, '문장연습', CustomIcons.lnr_bubble),
    Destination(2, '즐겨찾기', CustomIcons.star),
    Destination(3, '환경설정', CustomIcons.cog),
  ];

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ]),
        child: NavigationBar(
          surfaceTintColor: Colors.white,
          indicatorColor: const Color(0x00000000),
          selectedIndex: navigationShell.currentIndex,
          destinations: allDestinations.map((Destination destination) {
            return NavigationDestination(
              selectedIcon: Icon(
                destination.icon,
                color: const Color(0xFF22BB66),
                shadows: const [
                  Shadow(
                    color: Color(0xFF22BB66),
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                  )
                ],
              ),
              icon: Icon(
                destination.icon,
                shadows: const [
                  Shadow(
                    color: Color(0xFF938F99),
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                  )
                ],
              ),
              label: destination.title,
            );
          }).toList(),
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
