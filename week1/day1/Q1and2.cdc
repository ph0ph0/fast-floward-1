pub struct Canvas {
    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
        self.width = width
        self.height = height
        // The following pixels
        // 123
        // 456
        // 789
        // should be serialised as 
        // 12345679
        self.pixels = pixels
    }
}

pub fun serialzeStringArray(_ lines: [String]): String {
    var buffer = ""
    for line in lines {
        // log(line)
        buffer = buffer.concat(line)
    }
    return buffer
}

pub resource Picture {
    pub let canvas: Canvas 

    init (canvas: Canvas) {
        self.canvas = canvas
    }
}

pub fun convertBackToPixelArray(_ pixelString: String, width: Int, height: Int): [String] {
    var pixelArray: [String] = []
    let width = width
    let height = height

    let NumberOfPixels = pixelString.length
    var start = 0
    var end = width
    while end <= NumberOfPixels {
        let slice = pixelString.slice(from: start, upTo: end)
        pixelArray.append(slice)
        start = start + (width)
        end = end + width
    }

    return pixelArray
}

pub fun addFrameEnds(to pixelArray: [String], width: Int, height: Int): [String] {
    var frameEndArray: [String] = []


    let corner = "x"
    let side = "-"

    var i = 1
    while i <= width + 2 {
        if (i == 1 || i == width + 2) {
            frameEndArray.append(corner)
        } else {
            frameEndArray.append(side)
        }
        i = i + 1
    }
    
    let frameEnd = serialzeStringArray(frameEndArray)
    pixelArray.insert(at: 0, frameEnd)
    pixelArray.insert(at: height + 1, frameEnd)
    return pixelArray
}

pub fun addFrameSides(to pixelArray: [String], width: Int, height: Int): [String] {

    var i = 0
    let side = "|"
    while i < pixelArray.length {
        if (i == 0 || i == pixelArray.length - 1) {
            i = i + 1
            continue
        }
        pixelArray[i] = side.concat(pixelArray[i])
        pixelArray[i] = pixelArray[i].concat(side)

        i = i + 1
    }
    return pixelArray
}

pub fun frameCanvas(_ canvas: Canvas): Canvas {
    let pixels = canvas.pixels
    let width = Int(canvas.width)
    let height = Int(canvas.height)

    var pixelArray = convertBackToPixelArray(pixels, width: width, height: height)

    pixelArray= addFrameEnds(to: pixelArray, width: width, height: height)
    pixelArray = addFrameSides(to: pixelArray, width: width, height: height)
    let framedCanvas = Canvas(width: UInt8(width + 2), height: UInt8(height + 2), pixels: serialzeStringArray(pixelArray))
    return framedCanvas
}

pub fun display(canvas: Canvas) {
    let framedCanvas = frameCanvas(canvas)
    log(framedCanvas)
}

pub resource Printer {
    pub fun print(canvas: Canvas): @Picture? {
        let letterX <- create Picture(canvas: canvas)
        log(letterX.canvas)
        return <- letterX
    }
}

pub fun main() {
    let pixelsX = [
        "*   *",
        " * * ",
        "  *  ",
        " * * ",
        "*   *"
    ]
    let pixels = serialzeStringArray(pixelsX)
    let canvasX = Canvas(width: 5, height: 5, pixels: pixels)
    
    // W1Q1
    display(canvas: canvasX)

    // W1Q2
    let printX <- create Printer()
    let letterX <- printX.print(canvas: canvasX)
    destroy letterX
    destroy printX

}