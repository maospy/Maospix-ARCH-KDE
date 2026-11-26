// Derivado de Garuda Mokka (GPL-3.0): gitlab.com/garuda-linux/themes-and-settings/settings/garuda-mokka
var plasma = getApiVersion(1)

// Create Top Panel
const panel = new Panel
panel.alignment = "left"
panel.floating = false
panel.height = Math.round(gridUnit * 1.8);
panel.location = "top"

// The order in which the below Applets are listed will be reflected from Left to Right in the Top Panel //

// Window Title - Using a fork for Plasma 6 (plasma6-applets-window-title https://aur.archlinux.org/packages/plasma6-applets-window-title)
var title = panel.addWidget("org.kde.windowtitle")
title.currentConfigGroup = ["General"]
title.writeConfig("filterActivityInfo", false)
title.writeConfig("lengthFirstMargin", 7)
title.writeConfig("lengthMarginsLock", false)
title.writeConfig("filterByScreen", true)
title.currentConfigGroup = ["Appearance"]
title.writeConfig("altTxt", "Maospix")
title.writeConfig("isBold", true)
title.writeConfig("txt", "%a")
title.writeConfig("visible", false)

// Window Global Menu
var plasmaappmenu = panel.addWidget("org.kde.plasma.appmenu")

// Add Left Expandable Spacer
var spacer = panel.addWidget("org.kde.plasma.panelspacer")

// Reloj y tablero Maospix
panel.addWidget("org.maospix.tablero")

// Add Right Expandable Spacer
var spacer = panel.addWidget("org.kde.plasma.panelspacer")

// Panel Colorizer for Top Panel
var colorizer = panel.addWidget("luisbocanegra.panel.colorizer")
colorizer.currentConfigGroup = ["General"]
colorizer.writeConfig("globalSettings", '{"panel":{"enabled":true,"blurBehind":false,"backgroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#013eff","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"foregroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#fc0000","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"padding":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"border":{"enabled":false,"customSides":false,"custom":{"widths":{"left":0,"bottom":3,"right":0,"top":0},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}}},"width":0,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#ff6c06","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true}},"shadow":{"background":{"enabled":false,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0},"foreground":{"enabled":false,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0}},"unfiedBackground":{"org.kde.plasma.digitalclock":0}},"widgets":{"enabled":true,"blurBehind":false,"backgroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#013eff","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"foregroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#fc0000","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"spacing":4,"border":{"enabled":false,"customSides":false,"custom":{"widths":{"left":0,"bottom":3,"right":0,"top":0},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}}},"width":0,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#ff6c06","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true}},"shadow":{"background":{"enabled":false,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0},"foreground":{"enabled":true,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0}},"unfiedBackground":{"org.kde.plasma.digitalclock":0}},"trayWidgets":{"enabled":false,"blurBehind":false,"backgroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#013eff","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"foregroundColor":{"enabled":false,"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#fc0000","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"border":{"enabled":false,"customSides":false,"custom":{"widths":{"left":0,"bottom":3,"right":0,"top":0},"margin":{"enabled":false,"side":{"right":0,"left":0,"top":0,"bottom":0}},"radius":{"enabled":false,"corner":{"topLeft":5,"topRight":5,"bottomRight":5,"bottomLeft":5}}},"width":0,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"highlightColor","systemColorSet":"View","custom":"#ff6c06","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true}},"shadow":{"background":{"enabled":false,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0},"foreground":{"enabled":false,"color":{"lightnessValue":0.5,"saturationValue":0.5,"alpha":1,"systemColor":"backgroundColor","systemColorSet":"View","custom":"#282828","list":["#f2878f","#8fd6a0","#f0d58a","#88a8d8","#b393f5","#4fd8e8","#f5b08a"],"followColor":0,"saturationEnabled":false,"lightnessEnabled":false,"animation":{"enabled":false,"interval":3000,"smoothing":800},"sourceType":1,"enabled":true},"size":5,"xOffset":0,"yOffset":0}},"unfiedBackground":{"org.kde.plasma.digitalclock":0}},"nativePanelBackground":{"enabled":false,"opacity":0},"forceForegroundColor":{"widgets":{"com.github.antroids.application-title-bar":{"method":{"mask":false,"multiEffect":false},"reload":true},"org.kde.plasma.appmenu":{"method":{"mask":false,"multiEffect":false},"reload":true}},"reloadInterval":250},"stockPanelSettings":{"position":3,"alignment":2,"width":2,"visibility":3,"opacity":2,"floating":false,"lengthMode":{"enabled":false,"value":"fill"},"thickness":{"enabled":false,"value":48},"visible":{"enabled":false,"value":true}},"configurationOverrides":{"overrides":{},"associations":{}},"overrideAssociations":{},"unifiedBackground":{}}')
colorizer.writeConfig("hideWidget", true)
colorizer.writeConfig("lastPreset", "/usr/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Maospix Top Panel")
colorizer.writeConfig("presetAutoloading", '{"enabled":true,"touchingWindow":"/usr/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Maospix Carbon","maximized":"/usr/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Maospix Carbon","normal":"/usr/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Maospix Top Panel"}')

// System Tray
var systray = panel.addWidget("org.kde.plasma.systemtray")
systray.currentConfigGroup = ["General"]
// In Plasma 6, 'scaleIconsToFit' is the boolean that toggles
// between "Small" (false) and "Scale with Panel height" (true)
systray.writeConfig("scaleIconsToFit", true)
systray.writeConfig("iconSize", 0) // Optional: If you want to ensure it doesn't default to a tiny fixed size

// User Switcher
var switcher = panel.addWidget("org.kde.plasma.userswitcher")
switcher.currentConfigGroup = ["General"]
switcher.writeConfig("showFace", true)
switcher.writeConfig("showName", false)
switcher.writeConfig("showTechnicalInfo", true)

// End of Top Panel creation //
