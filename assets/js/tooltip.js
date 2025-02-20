export var TooltipHook = {
  mounted() {
    section = this.el;
    summary = section.querySelector(".summary");
    description = section.querySelector("description");

    section.addEventListener("mouseenter", (e) => {
      console.log("over");
      description.style.visibility = "hidden";
      summary.style.visibility = "invisible";
    });
    section.addEventListener("mouseleave", (e) => {
      console.log("out");
    });
  },
};
