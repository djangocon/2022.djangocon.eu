/* Handle Markdown */
let dirtyInputs = []
const options = {
  baseUrl: null,
  breaks: true,
  gfm: true,
  headerIds: true,
  headerPrefix: "",
  highlight: null,
  langPrefix: "language-",
  mangle: true,
  pedantic: false,
  sanitize: false,
  sanitizer: null,
  silent: false,
  smartLists: true,
  smartypants: false,
  tables: true,
  xhtml: false,
}

function checkForChanges() {
  if (dirtyInputs.length) {
    dirtyInputs.forEach(element => {
      const inputElement = element.querySelector("textarea")
      const outputElement = element.querySelector(".preview")
      outputElement.innerHTML = marked(inputElement.value)
    })
    dirtyInputs = []
  }
  checkChangeTimeout = window.setTimeout(checkForChanges, 100)
}

const warnFileSize = (element) => {
  const warning = document.createElement("div")
  warning.classList = ["invalid-feedback"]
  warning.textContent = element.dataset.sizewarning
  element.parentElement.appendChild(warning)
  element.classList.add("is-invalid")
}
const unwarnFileSize = (element) => {
  element.classList.remove("is-invalid")
  const warning = element.parentElement.querySelector(".invalid-feedback")
  if (warning) element.parentElement.removeChild(warning)
}

/* Register handlers */
window.onload = () => {
  document.querySelectorAll(".markdown-wrapper").forEach(element => {
    const inputElement = element.querySelector("textarea")
    const outputElement = element.querySelector(".preview")
    outputElement.innerHTML = marked(inputElement.value)
    const handleInput = () => {
      dirtyInputs.push(element)
    }
    inputElement.addEventListener("change", handleInput, false)
    inputElement.addEventListener("keyup", handleInput, false)
    inputElement.addEventListener("keypress", handleInput, false)
    inputElement.addEventListener("keydown", handleInput, false)
  })
  checkForChanges()

  document.querySelectorAll("input[data-maxsize][type=file]").forEach(element => {
    const checkFileSize = () => {
      const files = element.files
      if (!files || !files.length) {
        unwarnFileSize(element)
      } else {
        maxsize = parseInt(element.dataset.maxsize)
        if (files[0].size > maxsize) { warnFileSize(element) } else { unwarnFileSize(element) }
      }
    }
    element.addEventListener("change", checkFileSize, false)
  })
}
