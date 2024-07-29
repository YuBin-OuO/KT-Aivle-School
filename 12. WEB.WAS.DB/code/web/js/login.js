(function() {
    var msgs = {
        login: 'Login Your Account.',
        noAccount: 'There is no Account.',
    };
    var Event = {
        login: function() {
            $('#login-btn').on('click', function() {
                var params = {
                    id: $("#email").val(),
                    pw: $("#pw").val(),
                };
                if( params.id === 'admin@kt.com' && params.pw === '1234'){
                    $('.login-wrap>.msg').text(msgs.login).show();
                    location.href = 'contents.html';
                } else {
                    $('.login-wrap>.msg').text(msgs.noAccount).show();
                }        
            });
        }
    };
    Event.login();
})();