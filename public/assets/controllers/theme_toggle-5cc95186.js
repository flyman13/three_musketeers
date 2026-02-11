// Theme toggle functionality
export class ThemeToggle {
  constructor() {
    this.STORAGE_KEY = 'theme-preference'
    this.DARK_THEME = 'dark'
    this.LIGHT_THEME = 'light'
    this.init()
  }

  init() {
    // Get saved theme or detect system preference
    const savedTheme = this.getSavedTheme()
    const prefersDark = this.prefersColorSchemeDark()
    const theme = savedTheme || (prefersDark ? this.DARK_THEME : this.LIGHT_THEME)

    this.setTheme(theme)
    this.attachEventListeners()
  }

  getSavedTheme() {
    return localStorage.getItem(this.STORAGE_KEY)
  }

  prefersColorSchemeDark() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches
  }

  setTheme(theme) {
    if (theme === this.DARK_THEME) {
      document.documentElement.setAttribute('data-theme', this.DARK_THEME)
    } else {
      document.documentElement.removeAttribute('data-theme')
    }
    localStorage.setItem(this.STORAGE_KEY, theme)
    this.updateToggleIcon(theme)
  }

  toggleTheme() {
    const currentTheme = this.getCurrentTheme()
    const newTheme = currentTheme === this.DARK_THEME ? this.LIGHT_THEME : this.DARK_THEME
    this.setTheme(newTheme)
  }

  getCurrentTheme() {
    return document.documentElement.getAttribute('data-theme') || this.LIGHT_THEME
  }

  updateToggleIcon(theme) {
    const btn = document.querySelector('.theme-toggle-btn')
    if (btn) {
      btn.innerHTML = theme === this.DARK_THEME ? '☀️' : '🌙'
      btn.setAttribute('title', theme === this.DARK_THEME ? 'Light mode' : 'Dark mode')
      btn.setAttribute('aria-label', theme === this.DARK_THEME ? 'Switch to light mode' : 'Switch to dark mode')
    }
  }

  attachEventListeners() {
    const btn = document.querySelector('.theme-toggle-btn')
    if (btn) {
      btn.addEventListener('click', () => this.toggleTheme())
    }
  }
}

// Initialize theme toggle when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  new ThemeToggle()
})
