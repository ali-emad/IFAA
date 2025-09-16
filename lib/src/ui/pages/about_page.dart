import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ABOUT US',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Learn about IFAA - Iranian Football Association Australia',
                              style: TextStyle(
                                fontSize: 14,
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
          
          // COVID-19 Notice
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEA580C),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COVID-19 Safety Notice',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This event observes all COVID-19 requirements. Please adhere to NSW government rules, maintain 1.5m distance, and regularly sanitize your hands.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.95),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // WHO WE ARE Section
          const SliverToBoxAdapter(
            child: _SectionCard(
              title: 'WHO WE ARE',
              icon: Icons.people,
              color: Color(0xFF059669),
              content: 'Iranian Football Association Australia (IFAA) was established by founding members (Iranian Community Ambassadors) in August 2014, prior to the Asian Cup conducted in Sydney during January 2015.',
            ),
          ),
          
          // OBJECTIVES Section
          const SliverToBoxAdapter(
            child: _SectionCard(
              title: 'OUR OBJECTIVES',
              icon: Icons.flag,
              color: Color(0xFF1E3A8A),
              content: '',
              isObjectives: true,
            ),
          ),
          
          // FACTS Section
          const SliverToBoxAdapter(
            child: _SectionCard(
              title: 'FACTS ABOUT IRAN & IRANIAN FOOTBALL',
              icon: Icons.sports_soccer,
              color: Color(0xFFEA580C),
              content: '',
              isFacts: true,
            ),
          ),
          
          // COMMUNITY ISSUES Section
          const SliverToBoxAdapter(
            child: _SectionCard(
              title: 'COMMUNITY ISSUES WE ADDRESS',
              icon: Icons.build,
              color: Color(0xFF7C3AED),
              content: '',
              isIssues: true,
            ),
          ),
          
          // PROGRAM SUMMARY Section
          const SliverToBoxAdapter(
            child: _SectionCard(
              title: 'PROGRAM SUMMARY',
              icon: Icons.emoji_events,
              color: Color(0xFF059669),
              content: 'An integrated program is developed to address the Australian Iranian Community football/futsal needs. IFAA has participated in various tournaments and friendlies since 2015, building solid friendships between various levels of Iranian communities.',
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;
  final bool isObjectives;
  final bool isFacts;
  final bool isIssues;
  
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
    this.isObjectives = false,
    this.isFacts = false,
    this.isIssues = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    if (isObjectives) {
      return _buildObjectives(context);
    } else if (isFacts) {
      return _buildFacts(context);
    } else if (isIssues) {
      return _buildIssues(context);
    } else {
      return Text(
        content,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1F2937),
          height: 1.6,
        ),
      );
    }
  }
  
  Widget _buildObjectives(BuildContext context) {
    const objectives = [
      'To promote the sport of football [soccer] and engage the community through soccer',
      'To teach the skill of playing football [soccer]',
      'To organise social and recreational activities for its members',
      'To arrange, promote and foster the establishment and development of a charitable, non-profit organisation dedicated to soccer and promote friendship, multiculturalism and encourage good deeds',
      'To enter into arrangements with any government or authority that may seem conducive to IFAA objects and obtain rights, privileges and concessions',
    ];
    
    return Column(
      children: objectives.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildFacts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFactItem(
          'Major Community',
          'More than 40,000 Iranian Australians in NSW - clusters in Hornsby, Hills Shire, Parramatta, Blacktown, Ku-Ringai LGAs',
          Icons.people,
        ),
        _buildFactItem(
          'Proud History',
          'Iran Team Melli is 3-time Asian Cup winner, played in 6 World Cups, currently ranked 1st in Asia. Iran is also the king of Asian Futsal - ranked 1st in Asia and 5th in the world',
          Icons.emoji_events,
        ),
        _buildFactItem(
          'Dominant Passion',
          'Football & Futsal is the #1 passion of the Australian Iranian community and crucial engagement platform for men, women, boys & girls',
          Icons.favorite,
        ),
        _buildFactItem(
          'Outside the System',
          'The majority of Iranian community plays unregistered "park football" and is outside the Football NSW system',
          Icons.sports_soccer,
        ),
      ],
    );
  }
  
  Widget _buildIssues(BuildContext context) {
    const issues = [
      {'title': 'Tournament', 'desc': 'No existing tournament uniting the Iranian community in both football and Futsal'},
      {'title': 'Community Club', 'desc': 'No pathway for officially registered Iranian Australian club'},
      {'title': 'Junior Development', 'desc': 'No organised Junior development program/Football Academy'},
      {'title': 'Representative Team', 'desc': 'No current Iranian NSW representative teams in both Football and Futsal'},
    ];
    
    return Column(
      children: issues.map((issue) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                issue['title']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                issue['desc']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildFactItem(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    height: 1.4,
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