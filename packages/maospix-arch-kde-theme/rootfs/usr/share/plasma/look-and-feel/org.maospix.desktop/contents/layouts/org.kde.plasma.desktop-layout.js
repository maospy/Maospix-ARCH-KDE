var plasma = getApiVersion(1)
const krunner = ConfigFile('krunnerrc')
krunner.group = 'General'
krunner.writeEntry('FreeFloating', true)
loadTemplate("org.maospix.desktop.defaultPanel")
loadTemplate("org.maospix.desktop.defaultDock")
for (const d of desktops()) {
    d.wallpaperPlugin = "org.kde.image"
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"]
    d.writeConfig("Image", "file:///usr/share/wallpapers/Maospix")
}
