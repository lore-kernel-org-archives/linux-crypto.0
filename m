From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/10] crypto: crc32c-intel - Switch to shash
Date: Fri, 07 Nov 2008 16:37:04 +0800
Message-ID: <E1KyMq0-0002lX-9n@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39130 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751617AbYKGIhG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:06 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMq0-0006Ab-GQ
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:04 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crc32c-intel - Switch to shash

This patch changes crc32c-intel to the new shash interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/crc32c-intel.c |  101 +++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 54 deletions(-)

diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel.c
index a2c539c..b9d0026 100644
--- a/arch/x86/crypto/crc32c-intel.c
+++ b/arch/x86/crypto/crc32c-intel.c
@@ -84,99 +84,92 @@ static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len
  * If your algorithm starts with ~0, then XOR with ~0 before you set
  * the seed.
  */
-static int crc32c_intel_setkey(struct crypto_ahash *hash, const u8 *key,
+static int crc32c_intel_setkey(struct crypto_shash *hash, const u8 *key,
 			unsigned int keylen)
 {
-	u32 *mctx = crypto_ahash_ctx(hash);
+	u32 *mctx = crypto_shash_ctx(hash);
 
 	if (keylen != sizeof(u32)) {
-		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	*mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
 
-static int crc32c_intel_init(struct ahash_request *req)
+static int crc32c_intel_init(struct shash_desc *desc)
 {
-	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	u32 *crcp = ahash_request_ctx(req);
+	u32 *mctx = crypto_shash_ctx(desc->tfm);
+	u32 *crcp = shash_desc_ctx(desc);
 
 	*crcp = *mctx;
 
 	return 0;
 }
 
-static int crc32c_intel_update(struct ahash_request *req)
+static int crc32c_intel_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len)
 {
-	struct crypto_hash_walk walk;
-	u32 *crcp = ahash_request_ctx(req);
-	u32 crc = *crcp;
-	int nbytes;
+	u32 *crcp = shash_desc_ctx(desc);
 
-	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
-	   nbytes = crypto_hash_walk_done(&walk, 0))
-	crc = crc32c_intel_le_hw(crc, walk.data, nbytes);
-
-	*crcp = crc;
+	*crcp = crc32c_intel_le_hw(*crcp, data, len);
 	return 0;
 }
 
-static int crc32c_intel_final(struct ahash_request *req)
+static int __crc32c_intel_finup(u32 *crcp, const u8 *data, unsigned int len,
+				u8 *out)
 {
-	u32 *crcp = ahash_request_ctx(req);
-
-	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
+	*(__le32 *)out = ~cpu_to_le32(crc32c_intel_le_hw(*crcp, data, len));
 	return 0;
 }
 
-static int crc32c_intel_digest(struct ahash_request *req)
+static int crc32c_intel_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct crypto_hash_walk walk;
-	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	u32 crc = *mctx;
-	int nbytes;
+	return __crc32c_intel_finup(shash_desc_ctx(desc), data, len, out);
+}
 
-	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
-	   nbytes = crypto_hash_walk_done(&walk, 0))
-		crc = crc32c_intel_le_hw(crc, walk.data, nbytes);
+static int crc32c_intel_final(struct shash_desc *desc, u8 *out)
+{
+	u32 *crcp = shash_desc_ctx(desc);
 
-	*(__le32 *)req->result = ~cpu_to_le32(crc);
+	*(__le32 *)out = ~cpu_to_le32p(crcp);
 	return 0;
 }
 
+static int crc32c_intel_digest(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *out)
+{
+	return __crc32c_intel_finup(crypto_shash_ctx(desc->tfm), data, len,
+				    out);
+}
+
 static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
 {
 	u32 *key = crypto_tfm_ctx(tfm);
 
 	*key = ~0;
 
-	tfm->crt_ahash.reqsize = sizeof(u32);
-
 	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name               =       "crc32c",
-	.cra_driver_name        =       "crc32c-intel",
-	.cra_priority           =       200,
-	.cra_flags              =       CRYPTO_ALG_TYPE_AHASH,
-	.cra_blocksize          =       CHKSUM_BLOCK_SIZE,
-	.cra_alignmask          =       3,
-	.cra_ctxsize            =       sizeof(u32),
-	.cra_module             =       THIS_MODULE,
-	.cra_list               =       LIST_HEAD_INIT(alg.cra_list),
-	.cra_init               =       crc32c_intel_cra_init,
-	.cra_type               =       &crypto_ahash_type,
-	.cra_u                  =       {
-		.ahash = {
-			.digestsize    =       CHKSUM_DIGEST_SIZE,
-			.setkey        =       crc32c_intel_setkey,
-			.init          =       crc32c_intel_init,
-			.update        =       crc32c_intel_update,
-			.final         =       crc32c_intel_final,
-			.digest        =       crc32c_intel_digest,
-		}
+static struct shash_alg alg = {
+	.setkey			=	crc32c_intel_setkey,
+	.init			=	crc32c_intel_init,
+	.update			=	crc32c_intel_update,
+	.final			=	crc32c_intel_final,
+	.finup			=	crc32c_intel_finup,
+	.digest			=	crc32c_intel_digest,
+	.descsize		=	sizeof(u32),
+	.digestsize		=	CHKSUM_DIGEST_SIZE,
+	.base			=	{
+		.cra_name		=	"crc32c",
+		.cra_driver_name	=	"crc32c-intel",
+		.cra_priority		=	200,
+		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+		.cra_ctxsize		=	sizeof(u32),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	crc32c_intel_cra_init,
 	}
 };
 
@@ -184,14 +177,14 @@ static struct crypto_alg alg = {
 static int __init crc32c_intel_mod_init(void)
 {
 	if (cpu_has_xmm4_2)
-		return crypto_register_alg(&alg);
+		return crypto_register_shash(&alg);
 	else
 		return -ENODEV;
 }
 
 static void __exit crc32c_intel_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(crc32c_intel_mod_init);
