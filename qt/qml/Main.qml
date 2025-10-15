import QtCore
import QtQuick
import QtQuick.Controls
// import QtQuick.Controls.Fusion
import QtQuick.Layouts
import "../../lib.js" as Lib


ApplicationWindow {
    id: root
    title: "Balance "+String("#6.0")
    visible: true
    width: 0  //  /*640*/; onWidthChanged: geometryTimer.start()   //if (!geometryTimer.running) {geometryTimer.start()}
    height: 0 //  /*480*/; onHeightChanged: geometryTimer.start()  //if (!geometryTimer.running) {geometryTimer.start()}

    property string resthost: "http://localhost"
    property string restapi: "/api/dev"
    property string resttoken: ""
    property string restuser: ""
    property string restpassword: ""
    property string term: "KNMAIN"
    // property string crntacnt: ""

    Settings {
        category: "acnt_monitor"
        property alias width: root.width
        property alias height: root.height
    }

    Settings {
        category: "upload"
        property alias http_host: root.resthost
        property alias http_api: root.restapi
        property alias http_user: root.restuser
        property alias http_password: root.restpassword
    }

    function closeChildWindow(){
        documWindowLoader.active = false
    }

    function hd(vdate) { return Lib.humanDate(vdate); }

    ModelAcnt {
        id: acntData
        uri: resthost + restapi + "/accounts?api_token=" + resttoken
        title: "TRADE"
        bal: "35"
        onVkEvent: (id, param) => {
            if (id === 'log'){ logView.append("[ModelAcnt] " + param, 2)  }
            else if (id === 'err') { logView.append("[ModelAcnt] " + param, 0)  }
            else { logView.append("[ModelAcnt] BAD event !!!", 1)}
        }
    }

    Action {
        id: actionLogin
        text: "Login"
        onTriggered: Lib.loginRequest(resthost+restapi+"/auth", restuser, restpassword, (response) => {
            resttoken = ""
            // Lib.log(response.status);
            if (response.status === 200) {
                let isPlainText = response.contentType.length === 0
                if (isPlainText) {
                    // Lib.log( response.content);
                    resttoken = JSON.parse(response.content).token
                    acntData.load()

                }
            } else if (response.status === 0){
                logView.append("[Main] Site connection error", 0)
            } else {
                logView.append("[Main] " + JSON.parse(response.content).errstr, 0)
            }

        });
    }

    Action {
        id: actionDataLoad
        text: "Load data"
        onTriggered: acntData.load()
    }


    Loader{
        id: documWindowLoader
        active: false
        source: 'WebDocum.qml'
        onActiveChanged: if (active) {
                             item.visible = true
                             item.height = root.height
                             item.title = String("%1(%2)").arg(root.title).arg("documents")
                             item.uri = resthost + restapi + "/dcms?api_token=" + resttoken
                         }
//        onItemChanged: documWindowLoader.active = false
        Connections {
            target: documWindowLoader.item
            function onClosing(id) { documWindowLoader.active = false }
            function onVkEvent(id, param){
                if (id === 'log'){
                    logView.append("[WebDocum] " + param, 2)
                } else {
                    logView.append("[WebDocum] BAD event !!!", 1)
                }
            }

        }
    }

    Page{
        anchors.fill: parent
        header: ToolBar{
            anchors.margins: 5
            RowLayout {
                width:parent.width-5
                ToolButton {
                    id:btnNaviMenu
                    text: "☰"
                    // onClicked: acntAmnt.vkContentMenu.popup()
                    onClicked: {
                        for (let j = acntAmnt.dcmsContentMenu.length-1; j >= 0; --j) {
                            naviMenu.insertItem(1, acntAmnt.dcmsContentMenu[j])
                        }
                        for (let i = acntAmnt.fastContentMenu.length-1; i >= 0; --i) {
                            naviMenu.insertItem(0, acntAmnt.fastContentMenu[i])
                        }

                        naviMenu.open()     //drawerLeft.open()
                    }
                    Menu{
                        id: naviMenu
                        // property int mask:2
                        MenuSeparator {
                            padding: 5
                            contentItem: Label {
                                text: 'Операції по рахунку:'
                                font.bold: true
                            }
                        }
                        MenuSeparator {
                            padding: 5
                        }
                        Action {
                            text: qsTr("Settings")
                            onTriggered: settingsArea.visible = true
                        }
                        // MenuItem { action: actionLogin; }
                    }
                }
                Item{
                    width: 35   //parent.width
                    height: 35   //parent.height
                    VkReloadBtn{
                        id: btnReload
                        reloadInterval: 60
                        onVkEvent: (id, param) => {
                            if ((id === 'clicked') || (id === 'timerTriggered')){
                                actionDataLoad.trigger();
                            } else if (id === 'log'){
                                logView.append("[VkReloadBtn.btn] " + eventParam.text, 2)
                            } else {
                                logView.append("[VkReloadBtn.btn] BAD event !!!", 1)
                            }
                        }
                    }
                }
                Label {
                    id: pageTitle
                    Layout.fillWidth: true
                    text: acntData.title
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                TextField{
                    id: filter
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 30
                    selectByMouse: true
                    placeholderText: 'фільтр'
                    color: text===''?'lightgray':'black'
                    onAccepted: { acntData.flt = text; }
                    Text{
                        anchors{right:parent.right; verticalCenter: parent.verticalCenter}
                        text:' X '
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: if (filter.text !== ''){filter.text=''; acntData.flt = '';}
                        }
                    }
                }
            }

        }

        ColumnLayout{
            anchors{fill: parent; margins: 2}
            spacing: 2
            Rectangle{
                id: settingsArea
                visible: false
                Layout.preferredHeight: childrenRect.height +10
                Layout.fillWidth: true
                // radius: 10
                // color:"PowderBlue"
                ColumnLayout {
                    // width: parent.width
                    anchors.centerIn: parent
                    RowLayout {
                        spacing: 10
                        Label{
        //                    minimumPixelSize: 100
                            text: "Login:"
                        }
                        TextField{
                            id: editLogin
                            // Layout.fillWidth: true
                            placeholderText: "login user"
                            text: root.restuser
                            onEditingFinished: root.restuser = text
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label{
                            minimumPixelSize: 100
                            text: "password:"
                        }
                        TextField{
                            id: editPassword
                            // Layout.fillWidth: true
                            echoMode: TextInput.Password
                            placeholderText: "password"
                            text: root.restpassword
                            onEditingFinished: root.restpassword = text
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label{ text: "host:" }
                        TextField{
                            id: editUrl
                            // Layout.fillWidth: true
                            placeholderText: "host url"
                            text: root.resthost
                            onEditingFinished: root.resthost = text
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label{
        //                    minimumPixelSize: 100
                            text: "api:"
                        }
                        TextField{
                            id: editApi
                            placeholderText: "api"
                            text: root.restapi
                            onEditingFinished: root.restapi = text
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Button{
                            id:settingOk
                            text: "Ok"
                            onClicked: {
                                actionLogin.trigger()
                                settingsArea.visible = false
                            }
                        }
                        Button{
                            id:settingCancel
                            text: "Cancel"
                            onClicked: settingsArea.visible = false
                        }
                    }
                }
            }

            VkAcntAmnt{
                id: acntAmnt
                Layout.fillHeight: true
                Layout.fillWidth: true
                acntModel: acntData
                onVkEvent: (id, param) => {
                    if (id === 'log'){
                        logView.append("[VkAcntAmnt] " + param.text, 2)
                    } else if (id === 'loadDcms') {
                        documWindowLoader.active = true
                        documWindowLoader.item.queryData = param
                    } else {
                        logView.append("[VkAcntAmnt.qml] BAD event !!!", 1)
                    }

                }
            }
            LogView{
                id: logView
                Layout.fillWidth: true
                Layout.preferredHeight: count * 25
                Layout.maximumHeight: parent.height / 3
            }
        }


    }

    footer: Label {
        text: String(" %1.%2 ").arg(restuser).arg(resthost)
        background: Rectangle{color: 'whitesmoke'}
    }

    onClosing: {
        closeChildWindow()
    }

    Component.onCompleted: {
        actionLogin.trigger();
        // logView.append("11111 111",0)
        // logView.append("22222222222222222222222222222222222222222222222222222",1)
        // logView.append("3333",2)
        // logView.append("4444",0)
    }
}




