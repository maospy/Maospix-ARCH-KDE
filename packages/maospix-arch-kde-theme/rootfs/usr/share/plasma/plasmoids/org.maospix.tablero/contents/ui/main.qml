// Tablero Maospix: reloj del panel + tablero. Idea inspirada en el dashboard de Caelestia; código propio.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5
import org.kde.coreaddons as KCoreAddons

PlasmoidItem {
    id: root
    property date ahora: new Date()
    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.ahora = new Date() }
    P5.DataSource { id: exe; engine: "executable"; onNewData: source => disconnectSource(source) }
    KCoreAddons.KUser { id: yo }
    function fecha(f) { const t = root.ahora.toLocaleDateString(Qt.locale(), f); return t.charAt(0).toUpperCase() + t.slice(1) }
    toolTipMainText: fecha("dddd d 'de' MMMM")
    toolTipSubText: "Clic para abrir el tablero"
    preferredRepresentation: compactRepresentation

    compactRepresentation: MouseArea {
        Layout.minimumWidth: fila.implicitWidth + 24
        Layout.preferredWidth: fila.implicitWidth + 24
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded
        Rectangle { anchors { fill: parent; margins: 3 } radius: height / 2; color: Qt.alpha(Kirigami.Theme.highlightColor, root.expanded ? 0.3 : parent.containsMouse ? 0.18 : 0) }
        Row { id: fila; anchors.centerIn: parent; spacing: 8
            Text { anchors.verticalCenter: parent.verticalCenter; text: root.fecha("ddd d MMM"); color: Kirigami.Theme.textColor; font { family: "Inter"; pixelSize: 13; bold: true } }
            Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 5; height: 5; radius: 3; color: Kirigami.Theme.highlightColor }
            Text { anchors.verticalCenter: parent.verticalCenter; text: Qt.formatTime(root.ahora, "HH:mm"); color: Kirigami.Theme.textColor; font { family: "Inter"; pixelSize: 14; bold: true } } }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 780; Layout.preferredWidth: 780; Layout.maximumWidth: 780
        Layout.minimumHeight: 470; Layout.preferredHeight: 470; Layout.maximumHeight: 470

        // Reloj
        Tarjeta { x: 0; y: 0; width: 170; height: 290
            Column { anchors.centerIn: parent; spacing: -6
                Text { anchors.horizontalCenter: parent.horizontalCenter; text: Qt.formatTime(root.ahora, "HH"); color: "#4fd8e8"; font { family: "Inter"; pixelSize: 84; bold: true } }
                Text { anchors.horizontalCenter: parent.horizontalCenter; text: Qt.formatTime(root.ahora, "mm"); color: "#b393f5"; font { family: "Inter"; pixelSize: 84; bold: true } }
                Text { anchors.horizontalCenter: parent.horizontalCenter; topPadding: 12; text: root.fecha("ddd d MMM"); color: Kirigami.Theme.disabledTextColor; font { pixelSize: 14; bold: true } } } }
        // Calendario
        Tarjeta { x: 182; y: 0; width: 284; height: 290
            Calendario { anchors { fill: parent; margins: 14 } hoy: root.ahora } }
        // Usuario y sesión
        Tarjeta { x: 478; y: 0; width: 302; height: 138
            Rectangle { id: cara; x: 16; width: 64; height: 64; radius: 32; y: 14; color: "#4fd8e8"
                Text { anchors.centerIn: parent; text: yo.loginName.charAt(0).toUpperCase(); color: "#0f1524"; font { pixelSize: 30; bold: true } } }
            Text { x: 94; y: 22; text: yo.loginName; color: Kirigami.Theme.textColor; font { pixelSize: 19; bold: true } }
            Text { x: 94; y: 48; text: "Maospix-ARCH-KDE"; color: Kirigami.Theme.disabledTextColor; font { pixelSize: 12; bold: true } }
            Row { x: 12; y: 92; spacing: 6
                Repeater {
                    model: [["Bloquear", "system-lock-screen", "loginctl lock-session"], ["Captura", "spectacle", "spectacle"], ["Salir", "system-shutdown", "qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptAll"]]
                    delegate: Rectangle { width: 89; height: 34; radius: 17; color: zb.containsMouse ? Qt.alpha(Kirigami.Theme.highlightColor, 0.35) : Qt.alpha(Kirigami.Theme.highlightColor, 0.12)
                        Text { anchors.centerIn: parent; text: modelData[0]; color: Kirigami.Theme.textColor; font { pixelSize: 12; bold: true } }
                        MouseArea { id: zb; anchors.fill: parent; hoverEnabled: true; onClicked: { root.expanded = false; exe.connectSource(modelData[2]) } } } } } }
        // Recursos
        Tarjeta { x: 478; y: 150; width: 302; height: 140
            Loader { anchors.centerIn: parent; source: "Recursos.qml" } }
        // Música
        Tarjeta { x: 0; y: 302; width: 330; height: 168
            Loader { anchors { fill: parent; margins: 18 } source: "Musica.qml" } }
        // Atajos del mosaico
        Tarjeta { x: 342; y: 302; width: 438; height: 168
            Text { x: 18; y: 12; text: "Atajos del mosaico"; color: "#4fd8e8"; font { pixelSize: 14; bold: true } }
            Grid { x: 18; y: 38; columns: 2; columnSpacing: 16; rowSpacing: 5
                Repeater {
                    model: [["Super + Y", "mosaico / flotante"], ["Super + G", "flotar ventana"], ["Super + flechas", "cambiar foco"], ["Super + Shift + flechas", "mover"], ["Super + Ctrl + flechas", "tamaño"], ["Super + O", "rotar"], ["Super + T  /  Q", "terminal / cerrar"], ["Super + 1 a 4", "escritorios"]]
                    delegate: Column { width: 195
                        Text { text: modelData[0] + "  ·  " + modelData[1]; width: parent.width; elide: Text.ElideRight; color: Kirigami.Theme.textColor; font.pixelSize: 11 } } } }
            Text { x: 18; y: 140; text: "Ver la guía completa"; color: "#b393f5"; font { pixelSize: 12; bold: true; underline: true }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.expanded = false; exe.connectSource("maospix-bienvenida") } } } }
    }
}
