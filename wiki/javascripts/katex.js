// KaTeX auto-render init for Material for MkDocs (instant-navigation aware).
// arithmatex (generic mode) converts real $...$ / $$...$$ math into \(...\) / \[...\]
// spans server-side, so we only tell KaTeX to process backslash delimiters here.
// This deliberately does NOT enable the "$" delimiter — that keeps dollar amounts
// in prose/tables (e.g. "$0.10 – $0.50") from being misrendered as math.
document$.subscribe(({ body }) => {
  renderMathInElement(body, {
    delimiters: [
      { left: "\\[", right: "\\]", display: true },
      { left: "\\(", right: "\\)", display: false }
    ],
  })
})
