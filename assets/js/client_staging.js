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
    submit_button.addEventListener("contract:click", (e) => {
      e.preventDefault();
      let from_id = e.detail.from_id;
      let client_id = e.detail.client_id;

      staging = section.querySelector(".staging");
      nodes = staging.querySelectorAll("[data-card-id]");
      card_ids = [...nodes].map((node) => node.dataset.cardId);
      console.log(card_ids);
      // this.handleEvent("sent_from_server", (data)=>{})
      this.pushEvent("submit-to-client", { from_id, client_id, card_ids });
    });
  },
};
