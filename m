From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 15:40:36 +0400
Message-ID: <20071011114034.GA12869@2ka.mipt.ru>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au> <20071011104313.GA31211@2ka.mipt.ru> <20071011105202.GA17487@gondor.apana.org.au> <20071011113002.GA20119@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51563 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXJKLkr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 07:40:47 -0400
Content-Disposition: inline
In-Reply-To: <20071011113002.GA20119@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 03:30:03PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> On Thu, Oct 11, 2007 at 06:52:02PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > On Thu, Oct 11, 2007 at 02:43:14PM +0400, Evgeniy Polyakov wrote:
> > > 
> > > Attached patch fixes that with following tcrypt output:
> > 
> > That was quick :)
> > 
> > Unfortunately it doesn't apply because des.c has been renamed
> > to des_generic.c in cryptodev-2.6.  Could you please fix that
> > up and also move the prototype into a header file, say
> > include/crypto/des.h?

HIFN driver update to use DES weak key checks (exported in this patch).

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- linux-2.6.mainline/crypto/des.c	2007-10-11 05:05:35.000000000 +0400
+++ linux-2.6.cryptodev-2.6/crypto/des_generic.c	2007-10-11 15:20:02.000000000 +0400
@@ -20,13 +20,7 @@
 #include <linux/crypto.h>
 #include <linux/types.h>
 
-#define DES_KEY_SIZE		8
-#define DES_EXPKEY_WORDS	32
-#define DES_BLOCK_SIZE		8
-
-#define DES3_EDE_KEY_SIZE	(3 * DES_KEY_SIZE)
-#define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
-#define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
+#include <crypto/des.h>
 
 #define ROL(x, r) ((x) = rol32((x), (r)))
 #define ROR(x, r) ((x) = ror32((x), (r)))
@@ -634,7 +628,7 @@
  *   Choice 1 has operated on the key.
  *
  */
-static unsigned long ekey(u32 *pe, const u8 *k)
+unsigned long des_ekey(u32 *pe, const u8 *k)
 {
 	/* K&R: long is at least 32 bits */
 	unsigned long a, b, c, d, w;
@@ -709,6 +703,7 @@
 	/* Zero if weak key */
 	return w;
 }
+EXPORT_SYMBOL_GPL(des_ekey);
 
 /*
  * Decryption key expansion
@@ -792,7 +787,7 @@
 	int ret;
 
 	/* Expand to tmp */
-	ret = ekey(tmp, key);
+	ret = des_ekey(tmp, key);
 
 	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
@@ -879,9 +874,9 @@
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
index b6c1ee1..c3479b0 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -29,6 +29,7 @@
 #include <linux/crypto.h>
 
 #include <crypto/algapi.h>
+#include <crypto/des.h>
 
 #include <asm/kmap_types.h>
 
@@ -1927,6 +1928,16 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		return -1;
 	}
 
+	if (len == HIFN_DES_KEY_LENGTH) {
+		u32 tmp[DES_EXPKEY_WORDS];
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
