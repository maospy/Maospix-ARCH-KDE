// Greeter de Maospix-ARCH-KDE. Solo QtQuick: sin dependencias de Plasma ni del compositor.
import QtQuick

Rectangle {
    id: root
    width: 1366; height: 768
    color: config.superficie
    property int sesion: Math.max(0, sessionModel.lastIndex)
    property int usuario: Math.max(0, userModel.lastIndex)
    property string mensaje: ""
    property real u: Math.max(0.8, Math.min(width / 1366, height / 768))
    function entrar() { mensaje = ""; sddm.login(nombre.text, clave.text, sesion) }

    Connections {
        target: sddm
        function onLoginFailed() { root.mensaje = "Contraseña incorrecta"; clave.text = ""; clave.forceActiveFocus(); temblor.restart() }
    }

    Image { anchors.fill: parent; source: config.background; fillMode: Image.PreserveAspectCrop }

    // Reloj
    Column {
        anchors { left: parent.left; leftMargin: root.width * 0.09; verticalCenter: parent.verticalCenter }
        spacing: 4 * root.u
        property date ahora: new Date()
        Timer { interval: 1000; running: true; repeat: true; onTriggered: parent.ahora = new Date() }
        Text { text: Qt.formatTime(parent.ahora, "HH:mm"); color: config.texto; font { family: "Inter"; pixelSize: 104 * root.u; bold: true } }
        Text {
            text: { var t = parent.ahora.toLocaleDateString(Qt.locale(), "dddd d 'de' MMMM"); return t.charAt(0).toUpperCase() + t.slice(1) }
            color: config.texto2; font { family: "Inter"; pixelSize: 24 * root.u; bold: true }
        }
        Rectangle {
            width: 120 * root.u; height: 5 * root.u; radius: height / 2
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: config.acento }
                GradientStop { position: 1; color: config.violeta }
            }
        }
    }

    // Tarjeta
    Rectangle {
        id: tarjeta
        width: 380 * root.u; height: contenido.height + 64 * root.u
        anchors { right: parent.right; rightMargin: root.width * 0.09; verticalCenter: parent.verticalCenter }
        radius: 28 * root.u
        color: Qt.alpha(config.superficie, 0.86)
        border { width: 1.5; color: Qt.alpha(config.acento, 0.55) }
        SequentialAnimation {
            id: temblor
            NumberAnimation { target: giro; property: "x"; to: 12; duration: 50 }
            NumberAnimation { target: giro; property: "x"; to: -12; duration: 80 }
            NumberAnimation { target: giro; property: "x"; to: 0; duration: 60 }
        }
        transform: Translate { id: giro }

        Column {
            id: contenido
            width: parent.width - 64 * root.u
            anchors.centerIn: parent
            spacing: 16 * root.u

            Image { source: config.logo; height: 150 * root.u; fillMode: Image.PreserveAspectFit; anchors.horizontalCenter: parent.horizontalCenter; smooth: true; mipmap: true }

            // Usuario (editable; las flechas recorren los usuarios)
            Rectangle {
                width: parent.width; height: 48 * root.u; radius: height / 2; color: config.campo
                border { width: nombre.activeFocus ? 2 : 0; color: config.violeta }
                TextInput {
                    id: nombre
                    anchors { fill: parent; leftMargin: 44 * root.u; rightMargin: 44 * root.u }
                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                    color: config.texto; clip: true; selectByMouse: true
                    font { family: "Inter"; pixelSize: 17 * root.u; bold: true }
                    text: lista.count > 0 && lista.itemAt(root.usuario) ? lista.itemAt(root.usuario).usr : userModel.lastUser
                    KeyNavigation.tab: clave
                    onAccepted: clave.forceActiveFocus()
                }
                Repeater { id: lista; model: userModel; delegate: Item { property string usr: model.name } }
                Repeater {
                    model: lista.count > 1 ? [-1, 1] : []
                    delegate: Text {
                        text: modelData < 0 ? "‹" : "›"; color: config.acento; font.pixelSize: 26 * root.u
                        anchors.verticalCenter: parent.verticalCenter
                        x: modelData < 0 ? 18 * root.u : parent.width - 28 * root.u
                        MouseArea { anchors { fill: parent; margins: -10 } onClicked: { root.usuario = (root.usuario + modelData + lista.count) % lista.count; nombre.text = lista.itemAt(root.usuario).usr; clave.forceActiveFocus() } }
                    }
                }
            }

            // Contraseña
            Rectangle {
                width: parent.width; height: 48 * root.u; radius: height / 2; color: config.campo
                border { width: 2; color: root.mensaje ? config.error : clave.activeFocus ? config.acento : "transparent" }
                TextInput {
                    id: clave
                    anchors { fill: parent; leftMargin: 22 * root.u; rightMargin: 56 * root.u }
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password; passwordCharacter: "●"; color: config.texto; clip: true; focus: true
                    font { family: "Inter"; pixelSize: 16 * root.u }
                    onAccepted: root.entrar()
                    onTextChanged: if (text) root.mensaje = ""
                    KeyNavigation.tab: nombre
                }
                Text { visible: !clave.text; text: "Contraseña"; color: config.texto2; opacity: 0.7; anchors { left: parent.left; leftMargin: 22 * root.u; verticalCenter: parent.verticalCenter } font { family: "Inter"; pixelSize: 16 * root.u } }
                Rectangle {
                    width: 38 * root.u; height: width; radius: width / 2
                    anchors { right: parent.right; rightMargin: 5 * root.u; verticalCenter: parent.verticalCenter }
                    gradient: Gradient { GradientStop { position: 0; color: config.acento } GradientStop { position: 1; color: config.violeta } }
                    Text { anchors.centerIn: parent; text: "→"; color: config.superficie; font { pixelSize: 20 * root.u; bold: true } }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.entrar() }
                }
            }

            Text {
                width: parent.width; horizontalAlignment: Text.AlignHCenter; height: 18 * root.u
                text: root.mensaje ? root.mensaje : keyboard.capsLock ? "Bloq Mayús activado" : ""
                color: root.mensaje ? config.error : config.texto2; font { family: "Inter"; pixelSize: 14 * root.u; bold: true }
            }
        }
    }

    // Sesión: clic para cambiar
    Rectangle {
        id: botonSesion
        anchors { left: parent.left; bottom: parent.bottom; margins: 24 * root.u }
        width: textoSesion.width + 36 * root.u; height: 40 * root.u; radius: 18 * root.u
        color: Qt.alpha(config.superficie, 0.82); border { width: 1; color: Qt.alpha(config.acento, 0.4) }
        Repeater { id: sesiones; model: sessionModel; delegate: Item { property string n: model.name } }
        Text { id: textoSesion; anchors.centerIn: parent; text: "Sesión: " + (sesiones.count > root.sesion && sesiones.itemAt(root.sesion) ? sesiones.itemAt(root.sesion).n : "Plasma"); color: config.texto; font { family: "Inter"; pixelSize: 14 * root.u; bold: true } }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: if (sesiones.count) root.sesion = (root.sesion + 1) % sesiones.count }
    }

    // Energía
    Row {
        anchors { right: parent.right; bottom: parent.bottom; margins: 24 * root.u }
        spacing: 10 * root.u
        Repeater {
            model: [
                { t: "Suspender", v: sddm.canSuspend, f: function() { sddm.suspend() } },
                { t: "Reiniciar", v: sddm.canReboot, f: function() { sddm.reboot() } },
                { t: "Apagar", v: sddm.canPowerOff, f: function() { sddm.powerOff() } }
            ]
            delegate: Rectangle {
                visible: modelData.v
                width: rot.width + 36 * root.u; height: 40 * root.u; radius: 18 * root.u
                color: zona.containsMouse ? Qt.alpha(config.acento, 0.28) : Qt.alpha(config.superficie, 0.82)
                border { width: 1; color: Qt.alpha(config.violeta, 0.45) }
                Text { id: rot; anchors.centerIn: parent; text: modelData.t; color: config.texto; font { family: "Inter"; pixelSize: 14 * root.u; bold: true } }
                MouseArea { id: zona; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: modelData.f() }
            }
        }
    }
    Component.onCompleted: clave.forceActiveFocus()
}
