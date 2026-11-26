import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.mpris as Mpris

Item {
    id: m
    Mpris.Mpris2Model { id: modelo }
    readonly property var p: modelo.currentPlayer
    readonly property bool sonando: p ? p.playbackStatus === Mpris.PlaybackStatus.Playing : false
    Rectangle { id: tapa; width: 84; height: 84; radius: 18; color: Qt.alpha(Kirigami.Theme.highlightColor, 0.18); anchors.verticalCenter: parent.verticalCenter; clip: true
        Image { id: arte; anchors.fill: parent; source: m.p ? m.p.artUrl : ""; fillMode: Image.PreserveAspectCrop; asynchronous: true }
        Kirigami.Icon { anchors.centerIn: parent; width: 36; height: 36; source: "media-playback-start"; visible: arte.status !== Image.Ready } }
    Column {
        anchors { left: tapa.right; leftMargin: 14; right: parent.right; verticalCenter: parent.verticalCenter }
        spacing: 4
        Text { width: parent.width; elide: Text.ElideRight; text: m.p && m.p.track ? m.p.track : "Nada sonando"; color: Kirigami.Theme.textColor; font { pixelSize: 15; bold: true } }
        Text { width: parent.width; elide: Text.ElideRight; text: m.p && m.p.artist ? m.p.artist : "Abrí música o un video"; color: Kirigami.Theme.disabledTextColor; font.pixelSize: 12 }
        Row { spacing: 10; topPadding: 4
            Repeater {
                model: [["media-skip-backward", "Previous"], [m.sonando ? "media-playback-pause" : "media-playback-start", "PlayPause"], ["media-skip-forward", "Next"]]
                delegate: Rectangle { width: 32; height: 32; radius: 16; color: za.containsMouse ? Qt.alpha(Kirigami.Theme.highlightColor, 0.35) : "transparent"; opacity: m.p ? 1 : 0.4
                    Kirigami.Icon { anchors.centerIn: parent; width: 18; height: 18; source: modelData[0] }
                    MouseArea { id: za; anchors.fill: parent; hoverEnabled: true; onClicked: if (m.p) m.p[modelData[1]]() } }
            }
        }
    }
}
