import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart' as auth;
import '../main.dart'; // เพื่อเข้าถึง MyApp.of(context)

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงค่า isThai จาก global state
    final isThai = MyApp.of(context).isThai;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              isThai ? 'เมนูหลัก' : 'Main Menu',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(isThai ? 'หน้าออมเงิน' : 'Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(isThai ? 'ออกจากระบบ' : 'Logout'),
            onTap: () async {
              try {
                // เรียก static method ตรงๆ
                await auth.AuthService.logout();
                
                // เช็คว่า context ยังใช้งานได้อยู่หรือไม่
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              } catch (e) {
                // จัดการ error กรณี logout ไม่สำเร็จ
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isThai ? 'เกิดข้อผิดพลาดในการออกจากระบบ' : 'Logout failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}