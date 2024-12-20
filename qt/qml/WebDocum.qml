import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
//    id: root
    width: 300
    height: 480
/*    jdata stru
    [{"bcode":"folder","bacnt":"3501","bamnt":"355","beq":"0","bdsc":"0","bbns":"0","clientid":"vasn","tm":"2024-04-09 18:04:24","shop":"FEYA","cshr":"vasn",
                "id":"1172054","pid":"865163","dcmcode":"memo","amnt":"953.25","eq":"0","dsc":"0","bns":"0","note":"reval 202500*0.1033/348 UAH",
        "atclcode":"980","dbt":"eqvl.3501/348","cdt":"rslt.3501/348","bind":5}]
    */
    // property string crntShop
    // property string dateFrom

    property var rowSelect: {'shop':'', 'acntno':'', 'curid':''}
    // property alias pageTitle: pageTitleLbl.text
    // property alias pageSubtitle: pageSubtitleLbl.text
    property alias jdata: vw.sourceData
    property var domestic : {"id":"980", "chid":"UAH", "name":"грн" }
    // onJdataChanged: vkEvent("log",JSON.stringify(jdata))


    signal vkEvent(string id, var param)



    function crnRateCoef(vcrn) {
        if (vcrn === 'RUB' || vcrn === '643'
                || vcrn === 'JPY'|| vcrn === '392') { return 10 }
        if (vcrn === 'HUF' || vcrn === '348') { return 100 }
        return 1;
    }
    Action {
        id: previousAction
        text: "❮"
        onTriggered: { vw.vcrnt = (vw.vcrnt > vcrntEdit.validator.top ? vcrntEdit.validator.top : --vw.vcrnt); /*vw.show();*/ }
    }

    Action {
        id: nextAction
        text: "❯"
        onTriggered: { vw.vcrnt = (vw.vcrnt > vcrntEdit.validator.top ? vcrntEdit.validator.top : ++vw.vcrnt); /*vw.show();*/ }
    }


    Component {
        id: dlg
        FocusScope{
            id: root
            width: root.ListView.view.width;
            height: childrenRect.height;
            Rectangle {
                width: parent.width;
                height: 32;
                // anchors.leftMargin: 10
                clip: true
                // color: (index === root.ListView.view.currentIndex)
                //        ? 'lightsteelblue'
                //          : (index%2 == 0 ?  Qt.darker('white',1.01) : 'white');
                Row{
                    id: rootLayout
                   anchors.fill: parent
                   spacing: 2
                    // width: parent.width
                    Label{ width: 0.05*parent.width; anchors.verticalCenter: parent.verticalCenter; text: Number(root.ListView.view.sourceData[sid].amnt) > 0 ? "+" : "-" }

                    Column{           // name
                        width: 0.4*parent.width-2;
                        spacing: 2
                        clip:true
                        Label {
//                            Layout.fillWidth: true
                            clip: true
//                            text: note
//                            hoverEnabled: true
                            text: root.ListView.view.sourceData[sid].note.indexOf("#")===-1
                                  ? root.ListView.view.sourceData[sid].note
                                  : root.ListView.view.sourceData[sid].note.substring(0,root.ListView.view.sourceData[sid].note.indexOf("#"))
                            MouseArea{
                                anchors.fill: parent
//                                hoverEnabled: true
                                ToolTip.delay: 1000
                                ToolTip.timeout: 5000
                                ToolTip.visible: containsMouse
                                ToolTip.text: root.ListView.view.sourceData[sid].note
                            }

                        }
                        Row{
                            spacing: 2
                            Label {
    //                            clip: true
                                text: root.ListView.view.sourceData[sid].dcmcode
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label{
                                text: '['+root.ListView.view.sourceData[sid].cdt+'.'+(root.ListView.view.sourceData[sid].atclcode==''?'UAH':root.ListView.view.sourceData[sid].atclcode)+']'
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
    //                            Layout.fillWidth: true
                                clip: true
                                text: root.ListView.view.sourceData[sid].note.indexOf("#")===-1
                                      ? ''
                                      : root.ListView.view.sourceData[sid].note.substring(note.indexOf("#"))
                                font.pointSize: 10
                                color: 'gray'
                            }
                        }
                    }

                    Column{     // price, eq,...
//                        anchors.fill: parent
                        width: 0.2*parent.width-2;
                        spacing: 2
//                            clip: true
                        visible: root.ListView.view.sourceData[sid].dcmcode.substring(0,6) === 'trade:'
                        Label {
                            text: (crnRateCoef(root.ListView.view.sourceData[sid].atclcode) === 1)
                                  ? (Number(root.ListView.view.sourceData[sid].eq)/Number(root.ListView.view.sourceData[sid].amnt)).toFixed(4)
                                  : ((crnRateCoef(root.ListView.view.sourceData[sid].atclcode)*Number(root.ListView.view.sourceData[sid].eq)/Number(root.ListView.view.sourceData[sid].amnt)).toFixed(3) + ('/'+crnRateCoef(root.ListView.view.sourceData[sid].atclcode)))
                        }
                        Row{
                            spacing: 2
//                            anchors.horizontalCenter: parent.horizontalCenter
                            Label {
                                text: Math.abs(Number(root.ListView.view.sourceData[sid].eq)).toLocaleString(Qt.locale(),'f',2)
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
                                text:Number(root.ListView.view.sourceData[sid].dsc)===0?'':('D:'+Number(root.ListView.view.sourceData[sid].dsc).toLocaleString(Qt.locale(),'f',2))
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
                                text:Number(root.ListView.view.sourceData[sid].bns)===0?'':('B:'+Number(root.ListView.view.sourceData[sid].bns).toLocaleString(Qt.locale(),'f',2))
                                font.pointSize: 10
                                color: 'gray'
                            }
                        }
                    }
                    Label {     // amnt
                        width: root.ListView.view.sourceData[sid].dcmcode.substring(0,6) === 'trade:' ? 0.2*parent.width-2 : 0.4*parent.width-4;
                        anchors.verticalCenter: parent.verticalCenter;
                        horizontalAlignment: Text.AlignRight
                        text: Math.abs(Number(root.ListView.view.sourceData[sid].amnt)).toLocaleString(Qt.locale(),'f',0)
                    }

                    Label{
                        width: 0.15*parent.width-2;
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: hd(root.ListView.view.sourceData[sid].tm)
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true
                            ToolTip{
                                delay: 1000
                                timeout: 5000
                                visible: parent.containsMouse
                                text: root.ListView.view.sourceData[sid].tm
                            }
                            onClicked: { vkEvent('log','#94h mouse clicked containsMouse='+containsMouse) }
                            // onDoubleClicked: { root.ListView.view.currentIndex = index; }
                        }
                    }

/*                    ColumnLayout{
                        spacing: 0
                        Label {
                            text: humanDate(root.ListView.view.sourceData[sid].tm)
                            font.pointSize: 10
                            color: 'gray'
                        }
                        Label {
                            text: root.ListView.view.sourceData[sid].dcmcode
                            font.pointSize: 10
                            color: 'gray'
                        }
                    } */
                }
            }
        }
    }


    Page{
        anchors{fill:parent}

        header: ToolBar{
            RowLayout {
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: pageTitleLbl
                    text: rowSelect.shop
                    elide: Label.ElideRight
                }
/*                Label {
                    id: pageSubtitleLbl
                    color: vw.showSelected ? 'grey' : 'black'
                    text: rowSelect.acntno + '/'+ rowSelect.curid
                    // font.pointSize: 7;
                    // horizontalAlignment: Qt.AlignHCenter
                } */
                Item{
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: chbShowSelected
                    checked: true
                    text: rowSelect.acntno + '/'+ rowSelect.curid //qsTr("All")
                    onCheckedChanged: vw.vpopulate()
                }

                CheckBox {
                       checked: false
                       text: qsTr("Bind")
                       onCheckedChanged: vw.section.property = (checked ? "bind" : "")
                }

/*                ToolButton {
                    text: qsTr("⋮")
                    onClicked: cashMenu.open()
                    Menu {
                        id: cashMenu
                        y: parent.height
                        MenuItem {
                            text: "Показати чек"
                            onClicked: {
                                vkEvent('postQuery', {"id":"viewBind",
                                    "query":String("dataid=getBind&bindid=%1")
                                    .arg(vw.model.get(vw.currentIndex).pid)
                                })
                            }
                        }
                    }
                } */
            }

        }

        Pane{
            anchors.fill: parent

            ListView {
                id: vw
                property var sourceData: []
                onSourceDataChanged: {
                    // vkEvent("log","#63t sourceData="+sourceData.length)
                    // console.log("#7eg "+JSON.parse(sourceData))
                    // vfilter = ""
                    let bind = 0
                    for (let r =0; r < sourceData.length; ++r){
                        if (r == 0 || sourceData[r-1].pid !== sourceData[r].pid){ bind = r; }
                        sourceData[r].bind = bind;
                        if (sourceData[r].atclcode === "") {
                            sourceData[r].atclcode = domestic.id
                            sourceData[r].note += " " + domestic.chid
                        }
                    }
                    vw.vpopulate()
                }
                property alias showSelected: chbShowSelected.checked
                property var bindList: []
                property int vlen: 25
                // property int bindCount: 0
                property alias vcrnt: vcrntEdit.text
                onVcrntChanged: show()

                property alias vfilter: vfilterEdit.text
                // onVfilterChanged: vpopulate()

                anchors.fill: parent
                clip: true
                spacing: 1
                model: ListModel{}

                delegate: dlg
                ScrollBar.vertical: ScrollBar{
                    parent: vw.parent
                    anchors.top: vw.top
                    anchors.right: vw.right
                    anchors.bottom: vw.bottom
                }
                section.property: ""
                // section.property: "bind"
                section.criteria: ViewSection.FullString
                section.delegate: Rectangle{
                    width: vw.width
                    height: 30  //childrenRect.height //*1.2
                    color: "whitesmoke"
                    Row{
                        anchors{fill: parent}
                        spacing: 4
                        Label{ width:parent.width/2; anchors.verticalCenter: parent.verticalCenter; font.pointSize: 15; text: vw.bindInfo(section).bcode}
                        Column{
                            Label{ text: vw.bindInfo(section).bamnt}
                            Row{
                                spacing: 2
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.bindInfo(section).beq}
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.bindInfo(section).bdsc; }
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.bindInfo(section).bbns}
                            }

                        }
                        // Item{}
                        Label{ anchors.verticalCenter: parent.verticalCenter; font.pointSize: 12; text: hd(vw.bindInfo(section).tm)}
                    }

                }

                function bindInfo(vid){
                    let i = 0
                    for (i = 0; (i < sourceData.length && sourceData[i].pid !== vid); ++i) {}
                    if (i < sourceData.length ) return {"bcode":sourceData[i].bcode,"bamnt":sourceData[i].bamnt,"beq":sourceData[i].beq,"bdsc":sourceData[i].bdsc,"bbns":sourceData[i].bbns,"tm":sourceData[i].tm}
                    return {"bcode":"","bamnt":"","beq":"","bdsc":"","bbns":"","tm":""}
                }

                function vpopulate(){
                   // msg('vpopulate STARTED...filter='+vfilter)
                    model.clear()
                    vcrnt = 1
                    var tmpa = []
                    var pcount = []
                    let r=0
                    for (r =0; r < sourceData.length; ++r){
                        // msg('vpopulate r='+r +' filter='+vfilter +" code="+sourceData[r].amnt + " rslt="+ (~((sourceData[r].amnt).indexOf(vfilter))))
                        if ( ( !showSelected || (sourceData[r].atclcode === rowSelect.curid && (sourceData[r].dbt === rowSelect.acntno || sourceData[r].cdt === rowSelect.acntno)))
                                && ((vfilter === undefined) || (vfilter === '')
                                || ~(((sourceData[r].note).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || ~(((sourceData[r].atclcode).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || ~(((sourceData[r].bcode).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || ~(((sourceData[r].dcmcode).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || ~(((sourceData[r].cdt).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || ~(((sourceData[r].dbt).toLowerCase()).indexOf(vfilter.toLowerCase()))
                                || (Number(vfilter)!==0 && ~((sourceData[r].amnt).indexOf(vfilter)))
                                || (Number(vfilter)!==0 && ~((sourceData[r].bamnt).indexOf(vfilter)))
                                || (Number(vfilter)!==0 && Number(sourceData[r].amnt)===Number(vfilter)))) {
                            // vkEvent("log",'flt='+vfilter+' r='+r +' '+JSON.stringify(sourceData[r]))
                            // if (!pcount.includes(sourceData[r].pid) ) { pcount.push(sourceData[r].pid) }
                            // tmpa.push({"bind":sourceData[r].pid,"vid":r})
                            tmpa.push(r)
                        }
                    }
                    // bindCount = pcount.length
                    // vkEvent("log","#63t tmpa="+tmpa.length)
                    vw.bindList = tmpa
                    vcrntEdit.validator.top = Math.ceil(bindList.length/vw.vlen)
                    show()
                }

                function show(){
                   // console.log('#46g _show vcrnt='+vcrnt + ' i='+((vcrnt-1)*vlen) + " to="+((vcrnt-1)*vlen+vlen) +" varr.length="+bindList.length)
                    previousAction.enabled = (vcrnt > 1)
                    nextAction.enabled = ((vcrnt)*vlen < bindList.length)
                    model.clear();
                    var pcount = []
                    var tmpa = bindList.slice((vcrnt-1)*vlen,(vcrnt-1)*vlen+vlen)
                    let r = (vcrnt-1) * vlen
                    // for (i = 0; (i < sourceData.length && sourceData[i].bind !== tmpa[0]); ++i) {}
                    for (r = vlen *(vcrnt-1) ; (r < bindList.length && r < vlen * vcrnt); ++r){
                        // if (!pcount.includes(sourceData[bindList[r]].pid) ) { pcount.push(sourceData[bindList[r]].pid) }
                        model.append({ "bind":sourceData[bindList[r]].pid,"sid": bindList[r] });
                    }
//                    console.log('#23g _show vcrnt='+vcrnt + ' i='+(vcrnt*vlen) + " to="+(vcrnt*vlen + vlen) +" varr.length="+varr.length)
                }

                function showOLD(){
                   // console.log('#46g _show vcrnt='+vcrnt + ' i='+((vcrnt-1)*vlen) + " to="+((vcrnt-1)*vlen+vlen) +" varr.length="+bindList.length)
                    previousAction.enabled = (vcrnt > 1)
                    nextAction.enabled = ((vcrnt)*vlen < bindList.length)
                    model.clear();
                    var tmpa = bindList.slice((vcrnt-1)*vlen,(vcrnt-1)*vlen+vlen)
                    let i = 0
                    for (i = 0; (i < sourceData.length && sourceData[i].bind !== tmpa[0]); ++i) {}
                    for (i ; (i < sourceData.length); ++i){
                    // for (let i = 0; (i < sourceData.length); ++i){
                        if (tmpa.includes(sourceData[i].bind) ) {
                            model.append({ "bind":sourceData[i].bind,"sid": i });
                        }
                    }
//                    console.log('#23g _show vcrnt='+vcrnt + ' i='+(vcrnt*vlen) + " to="+(vcrnt*vlen + vlen) +" varr.length="+varr.length)
                }
            }
    }
        footer: ToolBar {
            RowLayout {
                anchors{fill: parent;leftMargin:5; rightMargin:5;}
                TextField{
                    id: vfilterEdit
                    Layout.preferredWidth: 100
//                    focus: true
                    selectByMouse: true
                    onActiveFocusChanged: if (activeFocus) {selectAll()}
                    horizontalAlignment: Text.AlignHCenter
                    onAccepted: vw.vpopulate()
                }
                Item{
                    Layout.fillWidth: true
                }
                ToolButton{ action: previousAction; }
                TextField{
                    id: vcrntEdit
                    Layout.preferredWidth: 50
//                    focus: true
                    selectByMouse: true
                    validator: IntValidator { bottom: 1; }
                    onActiveFocusChanged: if (activeFocus) { selectAll(); }
                    horizontalAlignment: Text.AlignHCenter
                    text: vw.vcrnt
                    // onEditingFinished: { if ( text >validator.top) { text = validator.top; } }
                        // {vw.vcrnt = (vw.vcrnt > vcrntEdit.validator.top ? vcrntEdit.validator.top : --vw.vcrnt); vw.show(); }
                    // onAccepted: vw.show()
                }
                ToolButton{ action: nextAction; }

                Label{
                    id: footerCount
                    text: String(" з %1 (%2)").arg(Math.ceil(vw.bindList.length/vw.vlen)).arg(vw.bindList.length)
                }
            }
        }
    }




}

