From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: al_alg: alg_setkey does not check key's size is zero or
 not, causing a Null-ptr-dereference
Date: Wed, 10 May 2017 03:48:23 +0800
Message-ID: <20170509194823.GA5217@gondor.apana.org.au>
References: <CAP=GMUGPZaWD6b_E=77keMpVO7f6EfW3rBVWV2KLnNjUiyLf5Q@mail.gmail.com>
 <20170505125928.b6dha2bnbg6y5z6n@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Baozeng <sploving1@gmail.com>, security@kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40944 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752667AbdEITsl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 May 2017 15:48:41 -0400
Content-Disposition: inline
In-Reply-To: <20170505125928.b6dha2bnbg6y5z6n@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 05, 2017 at 03:59:28PM +0300, Dan Carpenter wrote:
> Thanks for the Report.  I've fowarded it to Herbert Xu.

Thanks.  This is a bug in the new skcipher interface.

---8<---
Subject: crypto: skcipher - Add missing API setkey checks

The API setkey checks for key sizes and alignment went AWOL during the
skcipher conversion.  This patch restores them.

Cc: <stable@vger.kernel.org>
Fixes: 4e6c3df4d729 ("crypto: skcipher - Add low-level skcipher...")
Reported-by: Baozeng <sploving1@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 014af74..4faa0fd 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -764,6 +764,44 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int skcipher_setkey_unaligned(struct crypto_skcipher *tfm,
+				     const u8 *key, unsigned int keylen)
+{
+	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
+	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+	int ret;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = cipher->setkey(tfm, alignbuffer, keylen);
+	kzfree(buffer);
+	return ret;
+}
+
+static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			   unsigned int keylen)
+{
+	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
+	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
+
+	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if ((unsigned long)key & alignmask)
+		return skcipher_setkey_unaligned(tfm, key, keylen);
+
+	return cipher->setkey(tfm, key, keylen);
+}
+
 static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
@@ -784,7 +822,7 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	    tfm->__crt_alg->cra_type == &crypto_givcipher_type)
 		return crypto_init_skcipher_ops_ablkcipher(tfm);
 
-	skcipher->setkey = alg->setkey;
+	skcipher->setkey = skcipher_setkey;
 	skcipher->encrypt = alg->encrypt;
 	skcipher->decrypt = alg->decrypt;
 	skcipher->ivsize = alg->ivsize;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
