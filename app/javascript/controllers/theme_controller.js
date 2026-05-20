import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const theme = this.element.dataset.currentTheme
    document.documentElement.setAttribute("data-theme", theme)
  }
}
