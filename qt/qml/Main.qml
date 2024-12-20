import QtCore
import QtQuick
// import QtQuick.Window
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import "../../lib.js" as Lib
// import com.vkeeper 3.0


ApplicationWindow {
    id: root
    title: "AcntMonitor"+String("#2.7")
    visible: true
    width: 0  //  /*640*/; onWidthChanged: geometryTimer.start()   //if (!geometryTimer.running) {geometryTimer.start()}
    height: 0 //  /*480*/; onHeightChanged: geometryTimer.start()  //if (!geometryTimer.running) {geometryTimer.start()}

    property string resthost: "http://localhost"
    property string restapi: "/api/dev"
    property string resttoken: ""
    property string restuser: ""
    property string restpassword: ""
    property string term: "KNMAIN"
    property string crntacnt: ""

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

    Action {
        id: actionLogin
        text: "Login"
        onTriggered: Lib.loginRequest(resthost+restapi+"/auth", restuser, restpassword, (response) => {
            resttoken = ""
            // Lib.log(response.status);
            // Lib.log( response.content);
            if (response.status === 200) {
                let isPlainText = response.contentType.length === 0
                if (isPlainText) {
                    // Lib.log( response.content);
                    resttoken = JSON.parse(response.content).token
                    // msg( "token="+resttoken);
                    actionTrade.trigger()
                }
            } else if (response.status === 0){
                errorStr.text = "Site connection error"
            } else {
                errorStr.text = JSON.parse(response.content).errstr
            }

        });
    }

    Action {
        id: actionDataLoad
        text: "Load data"
        onTriggered: Lib.postRequest(resthost+restapi+"/accounts/index.php?api_token="+resttoken, {"reqid":"sel","acnt": crntacnt}, (response) => {
            // Lib.log("url: "+ resthost+restapi+"/test/index.php?api_token="+resttoken);
            // Lib.log("acnt: "+ crntacnt+" status: "+response.status+" content: "+response.content);
            // msg(response.headers);
            // Lib.log( response.content);
            // msg("contentType="+response.contentType)
            let j = false
            if (response.status === 200) {
                let isPlainText = response.contentType.length === 0
                if (isPlainText) {
                    // Lib.log( response.content);
                    j = Lib.parse(response.content)
                    if (j){
                        let vtot = 0
                        for (let i = 0; i < j.rslt.length; ++i) { vtot += acntAmnt.vhash(j.rslt[i].amnt,j.rslt[i].turncdt,j.rslt[i].turncdt); }
                        if (vtot.toFixed(0) !== acntAmnt.grandTotal) { acntAmnt.vpopulate(j.rslt, filter.text ); }
                        // else { Lib.log("#4hhf nothing to do"); }
                    } else { errorStr.text = "JSON parse data error"; }
                }
            } else if (response.status === 0){
                j = Lib.parse(response.content)
                if (j){ errorStr.text = "id:["+j.status +"] "+ j.str +" Note:"+ j.note ;}
                else { errorStr.text = "Site connection error"; }
            } else {
                // msg(JSON.parse(response.content).errstr);
                j = Lib.parse(response.content)
                if (j){ errorStr.text = "id:["+j.status +"] "+ j.str +" Note:"+ j.note ;}
                else { errorStr.text = "Site connection error"; }
            }

        });
    }

    Action {
        id: actionTrade
        text: "Trade"
        onTriggered: {
            pageTitle.text = text
            filter.text = ''
            crntacnt = "350"
            actionDataLoad.trigger()
        }
    }

    Action {
        id: actionCash
        text: "Каса"
        onTriggered: {
            pageTitle.text = text
            filter.text = ''
            crntacnt = "300"
            actionDataLoad.trigger()
        }
    }

    Action {
        id: actionDepo
        text: "Борги"
        onTriggered: {
            pageTitle.text = text
            filter.text = ''
            crntacnt = "360"
            actionDataLoad.trigger()
        }
    }

    Action {
        id: actionCapital
        text: "Капітал"
        onTriggered: {
            pageTitle.text = text
            filter.text = ''
            crntacnt = "420"
            actionDataLoad.trigger()
        }
    }


    Loader{
        id: documWindowLoader
        active: false
        source: 'WebDocum.qml'
        onActiveChanged: if (active) {
                             item.visible = true
                             item.height = root.height
                             item.title = String("%1(%2)").arg(root.title).arg("documents")
                         }
//        onItemChanged: documWindowLoader.active = false
        Connections {
            target: documWindowLoader.item
            function onClosing(id) { documWindowLoader.active = false }
            function onVkEvent(id, param){
                // msg("#790e documWindowLoader.onVkEvent"+id)
                if (id === 'postQuery'){ uplMngr.post("/sout2.php", param.query); }
                else if (id === 'log') { Lib.log(param,'WebDocum.qml'); }
            }

        }
    }

    Page{
        anchors.fill: parent
//        Layout.preferredWidth: 360
//        Layout.fillHeight: true
        header: ToolBar{
            anchors.margins: 5
            RowLayout {
                width:parent.width-5
                ToolButton {
                    id:btnNaviMenu
                    text: "☰"
                    onClicked: naviMenu.open()     //drawerLeft.open()
                    Menu{
                        id: naviMenu
                        property int mask:2
                        MenuItem { action: actionTrade; }
                        MenuItem { action: actionCash; }
                        MenuItem { action: actionDepo; }
                        MenuItem { action: actionCapital; }
                        MenuSeparator {
                            padding: 5
                            contentItem: Label {
                                text: 'Операції по рахунку:'
                                font.bold: true
                            }
                        }

                        MenuItem {
                            height: visible?30:0
                            enabled: acntAmnt.crntRow!==undefined
                            text: "Останній день"
                            onClicked: {
                                let req = {
                                    "reqid" : "sel",
                                    "shop" : acntAmnt.crntRow.shop,
                                    // "acnt" : acntAmnt.crntRow.acntno,
                                    // "cur" : acntAmnt.crntRow.id,
                                    "from" : acntAmnt.crntRow.tm.substring(0,10)
                                }
                                // Lib.log("#94uj req=" + JSON.stringify(req) +"\n acntAmnt.crntRow="+JSON.stringify(acntAmnt.crntRow))
                                Lib.postRequest(resthost+restapi+"/dcms/index.php?api_token="+resttoken, req, (response) => {
                                            // Lib.log(response.status);
                                            // msg(response.headers);
                                            // msg("contentType="+response.contentType)
                                            let j = false;
                                            // Lib.log("#26g status="+response.status+"\n content="+ response.content);
                                            if (response.status === 200) {
                                                let isPlainText = response.contentType.length === 0
                                                if (isPlainText) {
                                                    documWindowLoader.active = true
                                                    documWindowLoader.item.rowSelect =  {'shop':acntAmnt.crntRow.shop,
                                                                'acntno':acntAmnt.crntRow.acntno,
                                                                'curid':acntAmnt.crntRow.id==='' ? documWindowLoader.item.domestic.id : acntAmnt.crntRow.id}
                                                    // documWindowLoader.item.pageTitle = acntAmnt.crntRow.shop + ' ' + acntAmnt.crntRow.chid
                                                    // documWindowLoader.item.pageSubtitle = "#"+acntAmnt.crntRow.acntno
                                                            // documWindowLoader.item.vrowFilter = acntAmnt.crntRow.chid
                                                    j = Lib.parse(response.content)
                                                    if (j) {  documWindowLoader.item.jdata = j.rslt; }
                                                    else { errorStr.text = "JSON parse data error"; }
                                                }
                                            } else {
                                                // msg( response.content);
                                                // Lib.log(JSON.parse(response.content).errstr);
                                                j = Lib.parse(response.content)
                                                if (j){ errorStr.text = "id:["+j.status +"] "+ j.str +" Note:"+ j.note ;}
                                                else { errorStr.text = "Site connection error"; }
                                            }

                                        });
                            }
                        }
                        MenuItem {
                            height: visible?30:0
                            enabled: acntAmnt.crntRow!==undefined
                            text: "Останній тиждень"
                            onClicked: {
                                var dnow = new Date(acntAmnt.crntRow.tm)
                                var dprev = new Date(dnow.getFullYear(), dnow.getMonth(), dnow.getDate()-7)
                                let req = {
                                    "reqid" : "sel",
                                    "shop" : acntAmnt.crntRow.shop,
                                    "from" : Qt.formatDate( dprev, "yyyy-MM-dd")
                                }
                                let j = false;
                                Lib.postRequest(resthost+restapi+"/dcms/index.php?api_token="+resttoken, req, (response) => {
                                            if (response.status === 200) {
                                                let isPlainText = response.contentType.length === 0
                                                if (isPlainText) {
                                                    documWindowLoader.active = true
                                                    documWindowLoader.item.rowSelect =  {'shop':acntAmnt.crntRow.shop,
                                                                'acntno':acntAmnt.crntRow.acntno,
                                                                'curid':acntAmnt.crntRow.id==='' ? documWindowLoader.item.domestic.id : acntAmnt.crntRow.id}
                                                    j = Lib.parse(response.content)
                                                    if (j) {  documWindowLoader.item.jdata = j.rslt; }
                                                    else { errorStr.text = "JSON parse data error"; }
                                                }
                                            } else {
                                                j = Lib.parse(response.content)
                                                if (j){ errorStr.text = "id:["+j.status +"] "+ j.str +" Note:"+ j.note ;}
                                                else { errorStr.text = "Site connection error"; }
                                            }

                                        });
                            }
                        }
                        MenuItem {
                            height: visible?30:0
//                            enabled: contentView.currentIndex!=-1
                            text: "Останні 200 по рах/вал"
                            onClicked: {
                                let req = {
                                    "reqid" : "sel",
                                    "shop" : acntAmnt.crntRow.shop,
                                    "acnt" : acntAmnt.crntRow.acntno,
                                    "cur" : acntAmnt.crntRow.id,
                                    "limit" : "200"
                                }
                                // Lib.log("#94uj req=" + JSON.stringify(req) +"\n acntAmnt.crntRow="+JSON.stringify(acntAmnt.crntRow))
                                Lib.postRequest(resthost+restapi+"/dcms/index.php?api_token="+resttoken, req, (response) => {
                                            // Lib.log(response.status);
                                            // msg(response.headers);
                                            // msg("contentType="+response.contentType)
                                            let j = false;
                                            // Lib.log("#26g status="+response.status+"\n content="+ response.content);
                                            if (response.status === 200) {
                                                let isPlainText = response.contentType.length === 0
                                                if (isPlainText) {
                                                    // msg( response.content);
                                                    documWindowLoader.active = true
                                                    documWindowLoader.item.rowSelect =  {'shop':acntAmnt.crntRow.shop,
                                                                'acntno':acntAmnt.crntRow.acntno,
                                                                'curid':acntAmnt.crntRow.id==='' ? documWindowLoader.item.domestic.id : acntAmnt.crntRow.id}
                                                    // documWindowLoader.item.pageTitle = acntAmnt.crntRow.shop + ' ' + acntAmnt.crntRow.chid
                                                    // documWindowLoader.item.pageSubtitle = "#"+acntAmnt.crntRow.acntno
                                                    j = Lib.parse(response.content)
                                                    if (j) {  documWindowLoader.item.jdata = j.rslt; }
                                                    else { errorStr.text = "JSON parse data error"; }
                                                }
                                            } else {
                                                j = Lib.parse(response.content)
                                                if (j){ errorStr.text = "id:["+j.status +"] "+ j.str +" Note:"+ j.note ;}
                                                else { errorStr.text = "Site connection error"; }
                                            }

                                        });
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
                        reloadInterval: 10
                        onVkEvent: (id, param) => {
                            if ((id === 'clicked') || (id === 'timerTriggered')){
//                                acntAmnt.sourceData = undefined
                                actionDataLoad.trigger();
                                // uplMngr.post("/sout2.php", acntAmnt.sourceQuery)
                            } else if (id === 'log'){
                                Lib.log(eventParam.text,
                                        eventParam.module!==undefined?eventParam.module:'VkReloadBtn.qml',
                                        eventParam.type!==undefined?eventParam.type:'II')
                            } else {Lib.log("VkReloadBtn.btnReload BAD event !!!")}
                        }
                    }
                }
                Label {
                    id: pageTitle
                    Layout.fillWidth: true
                    text: String("Trade")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
//                    Layout.fillWidth: true
                }

                TextField{
                    id: filter
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 30
                    selectByMouse: true
                    placeholderText: 'фільтр'
                    color: text===''?'lightgray':'black'
                    onAccepted: { acntAmnt.refresh(text); }
                    Text{
                        anchors{right:parent.right; verticalCenter: parent.verticalCenter}
                        text:' X '
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: if (filter.text !== ''){filter.text='';acntAmnt.refresh()}
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
                radius: 10
                color:"PowderBlue"
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
                            // onAccepted: { uplMngr.setSettingsValue("terminal/code", text); nextItemInFocusChain(true).forceActiveFocus(); }
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
                            // onAccepted: { uplMngr.setSettingsValue("upload/http_password", text); nextItemInFocusChain(true).forceActiveFocus(); }
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
                            // onAccepted: { uplMngr.setSettingsValue("upload/http_host", text); nextItemInFocusChain(true).forceActiveFocus(); }
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
                            // onAccepted: { uplMngr.setSettingsValue("program/pwd", text); nextItemInFocusChain(true).forceActiveFocus(); }
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
                onVkEvent: (id, param) => {
                    if (id === 'log'){
                        Lib.log(param.text,
                                param.module!==undefined?param.module:'VkAcntAmnt.qml',
                                param.type!==undefined?param.type:'II')
                    } else if (id === 'viewChanged'){
                        btnReload.restart()
                    } else if (id === 'clearFilter'){ filter.text = "";
                    } else if (id === 'sourceQueryChanged'){
                        // uplMngr.post("/sout2.php", acntAmnt.sourceQuery)
                        let vheader = [{"name":"Content-Type", "val":"application/x-www-form-urlencoded"}]
                        // uplMngr.postTest({"url":"http://kantorfk.com/sout2.php", "header":vheader}, acntAmnt.sourceQuery)
                    } else {Lib.log("VkAcntAmnt.acntAmnt BAD event !!!")}

                }
            }
            Rectangle{
                id: errorArea
                visible: (errorStr.text !== undefined && errorStr.text !== "")
                Layout.fillHeight: true
                // Layout.preferredHeight: 30  //childrenRect.height
                Layout.fillWidth: true
                radius: 180
                color:"MistyRose"
                Text{
                    id: errorStr
                    anchors{margins: 5; fill:parent}
                    clip: true
                    wrapMode: Text.Wrap
                    onTextChanged: errorTimer.interval = 20000
                    Timer{
                        id: errorTimer
                        repeat: false
                        running: false
                        onTriggered: errorStr.text=""
                        onIntervalChanged: if (interval !==0 ){start()}
                    }
                }
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

    Component.onCompleted: { actionLogin.trigger(); }
}
