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

#include "coremodel.h"


Request::Request(QObject *parent) : QObject(parent)
{}

CoreModel::CoreModel(Core *core, QObject *parent) :
    QObject(parent)
{
    m_core = core;
    m_user = new Friend(-1);
    m_user->setName("Hello");
    m_user->setStatus(StatusWrapper::Online);
    connect(m_core, &Core::onFriendAdded, this, &CoreModel::onFriendAdded);
    connect(m_core, &Core::onFriendRequested, this, &CoreModel::onFriendRequest);
    connect(m_core, &Core::onFriendMessaged, this, &CoreModel::onFriendMessage);
    connect(m_core, &Core::onFriendNameChanged, this, &CoreModel::onFriendNameChanged);
    connect(m_core, &Core::onFriendStatusChanged, this, &CoreModel::onFriendStatusChanged);
    connect(m_core, &Core::onFriendStatusTextChanged, this, &CoreModel::onFriendStatusMessageChanged);

    connect(m_core, &Core::connectedChanged, this, &CoreModel::onConnectedChanged);

    connect(m_core, &Core::onStarted, this, &CoreModel::onCoreStarted);
}

void CoreModel::onConnectedChanged()
{
    m_connected = m_core->connected();
    emit connectedChanged();
}

void CoreModel::onFriendAdded(int friendnumber, const QString &key)
{
    Friend *newfriend = new Friend(friendnumber);
    newfriend->setToxId(key);
    newfriend->setName("???");
    newfriend->setStatus(StatusWrapper::Status::Offline);
    m_friendList.append(newfriend);
    m_friendmap[friendnumber] = newfriend;
    connect(newfriend, &Friend::m_sendmessage, this, &CoreModel::sendFriendMessage);
    connect(newfriend, &Friend::deleteFriend, this, &CoreModel::onFriendDelete);

    emit friendsChanged();
}

void CoreModel::onFriendDelete(int friendnumber)
{
    Friend* tmp = m_friendmap[friendnumber];
    m_friendList.removeAll(tmp);
    m_friendmap.remove(friendnumber);
    delete tmp;
    m_core->deleteFriend(friendnumber);
    emit friendsChanged();
}

void CoreModel::onFriendRequest(const QString& key, const QString& message)
{
    Request *newrequest = new Request(this);
    newrequest->m_key = key;
    newrequest->m_message = message;

    m_friendRequests.append(newrequest);
    emit friendRequest(newrequest);
    emit requestsChanged();
}

void CoreModel::onFriendMessage(int friendnumber, const QString& message)
{
    m_friendmap[friendnumber]->messageReceived(message);
}

void CoreModel::onFriendNameChanged(int friendnumber, const QString& name)
{
    m_friendmap[friendnumber]->setName(name);
}

void CoreModel::onFriendStatusChanged(int friendnumber, TOX_USERSTATUS status)
{
    m_friendmap[friendnumber]->setStatus((StatusWrapper::Status) status);
}

void CoreModel::onFriendStatusMessageChanged(int friendnumber, const QString& message)
{
    m_friendmap[friendnumber]->setStatusMessage(message);
}

void CoreModel::acceptFriendRequest(Request *newfriend)
{
    m_core->acceptFriendRequest(newfriend->m_key);
    m_friendRequests.removeAll(newfriend);
    emit requestsChanged();
}

void CoreModel::sendFriendRequest(const QString &key, const QString &message)
{
    m_core->sendFriendRequest(key, message);
}

void CoreModel::sendFriendMessage(int id, const QString &message)
{
    m_core->sendMessage(id, message);
}

void CoreModel::setName(const QString &name)
{
    m_core->setName(name);
    m_user->setName(name);
    emit userChanged();
}

void CoreModel::setStatusMessage(const QString &note)
{
    m_core->setStatusMessage(note);
    m_user->setStatusMessage(note);
    emit userChanged();
}

void CoreModel::onCoreStarted()
{
    m_user->setToxId(m_core->toxId());
    m_user->setName(m_core->name());
}
