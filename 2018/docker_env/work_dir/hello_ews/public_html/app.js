APP = (function() {
    init = function() {
        /*
         * 日付入力パーツ初期化
         */
        dateTimeApp = new expGuiDateTime(document.getElementById("dateTime"));
        dateTimeApp.setConfigure("ssl", true);
        dateTimeApp.dispDateTime(dateTimeApp.SEARCHTYPE_PLAIN);

        /*
         * 駅名入力パーツ初期化
         */
        // 駅名入力パーツ初期化(出発駅)
        stationFromApp = new expGuiStation(document.getElementById("stationFrom"));
        stationFromApp.setConfigure("ssl", true);
        stationFromApp.setConfigure("maxStation",10);
        stationFromApp.setConfigure("type",stationFromApp.TYPE_TRAIN +":"+ stationFromApp.TYPE_PLANE +":"+ stationFromApp.TYPE_SHIP);
        stationFromApp.dispStation();
        // 駅名入力パーツ初期化(到着駅)
        stationToApp = new expGuiStation(document.getElementById("stationTo"));
        stationToApp.setConfigure("ssl", true);
        stationToApp.setConfigure("maxStation",10);
        stationToApp.setConfigure("type",stationToApp.TYPE_TRAIN +":"+ stationToApp.TYPE_PLANE +":"+ stationToApp.TYPE_SHIP);
        stationToApp.dispStation();

        /*
         * 探索条件パーツ初期化
         */
        conditionApp = new expGuiCondition(document.getElementById("condition"));
        conditionApp.setConfigure("ssl", true);
        conditionApp.dispCondition();

        /*
         * 経路表示パーツ初期化
         */
        resultApp = new expGuiCourse(document.getElementById("result"));
        resultApp.setConfigure("ssl", true);
        resultApp.setConfigure("PriceChange",true);// 変更を許可
        resultApp.setConfigure("AssignDia",true);
    };

    /*
     * 探索前に入力チェックを行う
     */
    function checkData(){
        // メッセージの初期化
        var errorMessage="";

        if(!dateTimeApp.checkDate()){
            // 日付入力パーツのチェック
            errorMessage +="\n日付を正しく入力してください。";
        }
        if(stationFromApp.getStation() == ""){
            // 駅名入力パーツの空チェック
            errorMessage +="\n出発地は必須です。";
        }
        if(stationToApp.getStation() == ""){
            // 駅名入力パーツの空チェック
            errorMessage +="\n目的地は必須です。";
        }else{
            if(stationFromApp.getStation() == stationToApp.getStation()){
                // 駅名同一チェック
                errorMessage +="\n出発地と目的地が同一です。";
            }
        }
        if(errorMessage != ""){
            alert("下記の項目を確認してください。"+errorMessage);
            return false;
        }else{
            return true;
        }
    }

    searchRun = function() {
        if(checkData()) {
            var searchWord = "";

            // 候補を閉じる
            stationFromApp.closeStationList();
            stationToApp.closeStationList();

            // 発着地リストを作成
            var viaList="";
            viaList += stationFromApp.getStationCode();
            viaList += ":"+ stationToApp.getStationCode();
            searchWord +="viaList="+viaList;

            // 探索種別
            searchWord += '&date='+ dateTimeApp.getDate();

            switch(dateTimeApp.getSearchType()){
                case dateTimeApp.SEARCHTYPE_DEPARTURE:// ダイヤ出発
                    searchWord += '&searchType=departure';
                    searchWord += '&time='+ dateTimeApp.getTime();
                    break;
                case dateTimeApp.SEARCHTYPE_ARRIVAL:// ダイヤ到着
                    searchWord += '&searchType=arrival';
                    searchWord += '&time='+ dateTimeApp.getTime();
                    break;
                case dateTimeApp.SEARCHTYPE_FIRSTTRAIN:// 始発
                    searchWord += '&searchType=firstTrain';
                    break;
                case dateTimeApp.SEARCHTYPE_LASTTRAIN:// 終電
                    searchWord += '&searchType=lastTrain';
                    break;
                case dateTimeApp.SEARCHTYPE_PLAIN:// 平均
                    searchWord += '&searchType=plain';
                    break;
            }

            // ソート
            searchWord += '&sort='+ conditionApp.getSortType();

            // 探索結果数
            searchWord += '&answerCount='+ conditionApp.getAnswerCount();

            // 探索条件
            searchWord += '&conditionDetail='+ conditionApp.getConditionDetail();

            // 探索を実行
            resultApp.search(searchWord,conditionApp.getPriceType(),result);
        }
    };

    return {
      "init": init,
      "searchRun": searchRun,
    };
})();
