import "Artist" from "../artist/artist.contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {

    let printerRef: &Artist.Printer
    let collectionRef: &Artist.Collection
    let picture: @Artist.Picture?

    prepare(account : AuthAccount){
        self.printerRef = getAccount(0x01cf0e2f2f715450)
        .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
        .borrow()
        ?? panic("Couldn't borrow printer reference.")

        self.collectionRef = getAccount(0x01cf0e2f2f715450)
        .getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
        .borrow()
        ??panic("Couldn't borrow collection reference")

        let canvas = Artist.Canvas(
            width: width,
            height: height,
            pixels: pixels
        )

        self.picture <- self.printerRef.print(canvas:canvas)
    }

    execute {
  
        if(self.picture==nil){
            log("Picture already exists.")
            destroy self.picture
        } else {
            log("Picture printed!")
            self.collectionRef.deposit(picture: <-self.picture!)
        }
        
    }
}