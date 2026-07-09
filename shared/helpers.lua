-- ================================
-- USUI CORE - HELPER FUNCTIONS
-- ================================
-- ไฟล์นี้เก็บฟังก์ชันช่วยเหลือทั่วไป
-- ใช้ได้ทั้ง Server Side และ Client Side

-- ฟังก์ชันแปลงตัวเลขเป็นรูปแบบสกุลเงิน
function formatMoney(amount)
    return string.format("%,d", amount):gsub(",", ".")
end

-- ฟังก์ชันตรวจสอบว่าเป็นตัวเลขหรือไม่
function isNumber(value)
    return tonumber(value) ~= nil
end

-- ฟังก์ชันตัดข้อความตามจำนวนตัวอักษร
function truncateString(str, length)
    if string.len(str) > length then
        return string.sub(str, 1, length - 3) .. "..."
    end
    return str
end

-- ฟังก์ชันแยกข้อความตามตัวคั่น
function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
