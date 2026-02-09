import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "icon", "count"]
  static values = {
    createUrl: String,
    destroyUrl: String,
    postId: Number,
    liked: Boolean
  }

  connect() {
    // nothing heavy on connect
  }

  async toggle(event) {
    event.preventDefault()

    const wasLiked = this.likedValue === true || this.likedValue === 'true'
    // optimistic UI change
    this._setLiked(!wasLiked)

    try {
      const token = document.querySelector('meta[name=csrf-token]').content
      if (wasLiked) {
        if (!this.hasDestroyUrlValue) {
          console.error('LikeController: destroyUrl missing')
          throw new Error('Missing destroy URL')
        }
        // send DELETE to destroyUrl
        const res = await fetch(this.destroyUrlValue, {
          method: 'DELETE',
          headers: { 'X-CSRF-Token': token, 'Accept': 'text/vnd.turbo-stream.html' }
        })
        await this._applyServerResponse(res)
      } else {
        if (!this.hasCreateUrlValue) {
          console.error('LikeController: createUrl missing')
          throw new Error('Missing create URL')
        }
        // send POST to createUrl with form data
        const fd = new FormData()
        // if postIdValue is available, include it
        if (this.hasPostIdValue) fd.append('reaction[post_id]', this.postIdValue)
        const res = await fetch(this.createUrlValue, {
          method: 'POST',
          headers: { 'X-CSRF-Token': token, 'Accept': 'text/vnd.turbo-stream.html' },
          body: fd
        })
        await this._applyServerResponse(res)
      }
    } catch (err) {
      console.error('Like request failed', err)
      this._revertLiked()
      this._notify('Action failed. Please try again.')
    }
  }

  _setLiked(liked) {
    this.likedValue = liked
    if (this.iconTarget) {
      if (liked) {
        this.iconTarget.classList.remove('bi-heart')
        this.iconTarget.classList.add('bi-heart-fill', 'text-danger')
        this.iconTarget.classList.remove('text-dark', 'text-muted')
      } else {
        this.iconTarget.classList.remove('bi-heart-fill', 'text-danger')
        this.iconTarget.classList.add('bi-heart')
        this.iconTarget.classList.add('text-dark')
      }
    }
    // optimistic count change
    if (this.countTarget) {
      let n = parseInt(this.countTarget.textContent) || 0
      // keep suffix like ' likes' if present
      const hasSuffix = this.countTarget.textContent.includes(' likes')
      const suffix = hasSuffix ? ' likes' : ''
      this.countTarget.textContent = liked ? (n + 1) + suffix : Math.max(n - 1, 0) + suffix
    }
  }

  _revertLiked() {
    this._setLiked(!this.likedValue)
  }

  async _applyServerResponse(res) {
    if (!res.ok) throw new Error(`Server responded ${res.status}`)

    const text = await res.text()
    // try to apply turbo-stream replace result if present
    try {
      const parser = new DOMParser()
      const doc = parser.parseFromString(text, 'text/html')
      const turboStream = doc.querySelector('turbo-stream[action="replace"][target]')
      if (turboStream) {
        const template = turboStream.querySelector('template')
        const content = template ? template.innerHTML : ''
        // replace our element with server-rendered partial to keep consistency
        const wrapper = document.createElement('div')
        wrapper.innerHTML = content
        const newEl = wrapper.firstElementChild
        if (newEl) {
          this.element.replaceWith(newEl)
        }
      }
    } catch (err) {
      // parsing failure — fallback: do nothing (we used optimistic update)
      console.warn('Failed to parse turbo-stream response', err)
    }
  }

  _notify(message) {
    // dispatch an event for toast controller to pick up
    window.dispatchEvent(new CustomEvent('app:notify', { detail: { message } }))
  }
}
