From: Stephan Mueller <smueller@chronox.de>
Subject: Re: skcipher
Date: Tue, 03 May 2016 07:16:07 +0200
Message-ID: <2327041.8y5TJYKVFL@tauon.atsec.com>
References: <CAKJ7aR5-GbkuFPQkw7DdKJLCKV48LzRY-WUeTeayZkK_h7cTUQ@mail.gmail.com> <2792780.OUI9jL64lE@tauon.atsec.com> <CAKJ7aR5atgaJye3C66_KUtXnWJGXSSUELKxxQ=c9HNWx8dyg2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54534 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbcECFQL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 01:16:11 -0400
In-Reply-To: <CAKJ7aR5atgaJye3C66_KUtXnWJGXSSUELKxxQ=c9HNWx8dyg2g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 3. Mai 2016, 10:34:01 schrieb Gadre Nayan:

Hi Gadre,

> Hello,
> 
> I tried few combinations of algorithms:
> 
> 1. skcipher = crypto_alloc_skcipher("aes", 0, 0);
> 
> could not allocate skcipher handle: -2
> lsmod:
> aes_i586               20480  0

Please read the documentation and compare it with /proc/crypto: skcipher does 
not work with the raw AES, but only with a block chaining mode as below.

> 
> 2. skcipher = crypto_alloc_skcipher("cbc(aes)", 0, 0);
> 
> So here all allocations work but,
> in test_skcipher_encdec this log:
> skcipher encrypt returned with -22 result -224149504

Error code is -EINVAL, so you provided wrong data.
> 
> and lsmod:
> xcbc                   16384  0

Please forget lsmod, /proc/crypto provides you with the information (excluding 
the permutations with the available block chaining modes).
> 
> So the second algo option at-least makes allocations but in the
> encrypt function throws error:
> crypto_skcipher_encrypt(sk->req);
> 
> Please suggest what may be going wrong.
> 
> I am posting my code as well in case I may have made some mistakes in
> length of key, iv, input data, output data. etc.
> 
> I have not modified the APIs from the sample, only the driver function
> test_skcipher.
> 
>         struct skcipher_def sk;
>         struct crypto_skcipher *skcipher = NULL;
>         struct skcipher_request *req = NULL;
>         char *scratchpad = NULL;
>         char *ivdata = NULL;
>         unsigned char key[32];
>         int ret = -EFAULT;
> 
>         skcipher = crypto_alloc_skcipher("cbc(aes)", 0, 0);

try CRYPTO_ALG_ASYNC as the last argument, otherwise you have a sync cipher 
that whould not work with the async API.

>         if(IS_ERR(skcipher)) {
>                 ret = PTR_ERR(skcipher);
>                 pr_err("could not allocate skcipher handle: %d\n", ret);
>                 goto CIPHERFAIL;
>         }
>         ret = 0;
>         req = skcipher_request_alloc(skcipher, GFP_KERNEL);
>         if(IS_ERR(req)) {
>                 ret = PTR_ERR(req);
>                 pr_err("could not allocate request queue: %d\n", ret);
>                 goto CIPHERFAIL;
>         }
> 
>         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> test_skcipher_cb, &sk.result);
> 
>         //AES 256 with random bytes
>         get_random_bytes(&key, 32);
>         if(crypto_skcipher_setkey(skcipher, key, 32)){
>                 pr_err("Key could not be set\n");
>                 goto CIPHERFAIL;
>         }
> 
>         //Initialization vector
>         ivdata = kmalloc(16, GFP_KERNEL);
>         if (!ivdata) {
>                 pr_err("Could not allocate ivadata\n");
>                 goto CIPHERFAIL;
>         }
>         get_random_bytes(ivdata, 16);
> 
>         // FIll the data you want to encrypt
>         strcpy(dataptr, "12345678901234567890");
>         sk.tfm = skcipher;
>         sk.req = req;
> 
>         //We encrypt one block of data
>         sg_init_one(&sk.sg, dataptr, 20);
>         skcipher_request_set_crypt(req, &sk.sg, &sk.sg, 20, ivdata);
>         init_completion(&sk.result.completion);
> 
>         //Encrypt data
>         ret = test_skcipher_encdec(&sk, 1);
>         if(ret){
>                 pr_err("Encryption failed...somehow :(: %d\n", ret);
>                 goto CIPHERFAIL;
>         }
>         else{
>                 pr_err("Encryption done op: %s\n", dataptr);
>                 return;
>         }
> 
> CIPHERFAIL:
>         if(!IS_ERR(skcipher)){
>                 pr_err("NO_ERR: Normal skcipher cleaning\n");
>                 crypto_free_skcipher(skcipher);
>         }
>         if(!IS_ERR(req)){
>                 pr_err("NO_ERR: REQ: Reached here because something
> else failed\n");
>                 skcipher_request_free(req);
>         }
>         if(!IS_ERR(ivdata)){
>                 pr_err("NO_ERR: IV: Reched here because something else
> failed\n");
>                 kfree(ivdata);
>         }
>         if(!IS_ERR(scratchpad)){
>                 pr_err("NO_ERR: scratch: reached here because
> something else failed\n");
>                 kfree(scratchpad);
>         }
> 
> Thanks
> 
> On Mon, May 2, 2016 at 9:03 PM, Stephan Mueller <smueller@chronox.de> wrote:
> > Am Montag, 2. Mai 2016, 21:00:25 schrieb Gadre Nayan:
> > 
> > Hi Gadre,
> > 
> >> Hi Stephan,
> >> 
> >> I checked modinfo aesni_intel:
> >> filename:       /lib/modules/4.5.0/kernel/arch/x86/crypto/aesni-intel.ko
> >> alias:          crypto-aes
> >> alias:          aes
> >> license:        GPL
> >> description:    Rijndael (AES) Cipher Algorithm, Intel AES-NI
> >> instructions optimized
> >> alias:          crypto-fpu
> >> alias:          fpu
> >> srcversion:     55C6346DCF663DDD74D3F13
> >> alias:          cpu:type:x86,ven*fam*mod*:feature:*0099*
> >> depends:        xts,aes-i586,lrw,ablk_helper
> >> intree:         Y
> >> vermagic:       4.5.0 SMP mod_unload modversions 686
> >> 
> >> when I do modprobe crypto-aes,
> >> modprobe: ERROR: could not insert 'aesni_intel': No such device
> >> modprobe: ERROR: could not insert 'padlock_aes': No such device
> > 
> > Well, maybe your CPU does not have AES-NI?
> > 
> > Besides, why fiddle around with special implementations? Simply use the
> > standard names of, say, "aes" and let the kernel crypto API do its magic
> > to
> > find the fastest implementation for your system?
> > 
> >> I have these modules: xts,aes-i586,lrw,ablk_helper loaded as well (
> >> the dependencies).
> > 
> > Well, a 32 bit system does not have AES-NI support.
> > 
> >> I think I am still missing something. Any hardware feature. Or some
> >> other module is using some IRQ or region which is not shared.
> >> 
> >> Thanks.
> >> Nayan Gadre.
> >> 
> >> On Mon, May 2, 2016 at 11:21 AM, Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> >> > Am Montag, 2. Mai 2016, 11:14:01 schrieb Gadre Nayan:
> >> > 
> >> > Hi Gadre,
> >> > 
> >> >> Hello,
> >> >> 
> >> >> I have read the crypto library documentation on chronox.de.
> >> >> 
> >> >> I used there sample code for symmetric key cipher operation.
> >> >> However in the check:
> >> >> 
> >> >> skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
> >> >> if (IS_ERR(skcipher)) {
> >> >> pr_info("could not allocate skcipher handle\n");
> >> >> return PTR_ERR(skcipher);
> >> >> }
> >> >> 
> >> >> I get could not allocate skcipher handle.
> >> >> 
> >> >> I have loaded all possible related modules for crypto:
> >> >> lsmod (relevant):
> >> >> algif_skcipher         32768  0
> >> >> algif_hash             20480  0
> >> >> algif_aead             20480  0
> >> >> af_alg                 24576  3 algif_aead,algif_hash,algif_skcipher
> >> >> cryptd
> >> >> ablk_helper.
> >> >> 
> >> >> What am I missing here?
> >> >> 
> >> >> Also IS_ERR checks if the skcipher value may be <1000, it may include
> >> >> the NULL check right?.
> >> > 
> >> > The allocation of the cipher failed. Please check /proc/crypto whether
> >> > you
> >> > have the cipher registered with the kernel crypto API.
> >> > 
> >> > The module listing does not show the AESNI cipher module.
> >> > 
> >> > Ciao
> >> > Stephan
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Ciao
> > Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
