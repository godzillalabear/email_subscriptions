import { Controller } from "stimulus"
export default class extends Controller {
  toggleComplete(event){
  	event.preventDefault();

  	const taskId = event.target.parentElement.dataset.taskId;
  	let data;

  	console.log("taskId", taskId);
  }

}
