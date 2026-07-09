-- ================================
-- USUI CORE - SERVER BOOTSTRAP
-- ================================
-- ไฟล์นี้ทำการเตรียมการและสตาร์ตเซิร์ฟเวอร์
-- เรียกใช้ก่อนโหลดมิดดิลแวร์อื่นๆ

print("=====================================")
print("Usui MTA:SA Server - Bootstrap")
print("Version: 0.1.0")
print("=====================================")

-- ตรวจสอบว่าระบบ OOP ถูกเปิดใช้งาน
if not getUsingOOP() then
    print("[ERROR] OOP system is not enabled!")
    print("Please enable OOP in meta.xml")
    return
end

print("[INFO] OOP system enabled successfully")

-- สตาร์ตฟังก์ชันพื้นฐาน
function initializeServer()
    print("[INFO] Initializing server...")
    
    -- TODO: เพิ่มฟังก์ชันสตาร์ตอื่นๆ
    
    print("[INFO] Server initialized successfully!")
end

-- เรียกใช้ฟังก์ชัน initialization เมื่อเซิร์ฟเวอร์เริ่มต้น
addEventHandler("onResourceStart", getResourceRootElement(), function()
    initializeServer()
end)
