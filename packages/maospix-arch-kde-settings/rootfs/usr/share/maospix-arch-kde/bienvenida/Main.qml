import QtQuick
import QtQuick.Window

Window {
    id: w
    title: "Bienvenida a Maospix"
    width: 720; height: 560; visible: true; color: "#0f1524"
    Column {
        anchors { fill: parent; margins: 32 }
        spacing: 16
        Row { spacing: 20
            Image { source: "file:///usr/share/pixmaps/maospix.png"; width: 96; height: 96; fillMode: Image.PreserveAspectFit; mipmap: true }
            Column { anchors.verticalCenter: parent.verticalCenter; spacing: 6
                Text { text: "Bienvenida a Maospix-ARCH-KDE"; color: "#e6ecff"; font { family: "Inter"; pixelSize: 26; bold: true } }
                Text { text: "Las ventanas se acomodan solas en mosaico. Super + Y lo enciende o apaga en cada escritorio."; color: "#b4c0dc"; font { family: "Inter"; pixelSize: 13 } width: 530; wrapMode: Text.WordWrap } } }
        Grid { columns: 2; spacing: 10
            Repeater {
                model: [["Super + Y", "Mosaico o flotante"], ["Super + G", "Flotar esta ventana"], ["Super + flechas", "Cambiar de ventana"], ["Super + Shift + flechas", "Mover la ventana"], ["Super + Ctrl + flechas", "Cambiar el tamaño"], ["Super + O", "Rotar el mosaico"], ["Super + M", "Maximizar"], ["Super + Q", "Cerrar"], ["Super + T", "Terminal"], ["Super + 1 a 4", "Ir al escritorio"], ["Super + Shift + 1 a 4", "Enviar al escritorio"], ["Super + Shift + Y", "Elegir otro diseño"]]
                delegate: Rectangle { width: 323; height: 46; radius: 16; color: "#182136"; border { width: 1; color: "#28344f" }
                    Rectangle { id: tecla; x: 8; anchors.verticalCenter: parent.verticalCenter; width: tt.width + 20; height: 30; radius: 12; color: index % 2 ? "#4a3685" : "#0f5a66"
                        Text { id: tt; anchors.centerIn: parent; text: modelData[0]; color: "#e6ecff"; font { family: "Inter"; pixelSize: 12; bold: true } } }
                    Text { anchors { left: tecla.right; leftMargin: 10; right: parent.right; rightMargin: 6; verticalCenter: parent.verticalCenter } elide: Text.ElideRight; text: modelData[1]; color: "#b4c0dc"; font { family: "Inter"; pixelSize: 13 } } } } }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: 180; height: 42; radius: 21
            gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#4fd8e8" } GradientStop { position: 1; color: "#b393f5" } }
            Text { anchors.centerIn: parent; text: "Empezar"; color: "#0f1524"; font { family: "Inter"; pixelSize: 15; bold: true } }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Qt.quit() } }
    }
    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }
}
