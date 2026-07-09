# Usui Core - MTA:SA Server

แกนหลักสำหรับเซิร์ฟเวอร์ MTA:SA แนว Modern GTA V

## 📋 ข้อมูล

- **ชื่อ**: Usui Core
- **เวอร์ชัน**: 0.1.0
- **ผู้เขียน**: TRAE Assistant
- **ประเภท**: Script
- **ภาษาตัวอักษร**: Thai (ไทย)

## 🏗️ โครงสร้างโปรเจค

```
├── meta.xml                 # ไฟล์หลักของ MTA Resource
├── README.md               # ไฟล์อธิบายโปรเจค
│
├── shared/                 # ไฟล์ที่ใช้ได้ทั้ง Server และ Client
│   ├── config.lua         # ข้อมูลการตั้งค่า
│   ├── items.lua          # ข้อมูลไอเทม
│   └── helpers.lua        # ฟังก์ชันช่วยเหลือ
│
├── server/                 # ไฟล์ Server-side
│   ├── bootstrap.lua      # เตรียมการเซิร์ฟเวอร์
│   ├── database.lua       # การจัดการฐานข้อมูล
│   ├── accounts.lua       # ระบบบัญชี
│   ├── characters.lua     # ระบบตัวละคร
│   ├── inventory.lua      # ระบบ Inventory
│   └── admin.lua          # ระบบแอดมิน
│
└── client/                 # ไฟล์ Client-side
    ├── hud.lua            # หน้าจอแสดงข้อมูล
    └── admin.lua          # แผงควบคุมแอดมิน
```

## ⚙️ ข้อกำหนด

- **MTA:SA Client**: 1.6.0 ขึ้นไป
- **MTA:SA Server**: 1.6.0 ขึ้นไป
- **OOP System**: ต้องเปิดใช้งาน

## 🎯 ฟีเจอร์หลัก

- ✅ ระบบบัญชี (Login/Register)
- ✅ ระบบตัวละคร (Create/Load/Delete)
- ✅ ระบบ Inventory (เพิ่ม/ลบ/อัปเดต)
- ✅ ระบบแอดมิน (คำสั่ง, สิทธิ์)
- ✅ ระบบ HUD (แสดงข้อมูล)
- ✅ ระบบเศรษฐกิจ (เงิน, ค่าจ้าง)

## 📦 ระบบที่กำลังพัฒนา

### Shared (ใช้ได้ทั้ง Server/Client)
- [x] Config - ข้อมูลการตั้งค่า
- [x] Items - รายการสินค้า
- [x] Helpers - ฟังก์ชันช่วยเหลือ

### Server
- [ ] Database - จัดการฐานข้อมูล
- [ ] Accounts - ระบบบัญชี
- [ ] Characters - ระบบตัวละคร
- [ ] Inventory - ระบบ Inventory
- [ ] Admin - ระบบแอดมิน

### Client
- [ ] HUD - หน้าจอแสดงข้อมูล
- [ ] Admin Panel - แผงควบคุม

## 🚀 วิธีการติดตั้ง

1. ดาวน์โหลดโปรเจค
2. คัดลอกไปยังโฟลเดอร์ resources ของเซิร์ฟเวอร์
3. เพิ่มบรรทัดนี้ใน `mtaserver.conf`:
   ```xml
   <resource src="Mta-laos" startup="1" protected="0" />
   ```
4. รีสตาร์ทเซิร์ฟเวอร์

## 📝 หมายเหตุ

โปรเจคนี้อยู่ในขั้นพัฒนา โปรดอย่าใช้ในการเล่นจริงหรือเซิร์ฟเวอร์สาธารณะ

## 📞 ติดต่อ

หากมีคำถามหรือปัญหา โปรดติดต่อผู้พัฒนา

---

**Last Updated**: 2026-07-09
**Status**: In Development 🔨
