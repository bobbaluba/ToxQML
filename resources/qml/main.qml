import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.0

ApplicationWindow {
    property var currentFriend

    id: root
    visible: true
    width: 600
    height: 400

    Connections {
        target: CoreModel

        onFriendRequest: {
            var req = request;
            friendRequestReceivedWindow.request = req;
            friendRequestReceivedWindow.visible = true;
        }
    }

    RequestFriendWindow {
        id: addFriendWindow
        onClickedSend: {
            CoreModel.sendFriendRequest(toxId, message);
        }
    }

    FriendRequestWindow {
        id: friendRequestReceivedWindow
        onAcceptClicked: {
            CoreModel.acceptFriendRequest(request);
        }
    }

    Window {
        id: ourToxIdWindow
        color: palette.window
        width: toxIdText.__contentWidth
        height: 50
        minimumHeight: 50
        maximumHeight: 50

        Item {
            anchors.fill: parent
            anchors.margins: 6
            TextField {
                id: toxIdText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                text: CoreModel.user.toxId
                readOnly: true
            }
        }
    }

    Rectangle {
        id: ourUser
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: friendList.right
        height: 60
        color: palette.window
        Image {
            id: useravatar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 6
            fillMode: Image.PreserveAspectFit
            source: "qrc:/icons/avatar-default.png"
            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    ourToxIdWindow.visible = true;
                }
            }
        }

        Text {
            id: nametext
            anchors.left: useravatar.right
            anchors.bottom: useravatar.verticalCenter
            anchors.right: connectionstatusicon.left
            text: CoreModel.user.name === "" ? "New user" : CoreModel.user.name
            font.pointSize: 13
            color: palette.windowText
            elide: Text.ElideRight

            TextField {
                id: editname
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                visible: false
                text: parent.text
                onAccepted: {
                    CoreModel.setName(text)
                    visible = false
                }

                onFocusChanged: {
                    if (focus == false) {
                        visible = false;
                    }
                }

                Keys.onPressed: {
                    if (event.key === Qt.Key_Escape) {
                        focus = false;
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    editname.focus = true;
                    editname.selectAll();
                    editname.visible = true;
                }
            }
        }

        Text {
            id: statusmessage
            anchors.top: nametext.bottom
            anchors.left: nametext.left
            anchors.right: nametext.right
            text: CoreModel.user.statusMessage ? CoreModel.user.statusMessage : "Online"
            color: nametext.color
            font.pointSize: nametext.font.pointSize - 2
            elide: Text.ElideRight

            TextField {
                id: edituserstatusmessage
                anchors.top: parent.top
                anchors.left: parent.left
                visible: false
                text: statusmessage.text
                onAccepted: {
                    CoreModel.setStatusMessage(text)

                    visible = false
                }

                onFocusChanged: {
                    if (focus == false) {
                        visible = false
                    }
                }

                Keys.onPressed: {
                    if (event.key === Qt.Key_Escape) {
                        focus = false
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    edituserstatusmessage.focus = true;
                    edituserstatusmessage.selectAll();
                    edituserstatusmessage.visible = true;
                }
            }
        }

        SystemPalette {
            id: palette
            colorGroup: SystemPalette.Active
        }

        SystemPalette {
            id: disabledPalette
            colorGroup: SystemPalette.Disabled
        }

        Image {
            id: connectionstatusicon
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 6
            fillMode: Image.PreserveAspectFit
            width: 32
            source: CoreModel.connected ? "qrc:/icons/user-available.png" : "qrc:/icons/user-offline.png"
        }
    }

        TableView {
            id: friendList

            anchors.top: ourUser.bottom
            anchors.bottom: friendsToolbar.top
            anchors.left: parent.left

            width: 230

            headerVisible: false
            model: CoreModel.friends
            ListModel {
                id: statusList
                ListElement {
                    iconSource: "qrc:/icons/user-available.png"
                }
                ListElement {
                    iconSource: "qrc:/icons/user-away.png"
                }
                ListElement {
                    iconSource: "qrc:/icons/user-busy.png"
                }
                ListElement {
                    iconSource: "qrc:/icons/user-offline.png"
                }
                ListElement {
                    iconSource: "qrc:/icons/dialog-question.png"
                }
            }

            Menu {
                id: friendMenu
                MenuItem {
                    text: "Delete"
                    onTriggered: {
                        root.currentFriend.deleteMe()
                    }
                }
            }

            style: TableViewStyle {

                rowDelegate: Rectangle {
                    height: 60
                    color: styleData.selected ? palette.highlight : palette.base
                }

                itemDelegate: Item {
                    Image {
                        id: friendAvatar
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/icons/avatar-default.png"
                    }

                    Text {
                        id: name
                        anchors.left: friendAvatar.right
                        anchors.bottom: friendAvatar.verticalCenter
                        anchors.right: statusIcon.left
                        color: styleData.selected ? palette.highlightedText : palette.windowText
                        text: friendList.model[styleData.row].name
                        font.pointSize: 13
                        elide: Text.ElideRight
                    }

                    Text {
                        anchors.top: name.bottom
                        anchors.left: name.left
                        anchors.right: statusIcon.left
                        text: CoreModel.friends[styleData.row].statusMessage
                        color: name.color
                        font.pointSize: name.font.pointSize - 2
                        elide: Text.ElideRight
                    }

                    Image {
                        id: statusIcon
                        anchors.margins: 6
                        antialiasing: true
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        source: statusList.get(
                                    friendList.model[styleData.row].status).iconSource
                        width: 32
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            onCurrentRowChanged: {
                currentFriend = model[currentRow];
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    if (parent.currentRow >= 0) {
                        friendMenu.__popup(mouseX + parent.x,
                                           mouseY + parent.y, -1);
                    }
                }
            }

            TableViewColumn {
            }
        }

    Rectangle {
        anchors.left: friendList.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: Qt.darker(palette.window)
        width: 1
        anchors.margins: -1
    }

    Item {
        id: friendsToolbar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: friendList.right
        height: 50

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 6
            color: palette.window
            width: height
            Image {
                width: 32
                height: 32
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/icons/contact-new.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.border.width = 1
                }
                onExited: {
                    parent.border.width = 0
                }
                onClicked: {
                    addFriendWindow.visible = true;
                }
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 6
            color: palette.window
            width: height
            Image {
                width: 32
                height: 32
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: CoreModel.connected ? "qrc:/icons/network-idle.png" : "qrc:/icons/network-offline.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.border.width = 1
                }
                onExited: {
                    parent.border.width = 0
                }
                onClicked: {
                    addFriendWindow.visible = true;
                }
            }
        }
    }

    ChatArea {
        friend: currentFriend
        id: chatviews
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: friendList.right
        anchors.bottom: parent.bottom
    }
}
