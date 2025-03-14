const fs = require('fs-extra');
const path = require('path');

// Clean and create dist directory
async function build() {
    console.log('Building site...');
    
    // Clean dist directory
    await fs.emptyDir('dist');
    
    // Copy all files from src to dist
    await fs.copy('src', 'dist');
    
    console.log('Build complete! Files are in the dist directory.');
}

build().catch(err => {
    console.error('Build failed:', err);
    process.exit(1);
});
