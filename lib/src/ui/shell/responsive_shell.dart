import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResponsiveShell extends StatefulWidget {
  final StatefulNavigationShell shell;
  const ResponsiveShell({super.key, required this.shell});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell>
    with TickerProviderStateMixin {
  late AnimationController _fabController;

  // Soccer-themed navigation destinations
  static const _destinations = [
    _NavigationDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _NavigationDestination(
      icon: Icons.info_outline,
      selectedIcon: Icons.info,
      label: 'About',
    ),
    _NavigationDestination(
      icon: Icons.flag_outlined,
      selectedIcon: Icons.flag,
      label: 'Vision',
    ),
    _NavigationDestination(
      icon: Icons.sports_soccer,
      selectedIcon: Icons.sports_soccer,
      label: 'Events',
    ),
    _NavigationDestination(
      icon: Icons.photo_camera_outlined,
      selectedIcon: Icons.photo_camera,
      label: 'Gallery',
    ),
    _NavigationDestination(
      icon: Icons.person_add_outlined,
      selectedIcon: Icons.person_add,
      label: 'Join',
    ),
    _NavigationDestination(
      icon: Icons.contact_phone_outlined,
      selectedIcon: Icons.contact_phone,
      label: 'Contact',
    ),
    _NavigationDestination(
      icon: Icons.newspaper_outlined,
      selectedIcon: Icons.newspaper,
      label: 'News',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 900;

      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: _buildModernAppBar(context, isWide),
        drawer: isWide ? null : _SoccerDrawer(onTapIndex: _goIndex),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(0.02, 0), end: Offset.zero),
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: widget.shell,
          ),
        ),
        bottomNavigationBar: isWide ? null : _buildSoccerBottomNav(context),
        floatingActionButton:
            null, // Removed floating action button from membership page as it conflicts with page content
      );
    });
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context, bool isWide) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: isWide
          ? null
          : Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF334155)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      title: // IFAA Logo using PNG asset
          Image.asset(
        'assets/images/IFAA.png',
        height: 32,
        width: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image fails to load
          return Container(
            height: 32,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'IFAA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF059669),
                  letterSpacing: 1,
                ),
              ),
            ),
          );
        },
      ),
      centerTitle: false,
      actions: [
        if (isWide) ..._buildDesktopNavigationItems(context),
        if (isWide)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: FilledButton.icon(
              onPressed: () => context.go('/membership'),
              icon: const Icon(Icons.sports_soccer,
                  size: 20), // Increased from 18 to 20
              label: const Text(
                'JOIN',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10), // Slightly increased padding
                minimumSize:
                    const Size(85, 40), // Slightly increased minimum size
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.search,
              color: Color(0xFF475569), size: 22), // Increased from 20 to 22
          onPressed: () {
            // Search functionality
          },
          tooltip: 'Search',
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  List<Widget> _buildDesktopNavigationItems(BuildContext context) {
    return _destinations.asMap().entries.map((entry) {
      final index = entry.key;
      final destination = entry.value;
      final isSelected = widget.shell.currentIndex == index;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: TextButton.icon(
          onPressed: () => _goIndex(index),
          icon: Icon(
            isSelected ? destination.selectedIcon : destination.icon,
            size: 22, // Increased back to 22 to match mobile footer
            color:
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFF475569),
          ),
          label: Text(
            destination.label,
            style: TextStyle(
              fontSize: 13, // Keep at 13 for balance
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF475569),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFF1E3A8A).withOpacity(0.08)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8), // Slightly increased padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(85, 40), // Slightly increased minimum width
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSoccerBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final destination = entry.value;
              final isSelected = widget.shell.currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => _goIndex(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E3A8A).withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected
                                ? destination.selectedIcon
                                : destination.icon,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF475569),
                            size: 22,
                            key: ValueKey('$index-$isSelected'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination.label,
                          style: TextStyle(
                            fontSize: 10, // Reduced font size
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF475569),
                          ),
                          textAlign: TextAlign.center, // Center align text
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _goIndex(int i) {
    setState(() {
      _fabController.reset();
      _fabController.forward();
    });
    widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex);
  }
}

class _NavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _SoccerDrawer extends StatelessWidget {
  final void Function(int) onTapIndex;

  // Soccer-themed navigation destinations (copy from parent)
  static const _destinations = [
    _NavigationDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _NavigationDestination(
      icon: Icons.info_outline,
      selectedIcon: Icons.info,
      label: 'About',
    ),
    _NavigationDestination(
      icon: Icons.flag_outlined,
      selectedIcon: Icons.flag,
      label: 'Vision',
    ),
    _NavigationDestination(
      icon: Icons.sports_soccer,
      selectedIcon: Icons.sports_soccer,
      label: 'Events',
    ),
    _NavigationDestination(
      icon: Icons.photo_camera_outlined,
      selectedIcon: Icons.photo_camera,
      label: 'Gallery',
    ),
    _NavigationDestination(
      icon: Icons.person_add_outlined,
      selectedIcon: Icons.person_add,
      label: 'Join',
    ),
    _NavigationDestination(
      icon: Icons.contact_phone_outlined,
      selectedIcon: Icons.contact_phone,
      label: 'Contact',
    ),
    _NavigationDestination(
      icon: Icons.newspaper_outlined,
      selectedIcon: Icons.newspaper,
      label: 'News',
    ),
  ];

  const _SoccerDrawer({required this.onTapIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Modern soccer-themed header
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&h=600&fit=crop'),
                        fit: BoxFit.cover,
                        opacity: 0.2,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'IFAA',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Iranian Football Association Australia',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _destinations.length,
              itemBuilder: (context, i) {
                final d = _destinations[i];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: ListTile(
                    leading: Icon(
                      d.icon,
                      color: const Color(0xFF1E3A8A),
                    ),
                    title: Text(
                      d.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onTapIndex(i);
                    },
                  ),
                );
              },
            ),
          ),

          // Footer section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'JOIN OUR TEAM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Become a member today',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
