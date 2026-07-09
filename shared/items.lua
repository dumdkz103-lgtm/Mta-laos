-- ================================
-- USUI ITEMS CONFIGURATION
-- ================================
-- ไฟล์นี้กำหนดรายการสินค้าทั้งหมดในเซิร์ฟเวอร์
-- ประกอบด้วยข้อมูล: ชื่อ, น้ำหนัก, สามารถซ้อนกันได้หรือไม่, ราคาพื้นฐาน

UsuiItems = {
    -- ของกินพื้นฐาน
    water = {
        label = "น้ำดื่ม",
        weight = 1,
        stack = true,
        basePrice = 35
    },
 
    bread = {
        label = "ขนมปัง",
        weight = 1,
        stack = true,
        basePrice = 45
    },
 
    medkit = {
        label = "ชุดปฐมพยาบาล",
        weight = 2,
        stack = true,
        basePrice = 250
    },
 
    repairkit = {
        label = "ชุดซ่อมรถ",
        weight = 3,
        stack = true,
        basePrice = 600
    },
 
    copper = {
        label = "ทองแดง",
        weight = 2,
        stack = true,
        basePrice = 85
    },
 
    iron = {
        label = "เหล็ก",
        weight = 3,
        stack = true,
        basePrice = 130
    },
 
    fish = {
        label = "ปลา",
        weight = 2,
        stack = true,
        basePrice = 90
    },
 
    phone = {
        label = "โทรศัพท์",
        weight = 1,
        stack = false,
        basePrice = 2500
    },
 
    tablet_ems = {
        label = "แท็บเล็ต EMS",
        weight = 1,
        stack = false,
        basePrice = 4000
    },
 
    tablet_police = {
        label = "แท็บเล็ตตำรวจ",
        weight = 1,
        stack = false,
        basePrice = 4500
    }
}

-- ================================
-- EXPORTS FUNCTIONS
-- ================================

function usuiGetItemConfig(itemName)
    return UsuiItems[itemName]
end
