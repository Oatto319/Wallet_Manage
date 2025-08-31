import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _profileVisibleToPublic = true;
  bool _profileVisibleToFriends = true;
  bool _allowLocation = true;
  bool _allowCamera = false;
  bool _twoFactorAuth = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _profileVisibleToPublic = prefs.getBool('profilePublic') ?? true;
          _profileVisibleToFriends = prefs.getBool('profileFriends') ?? true;
          _allowLocation = prefs.getBool('allowLocation') ?? true;
          _allowCamera = prefs.getBool('allowCamera') ?? false;
          _twoFactorAuth = prefs.getBool('twoFactorAuth') ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profilePublic', _profileVisibleToPublic);
      await prefs.setBool('profileFriends', _profileVisibleToFriends);
      await prefs.setBool('allowLocation', _allowLocation);
      await prefs.setBool('allowCamera', _allowCamera);
      await prefs.setBool('twoFactorAuth', _twoFactorAuth);

      if (mounted) {
        final isThai = MyApp.of(context).isThai ?? true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isThai ? 'บันทึกการตั้งค่าสำเร็จ' : 'Preferences saved')),
        );
      }
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  Future<void> _deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: เชื่อม API ลบบัญชีจริง
  }

  void _switchChanged(bool? value, void Function(bool) setter) {
    if (value != null) {
      setState(() {
        setter(value);
      });
      _savePreferences(); // บันทึกทันทีเมื่อเปลี่ยนค่า
    }
  }

  @override
  Widget build(BuildContext context) {
    final isThai = MyApp.of(context).isThai ?? true;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isThai ? 'ความเป็นส่วนตัว' : 'Privacy Settings'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isThai ? 'การมองเห็นโปรไฟล์' : 'Profile Visibility',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(isThai ? 'โปรไฟล์สาธารณะ' : 'Public Profile'),
              value: _profileVisibleToPublic,
              onChanged: (value) => _switchChanged(value, (v) => _profileVisibleToPublic = v),
            ),
            SwitchListTile(
              title: Text(isThai ? 'โปรไฟล์เพื่อนเท่านั้น' : 'Friends Only'),
              value: _profileVisibleToFriends,
              onChanged: (value) => _switchChanged(value, (v) => _profileVisibleToFriends = v),
            ),
            const Divider(),
            Text(
              isThai ? 'อนุญาตการเข้าถึง' : 'Permissions',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(isThai ? 'ตำแหน่ง' : 'Location'),
              value: _allowLocation,
              onChanged: (value) => _switchChanged(value, (v) => _allowLocation = v),
            ),
            SwitchListTile(
              title: Text(isThai ? 'กล้อง' : 'Camera'),
              value: _allowCamera,
              onChanged: (value) => _switchChanged(value, (v) => _allowCamera = v),
            ),
            const Divider(),
            Text(
              isThai ? 'ความปลอดภัย' : 'Security',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Two-Factor Authentication (2FA)'),
              value: _twoFactorAuth,
              onChanged: (value) => _switchChanged(value, (v) => _twoFactorAuth = v),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(isThai ? 'ลบบัญชี / ปิดใช้งานชั่วคราว' : 'Delete / Disable Account'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isThai ? 'ยืนยันการลบบัญชี' : 'Confirm Account Deletion'),
                    content: Text(isThai
                        ? 'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชี?'
                        : 'Are you sure you want to delete your account?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(isThai ? 'ยกเลิก' : 'Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(isThai ? 'ลบ' : 'Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  await _deleteAccount();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isThai ? 'บัญชีถูกลบแล้ว' : 'Account deleted')),
                    );
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
