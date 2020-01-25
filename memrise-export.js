/*

copy from gist https://gist.github.com/vasilykraev/6deebaa0e47c6c860981e8987869eea0/6530dee6cc723fd8fa08b5eed3d5af42503c7878

Export Memrise course words to CSV.

1. Log into memrise.com
2. Navigate to course home page (e.g. http://www.memrise.com/course/335725/comprehensive-german-duolingo-vocabulary/)
3. Open Developer Console
4. Paste below script and hit enter
5. After all urls have been fetched, copy final word list into spreadsheet.

*/

(() => {

  function getWords(courseId, level) {
    const url = `https://www.memrise.com/ajax/session/?course_id=${courseId}&level_index=${level}&session_slug=preview`
    console.log('Fetching words from ' + url)
    return fetch(url, { credentials: 'same-origin' })
      // parse response
      .then(res => {
        return res.status === 200
          ? res.json()
            // map results
            .then(data => {
              
              return data.learnables.map(row => ({
                level_id: data.session.level_id,
                level_title: data.session.level.title,
                level_index: data.session.level.index,
                id: row.thing_id,
                original: row.item.value,
                translation: row.definition.value,
                ignored: getSafe(data.thingusers, row.thing_id)
              }))
            })
            .then(words => {
              return getWords(courseId, level + 1)
                .then(words.concat.bind(words))
            })
          : []
    })
    .catch(err => {
      console.error(err)
      return []
    })
  }

  function replaceUndefinied(item) {
   var str =  JSON.stringify(item, function (key, value) {return (value === undefined) ? "" : value});
   return JSON.parse(str);
  }

  function getSafe(fn, id, defaultVal) {
    try {
      item = fn.find(item => item.thing_id === id);
      return item.ignored;
    } catch (e) {
      return defaultVal;
    }
  }

  // fetch
  const start = 1
  const courseId = location.href.slice(30).match(/\d+/)[0] 
  getWords(courseId, start)
    // format as csv
    .then(words => {
      console.log(words.length + ' words')
      return words.map(word => courseId + '\t' + word.level_index + '\t' + word.level_title + '\t' + word.id + '\t' + word.original + '\t' + word.translation + '\t' + replaceUndefinied(word.ignored) + '\n').join('')
    })
    // print
    .then(console.table)

})()