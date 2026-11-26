import QtQuick
import QtQuick.Shapes
import org.kde.kirigami as Kirigami

Item {
    id: r
    property real valor: 0
    property string nombre: ""
    property color tono: Kirigami.Theme.highlightColor
    implicitWidth: 92; implicitHeight: 112
    Shape {
        id: s; width: 88; height: 88; anchors.horizontalCenter: parent.horizontalCenter
        preferredRendererType: Shape.CurveRenderer
        ShapePath { strokeWidth: 8; strokeColor: Qt.alpha(r.tono, 0.2); fillColor: "transparent"; capStyle: ShapePath.RoundCap
            PathAngleArc { centerX: 44; centerY: 44; radiusX: 38; radiusY: 38; startAngle: 135; sweepAngle: 270 } }
        ShapePath { strokeWidth: 8; strokeColor: r.tono; fillColor: "transparent"; capStyle: ShapePath.RoundCap
            PathAngleArc { centerX: 44; centerY: 44; radiusX: 38; radiusY: 38; startAngle: 135; sweepAngle: 270 * Math.max(0.01, Math.min(r.valor / 100, 1))
                Behavior on sweepAngle { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } } } }
    }
    Text { anchors.centerIn: s; text: Math.round(r.valor) + "%"; color: Kirigami.Theme.textColor; font { pixelSize: 17; bold: true } }
    Text { anchors { top: s.bottom; horizontalCenter: parent.horizontalCenter } text: r.nombre; color: Kirigami.Theme.disabledTextColor; font { pixelSize: 12; bold: true } }
}
