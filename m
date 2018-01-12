From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/5] crypto/generic: sha3 - export init/update/final routines
Date: Fri, 12 Jan 2018 13:15:20 +0000
Message-ID: <20180112131522.25663-4-ard.biesheuvel@linaro.org>
References: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        jgarzik@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42282 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933581AbeALNPo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 08:15:44 -0500
Received: by mail-wr0-f195.google.com with SMTP id e41so4943556wre.9
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 05:15:43 -0800 (PST)
In-Reply-To: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
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
index 677247d429a1..86db5baafc83 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -87,7 +87,7 @@ static void keccakf(u64 st[25])
 	}
 }
 
-static int sha3_init(struct shash_desc *desc)
+int crypto_sha3_init(struct shash_desc *desc)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
@@ -99,8 +99,9 @@ static int sha3_init(struct shash_desc *desc)
 	memset(sctx->st, 0, sizeof(sctx->st));
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha3_init);
 
-static int sha3_update(struct shash_desc *desc, const u8 *data,
+int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
@@ -136,8 +137,9 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha3_update);
 
-static int sha3_final(struct shash_desc *desc, u8 *out)
+int crypto_sha3_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int i, inlen = sctx->partial;
@@ -162,12 +164,13 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
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
@@ -176,9 +179,9 @@ static struct shash_alg algs[] = { {
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
@@ -187,9 +190,9 @@ static struct shash_alg algs[] = { {
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
@@ -198,9 +201,9 @@ static struct shash_alg algs[] = { {
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
