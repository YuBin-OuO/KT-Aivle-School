(function() {
    var msgs = {
        checkPw: 'Check Your Password.',
        joinAccount: 'Joined Your Account.',
    };
    var Event = {
        join: function() {
            $('#join-btn').on('click', function() {
                var params = {
                    id: $('#email').val(),
                    pw: $('#pw').val(),
                    ckpw: $('#ckpw').val(),
                    addr: $('input[name="addr"]:checked').val(),
                    birth: $('#birth').val(),
                    subscription: $('#subscription').val(),
                };
                console.log(params);
                if(params.pw != params.ckpw){
                    console.log('check password!');
                    $('.join-wrap>.msg').text(msgs.checkPw).show();
                } else {
                    console.log(params);
                    $('.join-wrap>.msg').text(msgs.joinAccount).show();
                };
            });
        }
    };
    Event.join();
})();