import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

Window{
    signal acceptClicked(var request)
    property var request
    id: friendRequestWindow

    width: 400
    height: 200

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 6
        Label{
            text: "You have received a friend request from someone with this Tox ID"
        }
        TextField{
            id: friendRequestToxId
            Layout.fillWidth: true
            text: typeof request == "undefined" ? "" : request.toxId
            readOnly: true
        }
        Label{
            text: "Here is the accompanying message"
        }
        TextArea{
            id: friendRequestMessage
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: typeof request == "undefined" ? "" :request.message
            readOnly: true
        }
        RowLayout{
            Layout.fillWidth: true
            Button{
                text: "Deny"
                
                onClicked:{
                    friendRequestWindow.visible = false
                }
            }
            Item{
                Layout.fillWidth: true
                height: 20
            }
            Button{
                text: "Accept"
                
                onClicked: {
                    acceptClicked(request)
                    friendRequestWindow.visible = false
                }
            }
        }
    }
}
