import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../services/saving_data.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = SavingData.history;
    double total = 0;
    Map<String, double> perMonth = {};

    // คำนวณสถิติ
    for (var item in history) {
      total += (item['amount'] as double);
      String month = item['date'].substring(0, 7); // yyyy-MM
      perMonth[month] = (perMonth[month] ?? 0) + (item['amount'] as double);
    }

    // หาเดือนที่ออมมากที่สุดและน้อยที่สุด
    String bestMonth = '';
    String worstMonth = '';
    double maxAmount = 0;
    double minAmount = double.infinity;

    if (perMonth.isNotEmpty) {
      for (var entry in perMonth.entries) {
        if (entry.value > maxAmount) {
          maxAmount = entry.value;
          bestMonth = entry.key;
        }
        if (entry.value < minAmount) {
          minAmount = entry.value;
          worstMonth = entry.key;
        }
      }
    }

    double averagePerMonth = perMonth.isNotEmpty ? total / perMonth.length : 0;
    int totalTransactions = history.length;

    return Scaffold(
      appBar: customAppBar(context, 'สถิติการออม'),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.account_balance_wallet,
                      title: 'ยอดเงินออมทั้งหมด',
                      value: '${total.toStringAsFixed(2)} บาท',
                      color: Colors.teal,
                      gradient: [Colors.teal.shade600, Colors.teal.shade800],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      title: 'จำนวนครั้งที่ออม',
                      value: '$totalTransactions ครั้ง',
                      color: Colors.blue,
                      gradient: [Colors.blue.shade600, Colors.blue.shade800],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.timeline,
                      title: 'เฉลี่ยต่อเดือน',
                      value: '${averagePerMonth.toStringAsFixed(2)} บาท',
                      color: Colors.purple,
                      gradient: [
                        Colors.purple.shade600,
                        Colors.purple.shade800,
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.calendar_month,
                      title: 'เดือนที่ออมมากที่สุด',
                      value: bestMonth.isNotEmpty
                          ? _formatMonth(bestMonth)
                          : 'ยังไม่มีข้อมูล',
                      color: Colors.green,
                      gradient: [Colors.green.shade600, Colors.green.shade800],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Monthly Statistics Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bar_chart,
                      color: Colors.teal.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'สถิติรายเดือน',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Monthly Statistics List
              if (perMonth.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ยังไม่มีข้อมูลสถิติ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เริ่มออมเงินเพื่อเห็นสถิติการออมของคุณ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: perMonth.entries.map((entry) {
                      final monthKey = entry.key;
                      final amount = entry.value;
                      final percentage = (amount / total * 100);
                      final isHighest = monthKey == bestMonth;

                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: isHighest
                              ? LinearGradient(
                                  colors: [
                                    Colors.amber.shade100,
                                    Colors.amber.shade50,
                                  ],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          border: isHighest
                              ? Border.all(
                                  color: Colors.amber.shade300,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isHighest
                                    ? [
                                        Colors.amber.shade400,
                                        Colors.amber.shade600,
                                      ]
                                    : [
                                        Colors.teal.shade400,
                                        Colors.teal.shade600,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isHighest ? Icons.star : Icons.calendar_month,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                _formatMonth(monthKey),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (isHighest) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'สูงสุด',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.grey.shade200,
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: percentage / 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isHighest
                                            ? [
                                                Colors.amber.shade400,
                                                Colors.amber.shade600,
                                              ]
                                            : [
                                                Colors.teal.shade400,
                                                Colors.teal.shade600,
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${percentage.toStringAsFixed(1)}% ของยอดรวม',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'บาท',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatMonth(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length == 2) {
      final year = parts[0];
      final month = parts[1];
      const months = [
        '',
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม',
      ];
      final monthIndex = int.tryParse(month) ?? 0;
      if (monthIndex > 0 && monthIndex < months.length) {
        return '${months[monthIndex]} $year';
      }
    }
    return monthKey;
  }
}
