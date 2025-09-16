import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

// Sample User Data Model
class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime joinDate;
  final MembershipType membershipType;
  final bool isActive;
  final Map<String, dynamic> profile;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinDate,
    required this.membershipType,
    required this.isActive,
    required this.profile,
  });
}

enum MembershipType {
  basic,
  premium,
  elite,
}

// Sample Payment Data Model
class Payment {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final PaymentStatus status;
  final String method;

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
    required this.method,
  });
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

class MembershipPage extends ConsumerStatefulWidget {
  const MembershipPage({super.key});

  @override
  ConsumerState<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends ConsumerState<MembershipPage>
    with TickerProviderStateMixin {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  User? _currentUser;
  int _selectedTab = 0;
  late TabController _tabController;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _authService = ref.read(authServiceProvider);
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkCurrentUser() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
        _currentUser = User(
          id: user.id,
          name: user.displayName ?? 'Google User',
          email: user.email,
          photoUrl: user.photoUrl,
          joinDate: DateTime.now(), // Placeholder, ideally fetched from backend
          membershipType: MembershipType.basic, // Placeholder
          isActive: true, // Placeholder
          profile: {}, // Placeholder
        );
      });
    }
  }

  // Sample data - in production this would come from a database
  final List<Payment> _samplePayments = [
    Payment(
      id: 'PAY001',
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 120.0,
      description: 'Annual Membership Fee 2024',
      status: PaymentStatus.completed,
      method: 'Credit Card',
    ),
    Payment(
      id: 'PAY002',
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 50.0,
      description: 'Tournament Registration',
      status: PaymentStatus.completed,
      method: 'Google Pay',
    ),
    Payment(
      id: 'PAY003',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 25.0,
      description: 'Training Camp Fee',
      status: PaymentStatus.pending,
      method: 'Bank Transfer',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return _buildAuthScreen();
    }

    return _buildMemberDashboard();
  }

  // Authentication Screen
  Widget _buildAuthScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF059669)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IFAA Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Welcome to IFAA',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1F2937),
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Join Australia\'s premier Iranian football community',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF374151),
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Google Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.login, size: 20),
                          label: Text(
                            _isLoading
                                ? 'Signing in...'
                                : 'Continue with Google',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Demo Login Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _demoLogin,
                          icon: const Icon(Icons.preview),
                          label: const Text(
                            'Demo Login (Sample Data)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF059669),
                            side: const BorderSide(
                                color: Color(0xFF059669), width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Terms and Privacy
                      Text(
                        'By continuing, you agree to our Terms of Service and Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF374151),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Authentication Methods
  void _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
      final user = await _authService.getCurrentUser();
      if (user != null) {
        setState(() {
          _isLoggedIn = true;
          _currentUser = User(
            id: user.id,
            name: user.displayName ?? 'Google User',
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate:
                DateTime.now(), // Placeholder, ideally fetched from backend
            membershipType: MembershipType.basic, // Placeholder
            isActive: true, // Placeholder
            profile: {}, // Placeholder
          );
        });
      } else {
        setState(() => _isLoggedIn = false);
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _demoLogin() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: 'demo_123',
      name: 'Demo User',
      email: 'demo@ifaa.org.au',
      photoUrl: null,
      joinDate: DateTime.now().subtract(const Duration(days: 180)),
      membershipType: MembershipType.basic,
      isActive: true,
      profile: {
        'phone': '+61 412 345 678',
        'position': 'Forward',
        'emergencyContact': 'Jane Doe',
        'dateOfBirth': '1995-06-15',
        'experience': '3 years',
      },
    );

    setState(() {
      _isLoading = false;
      _isLoggedIn = true;
    });
  }

  void _logout() async {
    await _authService.signOutGoogle();
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
      _selectedTab = 0;
    });
  }

  String _getMembershipLabel(MembershipType type) {
    switch (type) {
      case MembershipType.basic:
        return 'BASIC';
      case MembershipType.premium:
        return 'PREMIUM';
      case MembershipType.elite:
        return 'ELITE';
    }
  }

  // Member Dashboard
  Widget _buildMemberDashboard() {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          // Header with user info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: _currentUser?.photoUrl != null
                      ? NetworkImage(_currentUser!.photoUrl!)
                      : null,
                  child: _currentUser?.photoUrl == null
                      ? const Icon(Icons.person,
                          size: 30, color: Color(0xFF1E3A8A))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                      ),
                      Text(
                        _currentUser?.name ?? 'Member',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getMembershipLabel(
                                  _currentUser?.membershipType ??
                                      MembershipType.basic),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_currentUser?.isActive == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),

          // Tab Navigation
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              onTap: (index) => setState(() => _selectedTab = index),
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
                Tab(icon: Icon(Icons.person), text: 'Profile'),
                Tab(icon: Icon(Icons.payment), text: 'Payments'),
                Tab(icon: Icon(Icons.history), text: 'History'),
              ],
              labelColor: const Color(0xFF1E3A8A),
              unselectedLabelColor: const Color(0xFF6B7280),
              indicatorColor: const Color(0xFF1E3A8A),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildProfileTab(),
                _buildPaymentsTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard Tab
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  value: _formatMemberSince(_currentUser?.joinDate),
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.payment,
                  title: 'Total Paid',
                  value: '\$${_getTotalPaid().toStringAsFixed(0)}',
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'RECENT ACTIVITY',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 16),

          ...(_samplePayments
              .take(3)
              .map((payment) => _PaymentCard(
                    payment: payment,
                    isCompact: true,
                  ))
              .toList()),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'QUICK ACTIONS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _makePayment('Membership Renewal'),
                  icon: const Icon(Icons.payment),
                  label: const Text(
                    'Renew Membership',
                    style: TextStyle(
                      color: Colors
                          .white, // Explicitly set white text for better contrast
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor:
                        Colors.white, // Ensure white text and icons
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _tabController.animateTo(1),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF059669),
                    side: const BorderSide(color: Color(0xFF059669)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Profile Tab
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                backgroundImage: _currentUser?.photoUrl != null
                    ? NetworkImage(_currentUser!.photoUrl!)
                    : null,
                child: _currentUser?.photoUrl == null
                    ? const Icon(Icons.person,
                        size: 60, color: Color(0xFF1E3A8A))
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => _updateProfilePicture(),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    iconSize: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile Form
          _ProfileField(
            label: 'Full Name',
            value: _currentUser?.name ?? '',
            icon: Icons.person,
          ),
          _ProfileField(
            label: 'Email',
            value: _currentUser?.email ?? '',
            icon: Icons.email,
          ),
          _ProfileField(
            label: 'Phone',
            value: _currentUser?.profile['phone'] ?? '',
            icon: Icons.phone,
          ),
          _ProfileField(
            label: 'Playing Position',
            value: _currentUser?.profile['position'] ?? '',
            icon: Icons.sports_soccer,
          ),
          _ProfileField(
            label: 'Date of Birth',
            value: _currentUser?.profile['dateOfBirth'] ?? '',
            icon: Icons.cake,
          ),
          _ProfileField(
            label: 'Experience',
            value: _currentUser?.profile['experience'] ?? '',
            icon: Icons.timeline,
          ),
          _ProfileField(
            label: 'Emergency Contact',
            value: _currentUser?.profile['emergencyContact'] ?? '',
            icon: Icons.emergency,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Payments Tab
  Widget _buildPaymentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Options
          Text(
            'MAKE A PAYMENT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _PaymentOptionCard(
                  title: 'Membership Fee',
                  amount: 120.0,
                  description: 'Annual membership',
                  onTap: () => _makePayment('Annual Membership Fee'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PaymentOptionCard(
                  title: 'Training Camp',
                  amount: 50.0,
                  description: 'Monthly training',
                  onTap: () => _makePayment('Training Camp Fee'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Payment History
          Text(
            'PAYMENT HISTORY',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 16),

          ..._samplePayments.map((payment) => _PaymentCard(
                payment: payment,
                isCompact: false,
              )),
        ],
      ),
    );
  }

  // History Tab
  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MEMBERSHIP HISTORY',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 16),

          // Membership Timeline
          _TimelineItem(
            date: DateTime.now(),
            title: 'Profile Updated',
            description: 'Contact information updated',
            icon: Icons.edit,
            color: const Color(0xFF059669),
          ),
          _TimelineItem(
            date: DateTime.now().subtract(const Duration(days: 5)),
            title: 'Payment Made',
            description: 'Training Camp Fee - \$25.00',
            icon: Icons.payment,
            color: const Color(0xFF1E3A8A),
          ),
          _TimelineItem(
            date: DateTime.now().subtract(const Duration(days: 30)),
            title: 'Membership Renewed',
            description: 'Annual Membership Fee - \$120.00',
            icon: Icons.card_membership,
            color: const Color(0xFF059669),
          ),
          _TimelineItem(
            date: _currentUser?.joinDate ?? DateTime.now(),
            title: 'Joined IFAA',
            description: 'Welcome to the community!',
            icon: Icons.sports_soccer,
            color: const Color(0xFFEA580C),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months';
    } else {
      return '${difference.inDays} days';
    }
  }

  double _getTotalPaid() {
    return _samplePayments
        .where((p) => p.status == PaymentStatus.completed)
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  void _makePayment(String description) {
    // Simulate payment processing
    showDialog(
      context: context,
      builder: (context) => _PaymentDialog(
        description: description,
        onConfirm: (amount) {
          // Add new payment to history
          final newPayment = Payment(
            id: 'PAY${DateTime.now().millisecondsSinceEpoch}',
            date: DateTime.now(),
            amount: amount,
            description: description,
            status: PaymentStatus.completed,
            method: 'Credit Card',
          );

          setState(() {
            _samplePayments.insert(0, newPayment);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Payment of \$${amount.toStringAsFixed(2)} successful!'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _updateProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Profile picture update functionality would be implemented here'),
      ),
    );
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }
}

// Widget Components
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Payment payment;
  final bool isCompact;

  const _PaymentCard({
    required this.payment,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: isCompact ? 20 : 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.description,
                  style: TextStyle(
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      payment.method,
                      style: TextStyle(
                        fontSize: isCompact ? 12 : 14,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const Text(' • '),
                    Text(
                      _formatDate(payment.date),
                      style: TextStyle(
                        fontSize: isCompact ? 12 : 14,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isCompact ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return const Color(0xFF10B981);
      case PaymentStatus.pending:
        return const Color(0xFFF59E0B);
      case PaymentStatus.failed:
        return const Color(0xFFEF4444);
      case PaymentStatus.refunded:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return Icons.check_circle;
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.failed:
        return Icons.error;
      case PaymentStatus.refunded:
        return Icons.undo;
    }
  }

  String _getStatusText() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return 'PAID';
      case PaymentStatus.pending:
        return 'PENDING';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.refunded:
        return 'REFUNDED';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.edit,
            color: Color(0xFF374151),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final double amount;
  final String description;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.amount,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payment,
                  color: Color(0xFF1E3A8A),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF374151),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '\$${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final DateTime date;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TimelineItem({
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDialog extends StatelessWidget {
  final String description;
  final Function(double) onConfirm;

  const _PaymentDialog({
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    double amount = 120.0;

    return AlertDialog(
      title: const Text('Make Payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Payment for: $description'),
          const SizedBox(height: 16),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a demo payment system. In production, this would integrate with real payment providers.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(amount);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
          ),
          child: const Text('Pay Now'),
        ),
      ],
    );
  }
}
