$(function () {
    window.addEventListener("message", function (event) {
        if (event.data.type === "ui") {
            if (event.data.display) {
                $("body").fadeIn(20);
            } else {
                $("body").fadeOut(20);
            }
            if (typeof event.data.entity != "undefined") {
                $("#eye").removeClass("active");
                $("#label").html(event.data.label);
                $("#coords").html(event.data.coords);
            } else {
                $("#eye").addClass("active"); 
                $("#label").html("");
                $("#coords").html("");
            }
        } else if (event.data.type === "cpy") {
            var node = document.createElement('textarea');
            var selection = document.getSelection();
      
            node.textContent = event.data.value;
            document.body.appendChild(node);
      
            selection.removeAllRanges();
            node.select();
            document.execCommand('copy');
      
            selection.removeAllRanges();
            document.body.removeChild(node);
        }
    })
});