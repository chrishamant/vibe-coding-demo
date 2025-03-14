# Spinning Triangle - Static Site Generator

A simple static site generator that displays an animated spinning triangle using HTML5 Canvas.

## Tech Stack

- **Node.js** - JavaScript runtime
- **Express** - Web server for local development
- **fs-extra** - Enhanced file system methods
- **Chokidar** - File watcher for auto-rebuilding
- **HTML5 Canvas** - For rendering the spinning triangle animation

## Project Structure

```
spinning-triangle/
├── build.js           # Production build script
├── dev-server.js      # Development server with hot reloading
├── package.json       # Project dependencies and scripts
├── src/               # Source files
│   ├── index.html     # Main HTML page
│   ├── script.js      # JavaScript for the spinning triangle
│   └── styles.css     # CSS styles
└── dist/              # Generated output (created by build)
```

## Features

- **Development Server** - Local server with automatic rebuilding on file changes
- **Production Build** - Optimized build for deployment
- **Canvas Animation** - Smooth spinning triangle with gradient fill

## Getting Started

### Installation

```bash
npm install
```

### Development

Start the development server:

```bash
npm run dev
```

This will:
- Build the site from the `src` directory to the `dist` directory
- Start a local server at http://localhost:3000
- Watch for file changes and automatically rebuild

### Production Build

Create a production build:

```bash
npm run build
```

This will generate optimized files in the `dist` directory ready for deployment.

## Deployment

The contents of the `dist` directory can be deployed to any static hosting service such as:

- GitHub Pages
- Netlify
- Vercel
- AWS S3
- Firebase Hosting

## License

MIT
