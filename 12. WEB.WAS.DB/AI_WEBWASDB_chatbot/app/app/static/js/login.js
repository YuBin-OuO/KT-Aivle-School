(function(){
    $('header a.login').addClass('active');
    var msgs = {
        login: 'Login your account.',
        fail: 'There is no account or wrong password.',
    }
    var Event = {
        login: function(){
            $('#login-btn').on('click', function(){
                // 로그인 정보들 받아옴
                var params = {
                    email: $('#email').val(),
                    pw: $('#pw').val(),
                }
                // if(params.email === 'admin@kt.com' && params.pw === '1234'){
                //     $('.msg').text(msgs.login).show();
                //     location.href = 'contents';
                // } else {
                //     $('.msg').text(msgs.fail).show();
                // }

                // 서버쪽의 DB에 계정이 있다면 로그인 성공되게끔
                $.post('/api/login', params, function(response){ // /api/login/ url로 params 데이터들 요청하고, 백엔드쪽에선 api_login() 실행됨. 응답 오면 function 함수 실행
                    console.log(response); // 브라우저 개발자도구 참고 (F12)
                    if(response.msg === 'login'){
                        location.href = 'contents' // 컨텐츠 페이지로 이동
                    }
                    else{
                        $('.msg').text(response.msg).show(); // 물론 그냥 위에 있는 msgs.fail 출력해줘도 됨
                    }
                })
                // js코드는 브라우저쪽에서 동작
            })
        }
    }
    Event.login();
})();
