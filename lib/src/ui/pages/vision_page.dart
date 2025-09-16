import 'package:flutter/material.dart';

class VisionPage extends StatelessWidget {
  const VisionPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: CustomScrollView(
        slivers: [
          // Hero Header Section
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF059669), Color(0xFF10B981)],
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'IFAA VISION',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Building the future of Iranian football in Australia through community, excellence, and youth development',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
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

          // Vision Cards Section
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'OUR THREE PILLARS',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: const Color(0xFF1F2937),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Our vision is built on three fundamental pillars that guide everything we do',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF374151),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Vision Card 1: Community Engagement
                const _VisionCard(
                  title: 'COMMUNITY ENGAGEMENT',
                  subtitle: 'Inclusiveness & Excellence Through Football',
                  description: 'Engaging with the community with focus on inclusiveness and capitalizing on excellence, potential and enjoyment through football.',
                  icon: Icons.people,
                  gradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  benefits: [
                    'Building inclusive football communities',
                    'Celebrating diversity and cultural heritage',
                    'Creating opportunities for all skill levels',
                    'Fostering excellence and personal growth',
                    'Promoting enjoyment and passion for football',
                    'Strengthening bonds within Iranian diaspora',
                  ],
                  details: 'We believe football is a universal language that brings people together. Our community-focused approach ensures every member feels valued, supported, and empowered to reach their potential while celebrating our rich Iranian heritage.',
                ),

                const SizedBox(height: 32),

                // Vision Card 2: High Performance
                const _VisionCard(
                  title: 'HIGH PERFORMANCE PATHWAY',
                  subtitle: 'Premier Talent Development in Australia',
                  description: 'High Performance objective: ensure the IFAA has the premier community talent development pathway in Australia.',
                  icon: Icons.trending_up,
                  gradient: [Color(0xFF059669), Color(0xFF10B981)],
                  benefits: [
                    'Professional coaching and training programs',
                    'Structured talent identification and development',
                    'Pathway to elite level football',
                    'Performance analysis and monitoring',
                    'Mentorship from experienced players',
                    'Competition at the highest community levels',
                  ],
                  details: 'Our high-performance program is designed to identify, nurture, and develop exceptional talent. We provide comprehensive training, expert coaching, and clear pathways for players to reach their maximum potential in Australian football.',
                ),

                const SizedBox(height: 32),

                // Vision Card 3: Youth Academy
                const _VisionCard(
                  title: 'YOUTH ACADEMY',
                  subtitle: 'Nurturing the Next Generation',
                  description: 'To establish Football/Futsal Academy for young generation of Iranian boys and girls.',
                  icon: Icons.school,
                  gradient: [Color(0xFFEA580C), Color(0xFFF59E0B)],
                  benefits: [
                    'Age-appropriate training programs',
                    'Technical skill development',
                    'Character building and life skills',
                    'Equal opportunities for boys and girls',
                    'Cultural identity preservation',
                    'Safe and supportive environment',
                  ],
                  details: 'Our Youth Academy is the cornerstone of our future. We are committed to establishing comprehensive football and futsal programs that nurture young Iranian talent, instill values of teamwork and discipline, and create pathways for lifelong involvement in football.',
                ),

                const SizedBox(height: 40),

                // Call to Action
                Container(
                  padding: const EdgeInsets.all(32),
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
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'BE PART OF OUR VISION',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Join us in building the premier Iranian football community in Australia',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () => {}, // Add navigation logic
                            icon: const Icon(Icons.join_full),
                            label: const Text('JOIN OUR COMMUNITY'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF059669),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => {}, // Add navigation logic
                            icon: const Icon(Icons.info_outline),
                            label: const Text('LEARN MORE'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final List<String> benefits;
  final String details;

  const _VisionCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.benefits,
    required this.details,
  });

  @override
  State<_VisionCard> createState() => _VisionCardState();
}

class _VisionCardState extends State<_VisionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradient,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2937), // Explicitly set dark color for better readability
                  ),
                ),

                // Expandable Content
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Details Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: widget.gradient.first.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.gradient.first.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: widget.gradient.first,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DETAILED OVERVIEW',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: widget.gradient.first,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.details,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    height: 1.6,
                                    color: const Color(0xFF1F2937), // Explicitly set dark color for better readability
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Benefits Section
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: widget.gradient.first,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'KEY BENEFITS & INITIATIVES',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: widget.gradient.first,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Benefits Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          childAspectRatio:
                              MediaQuery.of(context).size.width > 600 ? 4 : 6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: widget.benefits.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color:
                                        widget.gradient.first.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: widget.gradient.first,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.benefits[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1F2937), // Explicitly set dark color for better readability
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Expand/Collapse Button
                Center(
                  child: TextButton.icon(
                    onPressed: _toggleExpansion,
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.gradient.first,
                      ),
                    ),
                    label: Text(
                      _isExpanded ? 'SHOW LESS' : 'LEARN MORE',
                      style: TextStyle(
                        color: widget.gradient.first,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
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