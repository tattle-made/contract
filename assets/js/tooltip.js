import { LitElement, css, html, nothing } from "lit";
import { ref, createRef } from "lit/directives/ref.js";

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
