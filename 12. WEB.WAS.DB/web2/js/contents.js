var Util = {
    round: function(data){
        return Math.round(Number(data) * 100) / 100;
    }
}
var Event = {
    getContents: function(){
        $('.search').on('click', function(){
            var addr = $('.input-address').val();
            var url = 'https://apis.zigbang.com/v2/search?leaseYn=N&q=' + addr + '&serviceType=원룸';
            // response = requests.get(url)
            $.getJSON(url, function(response){
                console.log(response.items);
                var items = response.items;
                var tag = '';
                for(var i = 0; i < items.length; i++){
                    tag += '<tr>';
                    tag += '    <td>' + (i + 1) + '</td>';
                    tag += '    <td>' + items[i].id + '</td>';
                    tag += '    <td>' + items[i].name + '</td>';
                    tag += '    <td>' + Util.round(items[i].lat) + '</td>';
                    tag += '    <td>' + Util.round(items[i].lng) + '</td>';
                    tag += '    <td>' + items[i].description + '</td>';
                    tag += '</tr>';
                }
                $('table > tbody').html(tag);
                $('.table-wrap').show();
            })
        })
    }
}
Event.getContents();