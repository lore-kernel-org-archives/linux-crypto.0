From: shivaji roy <shivaji_22@yahoo.co.in>
Subject: error while enc/dec with CFB and CTR
Date: Sat, 3 Nov 2007 14:22:18 +0530 (IST)
Message-ID: <832785.9442.qm@web8902.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web8902.mail.in.yahoo.com ([203.84.221.30]:37482 "HELO
	web8902.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755463AbXKCI7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Nov 2007 04:59:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,  
I am getting error during enc/dec of data with CFB and CTR mode, while CBC,ECB works fine. The test code is given below what changes need to be done. please help.
int init_module (void)
{
    char Input[]={0xaa,0xbb,0xcc,0xdd,0xee,0xff,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0x00};
    tfm_crypto = crypto_alloc_tfm ("aes", CRYPTO_TFM_MODE_CFB);
    if (tfm_crypto == NULL)
    {
      printk (KERN_ALERT "<1> The cipher algo not supported\n");
      goto err;
    }
    printk (KERN_ALERT "Module Loaded successfully\n");
    hexprint(Input,sizeof(Input),"PlnTxt");
    my_en_de_crypt(0,Input,sizeof(Input));
    hexprint(Input,sizeof(Input),"CprTxt");
    my_en_de_crypt(1,Input, sizeof(Input));
    hexprint(Input,sizeof(Input),"PlnTxt");
err:
    return 0;
}

void my_en_de_crypt(int flag,char *Input, int buflen)
{
    int ret;
    struct scatterlist sg;
    char *tempptr;
    char Key[] = {0xaa,0xbb,0xcc,0xdd,0xee,0xff,0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x1a,0x2b};
    char IV[] = {0xa2,0xfb,0x3c,0x4d,0x5e,0x6f,0x71,0x8,0x9,0x4,0xd,0xf,0xe,0xb,0x13,0x2e};
    ret = crypto_cipher_setkey (tfm_crypto,Key,sizeof(Key));
    if (ret)
    {
      printk ("setkey() failed flags=%x\n", tfm_crypto->crt_flags);
      return;
    }
    sg_init_one (&sg, Input, buflen);
    crypto_cipher_set_iv (tfm_crypto, IV, crypto_tfm_alg_ivsize(tfm_crypto));
    if(!flag)
        ret = crypto_cipher_encrypt (tfm_crypto, &sg, &sg, buflen);
    else
        ret = crypto_cipher_decrypt (tfm_crypto, &sg, &sg, buflen);
    tempptr = kmap (sg.page) + sg.offset;
    memcpy(Input, tempptr, buflen);
    if (ret)
    {
      printk ("%s  failed \n", (flag == 0) ? "Encryption" : "Decryption");
    }
    return;
}


      Did you know? You can CHAT without downloading messenger. Go to http://in.messenger.yahoo.com/webmessengerpromo.php/ 
