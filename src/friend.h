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

#ifndef FRIEND_H
#define FRIEND_H
#include <QObject>
#include "statuswrapper.h"

class Friend : public QObject
{

    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(StatusWrapper::Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)
    Q_PROPERTY(QString toxId READ toxId NOTIFY toxIdChanged)
    Q_PROPERTY(QString chatlog READ chatlog WRITE setchatlog NOTIFY chatlogChanged)

public:
    Friend(int friendNumber, QObject *parent = 0);

    QString name(){return m_name;}
    StatusWrapper::Status status(){return m_status;}
    QString statusMessage(){return m_statusMessage;}
    QString toxId(){return m_toxId;}
    QString chatlog(){return m_chatlog;}

    void setName(const QString& name);
    void setToxId(const QString& toxId);
private:
    //I dont like you
    QString m_name;
    StatusWrapper::Status m_status;
    QString m_statusMessage;
    QString m_toxId;
    QString m_chatlog;

    int m_friendNumber; //I like you

signals:
    void nameChanged();
    void statusChanged();
    void statusMessageChanged();
    void toxIdChanged();

    void receivedMessage(const QString& message);
    void chatlogChanged();

    void m_sendmessage(int id, const QString &message);
    void deleteFriend(int id);

public slots:
    void setStatus(StatusWrapper::Status status);
    void setStatusMessage(const QString& note);
    void setchatlog(const QString& data);
    void m_receivedMessage(const QString& message);

    void sendMessage(const QString& message);
    void messageReceived(const QString &message);
    void deleteMe();
};

Q_DECLARE_METATYPE(Friend*)
#endif // FRIEND_H
