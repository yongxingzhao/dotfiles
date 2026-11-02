-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

-- ============================================================================
-- yoxi 个人配置 — 2026-10-24 从 ~/.config/hypr/*.conf 移植
-- (HyDE v26.10 起旧 .conf 全部不再被读取；原文件备份在
--  ~/.hyde-pre-update-20261024/hypr-config/，未删)
-- ============================================================================

local MOD = hyde.config.modifiers.main

-- ---- input / misc (was userprefs.conf) ----------------------------------
hl.config({
	input = {
		touchpad = { natural_scroll = true },
	},
	misc = {
		enable_swallow = true,
		swallow_regex = [[(foot|kitty|Alacritty|ghostty|Ghostty|org.wezfurlong.wezterm)]],
	},
	-- was nvidia.conf: cursor:no_hardware_cursors = true
	cursor = { no_hardware_cursors = true },
})

-- ---- fcitx5 输入法 (was userprefs.conf, Wayland 下 Electron/GTK 必需) ----
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT4_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus") -- GLFW 用 ibus 协议, fcitx 也支持

-- ---- nvidia (was nvidia.conf) -------------------------------------------
-- LIBVA_DRIVER_NAME / __GLX_VENDOR_LIBRARY_NAME / GBM_BACKEND 已由上游
-- env.lua 在检测到 nvidia 时自动设置，这里只补用户独有的 NVD_BACKEND。
hl.env("NVD_BACKEND", "direct")

-- ---- fcitx5 改由 XDG autostart 统一管理 (app-org.fcitx.Fcitx5@autostart); 此处仅导入 IM 环境变量 ----
hl.on("hyprland.start", function()
	-- 将输入法环境变量导入 systemd --user，使菜单/服务启动的 GUI 应用(QQ等)也能继承
	hl.exec_cmd(
		"systemctl --user import-environment GTK_IM_MODULE QT_IM_MODULE QT4_IM_MODULE XMODIFIERS SDL_IM_MODULE GLFW_IM_MODULE"
	)
end)

-- ---- monitors (was monitors.conf) ----------------------------------------
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.25 })
-- 2026-11-01: 坐标修正 1920x0 -> 1536x0
-- eDP-1 1920x1080@1.25 逻辑宽 1536，原 1920 会在两屏间留 384px 空隙
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "1536x0", scale = 1.25 })

-- ---- window rules (was windowrules.conf) ---------------------------------
-- 画中画 (原样移植)
-- 画中画: 上游 hyde_pin 已覆盖 float/move/size/pin, 此处只补上游没有的 keep_aspect_ratio
hl.window_rule({
	name = "yoxi_picture_in_picture",
	match = { title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] },
	tag = "+hyde_pin",
	keep_aspect_ratio = true,
})

-- 浮动规则
local float_rules = {
	[[^(Signal)$]],
	[[^(com.github.rafostar.Clapper)$]],
	[[^(app.drey.Warp)$]],
	[[^(net.davidotek.pupgui2)$]],
	[[^(yad)$]],
	[[^(eog)$]],
	[[^(io.github.alainm23.planify)$]],
	[[^(io.gitlab.theevilskeleton.Upscaler)$]],
	[[^(com.github.unrud.VideoDownloader)$]],
	[[^(io.gitlab.adhami3310.Impression)$]],
	[[^(io.missioncenter.MissionCenter)$]],
}
for i, cls in ipairs(float_rules) do
	hl.window_rule({ name = "yoxi_float_" .. i, match = { class = cls }, float = true })
end
hl.window_rule({ name = "yoxi_float_steam_friends", match = { title = [[^(Friends List)$]] }, float = true })
hl.window_rule({ name = "yoxi_float_steam_settings", match = { title = [[^(Steam Settings)$]] }, float = true })

-- jetbrains 下拉菜单闪烁 workaround
hl.window_rule({
	name = "yoxi_jetbrains_popup_focus",
	match = { class = [[^(.*jetbrains.*)$]], title = [[^(win[0-9]+)$]] },
	no_initial_focus = true,
})

-- layerrule (rofi/notifications/swaync/logout_dialog 的 blur + ignore_alpha)
-- 未移植: 上游 layer_rules.lua 已全部覆盖(且还多了 waybar/selection)。

-- ---- keybind 个性化 (was keybindings.conf 中的本地改动) ------------------

-- 终端走 prime-run (旧 $TERMINAL = prime-run kitty; 上游现在绑 hyde-shell app -T)
hl.bind(MOD .. " + T", hl.dsp.exec_cmd("prime-run kitty"), {
	description = "[Launcher|Apps] terminal emulator",
})

-- ---- 合盖迁移 v2: lid 轮询 (2026-11-01) ------------------------------
-- 根因: 本机 logind HandleLidSwitch=ignore, 合盖不会移除 eDP-1 连接器,
--       monitor.removed 事件永远不会触发 => v1(事件监听)方案必然无效。
-- 方案: hl.timer 每 2s 轮询 ACPI lid state, 主动开关内屏:
--   合盖 + HDMI 在线 + eDP 启用 -> 禁用 eDP-1
--     (Hyprland 内置 lifecycle 自动迁移工作区/窗口到外屏, v0.57 实测通过)
--   开盖 + eDP 被禁 -> 恢复 eDP-1
--   HDMI 不在线 + eDP 被禁 -> 强制恢复 (兜底, 防止无屏可用)
-- 日志: /tmp/lid-switch.log (仅状态切换时写入)

local LID_STATE_FILE = "/proc/acpi/button/lid/LID0/state"
local INT_MONITOR = "eDP-1"
local EXT_MONITOR = "HDMI-A-1"

local function lid_is_closed()
	local f = io.open(LID_STATE_FILE, "r")
	if not f then
		return nil
	end
	local s = f:read("*a")
	f:close()
	return s:find("closed", 1, true) ~= nil
end

-- 返回: true=启用 / false=被禁 / nil=不存在
local function monitor_state(name)
	for _, m in ipairs(hl.get_monitors({ all = true })) do
		if m.name == name then
			return m.enabled
		end
	end
	return nil
end

local function lid_log(msg)
	local f = io.open("/tmp/lid-switch.log", "a")
	if f then
		f:write(os.date("%m-%d %H:%M:%S ") .. msg .. "\n")
		f:close()
	end
end

local function set_internal_disabled(disabled, why)
	local ok, err = pcall(hl.monitor, { output = INT_MONITOR, disabled = disabled })
	lid_log((disabled and "OFF " or "ON  ") .. INT_MONITOR .. "  (" .. why .. ")  ok=" .. tostring(ok) .. (err and ("  err=" .. tostring(err)) or ""))
end

hl.timer(function()
	local closed = lid_is_closed()
	if closed == nil then
		return -- ACPI 节点异常, 不动作
	end
	local ext = monitor_state(EXT_MONITOR)
	local int = monitor_state(INT_MONITOR)
	if int == nil then
		return -- 内屏异常缺席, 不动作
	end

	if closed and ext == true and int == true then
		-- 合盖: 内屏窗口自动迁往外屏
		set_internal_disabled(true, "lid closed, " .. EXT_MONITOR .. " online")
	elseif (not closed) and int == false then
		-- 开盖: 恢复内屏
		set_internal_disabled(false, "lid opened")
	elseif ext == nil and int == false then
		-- 外屏没了但内屏被禁: 强制恢复, 保证至少一屏可用
		set_internal_disabled(false, EXT_MONITOR .. " gone, safety")
	end
end, { timeout = 2000, type = "repeat" })

lid_log("config loaded, lid timer armed")

