import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home--modal"
export default class extends Controller {
  static targets = ['overlay', 'frame']

  connect() {
    this.element.addEventListener('turbo:submit-end', this.#handleSubmitEnd)
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-end', this.#handleSubmitEnd)
  }

  open(event) {
    event.preventDefault()
    this.frameTarget.src = event.params.url
    this.overlayTarget.classList.add('is-open')
  }

  close() {
    this.overlayTarget.classList.remove('is-open')
    this.frameTarget.removeAttribute('src')
    this.frameTarget.innerHTML = ''
  }

  closeOnBackdrop(event) {
    if (event.target === this.overlayTarget) this.close()
  }

  // The update response is a turbo stream that re-renders the invoice list, so closing
  // the modal is all that is left to do here.
  #handleSubmitEnd = ({ detail: { success } }) => {
    if (success) this.close()
  }
}
