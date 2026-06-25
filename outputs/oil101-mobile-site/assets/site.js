const search = document.querySelector("[data-search]");
const cards = [...document.querySelectorAll("[data-unit-card]")];
if (search) {
  search.addEventListener("input", () => {
    const q = search.value.trim().toLowerCase();
    for (const card of cards) {
      card.style.display = card.textContent.toLowerCase().includes(q) ? "" : "none";
    }
  });
}
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => navigator.serviceWorker.register("./sw.js").catch(() => {}));
}