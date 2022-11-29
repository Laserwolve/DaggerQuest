const fs = require('fs');
const glob = require('glob')
const getDirName = require("path").dirname;
//const sheet = JSON.parse(fs.readFileSync(`./${Name}.tpsheet`));
//const textures = sheet.texture

let files = glob.sync("../../assets/**/*.tpsheet", {})

for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const sheet = JSON.parse(fs.readFileSync(file));
    const textures = sheet.textures

    for (let texture in textures) {
        const image = textures[texture].image
        const sprites = textures[texture].sprites;
        for (let sprite in sprites) {
            let tempPath = file.split("/")
            tempPath.pop()
            let path = tempPath.join("/") + `/sprites.${image.replace(".png", "")}/${sprites[sprite].filename}`
            let resourcePath = tempPath.join("/") + `/${image}`
            resourcePath = resourcePath.replace("../..", "res:/");
            let tres = `[gd_resource type="AtlasTexture" load_steps=2 format=2]\n\n`;
            tres += `[ext_resource path="${resourcePath}" type="Texture" id=1]\n\n[resource]\nflags = 7\natlas = ExtResource( 1 )\n`
            tres += `region = Rect2( ${sprites[sprite].region.x}, ${sprites[sprite].region.y}, ${sprites[sprite].region.w}, ${sprites[sprite].region.h} )\n`
            // tres += `margin = Rect2( ${sprites[sprite].margin.x}, ${sprites[sprite].margin.y}, ${sprites[sprite].margin.w}, ${sprites[sprite].margin.h} )\n`

            if (path.includes("items") || path.includes("loot")) tres += `margin = Rect2( ${sprites[sprite].margin.x}, ${sprites[sprite].margin.y}, ${512 - sprites[sprite].region.w}, ${512 - sprites[sprite].region.h} )\n`
            else tres += `margin = Rect2( ${sprites[sprite].margin.x}, ${sprites[sprite].margin.y}, ${1024 - sprites[sprite].region.w}, ${1024 - sprites[sprite].region.h} )\n`

            saveFile(path, tres)
        }
    }
}

function saveFile(path, data) {
    path = path.replace("Degrees/", "Degrees-")
    path = path.replace(".png", ".tres");
    fs.mkdir(getDirName(path), { recursive: true }, function () {
        fs.writeFile(path, data, () => {});
    });
}
