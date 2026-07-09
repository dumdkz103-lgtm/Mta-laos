-- ================================
-- USUI CORE - CLIENT HUD SYSTEM
-- ================================
-- ไฟล์นี้จัดการ HUD (Head-Up Display)
-- ประกอบด้วย การแสดงข้อมูลผู้เล่น, เงิน, HP, Armor

print("[INFO] Loading client HUD system...")

-- TODO: เพิ่มฟังก์ชัน Draw HUD
-- TODO: เพิ่มแสดงเงิน
-- TODO: เพิ่มแสดง Health/Armor
-- TODO: เพิ่มแสดงตำแหน่ง
-- TODO: เพิ่มแสดง Time/Weather

print("[INFO] Client HUD system loaded")
d +1278 -0
meta.xml
/workspace/mta_usui_pack/resources/[core]/usui_core
+31
-0
<meta>
    <info
        author="TRAE Assistant"
        name="Usui Core"
        version="0.1.0"
        type="script"
        description="แกนหลักสำหรับเซิร์ฟเวอร์ MTA:SA แนว Modern GTA V"
    />
 
    <min_mta_version client="1.6.0" server="1.6.0" />
 
    <script src="shared/config.lua" type="shared" />
    <script src="shared/items.lua" type="shared" />
    <script src="shared/helpers.lua" type="shared" />
 
    <script src="server/bootstrap.lua" type="server" />
    <script src="server/database.lua" type="server" />
    <script src="server/accounts.lua" type="server" />
    <script src="server/characters.lua" type="server" />
    <script src="server/inventory.lua" type="server" />
    <script src="server/admin.lua" type="server" />
 
    <script src="client/admin.lua" type="client" />
    <script src="client/hud.lua" type="client" />
 
    <oop>true</oop>
    <download_priority_group>1</download_priority_group>
 
    <export function="usuiGetBagConfig" type="shared" />
    <export function="usuiGetItemConfig" type="shared" />
</meta>
items.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/shared
+76
-0
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
 
function usuiGetItemConfig(itemName)
    return UsuiItems[itemName]
end
helpers.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/shared
+47
-0
function usuiGetBagConfig(level)
    return UsuiConfig.bagLevels[level]
end
 
function usuiSafeNumber(value, fallback)
    local converted = tonumber(value)
    if not converted then
        return fallback or 0
    end
 
    return converted
end
 
function usuiClamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end
 
    if value > maxValue then
        return maxValue
    end
 
    return value
end
 
function usuiText(value)
    return tostring(value or "")
end
 
function usuiSendLocalMessage(player, message, r, g, b)
    if not isElement(player) then
        return false
    end
 
    outputChatBox("[Usui] " .. usuiText(message), player, r or 255, g or 255, b or 255, true)
    return true
end
 
function usuiHashPassword(password)
    -- ใช้ hash ของ MTA เพื่อเก็บรหัสผ่านให้ปลอดภัยกว่าการเก็บเป็น plain text
    return hash("sha256", usuiText(password))
end
 
function usuiNow()
    -- เวลาในรูปแบบ unix timestamp ใช้เก็บเวลาสร้างหรืออัปเดตข้อมูล
    return getRealTime().timestamp
end
database.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/server
+71
-0
UsuiDatabase = {
    connection = nil
}
 
function usuiConnectDatabase()
    local db = UsuiConfig.database
 
    if db.type ~= "mysql" then
        outputDebugString("[Usui] รองรับเฉพาะ mysql ในเวอร์ชันเริ่มต้นนี้", 1)
        return false
    end
 
    local connectionString = string.format(
        "dbname=%s;host=%s;port=%d",
        db.name,
        db.host,
        db.port
    )
 
    UsuiDatabase.connection = dbConnect(
        "mysql",
        connectionString,
        db.username,
        db.password,
        db.options
    )
 
    if not UsuiDatabase.connection then
        outputDebugString("[Usui] เชื่อมฐานข้อมูลไม่สำเร็จ", 1)
        return false
    end
 
    outputDebugString("[Usui] เชื่อมฐานข้อมูลสำเร็จ", 3)
    return true
end
 
function usuiGetConnection()
    return UsuiDatabase.connection
end
 
function usuiQuery(query, ...)
    local connection = usuiGetConnection()
    if not connection then
        return false
    end
 
    local qh = dbQuery(connection, query, ...)
    if not qh then
        return false
    end
 
    return dbPoll(qh, -1)
end
 
function usuiExec(query, ...)
    local connection = usuiGetConnection()
    if not connection then
        return false
    end
 
    return dbExec(connection, query, ...)
end
 
function usuiGetLastInsertId()
    local rows = usuiQuery("SELECT LAST_INSERT_ID() AS id")
    if not rows or not rows[1] then
        return nil
    end
 
    return tonumber(rows[1].id)
end
accounts.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/server
+62
-0
function usuiLoadAccountToState(player, accountRow)
    usuiSetPlayerStateValue(player, "accountId", tonumber(accountRow.id))
    usuiSetPlayerStateValue(player, "adminLevel", tonumber(accountRow.admin_level) or 0)
    setElementData(player, "usui.accountId", tonumber(accountRow.id), false)
    setElementData(player, "usui.adminLevel", tonumber(accountRow.admin_level) or 0, false)
end
 
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
characters.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/server
+159
-0
function usuiApplyCharacter(player, characterRow)
    local spawn = {
        x = tonumber(characterRow.pos_x) or UsuiConfig.gameplay.defaultSpawn.x,
        y = tonumber(characterRow.pos_y) or UsuiConfig.gameplay.defaultSpawn.y,
        z = tonumber(characterRow.pos_z) or UsuiConfig.gameplay.defaultSpawn.z,
        rotation = tonumber(characterRow.rotation) or UsuiConfig.gameplay.defaultSpawn.rotation,
        interior = tonumber(characterRow.interior) or 0,
        dimension = tonumber(characterRow.dimension) or 0
    }
 
    spawnPlayer(
        player,
        spawn.x,
        spawn.y,
        spawn.z,
        spawn.rotation,
        tonumber(characterRow.skin) or UsuiConfig.gameplay.defaultSkin,
        spawn.interior,
        spawn.dimension
    )
 
    setCameraTarget(player, player)
    setElementHealth(player, tonumber(characterRow.health) or 100)
    setPedArmor(player, tonumber(characterRow.armor) or 0)
    setPlayerMoney(player, tonumber(characterRow.cash) or 0)
 
    usuiSetPlayerStateValue(player, "characterId", tonumber(characterRow.id))
    usuiSetPlayerStateValue(player, "bagLevel", tonumber(characterRow.bag_level) or UsuiConfig.gameplay.defaultBagLevel)
 
    setElementData(player, "usui.characterId", tonumber(characterRow.id), false)
    setElementData(player, "usui.characterName", tostring(characterRow.name), false)
    setElementData(player, "usui.bagLevel", tonumber(characterRow.bag_level) or UsuiConfig.gameplay.defaultBagLevel, false)
 
    usuiLoadInventory(player, tonumber(characterRow.id))
end
 
function usuiSaveCurrentCharacter(player)
    if not isElement(player) or not usuiHasCharacter(player) then
        return false
    end
 
    local characterId = usuiGetPlayerStateValue(player, "characterId")
    local x, y, z = getElementPosition(player)
    local _, _, rotation = getElementRotation(player)
 
    return usuiExec(
        [[
            UPDATE characters
            SET cash = ?, health = ?, armor = ?, pos_x = ?, pos_y = ?, pos_z = ?, rotation = ?, interior = ?, dimension = ?, updated_at = ?
            WHERE id = ?
        ]],
        getPlayerMoney(player),
        getElementHealth(player),
        getPedArmor(player),
        x,
        y,
        z,
        rotation,
        getElementInterior(player),
        getElementDimension(player),
        usuiNow(),
        characterId
    )
end
 
addCommandHandler("createchar", function(player, _, ...)
    if not usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "ต้องล็อกอินก่อน", 255, 100, 100)
    end
 
    local characterName = table.concat({ ... }, " ")
    if characterName == "" then
        return usuiSendLocalMessage(player, "ใช้ /createchar ชื่อตัวละคร", 255, 200, 0)
    end
 
    local accountId = usuiGetPlayerStateValue(player, "accountId")
    local success = usuiExec(
        [[
            INSERT INTO characters
            (account_id, name, skin, cash, bank, bag_level, health, armor, pos_x, pos_y, pos_z, rotation, interior, dimension, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]],
        accountId,
        characterName,
        UsuiConfig.gameplay.defaultSkin,
        UsuiConfig.gameplay.startingCash,
        UsuiConfig.gameplay.startingBank,
        UsuiConfig.gameplay.defaultBagLevel,
        100,
        0,
        UsuiConfig.gameplay.defaultSpawn.x,
        UsuiConfig.gameplay.defaultSpawn.y,
        UsuiConfig.gameplay.defaultSpawn.z,
        UsuiConfig.gameplay.defaultSpawn.rotation,
        UsuiConfig.gameplay.defaultSpawn.interior,
        UsuiConfig.gameplay.defaultSpawn.dimension,
        usuiNow(),
        usuiNow()
    )
 
    if not success then
        return usuiSendLocalMessage(player, "สร้างตัวละครไม่สำเร็จ", 255, 100, 100)
    end
 
    usuiSendLocalMessage(player, "สร้างตัวละครสำเร็จ ใช้ /charlist เพื่อตรวจสอบ", 100, 255, 100)
end)
 
addCommandHandler("charlist", function(player)
    if not usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "ต้องล็อกอินก่อน", 255, 100, 100)
    end
 
    local accountId = usuiGetPlayerStateValue(player, "accountId")
    local rows = usuiQuery(
        "SELECT id, name, bag_level, cash FROM characters WHERE account_id = ? ORDER BY id ASC",
        accountId
    )
 
    if not rows or #rows == 0 then
        return usuiSendLocalMessage(player, "ยังไม่มีตัวละคร ใช้ /createchar ก่อน", 255, 200, 0)
    end
 
    usuiSendLocalMessage(player, "รายการตัวละครของคุณ", 0, 200, 255)
    for _, row in ipairs(rows) do
        local line = string.format(
            "ID %d | %s | กระเป๋าเลเวล %d | เงินสด $%d",
            tonumber(row.id),
            tostring(row.name),
            tonumber(row.bag_level) or 1,
            tonumber(row.cash) or 0
        )
        usuiSendLocalMessage(player, line, 255, 255, 255)
    end
end)
 
addCommandHandler("selectchar", function(player, _, characterId)
    if not usuiIsLoggedIn(player) then
        return usuiSendLocalMessage(player, "ต้องล็อกอินก่อน", 255, 100, 100)
    end
 
    local targetCharacterId = tonumber(characterId)
    if not targetCharacterId then
        return usuiSendLocalMessage(player, "ใช้ /selectchar ไอดีตัวละคร", 255, 200, 0)
    end
 
    local accountId = usuiGetPlayerStateValue(player, "accountId")
    local rows = usuiQuery(
        "SELECT * FROM characters WHERE id = ? AND account_id = ? LIMIT 1",
        targetCharacterId,
        accountId
    )
 
    if not rows or not rows[1] then
        return usuiSendLocalMessage(player, "ไม่พบตัวละครนี้ในบัญชีของคุณ", 255, 100, 100)
    end
 
    usuiApplyCharacter(player, rows[1])
    usuiSendLocalMessage(player, "เข้าสู่ตัวละครสำเร็จ", 100, 255, 100)
end)
inventory.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/server
+132
-0
function usuiGetInventoryWeight(inventory)
    local totalWeight = 0
 
    for _, itemRow in pairs(inventory or {}) do
        local itemConfig = usuiGetItemConfig(itemRow.item_name)
        if itemConfig then
            totalWeight = totalWeight + ((tonumber(itemRow.amount) or 0) * (tonumber(itemConfig.weight) or 0))
        end
    end
 
    return totalWeight
end
 
function usuiGetCharacterBagConfig(player)
    local bagLevel = tonumber(usuiGetPlayerStateValue(player, "bagLevel", UsuiConfig.gameplay.defaultBagLevel))
    return usuiGetBagConfig(bagLevel), bagLevel
end
 
function usuiLoadInventory(player, characterId)
    local rows = usuiQuery(
        "SELECT id, slot, item_name, amount FROM inventories WHERE character_id = ? ORDER BY slot ASC",
        characterId
    ) or {}
 
    usuiSetPlayerStateValue(player, "inventory", rows)
    return rows
end
 
function usuiSaveInventoryRow(characterId, slot, itemName, amount)
    local rows = usuiQuery(
        "SELECT id FROM inventories WHERE character_id = ? AND slot = ? LIMIT 1",
        characterId,
        slot
    )
 
    if rows and rows[1] then
        return usuiExec(
            "UPDATE inventories SET item_name = ?, amount = ?, updated_at = ? WHERE id = ?",
            itemName,
            amount,
            usuiNow(),
            tonumber(rows[1].id)
        )
    end
 
    return usuiExec(
        "INSERT INTO inventories (character_id, slot, item_name, amount, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
        characterId,
        slot,
        itemName,
        amount,
        usuiNow(),
        usuiNow()
    )
end
 
function usuiGiveItem(player, itemName, amount)
    if not usuiHasCharacter(player) then
        return false, "ผู้เล่นยังไม่ได้เลือกตัวละคร"
    end
 
    local itemConfig = usuiGetItemConfig(itemName)
    if not itemConfig then
        return false, "ไม่พบไอเทมนี้"
    end
 
    local itemAmount = math.max(1, math.floor(tonumber(amount) or 1))
    local inventory = usuiGetPlayerStateValue(player, "inventory", {})
    local bagConfig = usuiGetCharacterBagConfig(player)
 
    local currentWeight = usuiGetInventoryWeight(inventory)
    local nextWeight = currentWeight + (itemAmount * itemConfig.weight)
    if nextWeight > bagConfig.maxWeight then
        return false, "น้ำหนักกระเป๋าเกิน"
    end
 
    local usedSlots = #inventory
    local targetSlot = usedSlots + 1
 
    if targetSlot > bagConfig.slots then
        return false, "ช่องกระเป๋าเต็ม"
    end
 
    local characterId = usuiGetPlayerStateValue(player, "characterId")
    local saved = usuiSaveInventoryRow(characterId, targetSlot, itemName, itemAmount)
    if not saved then
        return false, "บันทึกไอเทมไม่สำเร็จ"
    end
 
    usuiLoadInventory(player, characterId)
    return true, "รับไอเทมสำเร็จ"
end
 
addCommandHandler("inv", function(player)
    if not usuiHasCharacter(player) then
        return usuiSendLocalMessage(player, "ต้องเลือกตัวละครก่อน", 255, 100, 100)
    end
 
    local inventory = usuiGetPlayerStateValue(player, "inventory", {})
    local bagConfig, bagLevel = usuiGetCharacterBagConfig(player)
 
    usuiSendLocalMessage(
        player,
        string.format(
            "กระเป๋าเลเวล %d | %s | %d/%d ช่อง | น้ำหนัก %d/%d",
            bagLevel,
            bagConfig.label,
            #inventory,
            bagConfig.slots,
            usuiGetInventoryWeight(inventory),
            bagConfig.maxWeight
        ),
        0,
        200,
        255
    )
 
    if #inventory == 0 then
        return usuiSendLocalMessage(player, "กระเป๋ายังว่างอยู่", 255, 255, 255)
    end
 
    for _, row in ipairs(inventory) do
        local itemConfig = usuiGetItemConfig(row.item_name)
        local line = string.format(
            "ช่อง %d | %s x%d",
            tonumber(row.slot),
            itemConfig and itemConfig.label or tostring(row.item_name),
            tonumber(row.amount) or 0
        )
        usuiSendLocalMessage(player, line, 255, 255, 255)
    end
end)
config.lua
/workspace/mta_usui_pack/resources/[core]/usui_core/shared
+114
-0
UsuiConfig = {
    -- ชื่อเซิร์ฟเวอร์เอาไว้แสดงผลตามเมนูหรือข้อความต้อนรับ
    serverName = "Usui Modern GTA",
 
    -- กลุ่มค่าตั้งต้นที่เกี่ยวกับฐานข้อมูล
    database = {
        -- แนะนำให้ใช้ mysql หรือ mariadb ถ้าจะทำเซิร์ฟยาวจริง
        type = "mysql",
        host = "127.0.0.1",
        port = 3306,
        name = "mta_usui",
        username = "root",
        password = "change_me",
 
        -- options ของ dbConnect ใน MTA
        options = "share=1;autoreconnect=1;charset=utf8mb4"
    },
 
    -- ค่าตั้งต้นของเกมเพลย์
    gameplay = {
        startingCash = 5000,
        startingBank = 10000,
        defaultBagLevel = 1,
        defaultSkin = 0,
 
        -- จุดเกิดหลักของตัวละครใหม่
        defaultSpawn = {
            x = 1481.45,
            y = -1766.02,
            z = 18.79,
            rotation = 90,
            interior = 0,
            dimension = 0
        }
    },
 
    -- ระดับกระเป๋าที่ใช้กำหนดจำนวนช่อง น้ำหนัก และโบนัสขายของ
    bagLevels = {
        [1] = {
            label = "กระเป๋าผ้าพื้นฐาน",
            slots = 12,
            maxWeight = 20,
            sellMultiplier = 1.00
        },
        [2] = {
            label = "กระเป๋าทำงาน",
            slots = 18,
            maxWeight = 35,
            sellMultiplier = 1.10
        },
        [3] = {
            label = "กระเป๋าสายฟาร์ม",
            slots = 24,
            maxWeight = 50,
            sellMultiplier = 1.20
        },
        [4] = {
            label = "กระเป๋าองค์กร",
            slots = 32,
            maxWeight = 70,
            sellMultiplier = 1.35
        }
    },
 
    -- ระดับสิทธิ์แอดมิน
    adminLevels = {
        player = 0,
        helper = 1,
        moderator = 2,
        admin = 3,
        manager = 4,
        owner = 5
    },
 
    -- จุดวาร์ปกลางที่ใช้ทั้งคำสั่งและเมนูแอดมิน
    warpPoints = {
        cityhall = {
            label = "ศาลากลาง",
            x = 1481.45,
            y = -1766.02,
            z = 18.79,
            rotation = 90
        },
        hospital = {
            label = "โรงพยาบาล LS",
            x = 1178.38,
            y = -1323.77,
            z = 14.11,
            rotation = 270
        },
        police = {
            label = "สน. LS",
            x = 1552.49,
            y = -1675.63,
            z = 16.20,
            rotation = 90
        },
        market = {
            label = "ตลาดกลาง",
            x = 1315.72,
            y = -898.15,
            z = 39.58,
          
