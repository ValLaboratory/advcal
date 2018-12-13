APP = (function() {
    var rosen;

    init = function() {
        rosen = new Rosen("map", {              // "map"は<div>のidと一致させる
            apiKey: "__ACCESS_KEY__", // アクセスキーはサンプル用です。実際にご利用されるときは書き換えてください。
            apiSetting: "https",                // HTTPS版のAPIサーバを指定
            tileSetting: "https"                // HTTPS版のタイルサーバを指定
        });

        rosen.on('selectStation', function(data) {
            // クリックした地点の付近に駅が複数ある場合は、複数の駅が返ってくる（近い順でソート）
            var msg = "";
            data.stations.forEach(function(station) {
                msg += station.code + ", ";
                msg += station.name + ", ";
                msg += station.yomi + ", ";
                msg += station.latitude + ", ";
                msg += station.longitude + "\n";
                console.log(station);
                rosen.setStationMarker(station.code);
            });
            $('#map_message').text(msg);
        });

        rosen.on('selectLine', function(data) {
            // クリックした地点の付近に路線が複数ある場合は、複数の路線が返ってくる（近い順でソート）
            var msg = "";
            data.lines.forEach(function(line) {
                msg += line.name + "\n";
                console.log(line);
                rosen.highlightLine(line.code);

                rosen.getSectionsByLineCode(line.code).then(function(sections) {
                    var middle_index = Math.floor(sections.length / 2);   // 真ん中
                    var section = sections[middle_index];
                    var popup = Rosen.textPopup().setComment(line.name);

                    rosen.setSectionPopup(section.code, popup);
                });
            });
            $('#map_message').text(msg);

        });
    };

    return {
        "init": init,
    };
})();
