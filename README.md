# Personal Website - Jekyll Portfolio

A minimalist, clean, and responsive Jekyll site for showcasing software engineering projects and blog posts. Built using Jekyll Now for easy GitHub Pages deployment.

## Features

- Clean, minimalist design
- Responsive layout
- Four main sections: About, Working, Writing, and Learning
- Search functionality for blog posts
- Integration with LinkedIn and Medium for content syndication

## Pages

- **About**: Brief introduction and professional bio
- **Working**: Portfolio of current and past projects
- **Writing**: Blog posts from both the site and syndicated from LinkedIn/Medium
- **Learning**: Summaries and reflections on completed courses and learning experiences

## Setup Instructions

### Prerequisites

- Ruby (version 2.7.0 or higher recommended)
- RubyGems
- GCC and Make (for some gem installations)

### Installation

1. Fork the repository

2. Clone your fork locally:
   ```
   git clone https://github.com/yourusername/yourusername.github.io.git
   cd yourusername.github.io
   ```

3. Install dependencies:
   ```
   bundle install
   ```

4. Customize configuration:
   - Edit `_config.yml` with your personal information
   - Replace `assets/images/avatar.jpg` with your profile picture
   - Modify the `about.md` file with your bio

5. Run locally:
   ```
   bundle exec jekyll serve
   ```
   This will start a local server at `http://localhost:4000`

6. Deploy to GitHub Pages:
   - Commit and push your changes to your GitHub repository
   - Ensure your repository is named `yourusername.github.io`
   - GitHub will automatically build and deploy your site

### Content Management

#### Adding New Posts

Create new posts by adding Markdown files to the `_posts` directory following the naming convention:
```
YYYY-MM-DD-title-slug.md
```

Each post should include front matter at the top:
```yaml
---
layout: post
title: Your Post Title
date: YYYY-MM-DD HH:MM:SS -0500
category: project|writing|learning
tags: [tag1, tag2]
---
```

#### LinkedIn and Medium Integration

To use the LinkedIn and Medium integration:

1. Set up environment variables:
   ```
   export LINKEDIN_ACCESS_TOKEN="your-linkedin-access-token"
   export LINKEDIN_USER_ID="your-linkedin-user-id"
   export MEDIUM_USERNAME="your-medium-username"
   ```

2. Run the update script:
   ```
   ./update-content.sh
   ```

Note: For LinkedIn integration, you'll need to create an app in the LinkedIn Developer Portal and obtain proper authentication tokens.

## Customization

### Styling

- Edit files in the `_sass` directory to customize the styling
- The main stylesheet is `_sass/main.scss`

### Adding Pages

To add a new page:

1. Create a new Markdown file in the root directory
2. Include front matter with layout and title
3. Update the navigation in `_includes/header.html`

### Modifying Layouts

Layout templates are stored in the `_layouts` directory:
- `default.html`: Base layout with header and footer
- `page.html`: Template for static pages
- `post.html`: Template for blog posts

## License

This project is available as open source under the terms of the [MIT License](LICENSE).

## Acknowledgements

- Built with [Jekyll](https://jekyllrb.com/)
- Based on [Jekyll Now](https://github.com/barryclark/jekyll-now)
- Design inspired by [Zach Holman's website](https://zachholman.com/)