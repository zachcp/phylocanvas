const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'phylocanvas-quickstart.js',
    library: 'Phylocanvas',
    libraryTarget: 'umd',
  },
  resolve: {
    root: path.resolve(__dirname, 'node_modules'),
  },
  module: {
    loaders: [
      { test: /\.js$/,
        include: path.join(__dirname, 'src'),
        loader: 'babel',
        query: {
          presets: [ 'es2015', 'stage-0' ],
        },
      },
    ],
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      },
    }),
  ],
};
