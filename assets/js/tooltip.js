import { LitElement, css, html, nothing } from "lit";
import { ref, createRef } from "lit/directives/ref.js";

export class Tooltip extends LitElement {
  static properties = {
    peers: {},
  };

  constructor() {
    super();
    this.open = false;
    this.peers = [
      { id: "abc", name: "adhiraj" },
      { id: "def", name: "denny" },
    ];
  }

  render() {
    let dropdown;
    if (this.open) {
      dropdown = html`hi`
    }else{
      dropdown = nothing
    }

    return html`
      <h1 class="text-sm">trade with</h1>
      ${this.open ? (
        
      ) : (
        nothing
      )}
    `;
  }
}

{
  /* <div>
        <h1 class="text-sm">trade with</h1>
        <div>
          ${this.peers.map((peer) => {
            html`<p>${peer.name}</p>`;
          })}
        </div>
      </div> */
}

export var TooltipHook = {
  mounted() {
    section = this.el;
    // console.log(section);
    // summary = section.querySelector(".summary");
    // description = section.querySelector(".description");

    // section.addEventListener("mouseenter", (e) => {
    //   console.log("over");
    //   description.style.visibility = "visible";
    //   // summary.style.visibility = "invisible";
    // });
    // section.addEventListener("mouseleave", (e) => {
    //   console.log("out");
    //   description.style.visibility = "hidden";
    // });
  },
};
