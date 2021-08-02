import Artist from "./contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {
    var formattedPictures: [String] = []
    let collectionRef = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
    .borrow()
    if(collectionRef == nil) {
      log("Account".concat(getAccount(address).address.toString()).concat(" doesn't have a picture collection"))
    }else{
      for canvas in collectionRef!.getCanvases() {
            formattedPictures.append(canvas.pixels)
       }
    }
    return formattedPictures
}