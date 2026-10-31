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
		follow_mouse = 1,
		touchpad = { natural_scroll = true },
	},
	misc = {
		enable_swallow = true,
		swallow_regex = [[(foot|kitty|allacritty|Alacritty|ghostty|Ghostty|org.wezfurlong.wezterm)]],
	},
	-- was nvidia.conf: cursor:no_hardware_cursors = true
	cursor = { no_hardware_cursors = true },
})
-- 注: 旧配置里的 misc.disable_hyprland_pipeline 在 Hyprland 0.56 已不存在，未移植。

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

-- ---- 启动 fcitx5 (was exec-once = fcitx5 -d --replace) -------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5 -d --replace")
	-- 将输入法环境变量导入 systemd --user，使菜单/服务启动的 GUI 应用(QQ等)也能继承
	hl.exec_cmd(
		"systemctl --user import-environment GTK_IM_MODULE QT_IM_MODULE QT4_IM_MODULE XMODIFIERS SDL_IM_MODULE GLFW_IM_MODULE"
	)
end)

-- ---- monitors (was monitors.conf) ----------------------------------------
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.25 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "1920x0", scale = 1.25 })

-- ---- workspace 绑定 (was workspaces.conf) --------------------------------
-- 方案B: 不绑定具体 monitor, 工作空间可在多块屏间自由切换 (Hyprland 默认行为)
-- 单屏时也完全正常: 所有工作空间落到唯一存在的屏
-- ---- window rules (was windowrules.conf) ---------------------------------
-- 画中画 (原样移植)
hl.window_rule({
	name = "yoxi_picture_in_picture",
	match = { title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] },
	tag = "+picture-in-picture,+hyde_picture_in_picture",
	float = true,
	keep_aspect_ratio = true,
	move = "(monitor_w*0.73) (monitor_h*0.72)",
	size = "(monitor_w*0.25) (monitor_h*0.25)",
	pin = true,
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
