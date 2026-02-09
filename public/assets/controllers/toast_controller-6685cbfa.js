import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Observe app:notify events
    this._onNotify = this._onNotify.bind(this)
    window.addEventListener('app:notify', this._onNotify)

    // Also handle existing flash alerts inserted server-side
    this._autoDismissExisting()
  }

  disconnect() {
    window.removeEventListener('app:notify', this._onNotify)
  }

  _onNotify(e) {
    const message = e.detail && e.detail.message
    if (!message) return
    this._showToast(message)
  }

  _autoDismissExisting() {
    const container = document.getElementById('flash')
    if (!container) return
    container.querySelectorAll('.alert').forEach(alert => {
      // auto remove after 4s
      setTimeout(() => {
        alert.classList.add('fade')
        alert.addEventListener('transitionend', () => alert.remove(), { once: true })
      }, 4000)
    })
  }

  _showToast(message) {
    const container = document.getElementById('flash') || document.body
    const div = document.createElement('div')
    div.className = 'alert alert-info'
    div.style.transition = 'opacity 0.4s ease'
    div.textContent = message
    container.prepend(div)
    // fade out after 3s
    setTimeout(() => {
      div.style.opacity = '0'
      div.addEventListener('transitionend', () => div.remove(), { once: true })
    }, 3000)
  }
}
