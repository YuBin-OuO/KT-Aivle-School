var drawChart = function(data){
    Highcharts.chart('container', {
        chart: {
            type: 'pie',
            backgroundColor: '#343a40'
        },
        title: {
            text: 'Classification Sentence',
            style:{
                color: 'white'
            }
        },
        tooltip: {
            valueSuffix: '%'
        },
        subtitle: {
            text:
            'Source:<a href="https://www.mdpi.com/2072-6643/11/3/684/htm" target="_default">MDPI</a>'
        },
        plotOptions: {
            series: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: [{
                    enabled: true,
                    distance: 20
                }, {
                    enabled: true,
                    distance: -40,
                    format: '{point.percentage:.1f}%',
                    style: {
                        fontSize: '1.2em',
                        textOutline: 'none',
                        opacity: 0.7
                    },
                    filter: {
                        operator: '>',
                        property: 'percentage',
                        value: 10
                    }
                }]
            }
        },
        series: [
            {
                name: 'Percentage',
                colorByPoint: true,
                data: data
            }
        ]
    });
    
}

var Event = {
    send: function(){
        $('.send-btn').on('click', function(){ // 클릭하면 함수 실행
            var params = {
                sentence: $('.sentence').val(),
            }
            console.log(params);
            $.post('/api/category', params, function(response){
                console.log(response);
                $('.result-category').text(response.category);
                $('section.result').show();
                var data = [];
                for (var i=0; i<response.predict.length; i++){
                    data.push({
                        name: response.predict[i][0],
                        y: response.predict[i][1]
                    }) // data는 리스트. 리스트.push로 리스트에 데이터 하나씩 추가
                }
                console.log(data);
                drawChart(data);
            }) // /api/category로 post 방식으로 params 보낸 뒤 응답 온 걸 function에 response로 넣어 함수 실행
        }) // Send 누르고 개발자도구 Headers ~ Preview 확인
    }
}
Event.send();