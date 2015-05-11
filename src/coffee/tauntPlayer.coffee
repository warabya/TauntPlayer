query_string = {};
query = window.location.search.substring 1
params = query.split "&"
for param,i in params
  pair = param.split "="
  if typeof query_string[pair[0]] == "undefined"
    query_string[pair[0]] = pair[1];
  else if typeof query_string[pair[0]] == "string"
    arr = [ query_string[pair[0]], pair[1] ];
    query_string[pair[0]] = arr;
  else
    query_string[pair[0]].push pair[1]

console.log(query_string.tauntFileName);

snd = new Audio 'taunts/' + query_string.tauntFileName;
snd.play()