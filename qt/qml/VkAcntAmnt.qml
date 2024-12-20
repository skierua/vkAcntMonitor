import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    // width: 200
    // height: 200
    property var crntRow
    property string grandTotal: ""  // for optimazation

    signal vkEvent(string id, var param)

    // add some optimazation
    function vhash(v1,v2,v3) { return Math.abs(Number(v1))+Math.abs(Number(v2))+Math.abs(Number(v3));}

    function vpopulate(vdata, vfilter = '', vmode ="cur") {
        // vkEvent("clearFilter","");
        vw.vclear()
        vw.makeTotal = true
        vw.lastDate = ""
        let vtot = 0;   // total for optimazation
        if (vmode ==="cur"){
            for (let i = 0; i < vdata.length; ++i) {
                vtot += vhash(vdata[i].amnt,vdata[i].turncdt,vdata[i].turncdt);
                if (String(vdata[i].tm).substring(0,10)>vw.lastDate){vw.lastDate = String(vdata[i].tm).substring(0,10)}
                vdata[i].bind = vdata[i].chid;
                vdata[i].name = vdata[i].shop
                if (vdata[i].acntno.substring(0,2) ==="30") {
                    vdata[i].turnin = Number(vdata[i].turndbt)
                    vdata[i].turnout = Number(vdata[i].turncdt)
                    vdata[i].total = Number(vdata[i].amnt)
                } else {
                    vdata[i].turnin = Number(vdata[i].turncdt)
                    vdata[i].turnout = Number(vdata[i].turndbt)
                    vdata[i].total = 0-Number(vdata[i].amnt)
                }
                // vkEvent("log",{"text":(""+(vdata[i].cuso==='0'?1000:100*Number(vdata[i].cuso))+Number(vdata[i].shso)+vdata[i].acntno.substring(0,4))})
            }
            // vw.sourceData = vdata.sort((a,b) => {return ((""+(a.cuso==='0'?1000:100*Number(a.cuso))+Number(a.shso)+a.acntno.substring(0,4))
            //                                              > (""+(b.cuso==='0'?1000:100*Number(b.cuso))+Number(b.shso)+b.acntno.substring(0,4)) ? 1 : -1);} )


            vw.sourceData = vdata.sort((a,b) => {return ((""+(String(Number(a.cuso)===0?"  ":a.cuso))+String(a.shso)+a.acntno.substring(0,4))
                                                         > (""+(String(Number(b.cuso)===0?"  ":b.cuso))+String(b.shso)+b.acntno.substring(0,4)) ? 1 : -1);} )
        }
        grandTotal = vtot.toFixed(0)

        refresh(vfilter);
    }

    function refresh(vfilter) {
        vw.vclear()
        // if (vfilter !== undefined) {
        //     console.log ("#9ue refresh started flt="+vfilter + " comp="+ ~("3500").indexOf(vfilter.toLowerCase()))
        //     // vfilter = '';
        // }
        var i=0
        for (i = 0; i < vw.sourceData.length; ++i) {
            if ((vfilter === undefined) || (vfilter === '')
                    ||(~((vw.sourceData[i].chid).toLowerCase()).indexOf(vfilter.toLowerCase()))
                    ||(~((vw.sourceData[i].shop).toLowerCase()).indexOf(vfilter.toLowerCase()))
                    ||(~((vw.sourceData[i].acntno).toLowerCase()).indexOf(vfilter.toLowerCase()))
                    ||(~((vw.sourceData[i].scancode).toLowerCase()).indexOf(vfilter.toLowerCase()))
                    ) {
                vw.model.append({"bind":vw.sourceData[i].bind,"sid":i})
                if (vw.makeTotal){
                    vw.total[vw.sourceData[i].bind] = (vw.total[vw.sourceData[i].bind] === undefined) ? (vw.sourceData[i].total) : (Number(vw.total[vw.sourceData[i].bind]) + (vw.sourceData[i].total))
                    if (String(vw.sourceData[i].tm).substring(0,10) ===vw.lastDate){
                        vw.totalDbt[vw.sourceData[i].bind] = (vw.totalDbt[vw.sourceData[i].bind] === undefined) ? (vw.sourceData[i].turnin) : (Number(vw.totalDbt[vw.sourceData[i].bind]) + vw.sourceData[i].turnin )
                        vw.totalCdt[vw.sourceData[i].bind] = (vw.totalCdt[vw.sourceData[i].bind] === undefined) ? (vw.sourceData[i].turnout) : (Number(vw.totalCdt[vw.sourceData[i].bind]) + vw.sourceData[i].turnout )
                    }
                }
            }

        }
        vw.currentIndex = (vw.model.count)?0:-1
        vkEvent("viewChanged",{})
    }


    Component{
        id: dlg3
        FocusScope{
            id: root
            width: root.ListView.view.width;
            height: childrenRect.height;
            Rectangle{
                width: parent.width;
                height: childrenRect.height;
                color:(index === root.ListView.view.currentIndex)
                      ? 'lightsteelblue'
                      : (index%2)?'transparent':'whitesmoke'
                RowLayout{
                    spacing: 5

                    Label{
                        Layout.minimumWidth: 70
                        text: root.ListView.view.sourceData[sid].name
                        font.pointSize: 12
                    }
                    Label{
                        Layout.minimumWidth: 70
                        text: root.ListView.view.sourceData[sid].total === 0 ? '' : Math.abs(root.ListView.view.sourceData[sid].total).toLocaleString(Qt.locale(),'f',0)
                        font.pointSize: 12
                        color: (root.ListView.view.sourceData[sid].total < 0) ? 'red' : 'black'
                        horizontalAlignment: Text.AlignRight
                    }
                    ColumnLayout {
                        Layout.minimumWidth: 50
                        spacing: 0
                        Label{
    //                            Layout.minimumWidth: 80
                            text:root.ListView.view.sourceData[sid].turnin.toLocaleString(Qt.locale(),'f',0)

                            color: root.ListView.view.sourceData[sid].tm.substring(0,10)===vw.lastDate? 'black':'gray'
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 9
                        }
                        Label{
    //                            Layout.minimumWidth: 80
                            text:root.ListView.view.sourceData[sid].turnout.toLocaleString(Qt.locale(),'f',0)
                            color: root.ListView.view.sourceData[sid].tm.substring(0,10)===vw.lastDate? 'black':'gray'
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 9
                        }

                    }
                    ColumnLayout {
//                        Layout.fillWidth: true
                        clip:true
                        spacing: 0
                        Label{

//                            anchors.right: parent.right
                            text: hd(root.ListView.view.sourceData[sid].tm)
                            color: root.ListView.view.sourceData[sid].tm.substring(0,10)===vw.lastDate? 'black':'gray'
                            font.pointSize: 9
                        }
                        Label{
                            text: root.ListView.view.sourceData[sid].acntno
                            color: 'gray'
                            font.pointSize: 9
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

//    RowLayout{
//        anchors.fill: parent
////        spacing: 2

//    }
    ListView {
        id: vw
        property var sourceData
        property bool makeTotal
        property string lastDate
        property var total: []
        property var totalDbt: []
        property var totalCdt: []

//        Layout.fillWidth: true
//        Layout.fillHeight: true
        width: parent.width
        height: parent.height

//                anchors.margins: 5
        clip: true
        spacing: 2
        model:     ListModel{
            id: modelCash            }

        delegate: dlg3
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
            height: childrenRect.height //*1.2
            color: "silver"
            RowLayout{
//                        anchors.fill: parent
                Label{
                    Layout.minimumWidth: 70
                    text:'  '+section
                    font.bold: true
                    font.pointSize: 14
                }
//                        Item{Layout.fillWidth: true}
                Label{
                    Layout.minimumWidth: 70
                    text: vw.total[section]!==undefined?Math.abs(Number(vw.total[section])).toLocaleString(Qt.locale(),'f',0):''
                    font.bold: true
                    font.pointSize: 12
                    color: (vw.total[section]===undefined||Number(vw.total[section])<0)? 'red':'black'
                    horizontalAlignment: Text.AlignRight
                }
                ColumnLayout{
                    spacing: 0
                    Label{
                        text: vw.totalDbt[section]!==undefined?(/*'+'+*/Number(vw.totalDbt[section]).toLocaleString(Qt.locale(),'f',0)):''
                        font.pointSize: 7
                    }
                    Label{
                        text: vw.totalCdt[section]!==undefined?(/*'-'+*/Number(vw.totalCdt[section]).toLocaleString(Qt.locale(),'f',0)):''
                        font.pointSize: 7
                    }
                }

            }


        }
        // onCurrentIndexChanged: crntAttr = { "shop":"", "acnt":"", "cur":"" }
        onCurrentIndexChanged: (crntRow = (currentIndex<0 || currentIndex>=count)?
                                   undefined
                                 : sourceData[model.get(currentIndex).sid])
        function vclear(){
            currentIndex = -1
            delegate = null
            model.clear()
            total =[]
            totalDbt =[]
            totalCdt =[]
            delegate = dlg3
        }
    }

}
