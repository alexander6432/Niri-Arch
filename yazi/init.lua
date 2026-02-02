function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		local hour = tonumber(os.date("%H", time))
		local suffix = hour < 12 and "AM" or "PM"
		time = os.date("%d %b %I:%M ", time) .. suffix
	else
		time = os.date("%d %b %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "", time)
end

require("recycle-bin"):setup()
require("full-border"):setup({ type = ui.Border.ROUNDED })
th.git = th.git or {}
th.git.modified_sign = "" -- Archivos modificados
th.git.deleted_sign = "" -- Archivos eliminados
th.git.added_sign = "" -- Archivos nuevos (staged o added)
th.git.untracked_sign = "?" -- Archivos sin seguimiento
th.git.ignored_sign = "" -- Ignorados (.gitignore)
th.git.updated_sign = "" -- Actualizados (renombrados, moved, etc.)
require("git"):setup({
	order = 500,
})
