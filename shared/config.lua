-- ================================
-- USUI CORE - SHARED CONFIGURATION
-- ================================
-- ไฟล์นี้เก็บค่าการตั้งค่าทั่วไปของเซิร์ฟเวอร์
-- ใช้ได้ทั้ง Server Side และ Client Side

UsuiConfig = {
    -- เซิร์ฟเวอร์พื้นฐาน
    server = {
        name = "Usui MTA:SA Server",
        language = "th",
        version = "0.1.0"
    },
    
    -- ระบบ Inventory
    inventory = {
        maxWeight = 100,
        maxSlots = 50,
        defaultSlotSize = 1
    },
    
    -- ระบบเศรษฐกิจ
    economy = {
        startingMoney = 5000,
        minWage = 50,
        maxWage = 500
    },
    
    -- ระบบแอดมิน
    admin = {
        minLevel = 1,
        maxLevel = 10
    }
}
