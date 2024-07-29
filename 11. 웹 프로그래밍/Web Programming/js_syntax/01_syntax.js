var data = {name: 'peter', age: 29, skills: ['coding', 'reading']};
var json_str = JSON.stringify(data);
console.log(typeof data, typeof json_str);
console.log(data, json_str);

json_obj = JSON.parse(json_str);
console.log(typeof json_obj, json_obj);