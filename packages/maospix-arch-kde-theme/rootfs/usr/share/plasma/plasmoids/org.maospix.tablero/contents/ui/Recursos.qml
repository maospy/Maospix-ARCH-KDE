import QtQuick
import org.kde.ksysguard.sensors as Sensors

Row {
    spacing: 8
    Sensors.Sensor { id: cpu; sensorId: "cpu/all/usage" }
    Sensors.Sensor { id: ram; sensorId: "memory/physical/usedPercent" }
    Sensors.Sensor { id: disco; sensorId: "disk/all/usedPercent" }
    Aro { nombre: "CPU"; valor: cpu.value ?? 0; tono: "#4fd8e8" }
    Aro { nombre: "RAM"; valor: ram.value ?? 0; tono: "#b393f5" }
    Aro { nombre: "Disco"; valor: disco.value ?? 0; tono: "#d68cf5" }
}
