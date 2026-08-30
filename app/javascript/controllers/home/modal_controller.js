import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home--modal"
export default class extends Controller {
  static targets = ['overlay', 'frame', 'title']

  connect() {
    this.element.addEventListener('turbo:submit-end', this.#handleSubmitEnd)
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-end', this.#handleSubmitEnd)
  }

  // The modal is shared by every form the home page can open, so the opener tells it both
  // which URL to load into the frame and which title to show.
  open(event) {
    event.preventDefault()
    this.titleTarget.textContent = event.params.title
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

  // A successful submit answers with a turbo stream that refreshes the page around the modal,
  // so closing it is all that is left to do here. A failed one re-renders the form inside the
  // frame and the modal has to stay open.
  #handleSubmitEnd = ({ detail: { success } }) => {
    if (success) this.close()
  }
}
