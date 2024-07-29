(function(){
    $('header a.login').addClass('active');
    var msgs = {
        login: 'Login your account.',
        fail: 'There is no account or wrong password.',
    }
    var Event = {
        login: function(){
            $('#login-btn').on('click', function(){
                var params = {
                    email: $('#email').val(),
                    pw: $('#pw').val(),
                }
                if(params.email === 'admin@kt.com' && params.pw === '1234'){
                    $('.msg').text(msgs.login).show();
                    location.href = 'contents';
                } else {
                    $('.msg').text(msgs.fail).show();
                }
            })
        }
    }
    Event.login();
})();
