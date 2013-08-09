#-------------------------------------------------
#
# Project created by QtCreator 2013-08-07T21:52:15
#
#-------------------------------------------------

QT       += core gui quick

TARGET = Tox-Gui

TEMPLATE = app

CONFIG += c++11

INCLUDEPATH += submodule/ProjectTox-Core/core

win32:INCLUDEPATH += ../../libs/sodium/include/
macx:INCLUDEPATH += /usr/local/include

win32 {
    LIBS += -lWS2_32 ../../libs/sodium/lib/libsodium.a
} else {
    macx {
        LIBS += -L/usr/local/lib -lsodium
    } else {
        LIBS += -lsodium
    }
}

SOURCES += main.cpp \
    src/core.cpp \
    src/friend.cpp \
    src/coremodel.cpp

SOURCES += \
    submodule/ProjectTox-Core/core/util.c \
    submodule/ProjectTox-Core/core/ping.c \
    submodule/ProjectTox-Core/core/network.c \
    submodule/ProjectTox-Core/core/net_crypto.c \
    submodule/ProjectTox-Core/core/Messenger.c \
    submodule/ProjectTox-Core/core/Lossless_UDP.c \
    submodule/ProjectTox-Core/core/LAN_discovery.c \
    submodule/ProjectTox-Core/core/friend_requests.c \
    submodule/ProjectTox-Core/core/DHT.c


HEADERS  += \
    submodule/ProjectTox-Core/core/util.h \
    submodule/ProjectTox-Core/core/ping.h \
    submodule/ProjectTox-Core/core/packets.h \
    submodule/ProjectTox-Core/core/network.h \
    submodule/ProjectTox-Core/core/net_crypto.h \
    submodule/ProjectTox-Core/core/Messenger.h \
    submodule/ProjectTox-Core/core/Lossless_UDP.h \
    submodule/ProjectTox-Core/core/LAN_discovery.h \
    submodule/ProjectTox-Core/core/friend_requests.h \
    submodule/ProjectTox-Core/core/DHT.h \
    src/core.h \
    src/friend.h \
    src/coremodel.h \
    src/statuswrapper.h

OTHER_FILES += \
    resources/qml/main.qml

RESOURCES += \
    resources/qml.qrc
