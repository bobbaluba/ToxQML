/*
    A QML GUI for tox

    Copyright (C) 2013  Alek900 (alek900@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see {http://www.gnu.org/licenses/}.
*/

//A class for making tox.h more QT friendly
#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QTimer>
#include "tox.h"
#include "DHT.h"

class Core : public QObject
{
    Q_OBJECT

public:
    explicit Core(QObject *parent = 0);
    QString toxId();
    QString name();
    bool connected(){return m_connected;}

private:
    QTimer m_eventTimer;
    bool m_connected;

    Tox *m_tox;

    static void m_friendRequest(Tox *tox, uint8_t *public_key, uint8_t  *data, uint16_t length, void *userdata);
    static void m_friendMessage(Tox *tox, int friendnumber, uint8_t *message, uint16_t length, void *userdata);
    static void m_friendNameChange(Tox *tox, int friendnumber, uint8_t *newname, uint16_t length, void *userdata);
    static void m_friendStatusChange(Tox *tox, int friendnumber, uint8_t kind, void *userdata);
    static void m_friendStatusMessageChange(Tox *tox, int friendnumber, uint8_t *status, uint16_t length, void *userdata);
    static void m_friendConnectionStatuschange(Tox *tox, int friendnumber, uint8_t status, void* userdata);

    static void m_groupInvite(Tox *tox, int friendNumber, uint8_t *group_public_key, void *userdata);

    static void m_groupMessage(Tox *tox, int groupNumber, int friendGroupNumber,
                               uint8_t * message, uint16_t length, void *userdata);

    static void m_groupNameListChanged(Tox *tox, int groupNumber,
                                       int peernumber, TOX_CHAT_CHANGE change, void *userdata);

signals:

    void onStarted();
    void connectedChanged();

    void onFriendAdded(int friendnumber, const QString& public_key);

    //Friends
    void onFriendRequested(const QString& public_key, const QString& message);
    void onFriendMessaged(int friendnumber, const QString& message);
    void onFriendNameChanged(int friendnumber, const QString& name);
    void onFriendStatusChanged(int friendnumber, TOX_USERSTATUS status);
    void onFriendStatusTextChanged(int friendnumber, const QString& note);

    //Groups
    void onGroupInvite(int friendnumber, QString& public_key);
    void onGroupMessage(int groupnumber,int peernumber, const QString& message);
    void onGroupPeerAdd(int groupnumber, int peernumber);
    void onGroupPeerDel(int groupnumber, int peernumber);
    void onGroupPeerNameChanged(int groupnumber, int peernumber, QString& newname);

private slots:
    void m_processEvents();
    void m_checkConnection();

public slots:
    void start();
    void stop();

    void setName(const QString& name);
    void setStatusMessage(const QString& note);

    void acceptFriendRequest(const QString& friendToxId);
    void sendFriendRequest(const QString& key, const QString& message);

    void sendMessage(int friendNumber, const QString& message);

    void deleteFriend(int friendNumber);

    int addGroupchat();
    int delGroupchat(int groupNumber);
    int joinGroup(int friendNumber, QString& friend_group_public_key);
    int inviteFriend(int friendNumber, int groupNumber);

    QByteArray saveSettings();
    void loadSettings(QByteArray settings);
};

#endif // CORE_H
