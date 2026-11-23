# อาคารสุพรีม - ตรวจเช็คซ่อมบำรุง (พร้อม Deploy ขึ้น Vercel + Supabase)

แอปนี้ถ่ายรูป + แนบไฟล์ได้จริง เพราะเป็นเว็บจริงที่มี https ของตัวเอง ไม่ได้อยู่ในกรอบ sandbox แล้ว

## 1. สร้าง Supabase (ฟรี)

1. เข้า https://supabase.com > New project > ตั้งชื่อ `supreme` > ตั้งรหัสผ่าน Database > Create
2. รอสร้างเสร็จ ไปที่เมนู **SQL Editor** > **New query** > คัดลอกไฟล์ `supabase/schema.sql` ทั้งหมดไปวาง > กด **Run**
3. ไปที่ **Storage** > ตรวจว่ามี Bucket ชื่อ `photos` แบบ Public แล้ว (ถ้าไม่มี ให้สร้างเอง ชื่อ `photos` + ติ๊ก Public)
4. ไปที่ **Project Settings > API** คัดลอก 2 ค่า:
   - Project URL
   - anon public key

## 2. ตั้งค่าบนเครื่องตัวเอง (ทดสอบก่อน)

```bash
npm install
cp .env.example .env
# เปิดไฟล์ .env แล้วใส่ค่าจริง
# VITE_SUPABASE_URL=https://xxx.supabase.co
# VITE_SUPABASE_ANON_KEY=xxx
npm run dev
```
เปิด http://localhost:5173 ทดสอบ Login + ถ่ายรูป

ถ้ายังไม่ใส่ .env แอปจะทำงานโหมดทดลอง: Login ด้วย `admin / 1234` ได้ รูปจะแสดง preview ในเครื่อง แต่ยังไม่อัปโหลดขึ้น Cloud

## 3. สมัครสมาชิก / เข้าใช้งานจริง

- หน้า Login มีปุ่ม **สร้างบัญชีใหม่** กรอกอีเมล + รหัสผ่าน (อย่างน้อย 6 ตัว) ระบบจะสร้างผู้ใช้ใน Supabase Auth ให้เลย
- บัญชีทดลองแบบไม่ต้องมี Supabase: `admin` / `1234` (ใช้ได้เฉพาะโหมดทดลอง)

## 4. Deploy ขึ้น Vercel (ให้เปิดบนมือถือได้)

1. อัปโหลดโฟลเดอร์นี้ขึ้น GitHub (สร้าง Repo ใหม่ แล้ว push)
2. เข้า https://vercel.com > Add New > Project > เลือก Repo นี้
3. ตรง **Environment Variables** ใส่ 2 ค่าเหมือนใน .env:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. กด **Deploy** รอจนเสร็จ จะได้ลิงก์ `https://supreme-xxx.vercel.app`
5. เอาลิงก์นั้นไปสร้าง QR Code ได้เลย เช่น `https://supreme-xxx.vercel.app/?system=fire` จะเปิดไปที่ฟอร์ม FHC ทันที

## 5. ทดสอบกล้องบนมือถือ

1. เปิดลิงก์ Vercel ด้วย Chrome (Android) หรือ Safari (iPhone)
2. เข้าเมนูตรวจเช็ค > เลือกหัวข้อ > กด **ถ่ายรูปจากกล้อง**
   - วิธีที่เสถียรสุด: ปุ่มนี้ใช้ `<input capture="environment">` มือถือจะเด้งไปแอปกล้องของเครื่องเลย ถ่ายเสร็จรูปจะกลับเข้ามาในฟอร์ม
3. หรือกด **เลือกจากไฟล์รูป** เพื่อเลือกรูปจากคลังภาพ
4. กด **บันทึก** รูปจะถูกอัปโหลดขึ้น Supabase Storage แล้วเก็บลิงก์ไว้ในตาราง `inspections`
5. ไปที่หน้า **ประวัติ** > กด **ดูรายละเอียด** จะเห็นรูปที่แนบไว้

## 6. ส่งออก Excel

- หน้า **ประวัติ** มีปุ่ม **ส่งออก Excel (.xlsx)** แยกชีตตามระบบ 9 ชีต + ปุ่ม **CSV สำรอง**
- ไฟล์ Excel จะมีรูปเป็นลิงก์ / สถานะมีรูป อยู่ในตารางด้วย

## โครงสร้างไฟล์

- `src/App.jsx` = โค้ดหลักทั้งหมด (Login, 8 ระบบ, Cooling Tower, Pump/Fan, FHC 98 จุด, ลายเซ็น, ประวัติ, Excel)
- `src/supabaseClient.js` = ต่อ Supabase
- `supabase/schema.sql` = สร้างตาราง + Bucket + Policy
- `public/hero.jpg` = รูปหน้า Login / หน้าหลัก

## ถ้ากล้องยังไม่ได้

- ต้องเปิดผ่าน `https://` เท่านั้น (Vercel ให้ https มาให้อยู่แล้ว) ห้ามเปิดผ่าน `http://`
- บน iPhone ต้องเปิดด้วย Safari ไม่ใช่เปิดในแชทแอป
- ถ้ากดแล้วไม่เด้ง ให้เข้า Settings ของมือถือ > เบราว์เซอร์ > อนุญาตกล้อง แล้วลองใหม่
