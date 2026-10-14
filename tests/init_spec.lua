local floating_note = require("floating-note")

describe("floating-note", function()
  it("returns a table when required", function()
    assert.is_table(floating_note)
  end)
  it("exports setup as a function", function()
    assert.is_function(floating_note.setup)
  end)
  -- Removed in Step 4
  it("exports toggle_note as a function", function()
    assert.is_function(floating_note.toggle_note)
  end)
end)
