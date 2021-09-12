import Sortable from "sortablejs";

export default {
  mounted() {
    let dragged;
    const hook = this;

    const selector = "#" + this.el.id;

    document.querySelectorAll(".dropzone").forEach((dropzone) => {
      new Sortable(dropzone, {
        animation: 150,
        delay: 50,
        delayOnTouchOnly: true,
        group: "shared",
        draggable: ".draggable",
        ghostClass: "sortable-ghost",
        onEnd: function (evt) {
          hook.pushEventTo(selector, "dropped", {
            draggedId: evt.item.id,
            dropzoneId: evt.to.id,
            fromId: evt.from.id,
            draggableIndex: evt.newDraggableIndex,
            item: {
              text: evt.item.querySelector(".card-text").innerText,
            },
          });
        },
      });
    });
  },
};
