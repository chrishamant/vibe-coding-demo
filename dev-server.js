const express = require('express');
const fs = require('fs-extra');
const path = require('path');
const chokidar = require('chokidar');

const app = express();
const PORT = 3000;

// Ensure dist directory exists
fs.ensureDirSync('dist');

// Build function
async function build() {
    console.log('Building site...');
    await fs.copy('src', 'dist', { overwrite: true });
    console.log('Build complete!');
}

// Initial build
build();

// Set up file watcher
const watcher = chokidar.watch('src', {
    ignored: /(^|[\/\\])\../, // ignore dotfiles
    persistent: true
});

// Watch for file changes
watcher
    .on('change', path => {
        console.log(`File ${path} has been changed`);
        build();
    })
    .on('add', path => {
        console.log(`File ${path} has been added`);
        build();
    })
    .on('unlink', path => {
        console.log(`File ${path} has been removed`);
        build();
    });

// Serve files from dist directory
app.use(express.static('dist'));

// Start server
app.listen(PORT, () => {
    console.log(`Dev server running at http://localhost:${PORT}`);
    console.log('Press Ctrl+C to stop');
});
