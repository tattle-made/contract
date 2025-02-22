import { Draggable, Droppable } from "@shopify/draggable";

export var ClientStaging = {
  mounted() {
    let section = this.el;
    let playerId = section.dataset.playerId;

    const droppable = new Droppable(section.querySelectorAll(".container"), {
      draggable: ".item",
      dropzone: ".dropzone",
    });

    submit_button = section.querySelector(`#submit_${playerId}`);
    submit_button.addEventListener("click", (e) => {
      e.preventDefault();
      staging = section.querySelector(".staging");
      nodes = staging.querySelectorAll("[data-card-id]");
      card_ids = [...nodes].map((node) => node.dataset.cardId);
      console.log(card_ids);
      // this.handleEvent("sent_from_server", (data)=>{})
      // this.pushEvent("send_event", {})
    });
  },
};
