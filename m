From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 14:43:14 +0400
Message-ID: <20071011104313.GA31211@2ka.mipt.ru>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44827 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXJKKnU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 06:43:20 -0400
Content-Disposition: inline
In-Reply-To: <20071011101400.GA17192@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 06:14:00PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Wed, Oct 10, 2007 at 07:21:47PM +0400, Evgeniy Polyakov wrote:
> >
> > It passed all tests for AES, DES and DES3_EDE except weak test for DES,
> > since hardware can not determine weak keys.
> 
> Patch applied. Thanks Evgeniy!

Thanks!

> BTW, we should change it so that the DES algorithm's setkey
> function uses the same weak-key test as used by the generic
> DES code.

Attached patch fixes that with following tcrypt output:
[71705.695117] test 5 (64 bit key):
[71705.698462] setkey() failed flags=100100
[71705.702499] 015744256a5ed31d
[71705.705703] pass

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/crypto/des.c b/crypto/des.c
index 1df3a71..37c0858 100644
--- a/crypto/des.c
+++ b/crypto/des.c
@@ -634,7 +634,7 @@ static const u32 S8[64] = {
  *   Choice 1 has operated on the key.
  *
  */
-static unsigned long ekey(u32 *pe, const u8 *k)
+unsigned long des_ekey(u32 *pe, const u8 *k)
 {
 	/* K&R: long is at least 32 bits */
 	unsigned long a, b, c, d, w;
@@ -709,6 +709,7 @@ static unsigned long ekey(u32 *pe, const u8 *k)
 	/* Zero if weak key */
 	return w;
 }
+EXPORT_SYMBOL_GPL(des_ekey);
 
 /*
  * Decryption key expansion
@@ -792,7 +793,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 	int ret;
 
 	/* Expand to tmp */
-	ret = ekey(tmp, key);
+	ret = des_ekey(tmp, key);
 
 	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
@@ -879,9 +880,9 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 		return -EINVAL;
 	}
 
-	ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
+	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	ekey(expkey, key);
+	des_ekey(expkey, key);
 
 	return 0;
 }
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e3d01da..52b5bb4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -90,9 +90,9 @@ config ZCRYPT_MONOLITHIC
 
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
+	select DES
 	select CRYPTO_ALGAPI
 	select CRYPTO_ABLKCIPHER
-	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
 
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 6c446f3..e152917 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1915,6 +1915,8 @@ static void hifn_flush(struct hifn_device *dev)
 	spin_unlock_irqrestore(&dev->lock, flags);
 }
 
+extern unsigned long des_ekey(u32 *pe, const u8 *k);
+
 static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		unsigned int len)
 {
@@ -1927,6 +1929,16 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		return -1;
 	}
 
+	if (len == HIFN_DES_KEY_LENGTH) {
+		u32 tmp[32];
+		int ret = des_ekey(tmp, key);
+		
+		if (unlikely(ret == 0) && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			return -EINVAL;
+		}
+	}
+
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
 	memcpy(ctx->key, key, len);

-- 
	Evgeniy Polyakov
