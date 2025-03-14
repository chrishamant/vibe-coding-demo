document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('triangleCanvas');
    const ctx = canvas.getContext('2d');
    
    // Set canvas dimensions
    const width = canvas.width;
    const height = canvas.height;
    
    // Triangle properties
    const triangleSize = 100;
    let rotation = 0;
    
    function drawTriangle() {
        // Clear canvas
        ctx.clearRect(0, 0, width, height);
        
        // Save the current state
        ctx.save();
        
        // Move to center of canvas
        ctx.translate(width / 2, height / 2);
        
        // Rotate
        ctx.rotate(rotation);
        
        // Draw triangle
        ctx.beginPath();
        ctx.moveTo(0, -triangleSize);
        ctx.lineTo(triangleSize * Math.cos(Math.PI * 2 / 3), triangleSize * Math.sin(Math.PI * 2 / 3));
        ctx.lineTo(triangleSize * Math.cos(Math.PI * 4 / 3), triangleSize * Math.sin(Math.PI * 4 / 3));
        ctx.closePath();
        
        // Fill with gradient
        const gradient = ctx.createLinearGradient(0, -triangleSize, 0, triangleSize);
        gradient.addColorStop(0, '#ff6b6b');
        gradient.addColorStop(0.5, '#4ecdc4');
        gradient.addColorStop(1, '#7159c1');
        ctx.fillStyle = gradient;
        ctx.fill();
        
        // Restore the state
        ctx.restore();
        
        // Update rotation
        rotation += 0.01;
        
        // Request next frame
        requestAnimationFrame(drawTriangle);
    }
    
    // Start animation
    drawTriangle();
});
