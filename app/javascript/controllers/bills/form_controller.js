import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills--form"
export default class extends Controller {
  static targets = [
    'recurringInput',
    'nonRecurringSection',
    'recurringSection'
  ]

  connect() {
    this.#applyVisibility(this.recurringInputTarget.checked)
  }

  toggleRecurring(event) {
    this.#applyVisibility(event.target.checked)
  }

  #applyVisibility(isRecurring) {
    this.nonRecurringSectionTarget.style.display = isRecurring ? 'none' : 'flex'
    this.recurringSectionTarget.style.display = isRecurring ? 'flex' : 'none'
  }
}
