import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/shell/responsive_shell.dart';
import 'ui/pages/pages.dart';
import 'ui/pages/news_management_page.dart';

GoRouter buildRouter() => GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navShell) => ResponsiveShell(shell: navShell),
          branches: [
            _branch('/', const HomePage()),
            _branch('/about', const AboutPage()),
            _branch('/vision', const VisionPage()),
            _branch('/events', const EventsPage()),
            _branch('/gallery', const GalleryPage()),
            _branch('/membership', const MembershipPage()),
            _branch('/contact', const ContactPage()),
            _branch('/news', const NewsPage()),
          ],
        ),
        GoRoute(
          path: '/event/:id',
          builder: (context, state) => EventDetailPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) => NewsDetailPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: '/news-management',
          builder: (context, state) => const NewsManagementPage(),
        ),
      ],
    );

StatefulShellBranch _branch(String path, Widget page) {
  return StatefulShellBranch(routes: [
    GoRoute(
      path: path,
      pageBuilder: (context, state) => NoTransitionPage(child: page),
    ),
  ]);
}