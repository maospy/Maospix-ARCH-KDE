import QtQuick

Rectangle {
    id: root
    property int stage
    color: "#0f1524"
    Image { id: logo; source: "images/logo.png"; anchors.centerIn: parent; height: Math.min(root.height * 0.3, 260); fillMode: Image.PreserveAspectFit; mipmap: true
        SequentialAnimation on scale { running: true; loops: Animation.Infinite
            NumberAnimation { to: 1.04; duration: 1100; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 1100; easing.type: Easing.InOutSine } } }
    Rectangle {
        anchors { horizontalCenter: parent.horizontalCenter; top: logo.bottom; topMargin: 48 }
        width: 220; height: 6; radius: 3; color: "#1f2a42"
        Rectangle { height: parent.height; radius: 3; width: parent.width * Math.min(root.stage / 6, 1)
            Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            gradient: Gradient { orientation: Gradient.Horizontal
                GradientStop { position: 0; color: "#4fd8e8" }
                GradientStop { position: 1; color: "#b393f5" } } }
    }
}
