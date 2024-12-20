/**
  JS library
*/
function version() { return "1.5";}

function log(vstring, vmodule, vtype) {
    if (vtype === undefined) { vtype = 'II'}
    if (vmodule === undefined) { vmodule = '???main.qml'}
    console.log(String("%1[%2]: %3").arg(vtype).arg(vmodule).arg(vstring))
}

function loginRequest(url, usr, psw, callback) {
    let request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            let response = {
                status : request.status,
                headers : request.getAllResponseHeaders(),
                contentType : request.responseType,
                content : request.response
            };

            callback(response);
        }
    }

    let jdata = { "usr": usr, "psw": psw }
    let v64 = Qt.btoa(JSON.stringify(jdata));
    // console.log("json="+JSON.stringify(jdata)+" ba v64="+v64)
    request.open("POST", url);
    request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    // request.send("usr="+usr+"&psw="+psw);
    request.send("data=" + v64);
}

function postRequest(url, req, callback) {
    let request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            let response = {
                status : request.status,
                headers : request.getAllResponseHeaders(),
                contentType : request.responseType,
                content : request.response
            };

            callback(response);
        }
    }
    request.open("POST", url);
    request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    // request.setRequestHeader("Content-Type","multipart/form-data");
    request.setRequestHeader("Accept","application/json");
    // request.setRequestHeader("Bearer",token);
    // request.send("data=" + Qt.btoa(JSON.stringify(req)));
    request.send("data=" + JSON.stringify(req));
}

function old_postRequest(url, req, token, callback) {
    let request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            let response = {
                status : request.status,
                headers : request.getAllResponseHeaders(),
                contentType : request.responseType,
                content : request.response
            };

            callback(response);
        }
    }
    request.open("POST", url);
    request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    // request.setRequestHeader("Content-Type","multipart/form-data");
    request.setRequestHeader("Accept","application/json");
    // request.setRequestHeader("Bearer",token);
    request.send("data=" + JSON.stringify(req));
}

// DEPRECATED
function patchRequest(url, req, token, callback) {
    let request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            let response = {
                status : request.status,
                headers : request.getAllResponseHeaders(),
                contentType : request.responseType,
                content : request.response
            };

            callback(response);
        }
    }
    request.open("PATCH", url);
    request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    request.setRequestHeader("Bearer",token);
    // request.send("term="+term+"&reqid=curAmnt&acnt=" + crntacnt);
    request.send("data=" + Qt.btoa(JSON.stringify(req)));
}

function getRequest(url, path, query, callback) {
    let request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            let response = {
                status : request.status,
                headers : request.getAllResponseHeaders(),
                contentType : request.responseType,
                content : request.response
            };

            callback(response);
        }
    }
    request.open("GET", url+path + (query === undefined ? '' : ("?"+query)));
    request.send();
}

function parse(raw){
    try {
        return JSON.parse(raw);
    } catch (err) {
        return false;
    }
}

function sortCoef(vcrn) {
    if (vcrn === '' || vcrn === 'UAH' || vcrn === 'ГРН') { return '' }
    else if (vcrn === 'USD') {return '005'}
    else if (vcrn === 'EUR') {return '010'}
    else if (vcrn === 'PLN') {return '015'}
    else if (vcrn === 'RUB') {return '020'}
    else if (vcrn === 'GBP') {return '025'}
    else if (vcrn === 'CAD') {return '030'}
    else if (vcrn === 'CZK') {return '035'}
    else if (vcrn === 'AUD') {return '040'}
    else if (vcrn === 'CHF') {return '045'}
    else if (vcrn === 'SEK') {return '050'}
    else if (vcrn === 'HUF') {return '055'}
    else if (vcrn === 'EURUSD') {return '070'}
    else if (vcrn === 'USDPLN') {return '075'}
    else if (vcrn === 'LITO') {return '100'}
    else if (vcrn === 'ELSV') {return '110'}
    else if (vcrn === 'KHRV') {return '120'}
    else if (vcrn === 'DOBR') {return '130'}
    else if (vcrn === 'KNMAIN') {return '140'}
    else if (vcrn === 'SHELS1') {return '200'}
    else if (vcrn === 'SHELS2') {return '210'}
    else if (vcrn === 'offer') {return '500'}
    return '999'
}

function humanDate(vdate) {
    var vtmp = Date()
    var vdiff = Math.floor(((new Date().getTime())-(new Date(String(vdate).substring(0,10)).getTime()))/(1000*60*60*24))
    if (vdiff === 0) { return vdate.substring(11,16) // Qt.formatDate(new Date(vdate), 'hh:mm')
    } else if (vdiff === 1) { return 'вч '+vdate.substring(11,16)  //Qt.formatDate(new Date(vdate), 'вч hh:mm')
    // } else if (vdiff < 8) { return Math.floor(((new Date().getTime())-(new Date(String(vdate).substring(0,10)).getTime()))/(1000*60*60*24))+' дн.'
    } else if (vdiff < 360) { return Qt.formatDate(new Date(vdate), 'dd MMM')
    } else { return Qt.formatDate(new Date(vdate), 'MMM yy'); /*String(vdate).substring(0,10);*/ }

}

