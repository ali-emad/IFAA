import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

// User model for the admin page
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime joinDate;
  final DateTime? lastLogin;
  final bool isActive;
  final String role;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinDate,
    this.lastLogin,
    required this.isActive,
    required this.role,
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
      isActive: map['isActive'] ?? true,
      role: map['role'] ?? 'member',
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
  bool _isLoading = false;
  AdminUser? _selectedUser;

  @override
  void initState() {
    super.initState();
    _authService = ref.read(authServiceProvider);
    _loadAllUsers();
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

  void _switchToUser(AdminUser user) async {
    setState(() {
      _selectedUser = user;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to user: ${user.name}'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
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
            isActive: user.isActive,
            role: newRole,
          );
        }
        
        if (_selectedUser != null && _selectedUser!.id == user.id) {
          _selectedUser = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            isActive: user.isActive,
            role: newRole,
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
            isActive: isActive,
            role: user.role,
          );
        }
        
        if (_selectedUser != null && _selectedUser!.id == user.id) {
          _selectedUser = AdminUser(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
            joinDate: user.joinDate,
            lastLogin: user.lastLogin,
            isActive: isActive,
            role: user.role,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected user info
                  if (_selectedUser != null) ...[
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
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _selectedUser!.role == 'admin'
                                                  ? const Color(0xFF10B981)
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
                                          const SizedBox(width: 8),
                                          Container(
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Action buttons for selected user
                            Row(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Users list header
                  const Text(
                    'All Users',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Users list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
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
                          title: Text(user.name),
                          subtitle: Text(user.email),
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
                                      ? const Color(0xFF10B981)
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
                          onTap: () => _switchToUser(user),
                        ),
                      );
                    },
                  ),
                ],
              ),
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