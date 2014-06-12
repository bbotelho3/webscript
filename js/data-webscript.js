function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    var m = checkTime(m);
    var s = checkTime(s);
    document.getElementById("txt").innerHTML = h + ":" + m + ":" + s;
    t = setTimeout(500);
}

function checkTime(i) {
    if (i < 10) {
        i = "0" + i;
    }
    return i;
}
