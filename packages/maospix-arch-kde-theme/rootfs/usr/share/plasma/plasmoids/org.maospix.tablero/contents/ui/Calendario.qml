import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: c
    property date hoy: new Date()
    property int despl: 0
    readonly property date mes: new Date(hoy.getFullYear(), hoy.getMonth() + despl, 1)
    readonly property int hueco: (mes.getDay() + 6) % 7
    readonly property int dias: new Date(mes.getFullYear(), mes.getMonth() + 1, 0).getDate()
    spacing: 6
    RowLayout {
        Layout.fillWidth: true
        Text { Layout.fillWidth: true; text: { const t = c.mes.toLocaleDateString(Qt.locale(), "MMMM yyyy"); return t.charAt(0).toUpperCase() + t.slice(1) } color: Kirigami.Theme.highlightColor; font { pixelSize: 15; bold: true } }
        Repeater { model: [["‹", -1], ["›", 1]]
            delegate: Text { text: modelData[0]; color: Kirigami.Theme.textColor; font { pixelSize: 22; bold: true } leftPadding: 8; rightPadding: 8
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: c.despl += modelData[1] } } }
    }
    Grid {
        columns: 7; spacing: 2; Layout.alignment: Qt.AlignHCenter
        Repeater { model: ["L", "M", "M", "J", "V", "S", "D"]; delegate: Text { width: 34; horizontalAlignment: Text.AlignHCenter; text: modelData; color: Kirigami.Theme.disabledTextColor; font { pixelSize: 11; bold: true } } }
        Repeater { model: 42
            delegate: Rectangle {
                readonly property int d: index - c.hueco + 1
                readonly property bool esHoy: c.despl === 0 && d === c.hoy.getDate()
                width: 34; height: 27; radius: 13; color: esHoy ? Kirigami.Theme.highlightColor : "transparent"
                Text { anchors.centerIn: parent; visible: parent.d >= 1 && parent.d <= c.dias; text: parent.d; color: parent.esHoy ? "#0f1524" : index % 7 > 4 ? "#b393f5" : Kirigami.Theme.textColor; font { pixelSize: 12; bold: parent.esHoy } }
            } }
    }
}
