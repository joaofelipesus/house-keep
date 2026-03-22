import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills--form"
export default class extends Controller {
  static targets = [
    'recurringInput',
    'dueDateSection',
    'recurrentDueDaySection'
  ]

  connect() {
    const isRecurring = this.recurringInputTarget.checked

    if (isRecurring) {
      this.dueDateSectionTarget.style.display = 'none'
      this.recurrentDueDaySectionTarget.style.display = 'flex'
    } else {
      this.dueDateSectionTarget.style.display = 'flex'
      this.recurrentDueDaySectionTarget.style.display = 'none'
    }
  }

  toggleRecurring (event) {
    const isRecurrentBill = event.target.checked

    if (isRecurrentBill) {
      this.dueDateSectionTarget.style.display = 'none'
      this.recurrentDueDaySectionTarget.style.display = 'flex'
    } else {
      this.dueDateSectionTarget.style.display = 'flex'
      this.recurrentDueDaySectionTarget.style.display = 'none'
    }
  }
}
