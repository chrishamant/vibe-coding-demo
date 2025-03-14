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
    try {
        // Make sure dist directory exists
        await fs.ensureDir('dist');
        // Copy files with overwrite option
        await fs.copy('src', 'dist', { overwrite: true });
        console.log('Build complete!');
    } catch (err) {
        console.error('Build error:', err.message);
    }
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
    .on('change', filePath => {
        console.log(`File ${filePath} has been changed`);
        build();
    })
    .on('add', filePath => {
        console.log(`File ${filePath} has been added`);
        build();
    })
    .on('unlink', filePath => {
        console.log(`File ${filePath} has been removed`);
        const destPath = filePath.replace(/^src/, 'dist');
        // Only try to remove if it exists
        fs.pathExists(destPath)
            .then(exists => {
                if (exists) {
                    return fs.remove(destPath);
                }
            })
            .then(() => build())
            .catch(err => console.error('Error handling file removal:', err.message));
    });

// Serve files from dist directory
app.use(express.static('dist'));

// Start server
app.listen(PORT, () => {
    console.log(`Dev server running at http://localhost:${PORT}`);
    console.log('Press Ctrl+C to stop');
});
