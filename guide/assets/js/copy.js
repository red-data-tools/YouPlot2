for (const pre of document.querySelectorAll(".post-content pre:not(.terminal-output)")) {
  const block = document.createElement("div");
  block.className = "command-block";
  const button = document.createElement("button");
  button.type = "button";
  button.className = "command-copy";
  button.textContent = "Copy";
  button.setAttribute("aria-label", "Copy command");
  button.setAttribute("aria-live", "polite");
  pre.before(block);
  block.append(button, pre);

  button.addEventListener("click", async () => {
    button.disabled = true;
    try {
      // Keep newlines and indentation, including Python here-documents.
      await navigator.clipboard.writeText(pre.textContent);
      button.textContent = "Copied";
    } catch {
      const range = document.createRange();
      range.selectNodeContents(pre);
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
      button.textContent = "Select and copy";
    }
    setTimeout(() => {
      button.textContent = "Copy";
      button.disabled = false;
    }, 2000);
  });
}
