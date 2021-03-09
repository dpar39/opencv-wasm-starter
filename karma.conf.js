module.exports = function (config) {
  config.set({
    frameworks: ['mocha', 'chai'],
    files: [
      { pattern: 'tests/*.svg', watched: false, included: false, served: true },
      'svg-png-tiler.all.js',
      'tests/**/*.js',
    ],
    reporters: ['progress'],
    port: 9876,  // karma web server port
    colors: true,
    browserNoActivityTimeout: 5000,
    logLevel: config.LOG_INFO,
    browsers: ['Chrome'],
    autoWatch: false,
    // singleRun: false, // Karma captures browsers, runs the tests and exits
    concurrency: Infinity,
    client: {
      mocha: {
        timeout: 3000
      }
    },
    proxies: {
      "/svg/": "/base/tests/"
    },

 
  })
}