import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../lib.js" as Lib

Item {
    id: root
    // width: 200
    // height: 200
    property Menu vkContentMenu: Menu{
        id: vkContentMenu_id
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
        MenuItem { action: actionLastDay; }
        MenuItem { action: actionLastWeek; }
        MenuItem { action: actionLastQty; }
    }

    property list<MenuItem> fastContentMenu: [
        MenuItem { action: actionTrade; },
        MenuItem { action: actionCash; },
        MenuItem { action: actionDepo; },
        MenuItem { action: actionCapital; }
    ]

    property list<MenuItem> dcmsContentMenu: [
        MenuItem { action: actionLastDay; },
        MenuItem { action: actionLastWeek; },
        MenuItem { action: actionLastQty; }
    ]

    property alias acntModel: vw.model

    signal vkEvent(string id, var param)

    Action {
        id: actionTrade
        text: "Trade"
        onTriggered: {
            acntModel.title = text
            // acntModel.flt = ''
            acntModel.bal = "350"
            acntModel.load()
        }
    }

    Action {
        id: actionCash
        text: "Каса"
        onTriggered: {
            acntModel.title = text
            // acntModel.flt = ''
            acntModel.bal = "300"
            acntModel.load()
        }
    }

    Action {
        id: actionDepo
        text: "Борги"
        onTriggered: {
            acntModel.title = text
            // acntModel.flt = ''
            acntModel.bal = "360"
            acntModel.load()
        }
    }

    Action {
        id: actionCapital
        text: "Капітал"
        onTriggered: {
            acntModel.title = text
            // acntModel.flt = ''
            acntModel.bal = "420"
            acntModel.load()
        }
    }

    Action {
        id: actionLastDay
        text: "Останній день"
        onTriggered: vkEvent("loadDcms",
                             {"req": {"reqid" : "sel",
                                     "shop" : vw.model.get(vw.currentIndex).name,
                                     "from" : vw.model.get(vw.currentIndex).tm.substring(0,10)
                                 },
                                 "acnt" : vw.model.get(vw.currentIndex).acnt,
                                 "cur" : vw.model.get(vw.currentIndex).cur,
                         })
    }

    Action {
        id: actionLastWeek
        text: "Останній тиждень"
        onTriggered: {
            let dnow = new Date(vw.model.get(vw.currentIndex).tm)
            let dprev = new Date(dnow.getFullYear(), dnow.getMonth(), dnow.getDate()-7)
            let param = { "req": {"reqid" : "sel",
                    "shop" : vw.model.get(vw.currentIndex).name,
                    "from" : Qt.formatDate( dprev, "yyyy-MM-dd")
                },
                "acnt" : vw.model.get(vw.currentIndex).acnt,
                "cur" : vw.model.get(vw.currentIndex).cur,
            }
            // console.log("#ya7h3 " + JSON.stringify(vw.model.get(vw.currentIndex)))
            // console.log("#rqw4 SHOP=" + vw.model.get(vw.currentIndex).shop)

            vkEvent("loadDcms", param)
        }
    }

    Action {
        id: actionLastQty
        text: "Останні 200 по рах/вал"
        onTriggered: vkEvent("loadDcms",
                             { "req": {"reqid" : "sel",
                                "shop" : vw.model.get(vw.currentIndex).name,
                                "limit" : "200"
                                },
                            "acnt" : vw.model.get(vw.currentIndex).acnt,
                            "cur" : vw.model.get(vw.currentIndex).cur,
                            })

    }

    Component{
        id: dlg1
        FocusScope{
            id: root
            width: root.ListView.view.width;
            height: childrenRect.height;
            Rectangle{
                width: parent.width;
                height: 30;
                color:(index === root.ListView.view.currentIndex)
                      ? 'lightsteelblue'
                      : (index%2)?'transparent':'whitesmoke'
                Row{
                    anchors.fill: parent
                    spacing: 5

                    Text{
                        width: 0.2 * parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        text: name
                        color: crnt ? 'black':'gray'
                        font.pointSize: 12
                    }
                    Text{
                        width: 0.35 * parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        text: amnt === 0 ? '' : Math.abs(amnt).toLocaleString(Qt.locale(),'f',0)
                        font.pointSize: 14
                        color: (amnt < 0) ? (crnt ? 'red' : Qt.lighter('red')) : (crnt ? 'black':'gray')
                        horizontalAlignment: Text.AlignRight
                    }
                    Column {
                        width: 0.2 * parent.width
                        spacing: 0
                        Text{
                            text: dbt.toLocaleString(Qt.locale(),'f',0)
                            color: crnt ? 'black':'gray'
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 10
                        }
                        Text{
                            text:cdt.toLocaleString(Qt.locale(),'f',0)
                            color: crnt ? 'black':'gray'
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 10
                        }

                    }

                    Column {
                        clip:true
                        spacing: 0
                        Text{
                            text: Lib.humanDate(tm)
                            color: crnt ? 'black':'gray'
                            font.pointSize: 10
                        }
                        Text{
                            text: acnt
                            color: crnt ? 'black':'gray'
                            font.pointSize: 10
                        }

                    }

                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        root.ListView.view.currentIndex = index;
                    }
                }
            }

        }
    }

    ListView {
        id: vw
        width: parent.width
        height: parent.height

        clip: true
        spacing: 2
        // model:     ListModel{
        //     id: modelCash            }

        delegate: dlg1
        add: Transition { PropertyAnimation { properties: "x,y"; duration: 250; easing.type: Easing.InOutQuad } }
        ScrollBar.vertical: ScrollBar{
            parent: vw.parent
            anchors.top: vw.top
            anchors.right: vw.right
            anchors.bottom: vw.bottom
        }
        section.property: "bind"
        section.criteria: ViewSection.FullString
        section.delegate: Rectangle{
            width: vw.width
            height: 30  // childrenRect.height //*1.2
            color: "silver"
            Row{
                anchors.fill: parent
                spacing: 5
                Label{
                    width: 0.2 * parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text:'  '+section
                    font.bold: true
                    font.pointSize: 14
                }
//                        Item{Layout.fillWidth: true}
                Label{
                    width: 0.35 * parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: Math.abs(vw.model.getTotal(section)).toLocaleString(Qt.locale(),'f',0)
                    font.bold: true
                    font.pointSize: 12
                    color: vw.model.getTotal(section) < 0 ? 'red':'black'
                    horizontalAlignment: Text.AlignRight
                }
                Column{
                    spacing: 2
                    anchors.verticalCenter: parent.verticalCenter
                    Label{
                        text: Math.abs(vw.model.getTotal(section, "dbt")).toLocaleString(Qt.locale(),'f',0)
                        font.pointSize: 8
                    }
                    Label{
                        text: Math.abs(vw.model.getTotal(section, "cdt")).toLocaleString(Qt.locale(),'f',0)
                        font.pointSize: 8
                    }
                }

            }
        }
    }

}
