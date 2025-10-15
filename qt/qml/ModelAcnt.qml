import QtQuick
import "../../lib.js" as Lib

ListModel {
    id: root
    property string uri: ""
    property var sourceData
    property string title: ""
    property string bal: ""
    property string lastDate: ""
    property string flt: ""
    // property var total: []
    // property var totalDbt: []
    // property var totalCdt: []
    // onSourceDataChanged: {
    //     root.flt = '';
    //     // for (let i=0; i < 5; ++i) console.log(JSON.stringify(root.sourceData[i]));

    //     root.sourceData.sort((a,b) => {
    //                              return ((""+(String(Number(a.cuso) === 0 ? "  "
    //                                 : a.cuso))+String(a.shso)+a.acntno.substring(0,4)) > (""+(String(Number(b.cuso)===0?"  ":b.cuso))+String(b.shso)+b.acntno.substring(0,4)) ? 1 : -1);} )
    //     populate();
    // }

    onBalChanged:{
        // console.log("AcntData bal=" + bal)
        root.flt = '';
        populate()
    }

    onFltChanged: populate()

    signal vkEvent(string id, var param)

    function load() {
        Lib.postRequest(root.uri, {"reqid":"sse"},
                        (err,resp) => {
                             if (err === null){
                                 // console.log("#278 main "+JSON.stringify(resp))

                                let ld = resp.reduce( (t, v) => (t = t < v.tm ? v.tm : t), "" );
                                if (ld > root.lastDate) {
                                    root.lastDate = ld;
                                    root.sourceData = resp;
                                    // for (let i=0; i < 5; ++i) console.log(JSON.stringify(root.sourceData[i]));
                                    root.sourceData.sort((a,b) => {
                                                             return ((""+(String(Number(a.cuso) === 0 ? "  "
                                                                : a.cuso))+String(a.shso)+a.acntno.substring(0,4)) > (""+(String(Number(b.cuso) === 0 ? "  ":b.cuso))+String(b.shso)+b.acntno.substring(0,4)) ? 1 : -1);} )
                                    populate();
                                }

                             } else {
                                vkEvent("err", "postReques: " + err.text)
                                // Lib.log(err.text, 'Lib.postRequest', err.code)
                             }
        });
    }

    function populate(){
        root.clear()
        if (root.sourceData === undefined) return;
        for (let i = 0; i < root.sourceData.length; ++i) {
            if (root.bal === root.sourceData[i].acntno.substring(0,root.bal.length)
                    && ((root.flt === undefined) || (root.flt === '')
                    ||(~((root.sourceData[i].chid).toLowerCase()).indexOf(root.flt.toLowerCase()))
                    ||(~((root.sourceData[i].shop).toLowerCase()).indexOf(root.flt.toLowerCase()))
                    ||(~((root.sourceData[i].acntno).toLowerCase()).indexOf(root.flt.toLowerCase()))
                    ||(~((root.sourceData[i].scancode).toLowerCase()).indexOf(root.flt.toLowerCase()))
                    )) {
                if (bal.substring(0,2) === "30") {  // acnt is active
                    root.append({
                                "bind" : sourceData[i].chid,
                                "cur": sourceData[i].id,
                                "name" : sourceData[i].shop,
                                "amnt" : Number(sourceData[i].amnt),
                                "dbt" : sourceData[i].turndbt,
                                "cdt" : sourceData[i].turncdt,
                                "tm" : sourceData[i].tm,
                                "acnt" : sourceData[i].acntno,
                                    "crnt": sourceData[i].tm.substring(0,10) === lastDate.substring(0,10)
                                })
                } else {                            // acnt is pasive
                    root.append({
                                "bind" : sourceData[i].chid,
                                "cur": sourceData[i].id,
                                "name" : sourceData[i].shop,
                                "amnt" : 0 - Number(sourceData[i].amnt),
                                "dbt" : sourceData[i].turncdt,
                                "cdt" : sourceData[i].turndbt,
                                "tm" : sourceData[i].tm,
                                "acnt" : sourceData[i].acntno,
                                    "crnt": sourceData[i].tm.substring(0,10) === lastDate.substring(0,10)
                                })
                }
            }

        }
    }

    function getTotal(sec, mode){
        let res = 0, i =0;
        if (mode === "dbt") {
            for (i=0; i < root.count; ++i){
                if (sec === get(i).bind) res += Number(get(i).dbt);
            }
        } else if (mode === "cdt") {
            for (i=0; i < root.count; ++i){
                if (sec === get(i).bind) res += Number(get(i).cdt);
            }
        } else {
            for (i=0; i < root.count; ++i){
                if (sec === get(i).bind) res += get(i).amnt;
            }
        }

        return res;
    }


}
