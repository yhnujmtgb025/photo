import { Application } from "@hotwired/stimulus"
import "custom/main"


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
