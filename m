From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/3] crypto: arm/ghash-ce - add missing async import/export
Date: Thu,  1 Sep 2016 14:25:42 +0100
Message-ID: <1472736343-15305-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36846 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754929AbcIAN1U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 09:27:20 -0400
Received: by mail-wm0-f49.google.com with SMTP id c133so78460701wmd.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2016 06:27:19 -0700 (PDT)
In-Reply-To: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero"),
all ahash drivers are required to implement import()/export(), and must have
a non-zero statesize. Fix this for the ARM Crypto Extensions GHASH
implementation.

Fixes: 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 1568cb5cd870..b88364aa149a 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -220,6 +220,27 @@ static int ghash_async_digest(struct ahash_request *req)
 	}
 }
 
+static int ghash_async_import(struct ahash_request *req, const void *in)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+
+	desc->tfm = cryptd_ahash_child(ctx->cryptd_tfm);
+	desc->flags = req->base.flags;
+
+	return crypto_shash_import(desc, in);
+}
+
+static int ghash_async_export(struct ahash_request *req, void *out)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+
+	return crypto_shash_export(desc, out);
+}
+
 static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
 {
@@ -268,7 +289,10 @@ static struct ahash_alg ghash_async_alg = {
 	.final			= ghash_async_final,
 	.setkey			= ghash_async_setkey,
 	.digest			= ghash_async_digest,
+	.import			= ghash_async_import,
+	.export			= ghash_async_export,
 	.halg.digestsize	= GHASH_DIGEST_SIZE,
+	.halg.statesize		= sizeof(struct ghash_desc_ctx),
 	.halg.base		= {
 		.cra_name	= "ghash",
 		.cra_driver_name = "ghash-ce",
-- 
2.7.4
