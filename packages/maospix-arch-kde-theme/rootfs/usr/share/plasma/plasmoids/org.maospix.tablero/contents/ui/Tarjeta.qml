import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    property string titulo: ""
    radius: 20
    color: Qt.alpha(Kirigami.Theme.alternateBackgroundColor, 0.55)
    border { width: 1; color: Qt.alpha(Kirigami.Theme.highlightColor, 0.22) }
}
