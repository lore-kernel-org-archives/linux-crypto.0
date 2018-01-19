From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/8] crypto/generic: sha3 - export init/update/final routines
Date: Fri, 19 Jan 2018 12:04:36 +0000
Message-ID: <20180119120440.31556-5-ard.biesheuvel@linaro.org>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:43163 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754232AbeASMFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:22 -0500
Received: by mail-wm0-f65.google.com with SMTP id g1so2956109wmg.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:21 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To allow accelerated implementations to fall back to the generic
routines, e.g., in contexts where a SIMD based implementation is
not allowed to run, expose the generic SHA3 init/update/final
routines to other modules.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha3_generic.c | 33 +++++++++++---------
 include/crypto/sha3.h |  5 +++
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index c7084a24eaf9..a965b9d80559 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -145,7 +145,7 @@ static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
 	}
 }
 
-static int sha3_init(struct shash_desc *desc)
+int crypto_sha3_init(struct shash_desc *desc)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
@@ -157,8 +157,9 @@ static int sha3_init(struct shash_desc *desc)
 	memset(sctx->st, 0, sizeof(sctx->st));
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha3_init);
 
-static int sha3_update(struct shash_desc *desc, const u8 *data,
+int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
@@ -194,8 +195,9 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha3_update);
 
-static int sha3_final(struct shash_desc *desc, u8 *out)
+int crypto_sha3_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int i, inlen = sctx->partial;
@@ -220,12 +222,13 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 	memset(sctx, 0, sizeof(*sctx));
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha3_final);
 
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
-	.init			= sha3_init,
-	.update			= sha3_update,
-	.final			= sha3_final,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
 	.descsize		= sizeof(struct sha3_state),
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-generic",
@@ -234,9 +237,9 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
-	.init			= sha3_init,
-	.update			= sha3_update,
-	.final			= sha3_final,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
 	.descsize		= sizeof(struct sha3_state),
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-generic",
@@ -245,9 +248,9 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
-	.init			= sha3_init,
-	.update			= sha3_update,
-	.final			= sha3_final,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
 	.descsize		= sizeof(struct sha3_state),
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-generic",
@@ -256,9 +259,9 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
-	.init			= sha3_init,
-	.update			= sha3_update,
-	.final			= sha3_final,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
 	.descsize		= sizeof(struct sha3_state),
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-generic",
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 1339dcdbc9b2..080f60c2e6b1 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -26,4 +26,9 @@ struct sha3_state {
 	u8		buf[SHA3_224_BLOCK_SIZE];
 };
 
+int crypto_sha3_init(struct shash_desc *desc);
+int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
+		       unsigned int len);
+int crypto_sha3_final(struct shash_desc *desc, u8 *out);
+
 #endif
-- 
2.11.0
