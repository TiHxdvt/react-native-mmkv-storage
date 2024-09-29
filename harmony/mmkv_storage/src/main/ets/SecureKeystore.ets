import { Storage } from './Storage'
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import huks from '@ohos.security.huks';
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI';
import { buffer } from '@kit.ArkTS';
import common from '@ohos.app.ability.common';
export class SecureKeystore {
  static  context = getContext(this) as common.UIAbilityContext;
  //根据参数生成对称密钥
  private getOrCreatSymKey(alias:string):cryptoFramework.SymKey{
    let applicationContext = Storage.context.getApplicationContext();
    let filesDir = applicationContext.filesDir;
    //通过类型别名得到二进制数据
    let cipherTextBytes = Storage.readValues(filesDir+"/"+"mmkv"+"/"+alias);
    // 创建SymKeyGenerator实例
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    let symKey = symKeyGenerator.convertKeySync({data:cipherTextBytes})
    return symKey;
  }
  //通过对称密钥加密
  private encryptAesPlainText(key:cryptoFramework.Key,input:cryptoFramework.DataBlob):cryptoFramework.DataBlob{
    let cipher = cryptoFramework.createCipher('AES128|ECB|PKCS5');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE,key,null);
    let cipherData = cipher.doFinalSync(input)
    return cipherData;
  }
  //通过对称密钥解密
  private  decryptAesPlainText(key:cryptoFramework.Key,input:cryptoFramework.DataBlob):cryptoFramework.DataBlob{
    let decoder  = cryptoFramework.createCipher('AES128|ECB|PKCS5');
    decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE,key,null);
    let decoderData = decoder.doFinalSync(input);
    return decoderData;
  }
  //设置安全密钥
  public setSecureKey(alias:string,input:string):boolean{
      let key = this.getOrCreatSymKey(alias);
      let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(input, 'utf-8').buffer) };
      let cipherData = this.encryptAesPlainText(key,plainText);
      let data = cipherData.data
      Storage.writeValues("SKS_DATA_FILE"+alias,data);
      return true

  }
  //获取安全密钥
  public getSecureKey(alias:string){
    let key = this.getOrCreatSymKey(alias);
    //通过类型别名得到加密后的二进制数据
    let cipherTextBytes = Storage.readValues("SKS_KEY_FILENAME"+alias);
    let BlobData:cryptoFramework.DataBlob ={data:cipherTextBytes};
    //解密加密后的二进制数据
    let decryptText =this.decryptAesPlainText(key,BlobData);
    return buffer.from(decryptText.data).toString('utf-8');
  }

  // 判断安全密钥是否存在
  public secureKeyExists(key:string):boolean{
    let res = Storage.exists("SKS_DATA_FILE"+key);
    return  res;
  }

  //删除安全密钥
  public removeSecureKey(key:string){
    let fileDeleted: Array<boolean> = [];
    try {
      const filenames = ["SKS_DATA_FILE"+key,"SKS_KEY_FILE"+key];
      for(const filename of filenames){
        fileDeleted.push(Storage.resetValues(filename));
      }
    }catch (e){

    }
  }
}