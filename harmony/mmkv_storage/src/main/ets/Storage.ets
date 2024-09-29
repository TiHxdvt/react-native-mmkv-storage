import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';

export class Storage {
  static  context = getContext(this) as common.UIAbilityContext;
  public static writeValues(filename: string, bytes: Uint8Array) {
    let file = fs.openSync(filename, fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, bytes);
    fs.closeSync(file);
  }

  public static readValues(filename: string): Uint8Array {
    try {
      let file = fs.openSync(filename);
      let buffer = new ArrayBuffer(1024);
      let arrayBuffer = fs.readSync(file.fd,buffer);
      fs.closeSync(file);
      return new Uint8Array(arrayBuffer);
    } catch (e) {
      throw new Error(`Failed to read file: ${e.message}`);
    }
  }

  public static exists(filename:string):boolean{
    let applicationContext = Storage.context.getApplicationContext();
    let path = applicationContext.filesDir+"/mmkv"+"/"+"default";
    let res = fs.accessSync(path);
    return res;
  }

  public static resetValues(filename:string):boolean{
  if(filename){
    fs.unlinkSync(filename);
    return true
  }else{
    return false
  }



  }
}