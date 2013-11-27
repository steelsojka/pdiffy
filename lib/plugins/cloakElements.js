/**
 * Cloaks elements on the page that match the selector.
 *
 * @param {Array} selectors Array of element selectors to cloak
 * @example
 * cloakElements: {
 *   selectors: ["#myID", ".someClass"]
 * }
 */
pdiffy.cloakElements.selectors.forEach(function(selector) {
  var elements = document.querySelectorAll(selector);

  for (var i = 0, len = elements.length; i < len; i++) {
    elements[i].style.display = "none";
  }
});
