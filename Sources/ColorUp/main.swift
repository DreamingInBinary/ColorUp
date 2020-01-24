import ColorUpCore

let tool = ColorUp()
do {
    try tool.execute()
} catch {
    print("ColorUp hit an error during generation: \(error)")
}
