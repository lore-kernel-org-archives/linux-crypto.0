From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/2] crypto: drbg: use single block cipher API
Date: Sun, 01 Mar 2015 20:39:17 +0100
Message-ID: <1739217.ss3etoD4pq@tachyon.chronox.de>
References: <50904620.OAA2OAojed@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36246 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbbCATkd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 14:40:33 -0500
In-Reply-To: <50904620.OAA2OAojed@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CTR DRBG only encrypts one single block at a time. Thus, use the
single block crypto API to avoid additional overhead from the block
chaining modes.

With the patch, the speed of the DRBG increases between 30% and 40%.

The DRBG still passes the CTR DRBG CAVS test.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d8ff16e..c14274a 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -119,19 +119,19 @@ static const struct drbg_core drbg_cores[] = {
 		.statelen = 32, /* 256 bits as defined in 10.2.1 */
 		.blocklen_bytes = 16,
 		.cra_name = "ctr_aes128",
-		.backend_cra_name = "ecb(aes)",
+		.backend_cra_name = "aes",
 	}, {
 		.flags = DRBG_CTR | DRBG_STRENGTH192,
 		.statelen = 40, /* 320 bits as defined in 10.2.1 */
 		.blocklen_bytes = 16,
 		.cra_name = "ctr_aes192",
-		.backend_cra_name = "ecb(aes)",
+		.backend_cra_name = "aes",
 	}, {
 		.flags = DRBG_CTR | DRBG_STRENGTH256,
 		.statelen = 48, /* 384 bits as defined in 10.2.1 */
 		.blocklen_bytes = 16,
 		.cra_name = "ctr_aes256",
-		.backend_cra_name = "ecb(aes)",
+		.backend_cra_name = "aes",
 	},
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 #ifdef CONFIG_CRYPTO_DRBG_HASH
@@ -1644,24 +1644,24 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, const unsigned char *key,
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
 	int ret = 0;
-	struct crypto_blkcipher *tfm;
+	struct crypto_cipher *tfm;
 
-	tfm = crypto_alloc_blkcipher(drbg->core->backend_cra_name, 0, 0);
+	tfm = crypto_alloc_cipher(drbg->core->backend_cra_name, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_info("DRBG: could not allocate cipher TFM handle\n");
 		return PTR_ERR(tfm);
 	}
-	BUG_ON(drbg_blocklen(drbg) != crypto_blkcipher_blocksize(tfm));
+	BUG_ON(drbg_blocklen(drbg) != crypto_cipher_blocksize(tfm));
 	drbg->priv_data = tfm;
 	return ret;
 }
 
 static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 {
-	struct crypto_blkcipher *tfm =
-		(struct crypto_blkcipher *)drbg->priv_data;
+	struct crypto_cipher *tfm =
+		(struct crypto_cipher *)drbg->priv_data;
 	if (tfm)
-		crypto_free_blkcipher(tfm);
+		crypto_free_cipher(tfm);
 	drbg->priv_data = NULL;
 	return 0;
 }
@@ -1669,21 +1669,14 @@ static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 static int drbg_kcapi_sym(struct drbg_state *drbg, const unsigned char *key,
 			  unsigned char *outval, const struct drbg_string *in)
 {
-	int ret = 0;
-	struct scatterlist sg_in, sg_out;
-	struct blkcipher_desc desc;
-	struct crypto_blkcipher *tfm =
-		(struct crypto_blkcipher *)drbg->priv_data;
-
-	desc.tfm = tfm;
-	desc.flags = 0;
-	crypto_blkcipher_setkey(tfm, key, (drbg_keylen(drbg)));
-	/* there is only component in *in */
-	sg_init_one(&sg_in, in->buf, in->len);
-	sg_init_one(&sg_out, outval, drbg_blocklen(drbg));
-	ret = crypto_blkcipher_encrypt(&desc, &sg_out, &sg_in, in->len);
+	struct crypto_cipher *tfm =
+		(struct crypto_cipher *)drbg->priv_data;
 
-	return ret;
+	crypto_cipher_setkey(tfm, key, (drbg_keylen(drbg)));
+	/* there is only component in *in */
+	BUG_ON(in->len < drbg_blocklen(drbg));
+	crypto_cipher_encrypt_one(tfm, outval, in->buf);
+	return 0;
 }
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 
-- 
2.1.0
