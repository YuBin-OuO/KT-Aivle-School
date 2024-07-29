(function(){
    $('header a.join').addClass('active');
    var msgs = {
        join: 'Joined your account.',
        check: 'Check your password same.',
    }
    var Event = {
        join: function(){
            $('#join-btn').on('click', function(){
                var params = {
                    email: $('#email').val(),
                    pw: $('#pw').val(),
                    ckpw: $('#ckpw').val(),
                    addr: $('input[name="addr"]:checked').val(),
                    birth: $('#birth').val(),
                    subscription: $('#subscription').val(),
                }
                if(params.pw === params.ckpw){
                    $('.msg').text(msgs.join);
                    $.post('api/join', params, function(response){
                        console.log(response);
                        if(response.msg === 'joinAccount'){
                            location.href = 'login';
                        } else {
                            $('.msg').text(response.msg);
                        }
                    })
                } else {
                    $('.msg').text(msgs.check);
                }
            })
        }
    }
    Event.join();
})();