💼 Wallet Manage App

Flutter + Dart + GetX + Hive

Wallet Manage App คือแอปพลิเคชัน Flutter สำหรับ จัดการการเงินส่วนบุคคล ที่ช่วยให้ผู้ใช้สามารถบันทึกธุรกรรมการเงิน ทั้งรายรับและรายจ่าย พร้อมทั้งดูสรุปผลการใช้จ่ายได้อย่างง่ายดาย

แอปถูกออกแบบมาให้ใช้งานง่าย รองรับการเก็บข้อมูลแบบ ออฟไลน์ ด้วย Hive และมีระบบ Authentication เบื้องต้นเพื่อความปลอดภัย

📖 คำอธิบายแอป

แอปนี้ถูกสร้างขึ้นเพื่อช่วยผู้ใช้ในการ

ติดตามรายรับ-รายจ่าย ในแต่ละวัน

จัดการกระเป๋าเงิน (Wallets) หลายกระเป๋าได้ (เช่น เงินสด, บัญชีธนาคาร, e-Wallet)

ดูสรุปการเงิน ผ่าน Dashboard ที่ใช้งานง่าย

ควบคุมงบประมาณส่วนบุคคล และฝึกการจัดการเงินอย่างเป็นระบบ

🚀 ฟีเจอร์หลัก (Main Functions)

Authentication (ระบบผู้ใช้)

ลงทะเบียน (Register)

เข้าสู่ระบบ (Login)

จดจำผู้ใช้ที่เข้าสู่ระบบล่าสุด (Auto-login)

ออกจากระบบ (Logout)

Wallet Management (จัดการกระเป๋าเงิน)

สร้างกระเป๋าเงินใหม่

แก้ไขชื่อ/รายละเอียดกระเป๋าเงิน

ลบกระเป๋าเงิน

Transaction Management (จัดการธุรกรรม)

เพิ่มธุรกรรมใหม่ (รายรับ/รายจ่าย)

แก้ไขข้อมูลธุรกรรม

ลบธุรกรรมที่ไม่ต้องการ

กำหนดหมวดหมู่ธุรกรรม (เช่น อาหาร, เดินทาง, ของใช้)

Dashboard & Summary (สรุปผล)

แสดงรายรับและรายจ่ายรวม

แสดงยอดคงเหลือสุทธิ

กรองธุรกรรมตามวัน/เดือน

Data Storage (การจัดเก็บข้อมูล)

ใช้ Hive Database (เก็บข้อมูลแบบ Local)

ข้อมูลปลอดภัยและเข้าถึงได้รวดเร็ว

ทำงานได้แม้ ออฟไลน์

User Interface (การใช้งาน)

UI เรียบง่าย สะอาดตา

รองรับ Light/Dark Mode (กำลังพัฒนา)

ใช้ GetX เพื่อการจัดการ state ที่รวดเร็ว

⚙️ การทำงานหลัก (Workflow ของแอป)

ผู้ใช้เปิดแอป → ตรวจสอบสถานะ login

ถ้า login แล้ว → เข้าสู่ Dashboard
ถ้าไม่ login → ไปที่ หน้า Login/Register

ผู้ใช้สามารถ:

เลือกกระเป๋าเงิน → ดูธุรกรรม → เพิ่ม/แก้ไข/ลบ

ไปหน้า Dashboard → ดูสรุปยอดเงิน

ไปหน้า Profile → จัดการข้อมูลผู้ใช้

ข้อมูลทั้งหมดถูกบันทึกใน Hive Database บนอุปกรณ์
🚀 ฟีเจอร์หลัก

🔐 Authentication (Login, Register, Auto-login, Logout)

💰 Wallet Management (บันทึก, แก้ไข, ลบ รายรับ-รายจ่าย)

📊 Dashboard แสดงยอดรวม รายรับ-รายจ่าย และสรุปผล

🛡️ Secure Storage ด้วย Hive Database

🎨 UI/UX ทันสมัย รองรับ Light/Dark Theme

🔄 State Management ด้วย GetX

🏗️ โครงสร้างโปรเจ็กต์
lib/
├── components/       # UI Components เช่น ปุ่ม ฟอร์ม
├── controllers/      # GetX Controllers จัดการ state
├── models/           # Data Models เช่น Wallet, Transaction
├── routes/           # การกำหนดเส้นทาง Navigation
├── screens/          # หน้าต่างๆ ของแอป (Login, Home, Wallet, Profile)
├── services/         # การทำงานเบื้องหลัง เช่น Hive, Auth
├── utils/            # Helper functions และ Constants
└── main.dart         # Entry Point ของแอป

🛠️ เทคโนโลยีที่ใช้
หมวดหมู่	เทคโนโลยี
Framework	Flutter SDK
Language	Dart
State Mgmt	GetX
Database	Hive
Others	Path Provider, Flutter Lints
📲 การติดตั้ง
# Clone Repo
git clone https://github.com/Oatto319/Wallet_Manage.git
cd Wallet_Manage

# ติดตั้ง dependencies
flutter pub get

# ตรวจสอบ environment
flutter doctor

# รันแอป
flutter run

🔒 Security

Hive Database พร้อมระบบเข้ารหัส

Input Validation + Error Handling

การออกแบบตามหลัก Clean Code & Best Practices

📅 Roadmap (แผนการพัฒนา)

📊 กราฟแสดงแนวโน้มรายรับ-รายจ่าย

📁 การจัดการหมวดหมู่แบบ custom

🌍 รองรับหลายภาษา (EN/TH)

📤 การ export เป็น CSV/PDF

🔔 ระบบแจ้งเตือน (เตือนบันทึกธุรกรรม/เกินงบประมาณ)

👨‍💻 ผู้พัฒนา

นายวิมลชัย ด่านประสิทธิ์ผล 6612732126
นายธนาพนธ์ แต้มมาก     6612732112
นาย ปฏิพัทธ์ ศรีบุรินทร์    6612732117

สาขาวิทยาการคอมพิวเตอร์
