document.addEventListener('DOMContentLoaded', function() {
    // Find all toggle buttons
    const toggleButtons = document.querySelectorAll('.toggle-btn');
    
    // Add click event listener to each button
    toggleButtons.forEach(button => {
      button.addEventListener('click', function() {
        // Toggle the aria-expanded attribute
        const expanded = this.getAttribute('aria-expanded') === 'true';
        this.setAttribute('aria-expanded', !expanded);
      });
    });
  });