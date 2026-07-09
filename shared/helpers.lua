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

-- ================================
-- ADDITIONAL HELPER FUNCTIONS
-- ================================

-- ฟังก์ชันดึงค่าตั้งค่า Bag ตามระดับ
function usuiGetBagConfig(level)
    return UsuiConfig.bagLevels[level]
end

-- ฟังก์ชันแปลงค่าให้เป็นตัวเลขอย่างปลอดภัย
function usuiSafeNumber(value, fallback)
    local converted = tonumber(value)
    if not converted then
        return fallback or 0
    end

    return converted
end

-- ฟังก์ชันจำกัดค่าให้อยู่ในช่วง Min-Max
function usuiClamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
        return maxValue
    end

    return value
end

-- ฟังก์ชันแปลงค่าใดๆให้เป็น String
function usuiText(value)
    return tostring(value or "")
end

-- ฟังก์ชันส่งข้อความ Local ไปยังผู้เล่น
function usuiSendLocalMessage(player, message, r, g, b)
    if not isElement(player) then
        return false
    end

    outputChatBox("[Usui] " .. usuiText(message), player, r or 255, g or 255, b or 255, true)
    return true
end

-- ฟังก์ชันเข้ารหัสรหัสผ่าน (Hash SHA256)
function usuiHashPassword(password)
    -- ใช้ hash ของ MTA เพื่อเก็บรหัสผ่านให้ปลอดภัยกว่าการเก็บเป็น plain text
    return hash("sha256", usuiText(password))
end

-- ฟังก์ชันดึงเวลาปัจจุบัน (Unix Timestamp)
function usuiNow()
    -- เวลาในรูปแบบ unix timestamp ใช้เก็บเวลาสร้างหรืออัปเดตข้อมูล
    return getRealTime().timestamp
end
