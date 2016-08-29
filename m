From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/ghash-ce - add missing async import/export
Date: Mon, 29 Aug 2016 12:19:53 +0100
Message-ID: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35400 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcH2LUS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 07:20:18 -0400
Received: by mail-wm0-f50.google.com with SMTP id f65so73932395wmi.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Aug 2016 04:20:17 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero"),
all ahash drivers are required to implement import()/export(), and must have
a non-zero statesize. Fix this for the ARM Crypto Extensions GHASH
implementation.

Fixes: 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 1568cb5cd870..212aaa715fdb 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -220,6 +220,29 @@ static int ghash_async_digest(struct ahash_request *req)
 	}
 }
 
+static int ghash_async_import(struct ahash_request *req, const void *in)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	ghash_async_init(req);
+
+	*dctx = *(const struct ghash_desc_ctx *)in;
+	return 0;
+
+}
+
+static int ghash_async_export(struct ahash_request *req, void *out)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	*(struct ghash_desc_ctx *)out = *dctx;
+	return 0;
+}
+
 static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
 {
@@ -268,7 +291,10 @@ static struct ahash_alg ghash_async_alg = {
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
