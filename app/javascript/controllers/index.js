// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import PdfMenuController from "controllers/pdf_menu_controller"
application.register("pdf-menu", PdfMenuController)
import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)
