import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Dynamic Hero Section - Soccer Stadium Style
        SliverToBoxAdapter(
          child: Container(
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A), // Deep blue
                  Color(0xFF3B82F6), // Lighter blue
                ],
              ),
            ),
            child: Stack(
              children: [
                // Stadium background pattern
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back-ifaa.png'),
                        fit: BoxFit.cover,
                        opacity: 0.15,
                      ),
                    ),
                  ),
                ),
                
                // Geometric overlay pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Hero Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IFAA Logo Image - Left aligned without background
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/IFAA.png',
                              height: 120,
                              width: 240,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image fails to load
                                return Container(
                                  height: 120,
                                  width: 240,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'IFAA',
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        'IRANIAN FOOTBALL ASSOCIATION AUSTRALIA',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: const Color(0xFF10B981),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Subtitle
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Text(
                            'Building champions, fostering community, and celebrating the beautiful game across Australia. Join our growing family of football enthusiasts.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.6,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // CTA Buttons
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _SoccerButton(
                              onPressed: () => context.go('/membership'),
                              label: 'JOIN THE TEAM',
                              icon: Icons.sports_soccer,
                              isPrimary: true,
                            ),
                            _SoccerButton(
                              onPressed: () => context.go('/events'),
                              label: 'UPCOMING MATCHES',
                              icon: Icons.calendar_today,
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Team Statistics Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'COMMUNITY IMPACT',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        number: '500+',
                        label: 'ACTIVE MEMBERS',
                        color: const Color(0xFF1E3A8A),
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        number: '24',
                        label: 'EVENTS YEARLY',
                        color: const Color(0xFF059669),
                        icon: Icons.event,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        number: '8',
                        label: 'CHAMPIONSHIP WINS',
                        color: const Color(0xFFEA580C),
                        icon: Icons.emoji_events,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Services/Features Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHAT WE OFFER',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover our programs and services designed for the Iranian football community',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        
        // Feature Cards Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              childAspectRatio: 1.1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            delegate: SliverChildListDelegate([
              _FeatureCard(
                title: 'YOUTH ACADEMY',
                description: 'Professional training programs for young talented players with certified coaches.',
                icon: Icons.school,
                gradient: const [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                onTap: () => context.go('/vision'),
              ),
              _FeatureCard(
                title: 'TOURNAMENTS',
                description: 'Regular competitions and friendly matches within the Australian football community.',
                icon: Icons.emoji_events,
                gradient: const [Color(0xFF059669), Color(0xFF10B981)],
                onTap: () => context.go('/events'),
              ),
              _FeatureCard(
                title: 'NEWS & UPDATES',
                description: 'Stay connected with the latest news, match results, and community announcements.',
                icon: Icons.newspaper,
                gradient: const [Color(0xFFEA580C), Color(0xFFF59E0B)],
                onTap: () => context.go('/news'),
              ),
              _FeatureCard(
                title: 'PHOTO GALLERY',
                description: 'Relive the best moments from our matches, training sessions, and events.',
                icon: Icons.photo_camera,
                gradient: const [Color(0xFF7C3AED), Color(0xFFA855F7)],
                onTap: () => context.go('/gallery'),
              ),
            ]),
          ),
        ),
        
        // Call to Action Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF059669), Color(0xFF10B981)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.sports_soccer,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 20),
                Text(
                  'READY TO JOIN THE TEAM?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Become part of Australia\'s premier Iranian football community',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _SoccerButton(
                  onPressed: () => context.go('/membership'),
                  label: 'START YOUR JOURNEY',
                  icon: Icons.arrow_forward,
                  isPrimary: true,
                  isLight: true,
                ),
              ],
            ),
          ),
        ),
        
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }
  
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 2;
    return 1;
  }
}

class _SoccerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isLight;
  
  const _SoccerButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.isPrimary,
    this.isLight = false,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: isLight ? Colors.white : const Color(0xFF10B981),
          foregroundColor: isLight ? const Color(0xFF1E3A8A) : Colors.white,
          elevation: isLight ? 0 : 4,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
      );
    }
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  final IconData icon;
  
  const _StatCard({
    required this.number,
    required this.label,
    required this.color,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 32,
            color: color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          number,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  
  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Arrow indicator
                Row(
                  children: [
                    Text(
                      'LEARN MORE',
                      style: TextStyle(
                        color: gradient.first,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: gradient.first.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: gradient.first,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}