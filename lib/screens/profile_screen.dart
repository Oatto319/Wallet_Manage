import 'package:flutter/material.dart';
import '../services/auth_service.dart' as Auth;
import 'login_screen.dart' as login;
import 'home_screen.dart' as home;

import 'privacy_screen.dart';
import 'help_center_screen.dart';
import 'edit_profile_screen.dart';
import '../main.dart'; // สำหรับ MyApp.of(context)

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    final isThai = MyApp.of(context).isThai ?? true;
    
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.orange.shade600),
              const SizedBox(width: 12),
              Text(isThai ? 'ออกจากระบบ' : 'Logout'),
            ],
          ),
          content: Text(isThai
              ? 'คุณแน่ใจหรือไม่ที่จะออกจากระบบ?'
              : 'Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(isThai ? 'ยกเลิก' : 'Cancel',
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isThai ? 'ออกจากระบบ' : 'Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      try {
        await Auth.AuthService.logout();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(isThai ? 'ออกจากระบบสำเร็จ' : 'Logged out successfully'),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const login.LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(isThai ? 'เกิดข้อผิดพลาดในการออกจากระบบ' : 'Error during logout'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    }

    if (mounted) setState(() => _isLoggingOut = false);
  }

  @override
  Widget build(BuildContext context) {
    final isThai = MyApp.of(context).isThai ?? true;
    final theme = Theme.of(context);

    final user = Auth.AuthService.currentUser ?? 'Unknown';
    final email = Auth.AuthService.currentEmail ?? 'Unknown';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const home.HomeScreen()),
            (route) => false,
          ),
          icon: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_ios_new,
                color: theme.iconTheme.color, size: 18),
          ),
        ),
        title: Text(isThai ? 'โปรไฟล์ของฉัน' : 'My Profile',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileCard(user, email, theme, isThai),
                const SizedBox(height: 32),
                _buildActionCards(theme, isThai),
                const SizedBox(height: 40),
                _buildLogoutButton(theme, isThai),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(String user, String email, ThemeData theme, bool isThai) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.primaryColor,
            child: Text(
              user.isNotEmpty ? user[0].toUpperCase() : 'U',
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          _infoTile(Icons.person, isThai ? 'ชื่อผู้ใช้' : 'Username', user, theme),
          const SizedBox(height: 16),
          _infoTile(Icons.email, isThai ? 'อีเมล' : 'Email', email, theme),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColorDark, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(ThemeData theme, bool isThai) {
    return Column(
      children: [
        _actionCard(
          Icons.edit,
          isThai ? 'แก้ไขโปรไฟล์' : 'Edit Profile',
          isThai ? 'เปลี่ยนแปลงข้อมูลส่วนตัว' : 'Update your info',
          Colors.blue,
          () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            );
            if (result == true && mounted) setState(() {});
          },
        ),
        const SizedBox(height: 16),
        _actionCard(
          Icons.privacy_tip,
          isThai ? 'ความเป็นส่วนตัว' : 'Privacy Settings',
          isThai ? 'จัดการการตั้งค่าความปลอดภัย' : 'Manage security settings',
          Colors.purple,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        _actionCard(
          Icons.help_center,
          isThai ? 'ศูนย์ช่วยเหลือ' : 'Help Center',
          isThai ? 'คำถามที่พบบ่อยและการสนับสนุน' : 'FAQs & support',
          Colors.teal,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle, MaterialColor color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: color.shade700)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ThemeData theme, bool isThai) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoggingOut ? null : _logout,
        icon: _isLoggingOut 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.logout),
        label: Text(_isLoggingOut 
            ? (isThai ? 'กำลังออกจากระบบ...' : 'Logging out...') 
            : (isThai ? 'ออกจากระบบ' : 'Logout')),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: _isLoggingOut ? 0 : 2,
        ),
      ),
    );
  }
}