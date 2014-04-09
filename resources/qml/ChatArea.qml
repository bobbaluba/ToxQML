import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

Item{
    property var friend

    Rectangle{
        clip: true
        id: chatViewport
        anchors.margins: 4
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: textViewport.top
        border.width: 1
        border.color: disabledPalette.highlight
        radius: 3
        Flickable{
            id: chatScroller
            anchors.fill: parent
            anchors.margins: 6
            contentHeight: chatMessages.contentHeight + chatMessages.font.pixelSize + 6
            boundsBehavior: Flickable.StopAtBounds
            
            TextEdit{
                id: chatMessages
                anchors.fill: parent
                color: palette.text
                selectionColor: palette.highlight
                wrapMode: TextEdit.WordWrap
                selectByMouse: true
                selectedTextColor: palette.highlightedText

                text: typeof friend == "undefined" ? "" : friend.chatlog
                
                onTextChanged: {
                    if (contentHeight > chatViewport.height) {
                        chatScroller.contentY = contentHeight - chatViewport.height;
                    } else {
                        chatScroller.contentY = 0;
                    }
                }
                
            }
        }
    }

    Rectangle{
        id: textViewport
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        
        antialiasing: true
        radius: 3
        border.width: 1
        border.color: disabledPalette.dark
        
        height: 50
        clip: true
        Flickable{
            id: textScroller
            anchors.fill: parent
            anchors.margins: 6
            contentHeight: chatinput.contentHeight + chatinput.font.pixelSize + 6
            boundsBehavior: Flickable.StopAtBounds

            TextEdit{
                id: chatinput
                anchors.fill: parent
                color: palette.text
                selectionColor: palette.highlight
                selectedTextColor: palette.highlightedText
                selectByMouse: true
                onCursorPositionChanged: {
                    if (cursorRectangle.y >= textScroller.contentY + textViewport.height - 1.5*cursorRectangle.height - 6) {
                        textScroller.contentY = cursorRectangle.y - textViewport.height + cursorRectangle.height*1.5;
                    } else if (cursorRectangle.y < textScroller.contentY) {
                        textScroller.contentY = cursorRectangle.y;
                    }
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return){
                        if(!(event.modifiers & Qt.ShiftModifier)) {
                            friend.sendMessage(text);
                            text = "";
                            event.accepted = true;
                        }
                    } else if (event.key == Qt.Key_Escape) {
                        text = "";
                        focus = false;
                    }
                }

                Text{
                    text: qsTr("Type your message here...")
                    color: disabledPalette.text
                    visible: !parent.focus && !parent.text.length
                }
            }
            
        }
        
    }
}
