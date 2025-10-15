import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "../../lib.js" as Lib

Window {
   id: root
    width: 300
    height: 480
    property string uri
    property var queryData      // stru
    onQueryDataChanged: {
        pageTitleLbl.text = queryData.req.shop
        chbShowSelected.text = queryData.acnt + '/'+ queryData.cur
        dataModel.queryData = queryData
    }

    signal vkEvent(string id, var param)

    ModelDcms {
        id: dataModel
        uri: root.uri
        pageCapacity: 25
        onVkEvent: (id, param) => {
            // msg("#790e documWindowLoader.onVkEvent"+id)
            if (id === 'log'){ logView.append("[ModelDcms]" + param, 2)  }
            else if (id === 'err') { logView.append("[ModelDcms]" + param, 0)  }
            else { logView.append("[ModelDcms] BAD event !!!", 1)}
        }
    }

    Action {
        id: previousAction
        enabled: Number(vcrntEdit.text) > vcrntEdit.validator.bottom
        text: "❮"
        onTriggered: vcrntEdit.text = Number(vcrntEdit.text) -1
    }

    Action {
        id: nextAction
        enabled: vw.model !== null && Number(vcrntEdit.text) !== vw.model.pager.length
        text: "❯"
        onTriggered: vcrntEdit.text = Number(vcrntEdit.text) +1
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
                    Label{
                        width: 0.05*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: amnt > 0 ? "+" : "-"
                    }

                    Column{           // name
                        width: 0.4*parent.width-2;
                        spacing: 2
                        clip:true
                        Label {
//                            Layout.fillWidth: true
                            clip: true
//                            text: note
//                            hoverEnabled: true
                            text: note
                            MouseArea{
                                anchors.fill: parent
//                                hoverEnabled: true
                                ToolTip.delay: 1000
                                ToolTip.timeout: 5000
                                ToolTip.visible: containsMouse
                                ToolTip.text: note
                            }

                        }
                        Row{
                            spacing: 2
                            Label {
    //                            clip: true
                                text: dcmcode
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label{
                                text: '['+cdt+'.'+(atclcode==''?'980':atclcode)+']'
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
    //                            Layout.fillWidth: true
                                clip: true
                                text: subnote
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
                        visible: isTrade
                        Label {
                            text: price
                        }
                        Row{
                            spacing: 2
//                            anchors.horizontalCenter: parent.horizontalCenter
                            Label {
                                text: Math.abs(eq).toLocaleString(Qt.locale(),'f',2)
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
                                text:dsc === 0 ?'' : ('D:' + dsc.toLocaleString(Qt.locale(),'f',2))
                                font.pointSize: 10
                                color: 'gray'
                            }
                            Label {
                                text:bns === 0 ? '' : ('B:' + bns.toLocaleString(Qt.locale(),'f',2))
                                font.pointSize: 10
                                color: 'gray'
                            }
                        }
                    }
                    Label {     // amnt
                        width: isTrade ? 0.2*parent.width-2 : 0.4*parent.width-4;
                        anchors.verticalCenter: parent.verticalCenter;
                        horizontalAlignment: Text.AlignRight
                        text: Math.abs(amnt).toLocaleString(Qt.locale(),'f',0)
                    }

                    Label{
                        width: 0.15*parent.width-2;
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: Lib.humanDate(tm)
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true
                            ToolTip{
                                delay: 1000
                                timeout: 5000
                                visible: parent.containsMouse
                                text: tm
                            }
                            // onClicked: { vkEvent('log','#94h mouse clicked containsMouse='+containsMouse) }
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
                    // text: dataModel.shop
                    elide: Label.ElideRight
                }
                Item{
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: chbShowSelected
                    checked: dataModel.acntOnly
                    // text: vw.model.acnt + '/'+ vw.model.cur //qsTr("All")
                    onCheckedChanged: if (vw.model !== null) vw.model.acntOnly = checked
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

                anchors.fill: parent
                clip: true
                spacing: 1
                model: dataModel

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
                        Label{ width:parent.width/2; anchors.verticalCenter: parent.verticalCenter; font.pointSize: 15; text: vw.model.bindInfo(section).bcode}
                        Column{
                            Label{ text: vw.model.bindInfo(section).bamnt}
                            Row{
                                spacing: 2
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.model.bindInfo(section).beq}
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.model.bindInfo(section).bdsc; }
                                Label{ font.pointSize: 10; color: 'gray'; text: vw.model.bindInfo(section).bbns}
                            }

                        }
                        // Item{}
                        Label{ anchors.verticalCenter: parent.verticalCenter; font.pointSize: 12; text: Lib.humanDate(vw.model.bindInfo(section).tm)}
                    }

                }
            }

            LogView{
                id: logView
                width: parent.width
                height: (count * 25 < parent.height / 4) ? count * 25 : parent.height / 4
                z: 10
                anchors.bottom: parent.bottom
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
                    onAccepted: {
                        vw.model.filterData(text)
                    }
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
                    text: "1"
                    onTextChanged: {
                        if (Number(text) > vw.model.pager.length ) text = vw.model.pager.length
                        vw.model.populate(text)
                    }
                }
                ToolButton{ action: nextAction; }

                Label{
                    id: footerCount
                    // text: String(" з %1 (%2)").arg(Math.ceil(vw.bindList.length/vw.vlen)).arg(vw.bindList.length)
                    text: String(" з %1 (%2)")
                    .arg(vw.model === null ? 0 : vw.model.pager.length)
                    .arg(vw.model === null ? 0 : vw.model.bindCount)
                }
            }
        }
    }
    // Component.onCompleted: {
    //     logView.append("11111 111",0)
    //     logView.append("22222222222222222222222222222222222222222222222222222",1)
    //     logView.append("3333",2)
    //     logView.append("4444",0)
    // }

}

