

describe("test suite", (suite) => {

  before((done) => {

    Module.onRuntimeInitialized = (lib) => {
      console.log(lib);
      done();
    };
     console.log('Here')
    setTimeout(x => done(), 2000)
    
  });

  it("converts large svg to png", async () => {
  });
});
