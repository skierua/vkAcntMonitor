import QtQuick
import QtQuick.Controls.Fusion

ToolButton {
    id: root
//    property string lastReload: Qt.formatDateTime(new Date(), 'hh:mm')
//    onLastReloadChanged: if (reloadInterval != 0){ timer.start() }
    property int reloadInterval: 0  // in second
    onReloadIntervalChanged: {
        if (reloadInterval != 0){ timer.start()
        } else {timer.stop}
    }

//    anchors.fill: parent
    width: 35   //parent.width
    height: 35   //parent.height

    signal vkEvent(string id, var param)

    contentItem: Column{
        anchors.fill: root
        spacing: 0
        Image {
            height: parent.height*0.7
            width:height
            anchors{horizontalCenter: parent.horizontalCenter}
            source: "qrc:/icon/reload.svg"
        }
        Label{
            id: reloadTime
            anchors{/*fill: parent; */horizontalCenter: parent.horizontalCenter}
            font.pointSize: 7
            text: Qt.formatDateTime(new Date(), 'hh:mm')
        }
    }
    onClicked: {
        vkEvent("clicked", {})
        reloadTime.text = Qt.formatDateTime(new Date(), 'hh:mm')
    }

    Timer{
        id: timer
        interval: reloadInterval*1000
        repeat: true
        running: false
        triggeredOnStart: false
        onTriggered: {
//            msg("timer triggered")
            vkEvent("timerTriggered", {})
            reloadTime.text = Qt.formatDateTime(new Date(), 'hh:mm')
        }
    }

    function restart() {
        if (reloadInterval != 0){ timer.restart() } else {timer.stop()}
    }
}
