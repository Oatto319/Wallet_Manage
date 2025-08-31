import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart' as auth;
import 'profile_screen.dart';
import '../widgets/custom_drawer.dart';
import 'saving_goal_screen.dart';
import 'saving_history_screen.dart';
import 'saving_simulator_screen.dart';
import 'statistics_screen.dart';
import '../main.dart'; // สำหรับ MyApp.of(context)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isThai = appState.isThai;
    final theme = Theme.of(context);
    final user = auth.AuthService.currentUser ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isThai ? 'วอลเล็ต' : 'Wallet',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 8,
        shadowColor: theme.primaryColorLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.account_circle, size: 32, color: theme.colorScheme.onPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              tooltip: isThai ? 'โปรไฟล์' : 'Profile',
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isThai ? 'สวัสดี, $user' : 'Hello, $user',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                children: [
                  _HomeMenuCard(
                    icon: Icons.savings,
                    title: isThai ? 'ออมเงิน' : 'Saving Goal',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SavingGoalScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.history,
                    title: isThai ? 'ประวัติการออม' : 'Saving History',
                    color: theme.colorScheme.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SavingHistoryScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.calculate,
                    title: isThai ? 'คำนวณแผนการออม' : 'Saving Simulator',
                    color: Colors.purple.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SavingSimulatorScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.bar_chart,
                    title: isThai ? 'สถิติการออม' : 'Statistics',
                    color: Colors.teal.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _HomeMenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
