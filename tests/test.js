

describe("svg-png-tiler test suite", (suite) => {

  before((done) => {

    Module.onRuntimeInitialized = (lib) => {
      console.log(lib);
      done();
    };
     console.log('Here')
    setTimeout(x => done(), 2000)
    
  });

  it("converts large svg to png", async () => {

    console.log("loading svg")
    const f = await fetch('svg/grid-1500x1500.svg');
    const svg = await f.text();
    console.log(Module)
    Module.svg2png(svg, {onProgress: (x)=>console.log(x) }, (png) => {
      console.log(png);
    })
  });
});