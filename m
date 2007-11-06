From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Patch to support stream ciphers
Date: Tue, 6 Nov 2007 15:19:09 +0300
Message-ID: <20071106121909.GA30349@2ka.mipt.ru>
References: <fd3e431c0710251055n1e810c90u285bb0be7d95dd07@mail.gmail.com> <20071026102102.GB4970@2ka.mipt.ru> <fd3e431c0711031035k11cd9dfbt26d9fb9b2c52eb20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42735 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbXKFMTX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 07:19:23 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711031035k11cd9dfbt26d9fb9b2c52eb20@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Sun, Nov 04, 2007 at 01:35:14AM +0800, Tan Swee Heng (thesweeheng@gmail.com) wrote:
> CHANGES
> 1. stream.c's blocksize is now 1 since (i) it makes more sense and
> (ii) the latest 2.6.24-rc1 git allows it.
> 2. SOSEMANUK, another eSTREAM candidate, has been ported.
> 3. Got rid of "coding style issues".. although I am not sure if I've
> eradicated all of them :-)

I have some minor comments inlined below.
Btw, it is much better if you inline patch and put them into several
mails if needed.

> TESTING
> 1. I've used "insmod tcrypt.ko mode=X" (X=34 for Salsa20 and X=35 for
> SOSEMANUK). The test vectors agree.
> 2. I've used "cryptsetup luksFormat -c salsa20-stream-plain
> /dev/loop0". That worked fine and I was able to create an encrypted
> ext2 filesystem using Salsa20 as the cipher.
> 3. However "cryptsetup luksFormat -c sosemanuk-stream-plain
> /dev/loop0" didn't work that well as I was unable to unlock using
> "cryptsetup luksOpen" later. (I am not sure where the problems lie.
> Any suggestion is welcomed.)

Add debug prints all over the place and find where the problem lies...

> BUG
> My patches currently set cia_encrypt and cia_decrypt to NULL. That
> isn't quite safe. Someone using luksFormat with "-c salsa20-cbc-plain"
> may cause the kernel to behave in an unbecoming manner as cbc will try
> to use salsa20's cia_encrypt. (Any suggestion is welcomed on how this
> can be avoided.)

> PATCHES
> Attached to this mail are the patches. I've split them into 3 this
> time so as to make clear what are the changes for stream, salsa20 and
> sosemanuk respectively. They need to be applied in succession to the
> latest 2.6.24-rc1 cryptodev git.
> 
> Swee Heng

+static int crypto_stream_crypt_walk(struct blkcipher_walk *walk,
+				    struct crypto_cipher *tfm)
+{
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *, u32) =
+		crypto_cipher_alg(tfm)->cia_setiv_crypt;
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	u8 *iv = walk->iv;
+
+	if(dst != src)

Need a space.

+		memcpy(dst, src, nbytes);
+	fn(crypto_cipher_tfm(tfm), dst, iv, nbytes);
+	return 0;
+}

+	if (!(alg->cra_blocksize % 4))
+		inst->alg.cra_alignmask |= 3;

You have not changed align mask as wanted originally - is it intentional?

+	inst->alg.cra_blkcipher.ivsize = 1;
+	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
+	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+
+	inst->alg.cra_ctxsize = sizeof(struct crypto_stream_ctx);
+
+	inst->alg.cra_init = crypto_stream_init_tfm;
+	inst->alg.cra_exit = crypto_stream_exit_tfm;
+
+	inst->alg.cra_blkcipher.setkey = crypto_stream_setkey;
+	inst->alg.cra_blkcipher.encrypt = crypto_stream_crypt;
+	inst->alg.cra_blkcipher.decrypt = crypto_stream_crypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}


--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -214,6 +214,10 @@ struct cipher_alg {
 	                  unsigned int keylen);
 	void (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+
+	unsigned int cia_ivsize;
+	void (*cia_setiv_crypt)(struct crypto_tfm *tfm, u8 *dst,
+				const u8 *iv, u32 nbytes);
 };

I'm not sure it is a good way - you can save this iv and its size in the
context and get it from cipher's encrypt/decrypt callback.
Or modify every encrypt and decrypt callback to have iv as parameter,
which I believe not a good solution.

In any case, you have to disallow unsupported usage (like cbc) in your
cipher callbacks.

+static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
+{
+        for (; bs; bs--)
+                *a++ ^= *b++;
+}
+
+static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
+{
+        u32 *a = (u32 *)dst;
+        u32 *b = (u32 *)src;
+
+        for (; bs >= 4; bs -= 4)
+                *a++ ^= *b++;
+        
+        xor_byte((u8 *)a, (u8 *)b, bs);
+}

This ones exist in cbc at least - move them into common header.
The same applies to sosemanuk algo.


-- 
	Evgeniy Polyakov
