const moduleName = 'demo';
const buildDirectory = 'example';
const fs = require('fs');
const contents = fs.readFileSync(`${buildDirectory}/${moduleName}.wasm`, { encoding: 'base64' });
let js = fs.readFileSync(`${buildDirectory}/${moduleName}.js`, 'utf8')
const newBundle = js.replace('var wasmBlobStr=null;', 'var wasmBlobStr="' + contents + '";');
fs.writeFileSync(`${buildDirectory}/${moduleName}.all.js`, newBundle, 'utf8');