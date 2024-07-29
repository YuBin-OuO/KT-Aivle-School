(function () {
    var msgs = {
        login: 'Login Your Account.',
        noAccount: 'Tdere is no Account.',
    };
    var Event = {
        getContents: function () {
            $('.search').on('click', function () {
                var addr = $('.input-address').val();
                var url = 'https://apis.zigbang.com/v2/search?leaseYn=N&q=' + addr + '&serviceType=원룸'
                $.getJSON(url, function (json) {
                    // console.log(json.items);
                    var tag = '';
                    for(var i = 0; i < json.items.length; i++){
                        // console.log(json.items[i])
                        tag += '<tr>';
                        tag += '    <td>' + (i + 1) + '</td>';
                        tag += '    <td>' + json.items[i].id + '</td>';
                        tag += '    <td>' + json.items[i].name + '</td>';
                        tag += '    <td>' + Math.round(Number(json.items[i].lat) * 100) / 100 + '</td>';
                        tag += '    <td>' + Math.round(Number(json.items[i].lng) * 100) / 100 + '</td>';
                        tag += '    <td>' + json.items[i].description + '</td>';
                        tag += '</tr>';
                    }
                    $('.table-wrap > table > tbody').html(tag);
                    $('.table-wrap').show();
                });
            });
        }
    };
    Event.getContents();
    // $('.search').click();
})();