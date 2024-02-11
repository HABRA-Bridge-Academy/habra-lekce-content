$(function () {
    $(".bidding-solution").each( function(index, el) {

        let fn =  function () {
            $(el).children(":not(.solution-label):not(.reveal-button)").removeClass("blur");
            $(el).children(".reveal-button").css("visibility", "hidden");
        }
        let button = $("<button>").append($("<i>").addClass("gg-eye")).addClass("reveal-button");
        button.on("click", fn)
        $(el).children(":not(.solution-label)").addClass("blur").on("click", fn);
        $(el).children().first().after(button);
    });

    $(".auction.revealable").each( function(index, el) {

        let controls = $("<div>").addClass("reveal-controls");
        let bids = $(el).children(".auction-bid");
        bids.hide();
        let curr = bids.first();

        let b1 = $("<button>").text(">|").addClass("reveal-control").on("click", function() {
            curr.show();
            curr = curr.next(".auction-bid");
            if(!curr.length) {
                controls.hide();
            }
        });
        let ba = $("<button>").text(">>|").addClass("reveal-control").on("click", function() {
            bids.show();
            controls.hide();
        });

        controls.append(b1, ba);

        $(el).after(controls);
    });

});
