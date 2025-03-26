document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('search-input');
    const searchResults = document.getElementById('search-results');
    
    if (!searchInput || !searchResults) return;
    
    // Create an index of all posts (will be loaded via JSON)
    let posts = [];
    
    // Fetch posts data
    fetch('/search-data.json')
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
      })
      .then(data => {
        posts = data;
        console.log('Search data loaded successfully');
      })
      .catch(error => {
        console.error('Error loading search data:', error);
        // Try with baseurl
        const baseUrl = document.querySelector('meta[name="baseurl"]')?.getAttribute('content') || '';
        if (baseUrl) {
          fetch(baseUrl + '/search-data.json')
            .then(response => response.json())
            .then(data => {
              posts = data;
              console.log('Search data loaded with baseurl');
            })
            .catch(err => {
              console.error('Failed to load search data with baseurl:', err);
            });
        }
      });
    
    // Handle search input
    searchInput.addEventListener('input', function() {
      const query = this.value.toLowerCase().trim();
      
      if (query === '') {
        searchResults.innerHTML = '';
        return;
      }
      
      // Filter posts based on query
      const results = posts.filter(post => {
        return post.title.toLowerCase().includes(query);
      });
      
      // Display results
      if (results.length === 0) {
        searchResults.innerHTML = '<p>No results found</p>';
      } else {
        let html = '<ul>';
        results.forEach(post => {
          html += `
            <li>
              <a href="${post.url}">
                <h3>${post.title}</h3>
                <span class="date">${post.date}</span>
              </a>
            </li>
          `;
        });
        html += '</ul>';
        searchResults.innerHTML = html;
      }
    });
  });