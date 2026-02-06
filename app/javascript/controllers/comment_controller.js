import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // start removing animation on connect
    requestAnimationFrame(() => {
      this.element.classList.add('removing')
    })

    // remove element from DOM after transition finishes
    const onTransitionEnd = (event) => {
      // ensure we handle only the comment's transition
      if (event.target === this.element) {
        this.element.remove()
      }
    }

    this.element.addEventListener('transitionend', onTransitionEnd, { once: true })
  }
}
