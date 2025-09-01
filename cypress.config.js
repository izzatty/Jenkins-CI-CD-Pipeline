const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    specPattern: 'cypress/e2e/**/*.cy.{js,ts}',
    baseUrl: 'https://parabank.parasoft.com',
    supportFile: false,   // optional, if you don't have support file
    reporter: 'mochawesome',
    reporterOptions: {
      reportDir: 'cypress/reports',
      reportFilename: 'index',
      overwrite: true,
      html: true,
      json: false
    }
  }
})