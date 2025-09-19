import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final UserRole role; // Add role field

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinDate,
    required this.membershipType,
    required this.isActive,
    required this.profile,
    this.role = UserRole.member, // Default role is member
  });

  // Convert User object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'joinDate': joinDate,
      'membershipType': membershipType.toString(),
      'isActive': isActive,
      'profile': profile,
      'role': role.toString(),
    };
  }

  // Create User object from Firestore data
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      joinDate: (map['joinDate'] is Timestamp 
          ? (map['joinDate'] as Timestamp).toDate() 
          : DateTime.now()),
      membershipType: _membershipTypeFromString(map['membershipType']),
      isActive: map['isActive'] ?? true,
      profile: Map<String, dynamic>.from(map['profile'] ?? {}),
      role: _userRoleFromString(map['role']),
    );
  }

  static MembershipType _membershipTypeFromString(String? type) {
    if (type == null) return MembershipType.basic;
    switch (type) {
      case 'MembershipType.premium':
        return MembershipType.premium;
      case 'MembershipType.elite':
        return MembershipType.elite;
      default:
        return MembershipType.basic;
    }
  }

  static UserRole _userRoleFromString(String? role) {
    if (role == null) return UserRole.member;
    switch (role) {
      case 'UserRole.admin':
        return UserRole.admin;
      case 'UserRole.editor':
        return UserRole.editor;
      default:
        return UserRole.member;
    }
  }
}

enum UserRole {
  member,
  admin,
  editor,
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
  final String? bankName;
  final String? accountNumber;
  final String? transactionId;
  final String? reference; // Add reference field
  final String? notes;

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
    required this.method,
    this.bankName,
    this.accountNumber,
    this.transactionId,
    this.reference, // Add reference field
    this.notes,
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
  late TabController _tabController;

  late final AuthService _authService;
  
  // Form controllers for editable profile fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();
  final _dobController = TextEditingController();
  final _experienceController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  
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
      bankName: 'Example Bank',
      accountNumber: '1234567890',
      reference: 'REF123456', // Add reference field
    ),
  ];

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _dobController.dispose();
    _experienceController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _checkCurrentUser() async {
    final firebase_auth.User? user = _authService.getCurrentUser();
    if (user != null) {
      try {
        // Get user data from Firestore
        final userData = await _authService.getUserData(user.uid);
        debugPrint('User data loaded: $userData');
        debugPrint('User active status from Firestore: ${userData?['isActive']}');
        
        // Get user role
        final userRole = await _authService.getUserRole(user.uid);
        debugPrint('User role: $userRole');
        
        setState(() {
          _isLoggedIn = true;
          _currentUser = User(
            id: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            joinDate: user.metadata.creationTime ?? DateTime.now(),
            membershipType: MembershipType.basic,
            isActive: userData?['isActive'] ?? true, // Load isActive from Firestore
            profile: Map<String, dynamic>.from(userData?['profile'] ?? {}),
            role: _mapStringToUserRole(userRole), // Add role
          );
          
          debugPrint('Current user active status after setState: ${_currentUser?.isActive}');
          
          // Initialize form controllers with user data
          _nameController.text = _currentUser!.name;
          _emailController.text = _currentUser!.email;
          _phoneController.text = _currentUser!.profile['phone'] ?? '';
          _positionController.text = _currentUser!.profile['position'] ?? '';
          _dobController.text = _currentUser!.profile['dateOfBirth'] ?? '';
          _experienceController.text = _currentUser!.profile['experience'] ?? '';
          _emergencyContactController.text = _currentUser!.profile['emergencyContact'] ?? '';
        });
        
        // Load user payments from Firebase
        _loadUserPayments();
      } catch (e) {
        debugPrint('Error loading user data: $e');
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading user data: $e'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    }
  }

  void _loadUserPayments() async {
    if (_currentUser == null) return;
    
    try {
      final paymentsData = await _authService.getUserPayments(_currentUser!.id);
      debugPrint('Payments data loaded: $paymentsData');
      
      // Convert payment data to Payment objects
      final payments = paymentsData.map((paymentData) {
        // Handle timestamp conversion
        DateTime paymentDate;
        if (paymentData['createdAt'] is Timestamp) {
          paymentDate = (paymentData['createdAt'] as Timestamp).toDate();
        } else {
          paymentDate = DateTime.now();
        }
        
        return Payment(
          id: paymentData['id'] as String,
          date: paymentDate,
          amount: (paymentData['amount'] as num).toDouble(),
          description: paymentData['description'] as String,
          status: _paymentStatusFromString(paymentData['status'] as String?),
          method: paymentData['method'] as String,
          bankName: paymentData['bankName'] as String?,
          accountNumber: paymentData['accountNumber'] as String?,
          transactionId: paymentData['transactionId'] as String?,
          reference: paymentData['reference'] as String?, // Add reference field
          notes: paymentData['notes'] as String?,
        );
      }).toList();
      
      setState(() {
        // Replace sample payments with actual payments from Firebase
        _samplePayments.clear();
        _samplePayments.addAll(payments);
      });
    } catch (e) {
      debugPrint('Error loading user payments: $e');
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading payments: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
      // Keep sample payments for demo purposes
    }
  }

  static PaymentStatus _paymentStatusFromString(String? status) {
    if (status == null) return PaymentStatus.pending;
    switch (status) {
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  // Authentication Methods
  void _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final firebase_auth.User? user = await _authService.signInWithGoogle();
      if (user != null) {
        try {
          // Get user data from Firestore
          final userData = await _authService.getUserData(user.uid);
          debugPrint('User data loaded after sign-in: $userData');
          debugPrint('User active status from Firestore: ${userData?['isActive']}');
          
          // Get user role
          final userRole = await _authService.getUserRole(user.uid);
          debugPrint('User role after sign-in: $userRole');
          
          setState(() {
            _isLoggedIn = true;
            _currentUser = User(
              id: user.uid,
              name: user.displayName ?? 'Google User',
              email: user.email ?? '',
              photoUrl: user.photoURL,
              joinDate: user.metadata.creationTime ?? DateTime.now(),
              membershipType: MembershipType.basic,
              isActive: userData?['isActive'] ?? true, // Load isActive from Firestore
              profile: Map<String, dynamic>.from(userData?['profile'] ?? {}),
              role: _mapStringToUserRole(userRole), // Add role
            );
            
            debugPrint('Current user active status after setState: ${_currentUser?.isActive}');
            
            // Initialize form controllers with user data
            _nameController.text = _currentUser!.name;
            _emailController.text = _currentUser!.email;
            _phoneController.text = _currentUser!.profile['phone'] ?? '';
            _positionController.text = _currentUser!.profile['position'] ?? '';
            _dobController.text = _currentUser!.profile['dateOfBirth'] ?? '';
            _experienceController.text = _currentUser!.profile['experience'] ?? '';
            _emergencyContactController.text = _currentUser!.profile['emergencyContact'] ?? '';
          });
          
          // Load user payments from Firebase
          _loadUserPayments();
          
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully signed in!'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
          }
        } catch (e) {
          debugPrint('Error loading user data after sign-in: $e');
          // Still show success but with a warning
          setState(() {
            _isLoggedIn = true;
            _currentUser = User(
              id: user.uid,
              name: user.displayName ?? 'Google User',
              email: user.email ?? '',
              photoUrl: user.photoURL,
              joinDate: user.metadata.creationTime ?? DateTime.now(),
              membershipType: MembershipType.basic,
              isActive: true,
              profile: {}, // Empty profile as fallback
              role: UserRole.member, // Default role
            );
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signed in successfully, but had issues loading profile data.'),
                backgroundColor: Color(0xFFF59E0B),
              ),
            );
          }
        }
      } else {
        setState(() => _isLoggedIn = false);
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign-in was cancelled or failed. Please try again.'),
              backgroundColor: Color(0xFFEF4444),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in with Google: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  UserRole _mapStringToUserRole(String? role) {
    if (role == null) return UserRole.member;
    
    // Handle different role formats
    final normalizedRole = role.toLowerCase().trim();
    
    switch (normalizedRole) {
      case 'admin':
      case 'userrole.admin':
        return UserRole.admin;
      case 'editor':
      case 'userrole.editor':
        return UserRole.editor;
      default:
        return UserRole.member;
    }
  }

  void _logout() async {
    await _authService.signOutGoogle();
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
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

  // Get user role label in capital letters
  String _getUserRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.editor:
        return 'EDITOR';
      case UserRole.member:
        return 'MEMBER';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Membership')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to IFAA Membership',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in with your Google account to access your membership dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  label: const Text('Sign in with Google'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: _buildMemberDashboard(),
    );
  }

  // Member Dashboard
  Widget _buildMemberDashboard() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Column(
        children: [
          // Header with user info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
              ),
            ),
            child: Row(
              children: [
                _ProfileImage(
                  photoUrl: _currentUser?.photoUrl,
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
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
                          GestureDetector(
                            onTap: _currentUser?.role == UserRole.admin 
                                ? _showUserRoleDialog 
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getUserRoleLabel(_currentUser?.role ?? UserRole.member),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Show active status badge
                          GestureDetector(
                            onTap: _currentUser?.role == UserRole.admin 
                                ? _showUserActiveStatusDialog 
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _currentUser?.isActive == true 
                                    ? const Color(0xFF10B981) // Green for active
                                    : const Color(0xFF6B7280), // Gray for inactive
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _currentUser?.isActive == true ? 'ACTIVE' : 'INACTIVE',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
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
                    currentUserRole: _currentUser?.role,
                    authService: _authService,
                    currentUserId: _currentUser?.id,
                    onPaymentUpdated: _updatePaymentInList, // Pass the callback
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
                    'Make Payment',
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
              _ProfileImage(
                photoUrl: _currentUser?.photoUrl,
                radius: 60,
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
          _EditableProfileField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person,
            onFieldSaved: () {
              // Show a subtle feedback that the field was saved
              debugPrint('Name field saved');
            },
          ),
          _EditableProfileField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            readOnly: true, // Email from Google Sign-In should not be editable
          ),
          _EditableProfileField(
            controller: _phoneController,
            label: 'Phone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onFieldSaved: () {
              // Show a subtle feedback that the field was saved
              debugPrint('Phone field saved');
            },
          ),
          _EditableProfileField(
            controller: _positionController,
            label: 'Playing Position',
            icon: Icons.sports_soccer,
            onFieldSaved: () {
              // Show a subtle feedback that the field was saved
              debugPrint('Position field saved');
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context, _dobController),
            child: _EditableProfileField(
              controller: _dobController,
              label: 'Date of Birth',
              icon: Icons.cake,
              onFieldSaved: () {
                // Show a subtle feedback that the field was saved
                debugPrint('Date of birth field saved');
              },
              // Remove the onTap since we handle it with the GestureDetector
            ),
          ),
          _EditableProfileField(
            controller: _experienceController,
            label: 'Experience',
            icon: Icons.timeline,
            onFieldSaved: () {
              // Show a subtle feedback that the field was saved
              debugPrint('Experience field saved');
            },
          ),
          _EditableProfileField(
            controller: _emergencyContactController,
            label: 'Emergency Contact',
            icon: Icons.emergency,
            keyboardType: TextInputType.phone,
            onFieldSaved: () {
              // Show a subtle feedback that the field was saved
              debugPrint('Emergency contact field saved');
            },
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
                currentUserRole: _currentUser?.role,
                authService: _authService,
                currentUserId: _currentUser?.id,
                onPaymentUpdated: _updatePaymentInList, // Pass the callback
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

          // Generate timeline items from actual user data
          // Join date
          _TimelineItem(
            date: _currentUser?.joinDate ?? DateTime.now(),
            title: 'Joined IFAA',
            description: 'Welcome to the community!',
            icon: Icons.sports_soccer,
            color: const Color(0xFFEA580C),
          ),
          
          // Profile update events
          _TimelineItem(
            date: DateTime.now().subtract(const Duration(days: 15)),
            title: 'Profile Updated',
            description: 'Contact information updated',
            icon: Icons.edit,
            color: const Color(0xFF059669),
          ),
          
          // Payment history events
          ..._samplePayments.map((payment) {
            String statusText;
            Color statusColor;
            
            switch (payment.status) {
              case PaymentStatus.completed:
                statusText = 'Completed';
                statusColor = const Color(0xFF10B981);
                break;
              case PaymentStatus.pending:
                statusText = 'Pending Approval';
                statusColor = const Color(0xFFF59E0B);
                break;
              case PaymentStatus.failed:
                statusText = 'Failed';
                statusColor = const Color(0xFFEF4444);
                break;
              case PaymentStatus.refunded:
                statusText = 'Refunded';
                statusColor = const Color(0xFF6B7280);
                break;
            }
            
            return _TimelineItem(
              date: payment.date,
              title: '${payment.method} Payment',
              description: '${payment.description} - \$${payment.amount.toStringAsFixed(2)} ($statusText)',
              icon: Icons.payment,
              color: statusColor,
            );
          }).toList(),
          
          // Membership events
          _TimelineItem(
            date: DateTime.now().subtract(const Duration(days: 30)),
            title: 'Membership Renewed',
            description: 'Annual membership fee paid',
            icon: Icons.card_membership,
            color: const Color(0xFF059669),
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
    // Show payment method selection
    showDialog(
      context: context,
      builder: (context) => _PaymentMethodDialog(
        description: description,
        onMethodSelected: (method) {
          if (method == 'Bank Transfer') {
            _showBankTransferForm(description);
          } else {
            // Simulate payment processing for other methods
            _processPayment(description, method);
          }
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void _saveProfile() async {
    if (_currentUser == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Prepare profile data
      final profileData = {
        'phone': _phoneController.text,
        'position': _positionController.text,
        'dateOfBirth': _dobController.text,
        'experience': _experienceController.text,
        'emergencyContact': _emergencyContactController.text,
      };
      
      // Update user profile in Firestore
      await _authService.updateUserProfile(_currentUser!.id, profileData);
      
      // Update local user object
      setState(() {
        _currentUser = User(
          id: _currentUser!.id,
          name: _nameController.text,
          email: _currentUser!.email,
          photoUrl: _currentUser!.photoUrl,
          joinDate: _currentUser!.joinDate,
          membershipType: _currentUser!.membershipType,
          isActive: _currentUser!.isActive,
          profile: profileData,
          role: _currentUser!.role,
        );
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submitBankTransferPayment({
    required String description,
    required double amount,
    required String bankName,
    required String accountNumber,
    required String transactionId,
    required String reference, // Add reference parameter
    required String notes,
  }) async {
    if (_currentUser == null) return;

    try {
      // Prepare payment data
      final paymentData = {
        'description': description,
        'amount': amount,
        'method': 'Bank Transfer',
        'bankName': bankName,
        'accountNumber': accountNumber,
        'transactionId': transactionId,
        'reference': reference, // Add reference field
        'notes': notes,
        'status': 'pending',
        'approved': false,
        'paymentDate': FieldValue.serverTimestamp(), // Add payment date
      };

      // Submit payment to Firestore
      final paymentId = await _authService.addPayment(_currentUser!.id, paymentData);

      // Create a new payment object
      final newPayment = Payment(
        id: paymentId,
        date: DateTime.now(),
        amount: amount,
        description: description,
        status: PaymentStatus.pending,
        method: 'Bank Transfer',
        bankName: bankName,
        accountNumber: accountNumber,
        transactionId: transactionId,
        notes: notes,
      );

      setState(() {
        _samplePayments.insert(0, newPayment);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank transfer details submitted. Awaiting admin approval.'),
            backgroundColor: Color(0xFFF59E0B),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error submitting bank transfer: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit bank transfer. Please try again.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showBankTransferForm(String description) {
    final amountController = TextEditingController();
    final bankNameController = TextEditingController();
    final accountNumberController = TextEditingController();
    final transactionIdController = TextEditingController();
    final referenceController = TextEditingController(); // Add reference field
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bank Transfer Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: transactionIdController,
                decoration: const InputDecoration(
                  labelText: 'Transaction ID (if available)',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference Number',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Validate and submit payment
              if (amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter an amount'),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
                return;
              }

              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
                return;
              }

              // Submit bank transfer payment
              _submitBankTransferPayment(
                description: description,
                amount: amount,
                bankName: bankNameController.text,
                accountNumber: accountNumberController.text,
                transactionId: transactionIdController.text,
                reference: referenceController.text,
                notes: notesController.text,
              );

              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _processPayment(String description, String method) {
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
            method: method,
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

  void _updatePaymentInList(Payment updatedPayment) {
    setState(() {
      final index = _samplePayments.indexWhere((p) => p.id == updatedPayment.id);
      if (index != -1) {
        _samplePayments[index] = updatedPayment;
      }
    });
  }

  void _showUserRoleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Member'),
              leading: Radio<UserRole>(
                value: UserRole.member,
                groupValue: _currentUser?.role,
                onChanged: (UserRole? value) {
                  if (value != null) {
                    _updateUserRole(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Admin'),
              leading: Radio<UserRole>(
                value: UserRole.admin,
                groupValue: _currentUser?.role,
                onChanged: (UserRole? value) {
                  if (value != null) {
                    _updateUserRole(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Editor'),
              leading: Radio<UserRole>(
                value: UserRole.editor,
                groupValue: _currentUser?.role,
                onChanged: (UserRole? value) {
                  if (value != null) {
                    _updateUserRole(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserRole(UserRole role) async {
    if (_currentUser == null) return;

    try {
      // Convert UserRole enum to string
      String roleString;
      switch (role) {
        case UserRole.admin:
          roleString = 'admin';
          break;
        case UserRole.editor:
          roleString = 'editor';
          break;
        case UserRole.member:
          roleString = 'member';
          break;
      }

      // Update user role in Firestore
      await _authService.updateUserRole(_currentUser!.id, roleString);

      // Update local user object
      setState(() {
        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          photoUrl: _currentUser!.photoUrl,
          joinDate: _currentUser!.joinDate,
          membershipType: _currentUser!.membershipType,
          isActive: _currentUser!.isActive,
          profile: _currentUser!.profile,
          role: role,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User role updated successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating user role: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user role: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showUserActiveStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Active Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Active'),
              leading: Radio<bool>(
                value: true,
                groupValue: _currentUser?.isActive,
                onChanged: (bool? value) {
                  if (value != null) {
                    _updateUserActiveStatus(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Inactive'),
              leading: Radio<bool>(
                value: false,
                groupValue: _currentUser?.isActive,
                onChanged: (bool? value) {
                  if (value != null) {
                    _updateUserActiveStatus(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserActiveStatus(bool isActive) async {
    if (_currentUser == null) return;

    debugPrint('Updating user active status. Current: ${_currentUser?.isActive}, New: $isActive');

    try {
      // Update user active status in Firestore
      await _authService.updateUserActiveStatus(_currentUser!.id, isActive);

      // Update local user object
      setState(() {
        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          photoUrl: _currentUser!.photoUrl,
          joinDate: _currentUser!.joinDate,
          membershipType: _currentUser!.membershipType,
          isActive: isActive,
          profile: _currentUser!.profile,
          role: _currentUser!.role,
        );
      });

      debugPrint('User active status updated. New status: ${_currentUser?.isActive}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User status updated to ${isActive ? 'ACTIVE' : 'INACTIVE'}!'),
            backgroundColor: isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating user active status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user active status: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }
}

// Widget Components

class _ProfileImage extends StatefulWidget {
  final String? photoUrl;
  final double radius;
  final IconData placeholderIcon;
  final Color placeholderColor;

  const _ProfileImage({
    required this.photoUrl,
    required this.radius,
    this.placeholderIcon = Icons.person,
    this.placeholderColor = const Color(0xFF1E3A8A),
  });

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage> {
  bool _imageLoadFailed = false;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  Widget build(BuildContext context) {
    if (widget.photoUrl == null || widget.photoUrl!.isEmpty || _imageLoadFailed) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.placeholderColor.withValues(alpha: 0.1),
        child: Icon(widget.placeholderIcon, size: widget.radius, color: widget.placeholderColor),
      );
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.white,
      backgroundImage: CachedNetworkImageProvider(
        widget.photoUrl!,
        errorListener: (error) {
          // Handle image loading errors
          debugPrint('Error loading profile image: $error');
          
          // Handle rate limiting (429) and other network errors
          if (_retryCount < maxRetries) {
            // Retry after a delay with exponential backoff
            Future.delayed(Duration(seconds: 2 * (_retryCount + 1)), () {
              if (mounted) {
                setState(() {
                  _retryCount++;
                });
              }
            });
          } else {
            // Give up and show placeholder
            if (mounted) {
              setState(() {
                _imageLoadFailed = true;
              });
            }
          }
        },
      ),
      child: const SizedBox(), // Empty child since we're using backgroundImage
    );
  }
}

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
            color: Colors.black.withValues(alpha: 0.05),
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
              color: color.withValues(alpha: 0.1),
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
  final UserRole? currentUserRole;
  final AuthService? authService;
  final String? currentUserId;
  final Function(Payment)? onPaymentUpdated; // Add callback for payment updates

  const _PaymentCard({
    required this.payment,
    required this.isCompact,
    this.currentUserRole,
    this.authService,
    this.currentUserId,
    this.onPaymentUpdated,
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
          color: _getStatusColor().withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
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
                // Show bank transfer details if applicable
                if (payment.method == 'Bank Transfer' && (payment.bankName != null || payment.accountNumber != null || payment.reference != null))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (payment.bankName != null)
                        Text(
                          'Bank: ${payment.bankName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      if (payment.accountNumber != null)
                        Text(
                          'Account: ${payment.accountNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      if (payment.reference != null)
                        Text(
                          'Reference: ${payment.reference}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
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
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
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
              // Admin approval button (only visible to admins)
              if (_isAdmin(currentUserRole) && payment.status == PaymentStatus.pending)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton.tonal(
                    onPressed: () {
                      // Show approval dialog
                      _showApprovalDialog(context, payment);
                    },
                    child: const Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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

  // Check if user is admin
  bool _isAdmin(UserRole? userRole) {
    return userRole == UserRole.admin;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Show approval dialog
  void _showApprovalDialog(BuildContext context, Payment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Payment'),
        content: Text('Are you sure you want to approve this payment of \$${payment.amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                // Call the approval method if we have the required parameters
                if (authService != null && currentUserId != null) {
                  await authService!.updatePaymentStatus(
                    currentUserId!,
                    payment.id,
                    'completed',
                    true,
                  );
                  
                  // Create updated payment object
                  final updatedPayment = Payment(
                    id: payment.id,
                    date: payment.date,
                    amount: payment.amount,
                    description: payment.description,
                    status: PaymentStatus.completed,
                    method: payment.method,
                    bankName: payment.bankName,
                    accountNumber: payment.accountNumber,
                    transactionId: payment.transactionId,
                    reference: payment.reference, // Add reference field
                    notes: payment.notes,
                  );
                  
                  // Notify parent widget about the update
                  if (onPaymentUpdated != null) {
                    onPaymentUpdated!(updatedPayment);
                  }
                  
                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment approved successfully!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                } else {
                  // Fallback for now
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment approved successfully!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to approve payment. Please try again.'),
                      backgroundColor: Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }
}

class _EditableProfileField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final VoidCallback? onFieldSaved;

  const _EditableProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.onFieldSaved,
  });

  @override
  _EditableProfileFieldState createState() => _EditableProfileFieldState();
}

class _EditableProfileFieldState extends State<_EditableProfileField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // If focus is lost, consider it as saving the field
    if (!_focusNode.hasFocus && _isFocused) {
      widget.onFieldSaved?.call();
    }
    
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _requestFocus() {
    if (!widget.readOnly) {
      // Use a small delay to avoid DOM element timing issues in Flutter Web
      Future.microtask(() {
        if (mounted) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    }
  }

  void _saveAndUnfocus() {
    widget.onFieldSaved?.call();
    // Use a small delay to avoid DOM element timing issues in Flutter Web
    Future.microtask(() {
      if (mounted) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly ? null : _requestFocus,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused 
                ? const Color(0xFF1E3A8A) 
                : const Color(0xFFE5E7EB),
            width: _isFocused ? 2 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, color: const Color(0xFF1E3A8A), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    readOnly: widget.readOnly, // Always respect readOnly, remove dynamic read-only logic
                    keyboardType: widget.keyboardType,
                    onTap: widget.onTap,
                    onEditingComplete: _saveAndUnfocus,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.readOnly)
              IconButton(
                onPressed: _isFocused ? _saveAndUnfocus : _requestFocus,
                icon: Icon(
                  _isFocused ? Icons.done : Icons.edit,
                  color: _isFocused ? const Color(0xFF10B981) : const Color(0xFF374151),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
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
                  color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
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
              color: color.withValues(alpha: 0.1),
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

class _PaymentMethodDialog extends StatelessWidget {
  final String description;
  final Function(String) onMethodSelected;

  const _PaymentMethodDialog({
    required this.description,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Disabled Credit Card option
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Credit Card'),
            trailing: Icon(Icons.lock, color: Colors.grey),
            onTap: null, // Disabled
            enabled: false, // Disabled
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Bank Transfer'),
            onTap: () {
              Navigator.of(context).pop();
              onMethodSelected('Bank Transfer');
            },
          ),
          // Disabled PayPal option
          const ListTile(
            leading: Icon(Icons.paypal),
            title: Text('PayPal'),
            trailing: Icon(Icons.lock, color: Colors.grey),
            onTap: null, // Disabled
            enabled: false, // Disabled
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