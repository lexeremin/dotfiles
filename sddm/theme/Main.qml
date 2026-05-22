import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: config.background

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: 320

        Text {
            text: sddm.hostName
            color: config.muted
            font.family: config.font
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: Qt.formatDateTime(new Date(), "HH:mm")
            color: config.foreground
            font.family: config.font
            font.pixelSize: 56
            Layout.alignment: Qt.AlignHCenter
            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: parent.text = Qt.formatDateTime(new Date(), "HH:mm")
            }
        }

        ComboBox {
            id: user
            model: userModel
            currentIndex: userModel.lastIndex
            textRole: "name"
            Layout.fillWidth: true
            font.family: config.font
        }

        TextField {
            id: password
            echoMode: TextInput.Password
            placeholderText: "password"
            Layout.fillWidth: true
            font.family: config.font
            color: config.foreground
            background: Rectangle {
                color: "transparent"
                border.color: password.activeFocus ? config.accent : config.muted
                border.width: 1
                radius: 2
            }
            onAccepted: sddm.login(user.currentText, password.text, sessionModel.lastIndex)
            Keys.onReturnPressed: sddm.login(user.currentText, password.text, sessionModel.lastIndex)
        }

        ComboBox {
            id: session
            model: sessionModel
            currentIndex: sessionModel.lastIndex
            textRole: "name"
            Layout.fillWidth: true
            font.family: config.font
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            Button {
                text: "shutdown"
                onClicked: sddm.powerOff()
                font.family: config.font
                flat: true
            }
            Button {
                text: "reboot"
                onClicked: sddm.reboot()
                font.family: config.font
                flat: true
            }
            Button {
                text: "login"
                onClicked: sddm.login(user.currentText, password.text, session.currentIndex)
                font.family: config.font
                flat: true
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            password.text = ""
            password.focus = true
        }
    }
}
