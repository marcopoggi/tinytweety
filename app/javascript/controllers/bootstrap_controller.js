import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeTooltip()
    this.initializeAlert()
  }

  initializeTooltip() {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
  }

  initializeAlert(){
    const alertList = document.querySelectorAll('.alert')
    const alerts = [...alertList].map(element => new bootstrap.Alert(element))
  }
}
