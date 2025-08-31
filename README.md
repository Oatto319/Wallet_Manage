# 💼 WALLET MANAGE APP

**Flutter + Dart + GetX + Hive**

Wallet Manage App คือแอปพลิเคชัน Flutter สำหรับจัดการการเงินส่วนบุคคล  
ช่วยให้ผู้ใช้สามารถบันทึกธุรกรรมการเงิน ทั้งรายรับและรายจ่าย พร้อมดูสรุปผลการใช้จ่ายได้ง่ายดาย

แอปถูกออกแบบให้ใช้งานง่าย รองรับการเก็บข้อมูล **แบบออฟไลน์** ด้วย Hive และมีระบบ **Authentication** เบื้องต้นเพื่อความปลอดภัย

---

## 📖 คำอธิบายแอป

แอปนี้ถูกสร้างขึ้นเพื่อช่วยผู้ใช้ในการ:  
- ติดตามรายรับ-รายจ่ายในแต่ละวัน  
- จัดการกระเป๋าเงิน (Wallets) หลายกระเป๋าได้ (เช่น เงินสด, บัญชีธนาคาร, e-Wallet)  
- ดูสรุปการเงินผ่าน Dashboard ที่ใช้งานง่าย  
- ควบคุมงบประมาณส่วนบุคคลและฝึกการจัดการเงินอย่างเป็นระบบ  

---

## 🚀 ฟีเจอร์หลัก (MAIN FUNCTIONS)

### 🔐 AUTHENTICATION (ระบบผู้ใช้)
- ลงทะเบียน (Register)  
- เข้าสู่ระบบ (Login)  
- จดจำผู้ใช้ที่เข้าสู่ระบบล่าสุด (Auto-login)  
- ออกจากระบบ (Logout)  

### 💰 WALLET MANAGEMENT (จัดการกระเป๋าเงิน)
- สร้างกระเป๋าเงินใหม่  
- แก้ไขชื่อ/รายละเอียดกระเป๋าเงิน  
- ลบกระเป๋าเงิน  

### 📝 TRANSACTION MANAGEMENT (จัดการธุรกรรม)
- เพิ่มธุรกรรมใหม่ (รายรับ/รายจ่าย)  
- แก้ไขข้อมูลธุรกรรม  
- ลบธุรกรรมที่ไม่ต้องการ  
- กำหนดหมวดหมู่ธุรกรรม (เช่น อาหาร, เดินทาง, ของใช้)  

### 📊 DASHBOARD & SUMMARY (สรุปผล)
- แสดงรายรับและรายจ่ายรวม  
- แสดงยอดคงเหลือสุทธิ  
- กรองธุรกรรมตามวัน/เดือน  

### 💾 DATA STORAGE (การจัดเก็บข้อมูล)
- ใช้ **Hive Database** (เก็บข้อมูลแบบ Local)  
- ข้อมูลปลอดภัยและเข้าถึงได้รวดเร็ว  
- ทำงานได้แม้ออฟไลน์  

### 🎨 USER INTERFACE (การใช้งาน)
- UI เรียบง่าย สะอาดตา  
- รองรับ Light/Dark Mode (กำลังพัฒนา)  
- ใช้ **GetX** เพื่อการจัดการ State ที่รวดเร็ว  

---

## ⚙️ การทำงานหลัก (WORKFLOW)

1. ผู้ใช้เปิดแอป → ตรวจสอบสถานะ login  
2. ถ้า login แล้ว → เข้าสู่ Dashboard  
3. ถ้าไม่ login → ไปที่หน้า Login/Register  

ผู้ใช้สามารถ:  
- เลือกกระเป๋าเงิน → ดูธุรกรรม → เพิ่ม/แก้ไข/ลบ  
- ไปหน้า Dashboard → ดูสรุปยอดเงิน  
- ไปหน้า Profile → จัดการข้อมูลผู้ใช้  

ข้อมูลทั้งหมดถูกบันทึกใน Hive Database บนอุปกรณ์  

---

## 🏗️ โครงสร้างโปรเจ็กต์

lib/
├── components/ # UI Components เช่น ปุ่ม ฟอร์ม
├── controllers/ # GetX Controllers จัดการ state
├── models/ # Data Models เช่น Wallet, Transaction
├── routes/ # การกำหนดเส้นทาง Navigation
├── screens/ # หน้าต่างๆ ของแอป (Login, Home, Wallet, Profile)
├── services/ # การทำงานเบื้องหลัง เช่น Hive, Auth
├── utils/ # Helper functions และ Constants
└── main.dart # Entry Point ของแอป

yaml
คัดลอกโค้ด

---

## 🛠️ เทคโนโลยีที่ใช้

| หมวดหมู่          | เทคโนโลยี             |
|------------------|--------------------|
| Framework        | Flutter SDK        |
| Language         | Dart               |
| State Mgmt       | GetX               |
| Database         | Hive               |
| Others           | Path Provider, Flutter Lints |

---

## 📲 การติดตั้ง

```bash
# Clone Repo
git clone https://github.com/Oatto319/Wallet_Manage.git
cd Wallet_Manage

# ติดตั้ง dependencies
flutter pub get

# ตรวจสอบ environment
flutter doctor

# รันแอป
flutter run
🔒 SECURITY
Hive Database พร้อมระบบเข้ารหัส

Input Validation + Error Handling

การออกแบบตามหลัก Clean Code & Best Practices

📅 ROADMAP (แผนการพัฒนา)
📊 กราฟแสดงแนวโน้มรายรับ-รายจ่าย

📁 การจัดการหมวดหมู่แบบ custom

🌍 รองรับหลายภาษา (EN/TH)

📤 การ export เป็น CSV/PDF

🔔 ระบบแจ้งเตือน (เตือนบันทึกธุรกรรม/เกินงบประมาณ)

👨‍💻 ผู้พัฒนา
นายวิมลชัย ด่านประสิทธิ์ผล — 6612732126

นายธนาพนธ์ แต้มมาก — 6612732112

นายปฏิพัทธ์ ศรีบุรินทร์ — 6612732117

สาขาวิทยาการคอมพิวเตอร์
