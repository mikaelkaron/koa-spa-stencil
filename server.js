const Koa = require('koa');
const static = require('koa-static');
const spa = require('koa-spa-es6template');
const { join } = require('path');
const { PORT = 3333 } = process.env;

// create server
const app = new Koa();
// serve static files with index override
app.use(
  static(join(__dirname, 'www'), {
    index: 'index.static.html'
  })
);
// 404 fallback to templated index page
app.use(spa(join(__dirname, 'www', 'index.html'), process.env));
// start server
app.listen({ port: PORT }, () =>
  console.info(`Server ready at http://localhost:${PORT}`)
);

module.exports = app;