
function setData()
{
    console.log('hahhaha');
    addLine(3);
////    var note = eval('(' + JavaScriptInterface.noteInfoData() + ')');
////    var note = '{"endTimeDay":"jack"}';
////    var obj = JSON.parse(note);
//    var note = JSON.parse(JavaScriptInterface.noteInfoData());
//
////    times.innerHTML = note.times;
//
//    startTimeYear.innerHTML = note.startTimeYear;
//    startTimeMonth.innerHTML = note.startTimeMonth;
//    startTimeDay.innerHTML = note.startTimeDay;
//    startTimeHour.innerHTML = note.startTimeHour;
//    startTimeMinute.innerHTML = note.startTimeMinute;
//
//    endTimeYear.innerHTML = note.endTimeYear;
//    endTimeMonth.innerHTML = note.endTimeMonth;
//    endTimeDay.innerHTML = note.endTimeDay;
//    endTimeHour.innerHTML = note.endTimeHour;
//    endTimeMinute.innerHTML = note.endTimeMinute;
}
function addLine(pageCount) {
    var line = "<table cellpadding=\"0\" cellspacing=\"0\" class=\"note-edit-table\"><tbody>" +
                "<tr style=\"height:40px;\"><td style=\"\"><div class=\"note-edit-content\">&nbsp;" +
                "</div></td></tr></tbody></table>";
    var htmlCode = "";
    for (var i = 0; i < pageCount; i++) {
        htmlCode +=line;
    }
    document.getElementById("noteContent").innerHTML += htmlCode
}
