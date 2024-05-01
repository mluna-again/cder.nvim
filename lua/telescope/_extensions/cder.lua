return require("telescope").register_extension({
  exports = {
    cder = require("cder").cd
  }
})
