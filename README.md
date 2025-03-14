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

The project includes a GitHub Actions workflow for continuous integration and deployment:

1. When you push to the `main` branch, GitHub Actions will:
   - Install dependencies
   - Build the site
   - Deploy to GitHub Pages automatically

The contents of the `dist` directory can also be manually deployed to any static hosting service such as:

- GitHub Pages
- Netlify
- Vercel
- AWS S3
- Firebase Hosting

### GitHub Pages Setup

To use the automatic GitHub Pages deployment:

1. Ensure your repository has GitHub Pages enabled in Settings
2. The workflow will deploy to the `gh-pages` branch automatically
3. Set your GitHub Pages source to the `gh-pages` branch in repository settings

## License

MIT
