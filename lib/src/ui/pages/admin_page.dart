import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import 'add_news_page.dart';

// Payment model for the admin page
class AdminPayment {
  final String id;
  final String userId;
  final DateTime date;
  final double amount;
  final String description;
  final String status;
  final String method;
  final String? bankName;
  final String? accountNumber;
  final String? transactionId;
  final String? reference;

  AdminPayment({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
    required this.method,
    this.bankName,
    this.accountNumber,
    this.transactionId,
    this.reference,
  });

  // Create AdminPayment object from Firestore data
  factory AdminPayment.fromMap(Map<String, dynamic> map, String id, String userId) {
    debugPrint('Creating AdminPayment from map: $map');
    debugPrint('Map keys: ${map.keys}');
    
    DateTime paymentDate;
    if (map['createdAt'] is Timestamp) {
      paymentDate = (map['createdAt'] as Timestamp).toDate();
    } else {
      paymentDate = DateTime.now();
    }

    // Debug each field individually
    final bankName = map['bankName'] as String?;
    final accountNumber = map['accountNumber'] as String?;
    final transactionId = map['transactionId'] as String?;
    final reference = map['reference'] as String?;
    
    debugPrint('Parsed fields - Bank: $bankName, Account: $accountNumber, Transaction: $transactionId, Reference: $reference');

    final payment = AdminPayment(
      id: id,
      userId: userId,
      date: paymentDate,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
      status: map['status'] as String,
      method: map['method'] as String,
      bankName: bankName,
      accountNumber: accountNumber,
      transactionId: transactionId,
      reference: reference,
    );
    
    debugPrint('Created AdminPayment - Bank: ${payment.bankName}, Account: ${payment.accountNumber}, Reference: ${payment.reference}, Transaction: ${payment.transactionId}');
    
    return payment;
  }
}

// User model for the admin page
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime joinDate;
  final DateTime? lastLogin;
  final DateTime? lastUpdated;
  final bool isActive;
  final String role;
  final Map<String, dynamic> profile;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinDate,
    this.lastLogin,
    this.lastUpdated,
    required this.isActive,
    required this.role,
    required this.profile,
  });

  // Create AdminUser object from Firestore data
  factory AdminUser.fromMap(Map<String, dynamic> map, String id) {
    return AdminUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      joinDate: (map['joinDate'] is Timestamp 
          ? (map['joinDate'] as Timestamp).toDate() 
          : DateTime.now()),
      lastLogin: (map['lastLogin'] is Timestamp 
          ? (map['lastLogin'] as Timestamp).toDate() 
          : null),
      lastUpdated: (map['lastUpdated'] is Timestamp 
          ? (map['lastUpdated'] as Timestamp).toDate() 
          : null),
      isActive: map['isActive'] ?? true,
      role: map['role'] ?? 'member',
      profile: Map<String, dynamic>.from(map['profile'] ?? {}),
    );
  }
}

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  late final AuthService _authService;
  List<AdminUser> _users = [];
  List<AdminUser> _filteredUsers = [];
  List<AdminPayment> _userPayments = [];
  bool _isLoading = false;
  AdminUser? _selectedUser;
  bool _showingUserDetails = false;
  bool _showingPayments = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authService = ref.read(authServiceProvider);
    _loadAllUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _users;
      });
    } else {
      setState(() {
        _filteredUsers = _users.where((user) {
          return user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query) ||
              user.id.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _loadAllUsers() async {
    setState(() => _isLoading = true);
    try {
      final usersData = await _authService.getAllUsers();
      final users = usersData.map((userData) {
        return AdminUser.fromMap(userData, userData['id'] as String);
      }).toList();
      
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading users: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _loadUserPayments(String userId) async {
    setState(() => _isLoading = true);
    try {
      final paymentsData = await _authService.getUserPayments(userId);
      debugPrint('Raw payments data for user $userId: $paymentsData'); // Add debug print
      
      // Debug print each payment data map
      for (var paymentData in paymentsData) {
        debugPrint('Payment data map: $paymentData');
        debugPrint('Bank Name in data: ${paymentData['bankName']}');
        debugPrint('Account Number in data: ${paymentData['accountNumber']}');
        debugPrint('Reference in data: ${paymentData['reference']}');
        debugPrint('Transaction ID in data: ${paymentData['transactionId']}');
      }
      
      final payments = paymentsData.map((paymentData) {
        debugPrint('Creating AdminPayment from map: $paymentData');
        return AdminPayment.fromMap(paymentData, paymentData['id'] as String, userId);
      }).toList();
      
      // Debug print each payment's fields
      for (var payment in payments) {
        debugPrint('Created Payment ID: ${payment.id}');
        debugPrint('Created Bank Name: ${payment.bankName}');
        debugPrint('Created Account Number: ${payment.accountNumber}');
        debugPrint('Created Reference: ${payment.reference}');
        debugPrint('Created Transaction ID: ${payment.transactionId}');
      }
      
      setState(() {
        _userPayments = payments;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user payments: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user payments: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _viewUserDetails(AdminUser user) {
    setState(() {
      _selectedUser = user;
      _showingUserDetails = true;
      _showingPayments = false;
    });
    // Load user payments when viewing user details
    _loadUserPayments(user.id);
  }

  void _viewUserPayments(AdminUser user) {
    setState(() {
      _selectedUser = user;
      _showingUserDetails = false;
      _showingPayments = true;
    });
    _loadUserPayments(user.id);
  }

  void _goBack() {
    setState(() {
      _showingUserDetails = false;
      _showingPayments = false;
      _selectedUser = null;
      _userPayments.clear(); // Clear payments when going back
    });
  }

  void _updateUserRole(AdminUser user, String newRole) async {
    try {
      await _authService.updateUserRole(user.id, newRole);
      
      // Update local user list
      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            lastUpdated: user.lastUpdated,
            isActive: user.isActive,
            role: newRole,
            profile: user.profile,
          );
        }
        
        _filterUsers(); // Re-apply filter to update filtered list
        
        if (_selectedUser != null && _selectedUser!.id == user.id) {
          _selectedUser = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            lastUpdated: user.lastUpdated,
            isActive: user.isActive,
            role: newRole,
            profile: user.profile,
          );
        }
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
            content: Text('Error updating user role: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _updateUserActiveStatus(AdminUser user, bool isActive) async {
    try {
      await _authService.updateUserActiveStatus(user.id, isActive);
      
      // Update local user list
      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            lastUpdated: user.lastUpdated,
            isActive: isActive,
            role: user.role,
            profile: user.profile,
          );
        }
        
        _filterUsers(); // Re-apply filter to update filtered list
        
        if (_selectedUser != null && _selectedUser!.id == user.id) {
          _selectedUser = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            lastUpdated: user.lastUpdated,
            isActive: isActive,
            role: user.role,
            profile: user.profile,
          );
        }
      });
      
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
            content: Text('Error updating user active status: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _updatePaymentStatus(AdminPayment payment, String status, bool approved) async {
    debugPrint('Attempting to update payment status - Payment ID: ${payment.id}, Status: $status, Approved: $approved');
    try {
      // Check if current user is admin before updating
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        debugPrint('No user logged in');
        throw Exception('No user logged in');
      }
      
      debugPrint('Current user ID: ${currentUser.uid}');
      
      final isAdmin = await _authService.isAdmin(currentUser.uid);
      debugPrint('Is current user admin: $isAdmin');
      
      if (!isAdmin) {
        debugPrint('User is not authorized to update payments');
        throw Exception('User is not authorized to update payments');
      }
      
      debugPrint('Calling updatePaymentStatus with uid: ${payment.userId}, paymentId: ${payment.id}');
      await _authService.updatePaymentStatus(payment.userId, payment.id, status, approved);
      
      // Update local payment list
      setState(() {
        final index = _userPayments.indexWhere((p) => p.id == payment.id);
        if (index != -1) {
          _userPayments[index] = AdminPayment(
            id: payment.id,
            userId: payment.userId,
            date: payment.date,
            amount: payment.amount,
            description: payment.description,
            status: status,
            method: payment.method,
            bankName: payment.bankName,
            accountNumber: payment.accountNumber,
            transactionId: payment.transactionId,
            reference: payment.reference,
          );
        }
      });
      
      debugPrint('Payment status updated successfully in local state');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment ${approved ? 'approved' : 'declined'} successfully!'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating payment status: $e');
      String errorMessage = 'Error updating payment status';
      
      // Provide more specific error messages
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied: Check if you have admin privileges';
      } else if (e.toString().contains('Payment document does not exist')) {
        errorMessage = 'Payment not found';
      } else {
        errorMessage = 'Error updating payment status: ${e.toString()}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  // Show decline dialog for payments (similar to membership page)
  void _showDeclineDialog(AdminPayment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Payment'),
        content: Text('Are you sure you want to decline this payment of \$${payment.amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                // Check if current user is admin before updating
                final currentUser = _authService.getCurrentUser();
                if (currentUser == null) {
                  debugPrint('No user logged in');
                  throw Exception('No user logged in');
                }
                
                debugPrint('Current user ID: ${currentUser.uid}');
                
                final isAdmin = await _authService.isAdmin(currentUser.uid);
                debugPrint('Is current user admin: $isAdmin');
                
                if (!isAdmin) {
                  debugPrint('User is not authorized to update payments');
                  throw Exception('User is not authorized to update payments');
                }
                
                debugPrint('Declining payment - Payment ID: ${payment.id}');
                
                // Update payment status to 'failed' when declining
                await _authService.updatePaymentStatus(
                  payment.userId,
                  payment.id,
                  'failed', // Set status to failed for declined payments
                  false, // Not approved
                );
                
                // Update local payment list
                setState(() {
                  final index = _userPayments.indexWhere((p) => p.id == payment.id);
                  if (index != -1) {
                    _userPayments[index] = AdminPayment(
                      id: payment.id,
                      userId: payment.userId,
                      date: payment.date,
                      amount: payment.amount,
                      description: payment.description,
                      status: 'failed', // Set to failed status
                      method: payment.method,
                      bankName: payment.bankName,
                      accountNumber: payment.accountNumber,
                      transactionId: payment.transactionId,
                      reference: payment.reference,
                    );
                  }
                });
                
                debugPrint('Payment declined successfully in local state');
                
                // Show success message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment declined successfully!'),
                      backgroundColor: Color(0xFFEF4444),
                    ),
                  );
                }
              } catch (e) {
                // Show error message
                debugPrint('Error declining payment: $e');
                String errorMessage = 'Failed to decline payment';
                
                // Provide more specific error messages
                if (e.toString().contains('permission-denied')) {
                  errorMessage = 'Permission denied: Check if you have admin privileges';
                } else if (e.toString().contains('Payment document does not exist')) {
                  errorMessage = 'Payment not found';
                } else {
                  errorMessage = 'Failed to decline payment: ${e.toString()}';
                }
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      case 'refunded':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'PAID';
      case 'pending':
        return 'PENDING';
      case 'failed':
        return 'FAILED';
      case 'refunded':
        return 'REFUNDED';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getPaymentStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      case 'refunded':
        return Icons.undo;
      default:
        return Icons.help;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Calculate user payment statistics
  Map<String, int> _calculateUserStats() {
    int total = _userPayments.length;
    int completed = _userPayments.where((p) => p.status == 'completed').length;
    int pending = _userPayments.where((p) => p.status == 'pending').length;
    int failed = _userPayments.where((p) => p.status == 'failed').length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'failed': failed,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showingUserDetails || _showingPayments 
            ? (_selectedUser?.name ?? 'User Details') 
            : 'Admin Dashboard'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        leading: (_showingUserDetails || _showingPayments)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/membership'),
              ),
        actions: [
          // Add refresh button to reload data
          if (!_showingUserDetails && !_showingPayments)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAllUsers,
              tooltip: 'Refresh Users',
            ),
          if (_showingPayments && _selectedUser != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _loadUserPayments(_selectedUser!.id),
              tooltip: 'Refresh Payments',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Management Section (only shown on main admin dashboard)
                  if (!_showingUserDetails && !_showingPayments) ...[
                    Card(
                      color: const Color(0xFF1E3A8A),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'News Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Manage news articles for the website',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                FilledButton.icon(
                                  onPressed: () {
                                    context.go('/news-management');
                                  },
                                  icon: const Icon(Icons.newspaper),
                                  label: const Text('Manage News'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Navigate to add news page directly
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const AddNewsPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add News'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Selected user info
                  if (_showingUserDetails && _selectedUser != null) ...[
                    Card(
                      color: const Color(0xFF1E3A8A),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                                  child: _selectedUser!.photoUrl != null
                                      ? CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(_selectedUser!.photoUrl!),
                                        )
                                      : const Icon(Icons.person, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedUser!.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _selectedUser!.email,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () => _showUserRoleDialog(_selectedUser!),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _selectedUser!.role == 'admin'
                                                      ? const Color(0xFFEF4444)
                                                      : _selectedUser!.role == 'editor'
                                                          ? const Color(0xFFF59E0B)
                                                          : const Color(0xFF6B7280),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  _selectedUser!.role.toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () => _showUserActiveStatusDialog(_selectedUser!),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _selectedUser!.isActive
                                                      ? const Color(0xFF10B981)
                                                      : const Color(0xFF6B7280),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  _selectedUser!.isActive ? 'ACTIVE' : 'INACTIVE',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // User profile details
                            const Text(
                              'Profile Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileDetail('Phone', _selectedUser!.profile['phone'] ?? 'Not provided'),
                                  _buildProfileDetail('Position', _selectedUser!.profile['position'] ?? 'Not provided'),
                                  _buildProfileDetail('Date of Birth', _selectedUser!.profile['dateOfBirth'] ?? 'Not provided'),
                                  _buildProfileDetail('Experience', _selectedUser!.profile['experience'] ?? 'Not provided'),
                                  _buildProfileDetail('Emergency Contact', _selectedUser!.profile['emergencyContact'] ?? 'Not provided'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Join Date: ${_formatDate(_selectedUser!.joinDate)}',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      const SizedBox(width: 16),
                                      if (_selectedUser!.lastLogin != null)
                                        Text(
                                          'Last Login: ${_formatDate(_selectedUser!.lastLogin!)}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      const SizedBox(width: 16),
                                      if (_selectedUser!.lastUpdated != null)
                                        Text(
                                          'Last Updated: ${_formatDate(_selectedUser!.lastUpdated!)}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // User statistics
                            /*const Text(
                              'User Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileDetail('Total Payments', _calculateUserStats()['total'].toString()),
                                  _buildProfileDetail('Completed Payments', _calculateUserStats()['completed'].toString()),
                                  _buildProfileDetail('Pending Payments', _calculateUserStats()['pending'].toString()),
                                  _buildProfileDetail('Failed Payments', _calculateUserStats()['failed'].toString()),
                                ],
                              ),
                            ),*/
                            const SizedBox(height: 16),
                            // Action buttons for selected user
                            /*Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showUserRoleDialog(_selectedUser!),
                                  child: const Text('Change Role'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _showUserActiveStatusDialog(_selectedUser!),
                                  child: const Text('Change Status'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _viewUserPayments(_selectedUser!),
                                  child: const Text('View Payments'),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // User payments section
                    if (_userPayments.isNotEmpty) ...[
                      const Text(
                        'User Payments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: _userPayments.map((payment) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: Colors.white.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              payment.description,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                // Payment method icon
                                                Icon(
                                                  payment.method == 'Bank Transfer' 
                                                      ? Icons.account_balance 
                                                      : Icons.payment,
                                                  size: 16,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  payment.method,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                const Text(' • ', style: TextStyle(color: Colors.white70)),
                                                Text(
                                                  '${_formatDate(payment.date)}',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
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
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getPaymentStatusColor(payment.status).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _getPaymentStatusText(payment.status),
                                              style: TextStyle(
                                                color: _getPaymentStatusColor(payment.status),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Bank transfer details if applicable
                                  if (payment.method == 'Bank Transfer') ...[
                                    const Divider(color: Colors.white30),
                                    if (payment.bankName != null)
                                      _buildPaymentDetail('Bank', payment.bankName!),
                                    if (payment.accountNumber != null)
                                      _buildPaymentDetail('Account', payment.accountNumber!),
                                    if (payment.reference != null)
                                      _buildPaymentDetail('Reference', payment.reference!),
                                    if (payment.transactionId != null)
                                      _buildPaymentDetail('Transaction ID', payment.transactionId!),
                                  ],
                                  const SizedBox(height: 12),
                                  // Admin actions for pending payments
                                  if (payment.status == 'pending')
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FilledButton.tonal(
                                          onPressed: () async {
                                            // Check if current user is admin before updating
                                            final currentUser = _authService.getCurrentUser();
                                            if (currentUser == null) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('No user logged in'),
                                                    backgroundColor: Color(0xFFEF4444),
                                                  ),
                                                );
                                              }
                                              return;
                                            }
                                            
                                            final isAdmin = await _authService.isAdmin(currentUser.uid);
                                            if (!isAdmin) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('User is not authorized to approve payments'),
                                                    backgroundColor: Color(0xFFEF4444),
                                                  ),
                                                );
                                              }
                                              return;
                                            }
                                            
                                            _updatePaymentStatus(payment, 'completed', true);
                                          },
                                          child: const Text('Approve'),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton(
                                          onPressed: () async {
                                            // Check if current user is admin before updating
                                            final currentUser = _authService.getCurrentUser();
                                            if (currentUser == null) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('No user logged in'),
                                                    backgroundColor: Color(0xFFEF4444),
                                                  ),
                                                );
                                              }
                                              return;
                                            }
                                            
                                            final isAdmin = await _authService.isAdmin(currentUser.uid);
                                            if (!isAdmin) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('User is not authorized to decline payments'),
                                                    backgroundColor: Color(0xFFEF4444),
                                                  ),
                                                );
                                              }
                                              return;
                                            }
                                            
                                            // Show decline dialog instead of directly updating
                                            _showDeclineDialog(payment);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFFEF4444)),
                                          ),
                                          child: const Text(
                                            'Decline',
                                            style: TextStyle(color: Color(0xFFEF4444)),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ] else if (_userPayments.isEmpty && _isLoading == false) ...[
                      const Text(
                        'No payments found for this user',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                  
                  // Users list header
                  if (!_showingUserDetails && !_showingPayments) ...[
                    const Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Search bar with clear button
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Search users by name, email, or ID...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterUsers();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Users list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : null,
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              user.email,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user.role == 'admin'
                                        ? const Color(0xFFEF4444)
                                        : user.role == 'editor'
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF6B7280),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.role.substring(0, 1).toUpperCase() + user.role.substring(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user.isActive
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF6B7280),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.isActive ? 'A' : 'I',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _viewUserDetails(user),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    debugPrint('Building payment detail - Label: $label, Value: $value'); // Add debug print
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserRoleDialog(AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Member'),
              leading: Radio<String>(
                value: 'member',
                groupValue: user.role,
                onChanged: (String? value) {
                  if (value != null) {
                    _updateUserRole(user, value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Admin'),
              leading: Radio<String>(
                value: 'admin',
                groupValue: user.role,
                onChanged: (String? value) {
                  if (value != null) {
                    _updateUserRole(user, value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Editor'),
              leading: Radio<String>(
                value: 'editor',
                groupValue: user.role,
                onChanged: (String? value) {
                  if (value != null) {
                    _updateUserRole(user, value);
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

  void _showUserActiveStatusDialog(AdminUser user) {
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
                groupValue: user.isActive,
                onChanged: (bool? value) {
                  if (value != null) {
                    _updateUserActiveStatus(user, value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Inactive'),
              leading: Radio<bool>(
                value: false,
                groupValue: user.isActive,
                onChanged: (bool? value) {
                  if (value != null) {
                    _updateUserActiveStatus(user, value);
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
}