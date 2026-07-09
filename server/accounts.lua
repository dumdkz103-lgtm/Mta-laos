-- ================================
-- USUI CORE - ACCOUNT SYSTEM
-- ================================
-- ไฟล์นี้จัดการระบบบัญชีผู้เล่น
-- ประกอบด้วย Login, Register, Character Select

print("[INFO] Loading account system...")

-- ================================
-- ACCOUNT STATE FUNCTIONS
-- ================================

function usuiSetPlayerStateValue(player, key, value)
    if not isElement(player) then
        return false
    end
    
    -- เก็บค่าใน element data เพื่อใช้ในภายหลัง
    setElementData(player, "usui.state." .. key, value, false)
    return true
end

function usuiGetPlayerStateValue(player, key, defaultValue)
    if not isElement(player) then
        return defaultValue
    end
    
    local value = getElementData(player, "usui.state." .. key)
    return value or defaultValue
end

function usuiIsLoggedIn(player)
    if not isElement(player) then
        return false
    end
    
    local accountId = usuiGetPlayerStateValue(player, "accountId")
    return accountId ~= nil and tonumber(accountId) ~= nil
end

function usuiGetPlayerAccountId(player)
    if not isElement(player) then
        return nil
    end
    
    return usuiGetPlayerStateValue(player, "accountId")
end

function usuiGetPlayerAdminLevel(player)
    if not isElement(player) then
        return 0
    end
    
    return usuiGetPlayerStateValue(player, "adminLevel", 0)
end

-- ================================
-- ACCOUNT LOADING FUNCTION
-- ================================

function usuiLoadAccountToState(player, accountRow)
    usuiSetPlayerStateValue(player, "accountId", tonumber(accountRow.id))
    usuiSetPlayerStateValue(player, "adminLevel", tonumber(accountRow.admin_level) or 0)
    setElementData(player, "usui.accountId", tonumber(accountRow.id), false)
    setElementData(player, "usui.adminLevel", tonumber(accountRow.admin_level) or 0, false)
end

-- ================================
-- REGISTER COMMAND
-- ================================

addCommandHandler("register", function(player, _, username, password)
    if usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "คุณล็อกอินอยู่แล้ว", 255, 100, 100)
    end

    if not username or not password then
        return usuiSendLocalMessage(player, "ใช้ /register ชื่อผู้ใช้ รหัสผ่าน", 255, 200, 0)
    end

    local exists = usuiQuery("SELECT id FROM accounts WHERE username = ? LIMIT 1", username)
    if exists and exists[1] then
        return usuiSendLocalMessage(player, "ชื่อผู้ใช้นี้มีอยู่แล้ว", 255, 100, 100)
    end

    local success = usuiExec(
        "INSERT INTO accounts (username, password_hash, created_at, updated_at) VALUES (?, ?, ?, ?)",
        username,
        usuiHashPassword(password),
        usuiNow(),
        usuiNow()
    )

    if not success then
        return usuiSendLocalMessage(player, "สมัครไม่สำเร็จ ตรวจสอบฐานข้อมูล", 255, 100, 100)
    end

    usuiSendLocalMessage(player, "สมัครสำเร็จ ใช้ /login เพื่อเข้าสู่ระบบ", 100, 255, 100)
end)

-- ================================
-- LOGIN COMMAND
-- ================================

addCommandHandler("login", function(player, _, username, password)
    if usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "คุณล็อกอินอยู่แล้ว", 255, 100, 100)
    end

    if not username or not password then
        return usuiSendLocalMessage(player, "ใช้ /login ชื่อผู้ใช้ รหัสผ่าน", 255, 200, 0)
    end

    local rows = usuiQuery(
        "SELECT id, username, admin_level, password_hash FROM accounts WHERE username = ? LIMIT 1",
        username
    )

    if not rows or not rows[1] then
        return usuiSendLocalMessage(player, "ไม่พบบัญชีนี้", 255, 100, 100)
    end

    local accountRow = rows[1]
    if accountRow.password_hash ~= usuiHashPassword(password) then
        return usuiSendLocalMessage(player, "รหัสผ่านไม่ถูกต้อง", 255, 100, 100)
    end

    usuiLoadAccountToState(player, accountRow)
    usuiSendLocalMessage(player, "ล็อกอินสำเร็จ ใช้ /charlist หรือ /createchar", 100, 255, 100)
end)

-- ================================
-- LOGOUT COMMAND
-- ================================

addCommandHandler("logout", function(player)
    if not usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "คุณไม่ได้ล็อกอินอยู่", 255, 100, 100)
    end

    usuiSetPlayerStateValue(player, "accountId", nil)
    usuiSetPlayerStateValue(player, "adminLevel", 0)
    setElementData(player, "usui.accountId", nil, false)
    setElementData(player, "usui.adminLevel", 0, false)
    
    usuiSendLocalMessage(player, "ล็อกเอาต์สำเร็จ", 100, 255, 100)
end)

print("[INFO] Account system loaded")
