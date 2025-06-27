// encrypt-md.js
const CryptoJS = require("crypto-js");
const fs = require("fs");

const inputPath = "SQL_Server/administracion.md";
const outputPath = "SQL_Server/administracion.enc.txt";
const key = "He perdido y he ganado"; // cámbiala por algo seguro

const content = fs.readFileSync(inputPath, "utf8");
const encrypted = CryptoJS.AES.encrypt(content, key).toString();

fs.writeFileSync(outputPath, encrypted);
console.log("Archivo encriptado y guardado como:", outputPath);
