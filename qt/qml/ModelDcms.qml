import QtQuick
import "../../lib.js" as Lib

ListModel {
    id: root
    property string uri: ""
    property var queryData
        onQueryDataChanged: load()
    property var data
    property int pageCapacity: 5
    property list<int> pager: []
    property int bindCount: 0   // filtered bind count
    property bool acntOnly: true
    onAcntOnlyChanged: filterData()



    signal vkEvent(string id, var param)

    function dbg(str, code ="") {
        console.log( String("%1[ModelDcms] %2").arg(code).arg(str));
    }

    function load() {
        // vkEvent("log","load() " + JSON.stringify(root.queryData.req));
        dbg(JSON.stringify(root.queryData), "#q6g")
        Lib.postRequest(root.uri, root.queryData.req,
                        (err,resp) => {
                             if (err === null){
                                let tmpd = []
                                tmpd = resp;
                                tmpd.sort((a,b) => { return  a.pid < b.pid ? 1 : -1;} )
                                // for (let i=0; i < 30; ++i) vkEvent("log", "#97hs "+ i + ": " + JSON.stringify(root.data[i]));
                                root.data = tmpd;
                                filterData()
                                // populate();
                             } else {
                                vkEvent("err", "postReques: " + err.text)
                                 // Lib.log(err.text, 'Lib.postRequest', err.code)
                             }
        });
    }

    function isAllowed(row, flt){
        return ( ~(((data[row].note).toLowerCase()).indexOf(flt.toLowerCase()))
                || ~(((data[row].atclcode).toLowerCase()).indexOf(flt.toLowerCase()))
                || ~(((data[row].bcode).toLowerCase()).indexOf(flt.toLowerCase()))
                || ~(((data[row].dcmcode).toLowerCase()).indexOf(flt.toLowerCase()))
                || ~(((data[row].cdt).toLowerCase()).indexOf(flt.toLowerCase()))
                || ~(((data[row].dbt).toLowerCase()).indexOf(flt.toLowerCase()))
                || (Number(flt)!==0 && ~((data[row].amnt).indexOf(flt)))
                || (Number(flt)!==0 && ~((data[row].bamnt).indexOf(flt)))
                || (Number(flt)!==0 && Number(data[row].amnt)===Number(flt)) )
    }

    function acntFilter (row){
        return (!acntOnly || ((root.queryData.acnt === "3000" ? true : root.queryData.acnt === data[row].cdt)
                && (root.queryData.cur === data[row].atclcode)))
    }

    function filterData(flt =""){
        // vkEvent("log","data : " + JSON.stringify(root.data));
        let tmpa = []
        // root.offset = 0
        let count =0, fcount =0
        let pid = "", fpid = ""

        for ( let r =0; r < data.length; ++r){
            // if (pid !== data[r].pid) {
            //     pid = data[r].pid
            //     ++count
            // }
            if ( acntFilter(r) && ((flt === undefined) || (flt === '') || isAllowed(r, flt))) {
                if (fpid !== data[r].pid) {
                    fpid = data[r].pid
                    if (fcount % pageCapacity === 0 ) tmpa.push(r);
                    ++fcount
                }
                data[r].flt = true;
            } else { data[r].flt = false; }

        }
        // for (let i=0, k=0; i < data.length && k < 12; ++i)
        //     if (data[i].flt) {
        //         vkEvent("log","#eqyb3 "+ i + ": " + JSON.stringify(root.data[i]));
        //         ++k
        //     }
        // vkEvent("log", "#82yb pager=" + JSON.stringify(tmpa));
        root.pager = tmpa
        bindCount = fcount;
        populate()
    }

    function populate(page =1){
        root.clear();
        let pid = ""
        let d = 0

        let ofs = root.pager[page-1]
        let lim = (page >= root.pager.length ? data.length : root.pager[page])
        // vkEvent("log", "73y page="+page+" ofs="+ofs+" lim="+lim)
        for (; ofs < lim; ++ofs){

            if (!data[ofs].flt) continue;

            // if (pid !== data[ofs].pid) {
            //     pid = data[ofs].pid
            //     ++d
            //     if (!(d < pageCapacity)) break;
            // }
            // root.append(data[ofs])
            root.append({
                            "bind": data[ofs].pid,
                            "dcmcode": data[ofs].dcmcode,
                            "note": data[ofs].note.indexOf("#") === -1 ?
                                data[ofs].note
                              : data[ofs].note.substring(0,data[ofs].note.indexOf("#")),
                            "subnote": data[ofs].note.indexOf("#") === -1 ?
                                "" : data[ofs].note.substring(data[ofs].note.indexOf("#")),
                            "cdt": data[ofs].cdt,
                            "atclcode": data[ofs].atclcode,
                            "amnt": Number(data[ofs].amnt),
                            "eq": Number(data[ofs].eq),
                            "dsc": Number(data[ofs].dsc),
                            "bns": Number(data[ofs].bns),
                            "tm": data[ofs].tm,
                            "shop": data[ofs].shop,
                            'isTrade': isTrade(ofs),
                            "price": isTrade(ofs) ? price(ofs) : ""
                        })
        }
        // root.offset = ofs
    }

    function isTrade(row) {
        if (data[row].dcmcode.substring(0,6) === 'trade:') return true;
        return false;
    }

    function price(row) {
        // let res = ""
        let coef = 1
        if (data[row].atclcode === '643') coef = 10;
        if (data[row].atclcode === '348') coef = 100;
        let res = coef * (Number(data[row].eq) + Number(data[row].dsc))/Number(data[row].amnt)
        return res.toFixed(4) + (coef != 1 ? ("/" + String(coef)) : "")
    }

    // function rateCoef(vcrn) {
    //     if (vcrn === 'RUB' || vcrn === '643'
    //             || vcrn === 'JPY'|| vcrn === '392') { return 10 }
    //     if (vcrn === 'HUF' || vcrn === '348') { return 100 }
    //     return 1;
    // }

    function bindInfo(vid){
        // vkEvent("log", "bindInfo vid="+vid)
        // let i = 0
        // for (i = 0; (i < data.length && data[i].pid !== vid); ++i) {}
        // TODO binary search
        let lf =0, rt = data.length -1, md =0;
        while (lf < rt && data[rt].pid !== vid) {
            // vkEvent("log", "bindInfo vid="+vid + " lf="+ lf + "/" + data[lf].pid
            //         + " rt="+rt + "/" + data[rt].pid+ " md="+md)
            md = lf + Math.floor((rt - lf)/2)
            if (data[md].pid > vid) lf = md
            else rt = md
        }
        // vkEvent("log", "bindInfo vid="+vid + " finded="+ data[rt].pid)

        if (data[rt].pid === vid ) return {
                "bcode":data[rt].bcode,
                "bamnt":data[rt].bamnt,
                "beq":data[rt].beq,
                "bdsc":data[rt].bdsc,
                "bbns":data[rt].bbns,
                "tm":data[rt].tm
            }
        return {"bcode":"","bamnt":"","beq":"","bdsc":"","bbns":"","tm":""}
    }

}

/*
  sourceData structure
  [
    {
        "bcode":"check",
        "bacnt":"3000",
        "bamnt":"-4130",
        "beq":"4130",
        "bdsc":"0",
        "bbns":"0",
        "clientid":"",
        "tm":"2025-10-09 11:30:11",
        "shop":"CITY",
        "cshr":"haro",
        "id":"1306859",
        "pid":"954366",
        "dcmcode":"trade:buy",
        "amnt":"100",
        "eq":"4130",
        "dsc":"0",
        "bns":"0",
        "note":"USD",
        "atclcode":"840",
        "dbt":"3000",
        "cdt":"3500"
    }
]

pid bcode bamnt beq bdsc bbns
note dcmcode cdt atclcode eq amnt dsc bns tm
  */
