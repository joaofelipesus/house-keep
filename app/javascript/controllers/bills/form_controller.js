import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills--form"
export default class extends Controller {
  static targets = [
    'recurringInput',
    'nonRecurringSection',
    'recurringSection',
    'logoPreview',
    'logoHint'
  ]

  connect() {
    this.#applyVisibility(this.recurringInputTarget.checked)
    this.logoPreviewTarget.hidden = !this.logoPreviewTarget.getAttribute('src')
  }

  toggleRecurring(event) {
    this.#applyVisibility(event.target.checked)
  }

  previewLogo(event) {
    const file = event.target.files[0]
    if (!file) return

    const url = URL.createObjectURL(file)
    this.logoPreviewTarget.src = url
    this.logoPreviewTarget.hidden = false
    this.logoHintTarget.textContent = file.name
    this.logoHintTarget.classList.add('file-upload-hint--filled')
  }

  #applyVisibility(isRecurring) {
    this.nonRecurringSectionTarget.style.display = isRecurring ? 'none' : 'flex'
    this.recurringSectionTarget.style.display = isRecurring ? 'flex' : 'none'
  }
}
