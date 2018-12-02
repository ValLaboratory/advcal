APP = (function() {
    var ACCESS_KEY = 'ここにアクセスキーを入力';
    var httpRequest = null;

    init = function() {
        if(window.XMLHttpRequest) { // Firefox, Opera
            httpRequest = new XMLHttpRequest();
            httpRequest.overrideMimeType('text/xml');
        } else if(window.ActiveXObject) { // IE
            try {
                httpRequest = new ActiveXObject('Msxml2.XMLHTTP');
            } catch (e) {
                httpRequest = new ActiveXObject('Microsoft.XMLHTTP');
            }
        }
    }

    getStationInfo = function() {
        var station_code = document.getElementById('stationCode').value;
        url = 'http://api.ekispert.jp/v1/json/station/info?type=welfare&key=' + ACCESS_KEY + '&code=' + station_code;
        console.log(url);
        httpRequest.open('GET', url, true);
        httpRequest.onreadystatechange = processResult;
        httpRequest.send(null);
    }

    processResult = function() {
        if (httpRequest.readyState == 4) {
            var status = httpRequest.status;
            if (status == 200 || status == 201) {
                console.log(JSON.parse(httpRequest.responseText).ResultSet.Information.WelfareFacilities);

                var wf = JSON.parse(httpRequest.responseText).ResultSet.Information.WelfareFacilities;
                var text = '';

                for(var i in wf) {
                    text += "■" + wf[i].Name + "\n" + wf[i].Comment + "\n";
                }
                $('#result').val(text);
            } else {
                var errStr = httpRequest.statusText + '(' + httpRequest.status + ')';
                alert(errStr);
            }
        }
    };

    return {
      "init": init,
      "getStationInfo": getStationInfo,
    };
})();
