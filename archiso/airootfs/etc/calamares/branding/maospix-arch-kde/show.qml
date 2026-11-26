/* Maospix-ARCH-KDE: presentación mientras se instala (slideshowAPI 2).
   El fondo vive en la Presentation (ocupa todo el panel); cada Slide
   solo lleva el texto, porque Slide agrega márgenes propios. */
import QtQuick 2.15
import calamares.slideshow 1.0

Presentation {
    id: presentation

    readonly property var backgrounds: [ "slide1.jpg", "slide2.jpg", "slide3.jpg" ]

    Rectangle {
        anchors.fill: parent
        color: "#0f1733"
        z: -3
    }
    Image {
        anchors.fill: parent
        source: presentation.backgrounds[presentation.currentSlide % presentation.backgrounds.length]
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        z: -2
    }
    Rectangle {
        anchors.fill: parent
        z: -1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00050a1f" }
            GradientStop { position: 0.5; color: "#90050a1f" }
            GradientStop { position: 1.0; color: "#f2050a1f" }
        }
    }

    Timer {
        id: advance
        interval: 7000
        running: false
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    component MaospixSlide: Slide {
        id: s
        property string title: ""
        property string body: ""

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 10
            Rectangle {
                width: 56; height: 4; radius: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#20e7f2" }
                    GradientStop { position: 1.0; color: "#9658ff" }
                }
            }
            Text {
                width: parent.width
                text: s.title
                color: "#ffffff"
                font.pixelSize: 30
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                width: parent.width
                text: s.body
                color: "#d6def5"
                font.pixelSize: 16
                wrapMode: Text.WordWrap
                lineHeight: 1.25
            }
        }
    }

    MaospixSlide {
        title: "Bienvenido a Maospix-ARCH-KDE"
        body: "Arch Linux con KDE Plasma, listo para usar desde el primer arranque. Estamos copiando el sistema a tu disco."
    }
    MaospixSlide {
        title: "Mosaico cuando lo necesitás"
        body: "Super + Y alterna entre mosaico y ventanas flotantes en cada escritorio. Super + G hace flotar una ventana."
    }
    MaospixSlide {
        title: "Identidad MAOSPIX"
        body: "Panel superior, dock, iconos Tela Circle y la paleta azul noche, cian y violeta en todo el sistema."
    }
    MaospixSlide {
        title: "Protegido con snapshots"
        body: "Con Btrfs, cada actualización guarda una instantánea. Si algo falla, elegís una anterior desde el menú de GRUB."
    }
    MaospixSlide {
        title: "Hecho en Paraguay"
        body: "MAOSPIX es un proyecto de Marcos Olmedo (maospytek), Itauguá. ¡Gracias por probarlo!"
    }

    function onActivate() {
        presentation.currentSlide = 0;
        advance.running = true;
    }
    function onLeave() {
        advance.running = false;
    }
}
