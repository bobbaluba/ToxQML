import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

Window{
    signal clickedSend(string key, string message)
    id: requestFriendWindow
    width: 400
    height: 200
    modality: Qt.WindowModal
    title: "Add friend"
    onVisibleChanged: {
        friendToxId.text = "";
        friendRequestMessage.text = "Please add me to your friend list";
    }
    
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        TextField{
            id: friendToxId
            Layout.fillWidth: true
            placeholderText: "Friend Tox ID"
        }
        Label{
            text: "Message:"
        }
        
        TextArea{
            id: friendRequestMessage
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        RowLayout{
            Button{
                text: "Cancel"
                onClicked: {
                    requestFriendWindow.visible = false;
                }
            }
            Item{
                Layout.fillWidth: true
                height: 20
            }
            Button{
                text: "Send request"
                onClicked: {
                    clickedSend(friendToxId.text, friendRequestMessage.text);
                    requestFriendWindow.visible = false;
                }
            }
        }
    }
    
}
