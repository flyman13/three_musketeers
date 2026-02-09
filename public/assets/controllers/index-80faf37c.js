import { Application } from "@hotwired/stimulus"
import CommentController from "./comment_controller"
import LikeController from "./like_controller"
import ToastController from "./toast_controller"

const application = Application.start()
application.register("comment", CommentController)
application.register("like", LikeController)
application.register("toast", ToastController)

export { application }
