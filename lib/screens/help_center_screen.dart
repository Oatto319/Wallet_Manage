import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // สำหรับ MyApp.of(context)

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqList = [
    {
      'question': 'ฉันลืมรหัสผ่านทำอย่างไร?',
      'answer': 'คุณสามารถรีเซ็ตรหัสผ่านได้ที่หน้าล็อกอินโดยคลิก "ลืมรหัสผ่าน?"'
    },
    {
      'question': 'จะเปลี่ยนภาษาในแอปได้อย่างไร?',
      'answer': 'ไปที่หน้าแก้ไขโปรไฟล์ จากนั้นเลือกภาษาที่ต้องการ'
    },
    {
      'question': 'แอปขออนุญาตตำแหน่งทำไม?',
      'answer': 'เพื่อปรับปรุงประสบการณ์ใช้งาน เช่น แสดงร้านค้าใกล้เคียง'
    },
    {
      'question': 'ฉันสามารถดูประวัติการทำรายการได้อย่างไร?',
      'answer': 'ไปที่หน้าประวัติการออม/การทำรายการเพื่อดูรายละเอียดทั้งหมด'
    },
    {
      'question': 'ฉันสามารถตั้งเป้าหมายการออมได้กี่รายการ?',
      'answer': 'คุณสามารถตั้งเป้าหมายการออมได้หลายรายการ ขึ้นอยู่กับการใช้งานของคุณ'
    },
    {
      'question': 'ทำไมแอปถึงขออนุญาตแจ้งเตือน?',
      'answer': 'เพื่อแจ้งเตือนการออม การชำระเงิน หรือโปรโมชั่นที่เกี่ยวข้องกับบัญชีของคุณ'
    },
    {
      'question': 'สามารถยกเลิกบัญชีได้หรือไม่?',
      'answer': 'คุณสามารถติดต่อเจ้าหน้าที่ผ่านปุ่ม "ติดต่อเจ้าหน้าที่" เพื่อขอยกเลิกบัญชี'
    },
    {
      'question': 'สามารถเปลี่ยนอีเมลบัญชีได้ไหม?',
      'answer': 'สามารถเปลี่ยนอีเมลได้ที่หน้าแก้ไขโปรไฟล์ แต่ต้องยืนยันอีเมลใหม่ทุกครั้ง'
    },
    {
      'question': 'แอปรองรับระบบปฏิบัติการอะไรบ้าง?',
      'answer': 'รองรับทั้ง iOS และ Android เวอร์ชันล่าสุด'
    },
  ];

  List<Map<String, String>> get _filteredFaqList {
    if (_searchController.text.isEmpty) return _faqList;
    final query = _searchController.text.toLowerCase();
    return _faqList
        .where((faq) =>
            (faq['question'] ?? '').toLowerCase().contains(query) ||
            (faq['answer'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  Future<void> _contactSupport(bool isThai) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      queryParameters: {
        'subject': isThai
            ? 'ขอความช่วยเหลือจากแอป Wallet Manage'
            : 'Help Request from Wallet Manage App'
      },
    );

    try {
      final bool canLaunch = await canLaunchUrl(emailLaunchUri);
      if (canLaunch) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isThai
                  ? 'ไม่สามารถเปิดอีเมลได้'
                  : 'Cannot open email app')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                isThai ? 'เกิดข้อผิดพลาด: $e' : 'Error occurred: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isThai = appState.isThai;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isThai ? 'ศูนย์ช่วยเหลือ' : 'Help Center'),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: isThai ? 'ค้นหาคำถาม...' : 'Search questions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // FAQ title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isThai ? 'คำถามที่พบบ่อย' : 'Frequently Asked Questions',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // FAQ list
            Expanded(
              child: _filteredFaqList.isEmpty
                  ? Center(
                      child: Text(
                        isThai
                            ? 'ไม่พบคำถามที่ตรงกับการค้นหา'
                            : 'No matching questions found',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredFaqList.length,
                      itemBuilder: (context, index) {
                        final faq = _filteredFaqList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ExpansionTile(
                            title: Text(faq['question'] ?? ''),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(faq['answer'] ?? ''),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            // Contact support button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _contactSupport(isThai),
                icon: const Icon(Icons.chat),
                label: Text(isThai ? 'ติดต่อเจ้าหน้าที่' : 'Contact Support'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
