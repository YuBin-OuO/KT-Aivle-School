(function () {
  var msgs = {
    join: "Joined your account.",
    check: "Your passwords are different.",
  };

  var Event = {
    join: function () {
      $("#join-btn").on("click", function () {
        var params = {
          email: $("#email").val(),
          pw: $("#pw").val(),
          ckpw: $("#ckpw").val(),
          addr: $('input[name="addr"]:checked').val(),
          birth: $("#birth").val(),
          subscription: $("#subscription").val(),
        };

        if (params.pw !== params.ckpw) {
          $(".msg").text(msgs["check"]);
        } else {
          $(".msg").text(msgs["join"]);
        }
      });
    },
  };

  Event.join();
})();