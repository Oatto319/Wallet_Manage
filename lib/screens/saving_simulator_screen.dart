import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class SavingSimulatorScreen extends StatefulWidget {
  final double? goalAmount;
  final String? productTitle;

  const SavingSimulatorScreen({super.key, this.goalAmount, this.productTitle});

  @override
  State<SavingSimulatorScreen> createState() => _SavingSimulatorScreenState();
}

class _SavingSimulatorScreenState extends State<SavingSimulatorScreen>
    with TickerProviderStateMixin {
  final _goalController = TextEditingController();
  final _perDayController = TextEditingController();
  final _monthsController = TextEditingController();
  String? _result;
  late AnimationController _resultAnimationController;
  late Animation<double> _resultScaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.goalAmount != null) {
      _goalController.text = widget.goalAmount!.toStringAsFixed(2);
    }

    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _calculateByPerDay() {
    final goal = double.tryParse(_goalController.text) ?? 0;
    final perDay = double.tryParse(_perDayController.text) ?? 0;
    if (goal > 0 && perDay > 0) {
      final days = (goal / perDay).ceil();
      final months = (days / 30).ceil();
      final years = (days / 365).ceil();
      setState(() {
        _result =
            '''หากออม ${perDay.toStringAsFixed(2)} บาทต่อวัน
จะครบเป้าหมาย ${goal.toStringAsFixed(2)} บาท ใน:

📅 $days วัน
📅 $months เดือน  
📅 $years ปี''';
      });
      _resultAnimationController.forward();
    } else {
      _showErrorDialog('กรุณากรอกข้อมูลให้ถูกต้อง');
    }
  }

  void _calculateByMonths() {
    final goal = double.tryParse(_goalController.text) ?? 0;
    final months = int.tryParse(_monthsController.text) ?? 0;
    if (goal > 0 && months > 0) {
      final perDay = goal / (months * 30);
      setState(() {
        _result =
            '''เพื่อให้ครบเป้าหมาย ${goal.toStringAsFixed(2)} บาท
ภายใน $months เดือน

💰 ต้องออมวันละ ${perDay.toStringAsFixed(2)} บาท
📊 รวมต่อเดือน ${(perDay * 30).toStringAsFixed(2)} บาท''';
      });
      _resultAnimationController.forward();
    } else {
      _showErrorDialog('กรุณากรอกข้อมูลให้ถูกต้อง');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('ข้อผิดพลาด'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'คำนวณแผนการออม'),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Goal Header
              if (widget.productTitle != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade600, Colors.purple.shade800],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.flag, size: 32, color: Colors.white),
                      const SizedBox(height: 8),
                      const Text(
                        'เป้าหมายของคุณ',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        widget.productTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              // Goal Amount Input
              _buildInputCard(
                icon: Icons.monetization_on,
                title: 'เป้าหมายเงินออม',
                color: Colors.amber,
                child: TextField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: 'จำนวนเงิน (บาท)',
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.amber.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.amber.shade600,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.amber.shade50,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Method 1: Calculate by Per Day
              _buildInputCard(
                icon: Icons.timeline,
                title: '🕐 วิธีที่ 1: คำนวณจากจำนวนเงินต่อวัน',
                color: Colors.blue,
                child: Column(
                  children: [
                    TextField(
                      controller: _perDayController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'อยากออมวันละเท่าไร? (บาท)',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.blue.shade600,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _calculateByPerDay,
                        icon: const Icon(Icons.calculate),
                        label: const Text('คำนวณระยะเวลา'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Method 2: Calculate by Months
              _buildInputCard(
                icon: Icons.schedule,
                title: '📅 วิธีที่ 2: คำนวณจากระยะเวลา',
                color: Colors.green,
                child: Column(
                  children: [
                    TextField(
                      controller: _monthsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'อยากได้ภายในกี่เดือน?',
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Colors.green.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green.shade600,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.green.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _calculateByMonths,
                        icon: const Icon(Icons.calculate),
                        label: const Text('คำนวณจำนวนเงินต่อวัน'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Result Card
              if (_result != null)
                AnimatedBuilder(
                  animation: _resultScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _resultScaleAnimation.value,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'ผลการคำนวณ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _result!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
