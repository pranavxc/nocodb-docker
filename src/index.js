// const zeroEks = require('0x')
const path = require('path')
const fs = require('fs')
const express = require('express')
const fileManager = require('express-file-manager');
const admz = require('adm-zip')


const shell = require('shelljs')
//
// async function capture () {
//   const opts = {
//     argv: [path.join(__dirname, '../nocodb/nocodb-develop/packages/nocodb/dist/run/local.js')],
//     workingDir: path.join(__dirname, 'results'),
//   }
//   try {
//     const file = await zeroEks(opts)
//     console.log(`flamegraph in ${file}`)
//   } catch (e) {
//     console.error(e)
//   }
// }
//
// capture()
// //

let childProc = null;

const app = express()

const scriptPath = path.join(__dirname, '../nocodb/nocodb-develop/packages/nocodb/dist/run/local.js')
const resultPath = path.join(__dirname, '../results')

app.use('/', express.static(path.join(__dirname, 'public')));

app.post('/start', (req, res) => {
  startApp()
  res.send('Done')
})
app.post('/stop', (req, res) => {
  stopApp()
  res.send('Done')
})
app.get('/flamegraphs', (req, res) => {
  const result = fs.readdirSync(resultPath, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name)

  res.send(result)
})


app.use('/', express.static(resultPath, {index: 'flamegraph.html'}));
app.use('/:name/download', (req, res) => {

  let folderPath = path.join(resultPath , req.params.name);

  if(!fs.existsSync(folderPath)) {
    res.status(404).send('Not found')
    return
  }

  const  to_zip = fs.readdirSync(folderPath);
  const zp = new admz();

  for (let k = 0; k < to_zip.length; k++) {
    zp.addLocalFile(folderPath + '/' + to_zip[k])
  }

  const file_after_download = `file_${req.params.name}.zip`;


  const data = zp.toBuffer();


  res.set('Content-Type', 'application/octet-stream');
  res.set('Content-Disposition', `attachment; filename=${file_after_download}`);
  res.set('Content-Length', data.length);
  res.send(data);

})

app.listen(4000, () => {
  console.log('Example app listening on port 4000!')
})
function startApp() {
  if(!childProc) {
    childProc = shell.exec(`0x -D '${resultPath}/{timestamp}.{pid}.0x' ${scriptPath}`, {async: true})
  }
}

function stopApp() {
  childProc.kill()
  // childProc.stdin.write("\x03")

  shell.exec('kill ' + childProc.pid)
  // process.kill(childProc.pid, 'SIGINT');

  // childProc.kill()
  // childProc.stdin.write(null, {ctrl: true, name: 'u'});

  // childProc.stdin.setEncoding('ascii');

  childProc = null

}
