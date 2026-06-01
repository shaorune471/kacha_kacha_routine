import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["exceptionFields"]

  connect() {
    this.toggleExceptionFields()
  }

  toggleExceptionFields() {
    const exceptionRadio = this.element.querySelector('input[value="exception"]')
    if (exceptionRadio && exceptionRadio.checked) {
      this.exceptionFieldsTarget.classList.remove("hidden")
    } else {
      this.exceptionFieldsTarget.classList.add("hidden")
    }
  }
}
