var stubResults

$(document).keyup(function(e) {
    if (e.key === "Escape" ) { // escape key maps to keycode `27`
        $("#tabletParaffin").fadeOut(200);
        $("#areYouSure").fadeOut(200);
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({
        }))
   }
});

window.addEventListener('message', function (event) {
    let e = event.data
    if (event.data.open) {

        // APPLICO LOCALE
        $("#forensictablet").html(locale.tabletTitle);
        $("#forensictabletsubt").html(locale.tabletSubtitle);
        $("#titlecontent").html(locale.stubtest);
        $("#desccontent").html(locale.stubtestSubtitle);
        $(".seetest").html(locale.seeTest);
        $(".seetestdesc").html(locale.seeTestSubt);
        $("#titlesitua").html(locale.newTestTitle);
        $("#titolosinistra").html(locale.selectPlayer);
        $(".testStubInfo").html(locale.rightInfo);
        $("#descrizionedestra").html(locale.rightInfoDesc);
        $(".stubResultTitle").html(locale.stubResult);
        $("#testtext").html(locale.stubResultSubt);
        $("#resulttitle").html(locale.stubResult_other);
        $("#infotitle").html(locale.stubResult_playerInformations);
        $(".fullname").html(locale.stubResult_playerInformations_fullname);
        $(".dobtrans").html(locale.stubResult_playerInformations_DOB);
        $("#hometext").html(locale.stubResult_backhome);
        $(".titleStubDb").html(locale.stubDatabase);
        $(".selectTest").html(locale.selectTest);
        $("#search").attr("placeholder", locale.search);
        $("#titleInfoPart").html(locale.stubResult);
        $("#fullnameDb").html(locale.stubResult_playerInformations_fullname);
        $(".dobDb").html(locale.stubResult_playerInformations_DOB);
        $(".testDate").html(locale.testDate);
        $("#buttontitle").html(locale.deleteEntry);
        $("#titleDelete").html(locale.delete_areYouSure);
        $("#descriptionDelete").html(locale.delete_takeCare);
        $(".confirm").html(locale.delete_confirm);
        $(".cancel").html(locale.delete_cancel);


        $("#tabletParaffin").fadeIn(50);
        tableselect = ""
        tabledb = ""
        for (const [key, value] of Object.entries(event.data.nearPlayers)) {
            tableselect = tableselect + '<div id="player">'
            tableselect = tableselect + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
            tableselect = tableselect + '<div id="playername">' + value.label + '</div>'
            tableselect = tableselect + '<div id="buttonselect" onclick = "testPlayer(\''+ value.value +'\')">'+locale.select_player+'</div>'
            tableselect = tableselect + '</div>'
        }
        stubResults = event.data.stubResults
        for (const [key, value] of Object.entries(event.data.stubResults)) {
            tabledb = tabledb + '<div id="playerDb" onclick = "seeData(\''+key+'\')">'
            tabledb = tabledb + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
            tabledb = tabledb + '<div id="datadb">'
            tabledb = tabledb + '<div id="playername">'+ value.player +'</div>'
            var situaz = locale.generalResult_Negative
            if (value.result) {
                situaz = locale.generalResult_Positive
            }
            tabledb = tabledb + '<div id="playerdesc">'+situaz+' - '+value.date+'</div>'
            tabledb = tabledb + '</div>'
            tabledb = tabledb + '</div>'
        }

        $("#subtitleinfopart").html("??")
        $(".nameCazz").html("--")
        $(".dobcazz").html("--")
        $(".testcazz").html("--")
        $("#tableselect").html(tableselect);
        $("#dbTable").html(tabledb);

    }
    if (event.data.refresh) {
        tableselect = ""
        tabledb = ""
        for (const [key, value] of Object.entries(event.data.nearPlayers)) {
            tableselect = tableselect + '<div id="player">'
            tableselect = tableselect + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
            tableselect = tableselect + '<div id="playername">' + value.label + '</div>'
            tableselect = tableselect + '<div id="buttonselect" onclick = "testPlayer(\''+ value.value +'\')">'+locale.select_player+'</div>'
            tableselect = tableselect + '</div>'
        }
        stubResults = event.data.stubResults
        for (const [key, value] of Object.entries(event.data.stubResults)) {
            tabledb = tabledb + '<div id="playerDb" onclick = "seeData(\''+key+'\')">'
            tabledb = tabledb + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
            tabledb = tabledb + '<div id="datadb">'
            tabledb = tabledb + '<div id="playername">'+ value.player +'</div>'
            var situaz = locale.generalResult_Negative
            if (value.result) {
                situaz = locale.generalResult_Positive
            }
            tabledb = tabledb + '<div id="playerdesc">'+situaz+' - '+value.date+'</div>'
            tabledb = tabledb + '</div>'
            tabledb = tabledb + '</div>'
        }
        $("#tableselect").html(tableselect);
        $("#dbTable").html(tabledb);
    }
    if (event.data.testTerminato) {
        $("#resultStub").removeClass("scomparsa");
        $("#newTest").addClass("scomparsa");
        $("#newTest").fadeOut(0);
        $("#resultStub").fadeIn(0);
        $("#tabletParaffin").fadeIn(50);

        if (event.data.esito.result) {
            $(".resultSituazza").html(locale.generalResult_Positive);
            $(".resultSituazza").css('color', 'red');
        } else {
            $(".resultSituazza").html(locale.generalResult_Negative);
            $(".resultSituazza").css('color', 'green');

        }
        $(".fullnameresult").html(event.data.esito.player)
        $(".dobresult").html(event.data.esito.dob)

    }
})


var currentSeeing
var currentSeeing2
function seeData(keyd) {
    currentSeeing = keyd
    currentSeeing2 = stubResults[keyd].identifier
    var value = stubResults[keyd]
    var situaz = locale.generalResult_Negative
    if (value.result) {
        situaz = locale.generalResult_Positive
    }
    if (value.result) {
        $("#subtitleinfopart").html(situaz);
        $("#subtitleinfopart").css('color', 'red');
    } else {
        $("#subtitleinfopart").html(situaz);
        $("#subtitleinfopart").css('color', 'green');

    }
    $(".nameCazz").html(value.player)
    $(".dobcazz").html(value.dob)
    $(".testcazz").html(value.date)
}


function elimina() {
    if (currentSeeing) {
        $("#areYouSure").fadeIn(100)
        $("#suretoDelete").fadeIn(100)
    }
}
function cancelDelete() {
    $("#areYouSure").fadeOut(100)
    $("#suretoDelete").fadeOut(100)
}
function confirmDelete() {
    cancelDelete()
    $("#subtitleinfopart").html("???")
    $(".nameCazz").html("--")
    $(".dobcazz").html("--")
    $(".testcazz").html("--")
    $.post(`https://${GetParentResourceName()}/eliminaQuesto`, JSON.stringify({
        idPlayer: currentSeeing,
        situa: currentSeeing2
    }))
    currentSeeing = null
    setTimeout(() => {
        $.post(`https://${GetParentResourceName()}/refreshAll`, JSON.stringify({
        }))
    }, 300);
}


function testPlayer(key) {
    $("#tabletParaffin").fadeOut(500);
    $.post(`https://${GetParentResourceName()}/testPlayer`, JSON.stringify({
        idPlayer: key
    }))
}

function search() {
    $("#dbTable").html("");
    var situa = ""
    if ($("#search").val() == "") {
        for (const [key, value] of Object.entries(stubResults)) {
            situa = situa + '<div id="playerDb" onclick = "seeData(\''+key+'\')">'
            situa = situa + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
            situa = situa + '<div id="datadb">'
            situa = situa + '<div id="playername">'+ value.player +'</div>'
            var situaz = locale.generalResult_Negative
            if (value.result) {
                situaz = locale.generalResult_Positive
            }
            situa = situa + '<div id="playerdesc">'+situaz+' - '+value.date+'</div>'
            situa = situa + '</div>'
            situa = situa + '</div>'
        }
        $("#dbTable").html(situa);
    } else {
        for (const [key, value] of Object.entries(stubResults)) {
            var text = value.player
            if (text.includes($("#search").val())) {
                situa = situa + '<div id="playerDb" onclick = "seeData(\''+key+'\')">'
                situa = situa + '<i class="fa-solid fa-user" aria-hidden="true"></i>'
                situa = situa + '<div id="datadb">'
                situa = situa + '<div id="playername">'+ value.player +'</div>'
                var situaz = locale.generalResult_Negative
                if (value.result) {
                    situaz = locale.generalResult_Positive
                }
                situa = situa + '<div id="playerdesc">'+situaz+' - '+value.date+'</div>'
                situa = situa + '</div>'
                situa = situa + '</div>'
            }
        }
        $("#dbTable").html(situa);
    }

}

function homepageClickResult() {
    refreshAll()
    setTimeout(() => {
        $("#mainscreen").removeClass("scomparsa");
        $("#resultStub").addClass("scomparsa");
        $("#resultStub").fadeOut(0);
        $("#mainscreen").fadeIn(0);
    }, 30);
}

function refreshAll() {
    $.post(`https://${GetParentResourceName()}/refreshAll`, JSON.stringify({
    }))
}

function newtestpage() {
    setTimeout(() => {
        $("#newTest").removeClass("scomparsa");
        $("#mainscreen").addClass("scomparsa");
        $("#mainscreen").fadeOut(0);
        $("#newTest").fadeIn(0);
    }, 30);
}
function homepageClick() {
    setTimeout(() => {
        $("#mainscreen").removeClass("scomparsa");
        $("#newTest").addClass("scomparsa");
        $("#newTest").fadeOut(0);
        $("#mainscreen").fadeIn(0);
    }, 30);  
}
function newstubDbpage() {
    setTimeout(() => {
        $("#stubDb").removeClass("scomparsa");
        $("#mainscreen").addClass("scomparsa");
        $("#mainscreen").fadeOut(0);
        $("#stubDb").fadeIn(0);
    }, 30);
}

function homepageClickStub() {
    setTimeout(() => {
        $("#mainscreen").removeClass("scomparsa");
        $("#stubDb").addClass("scomparsa");
        $("#stubDb").fadeOut(0);
        $("#mainscreen").fadeIn(0);
    }, 30);  
}

function seetests() {
    setTimeout(() => {
        $("#stubDb").removeClass("scomparsa");
        $("#mainscreen").addClass("scomparsa");
        $("#mainscreen").fadeOut(0);
        $("#stubDb").fadeIn(0);
    }, 30);

}
