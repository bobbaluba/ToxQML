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

#ifndef FRIENDSMODEL_H
#define FRIENDSMODEL_H

#include <QObject>
#include <QHash>
#include "statuswrapper.h"
#include "friend.h"
#include "core.h"

class Request : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key)
    Q_PROPERTY(QString message READ message)

public:
    explicit Request(QObject *parent = 0);
    QString key(){return m_key;}
    QString message(){return m_message;}
    QString m_key;
    QString m_message;
};

//Not a QT model
class CoreModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* user READ user NOTIFY userChanged)
    Q_PROPERTY(QList<QObject*> friends READ friends NOTIFY friendsChanged)
    Q_PROPERTY(QList<QObject*> requests READ requests NOTIFY requestsChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
public:
    explicit CoreModel(Core* core, QObject *parent = 0);

    Friend* user(){return m_user;}
    QList<QObject*> friends(){return m_friendList;}
    QList<QObject*> requests(){return m_friendRequests;}
    bool connected(){return m_connected;}

    Q_INVOKABLE void sendFriendRequest(const QString& key, const QString& message);
    Q_INVOKABLE void sendFriendMessage(int id, const QString& message);

private:
    Friend* m_user;
    QHash<int, Friend*> m_friendmap; //used- for looking up based on core friendnumber
    QList<QObject*> m_friendList; //the list qml cares about.
    QList<QObject*> m_friendRequests;
    bool m_connected;

    Core *m_core;
signals:
    void userChanged();
    void friendsChanged();
    void requestsChanged();
    void connectedChanged();

    void friendRequest(QObject *request);

public slots:
    void onConnectedChanged();
    void onFriendAdded(int friendnumber, const QString& key);
    void onFriendDelete(int friendnumber);
    void onFriendRequest(const QString& key, const QString& message);
    void onFriendMessage(int friendnumber, const QString& message);
    void onFriendNameChanged(int friendnumber, const QString& name);
    void onFriendStatusChanged(int friendnumber, TOX_USERSTATUS status);
    void onFriendStatusMessageChanged(int friendnumber, const QString& message);

    void acceptFriendRequest(Request *newfriend);
    void setName(const QString& name);
    void setStatusMessage(const QString& note);

    void onCoreStarted();
};

Q_DECLARE_METATYPE(Request*)
Q_DECLARE_METATYPE(CoreModel*)
Q_DECLARE_METATYPE(QList<Request*>)
#endif // FRIENDSMODEL_H
