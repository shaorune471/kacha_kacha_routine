import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Autocomplete } from "stimulus-autocomplete"

application.register("autocomplete", Autocomplete)
eagerLoadControllersFrom("controllers", application)
