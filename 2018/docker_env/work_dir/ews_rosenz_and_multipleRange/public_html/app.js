APP = (function() {
    var rosen = null;       // 駅すぱあと路線図のオブジェクト。
    var httpRequest = null; // HTTPアクセス用オブジェクト(駅すぱあとWebサービスを呼び出す際に使用する)。

    var rosenz_key = "__ROSENZ_ACCESS_KEY__"; // 駅すぱあと路線図のアクセスキー
    var ews_key    = "__EWS_ACCESS_KEY__";    // 駅すぱあとWebサービスのアクセスキー

    var processing_lock = false; // 処理のロック用変数
    var station_codes = [];      // 駅コードを持ちまわすための配列

    init = function() {
        // 駅すぱあとWebサービスを呼び出すため、httpRequestを準備する。
        if(window.XMLHttpRequest) { // Firefox,Opera
            httpRequest = new XMLHttpRequest();
            httpRequest.overrideMimeType('text/xml');
        } else if(window.ActiveXObject) { // IE
            try {
                httpRequest = new ActiveXObject('Msxml2.XMLHTTP');
            } catch (e) {
                httpRequest = new ActiveXObject('Microsoft.XMLHTTP');
            }
        }

        // 駅すぱあと路線図の初期化。
        rosen = new Rosen("map", { // "map"は<div>のidと一致させる
            apiKey: rosenz_key,    // 駅すぱあと路線図のアクセスキーを指定します
            apiSetting: "https",   // HTTPS版のAPIサーバを指定
            tileSetting: "https",  // HTTPS版のタイルサーバを指定
            zoom: 12
        });
    }

    // 駅すぱあとWebサービスの範囲探索(/search/multipleRange)を呼び出します。
    // http://docs.ekispert.com/v1/api/search/multipleRange.html
    multipleRange = function() {
        // スライダーの値を取得。
        var upper_minute = document.getElementById('slider').value;
        document.getElementById('minute').innerText = upper_minute;

        // 駅すぱあと路線図にマッピング中の場合は処理させない。
        if (processing_lock == true) {
            return;
        }

        // 範囲探索(/search/multipleRange)のリクエストURLを作成する。
        url = 'http://api.ekispert.jp/v1/json/search/multipleRange?key=' + ews_key + '&baseList=22828&upperMinute=' + upper_minute;

        // WebAPI呼び出し。
        processing_lock = true;
        httpRequest.open('GET', url, true);
        httpRequest.onreadystatechange = processResult;
        httpRequest.send(null);
    }

    // 範囲探索で取得したデータを駅すぱあと路線図にマッピングする。
    mapping = function(json) {
        // マッピングしているマーカーを消す。
        for (var i in station_codes) {
            rosen.unsetStationMarker(station_codes[i]);
        }
        station_codes = [];

        // 範囲探索で取得した駅に円形のポップアップを表示させる。
        for (var i in json.ResultSet.Point) {
            var code = json.ResultSet.Point[i].Station.code;
            var option = {
                type: "circle",
                radius: 2,
                color: "#ff0000",
                opacity: 0.7
            };
            rosen.setStationMarker(code, option);
            station_codes.push(code);
        }
        processing_lock = false;
    }

    processResult = function() {
        if (httpRequest.readyState == 4) {
            var status = httpRequest.status;
            if (status == 200 || status == 201) {
                mapping(JSON.parse(httpRequest.responseText));
            } else {
                var errStr = httpRequest.statusText + '(' + httpRequest.status + ')';
                alert(errStr);
            }
        }
    }
 
    return {
        "init": init,
        "multipleRange": multipleRange,
    };
})();
