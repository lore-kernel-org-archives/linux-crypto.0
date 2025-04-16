Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052E623A564
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785867; cv=none; b=jDduUoQ9SR2R4tDbzQo6gpK8F0iea6YvZNHJr2vaDxm67KHVJ4K2B1Bi768rGIEgkpCgCvMllhmDLfy01T1OjWCBq/KA/1n6UP5UD0M6WlTbigzkVoq+yLlryVWcKTf8UtNQFRUHMhXWPqalESzjaqOZJFylii8eFrLeT14il6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785867; c=relaxed/simple;
	bh=LIXd7XtcjRaZHVTen5JoRDFeDdiCtjOX2Tl4JxGRoJ4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=czvrpfHanuOiT8BbESfnQ2TnHva7XI9FDTvNCOIWtcrNaWaCraaIg2rheQgA/TC4ucHCNqYTxs4g/d+AXWDObJ7DzZ22daji4wUDlLtxc20U2YYyxPYc58RY85yrwpeZWualMjO5qhMVMKHVBw3dK9iHfuiKZTl9nvr1UGlMGps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YruZ3jhc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YruZ3jhc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I2uAmTfPKTJbQyjSFsroBV+qS+nJPQFJ/XME/5jqo9s=; b=YruZ3jhccshb8HRXFp6j4Afp75
	BfKH4Dyzoz2lUjZvGX77AFDPJdDGiVlQo30+ASAMlY0ItUPcjj8tG8pfJCHdBRS6xVJX6ZJ6U6nBn
	q9EoALCnjmENkL762kZ/684LvZmB8InmRDbwRANOzEfMNL1dIeJhwsgxgTOkUdu4vNXHBBAFJGQyL
	6mXo6ALw30Ojc/P+/bxqV3h/se3fGPFFS9A8MMvobL75jZ4RtDh2D4Ni5JH90HsrcQhXr/5hZ+a0y
	BtC7VeXK+olXiRKl7S9t8g7Ue4iOG3PWzMRv8Rrc1Q4vng7ORm2caV/GVtPbESvVitL+P2j3liR/m
	D55MjOuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVS-00G6Ot-08;
	Wed, 16 Apr 2025 14:44:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:22 +0800
Date: Wed, 16 Apr 2025 14:44:22 +0800
Message-Id: <8cbeaab2473afa3153f3c3f592be4d5eb6c0e92f.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 43/67] crypto: zynqmp-sha - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

As this was the last user of the extra fields in struct sha3_state,
remove them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 71 +++++++++---------------------
 include/crypto/sha3.h              |  5 ---
 2 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 4db8c717906f..67cf8d990a1d 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -3,7 +3,6 @@
  * Xilinx ZynqMP SHA Driver.
  * Copyright (c) 2022 Xilinx Inc.
  */
-#include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha3.h>
 #include <linux/cacheflush.h>
@@ -37,10 +36,6 @@ struct zynqmp_sha_tfm_ctx {
 	struct crypto_shash *fbk_tfm;
 };
 
-struct zynqmp_sha_desc_ctx {
-	struct shash_desc fbk_req;
-};
-
 static dma_addr_t update_dma_addr, final_dma_addr;
 static char *ubuf, *fbuf;
 
@@ -64,7 +59,6 @@ static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 
 	if (crypto_shash_descsize(hash) <
-	    sizeof(struct zynqmp_sha_desc_ctx) +
 	    crypto_shash_descsize(tfm_ctx->fbk_tfm)) {
 		crypto_free_shash(fallback_tfm);
 		return -EINVAL;
@@ -79,58 +73,41 @@ static void zynqmp_sha_exit_tfm(struct crypto_shash *hash)
 {
 	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_shash_ctx(hash);
 
-	if (tfm_ctx->fbk_tfm) {
-		crypto_free_shash(tfm_ctx->fbk_tfm);
-		tfm_ctx->fbk_tfm = NULL;
-	}
-
-	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_sha_tfm_ctx));
+	crypto_free_shash(tfm_ctx->fbk_tfm);
 }
 
 static int zynqmp_sha_init(struct shash_desc *desc)
 {
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
 	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct crypto_shash *fbtfm = tctx->fbk_tfm;
+	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
 
-	dctx->fbk_req.tfm = tctx->fbk_tfm;
-	return crypto_shash_init(&dctx->fbk_req);
+	fbdesc->tfm = fbtfm;
+	return crypto_shash_init(fbdesc) ?:
+	       crypto_shash_export_core(fbdesc, shash_desc_ctx(desc));
 }
 
 static int zynqmp_sha_update(struct shash_desc *desc, const u8 *data, unsigned int length)
 {
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct crypto_shash *fbtfm = tctx->fbk_tfm;
+	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
 
-	return crypto_shash_update(&dctx->fbk_req, data, length);
-}
-
-static int zynqmp_sha_final(struct shash_desc *desc, u8 *out)
-{
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	return crypto_shash_final(&dctx->fbk_req, out);
+	fbdesc->tfm = fbtfm;
+	return crypto_shash_import_core(fbdesc, shash_desc_ctx(desc)) ?:
+	       crypto_shash_update(fbdesc, data, length) ?:
+	       crypto_shash_export_core(fbdesc, shash_desc_ctx(desc));
 }
 
 static int zynqmp_sha_finup(struct shash_desc *desc, const u8 *data, unsigned int length, u8 *out)
 {
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	return crypto_shash_finup(&dctx->fbk_req, data, length, out);
-}
-
-static int zynqmp_sha_import(struct shash_desc *desc, const void *in)
-{
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
 	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct crypto_shash *fbtfm = tctx->fbk_tfm;
+	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
 
-	dctx->fbk_req.tfm = tctx->fbk_tfm;
-	return crypto_shash_import(&dctx->fbk_req, in);
-}
-
-static int zynqmp_sha_export(struct shash_desc *desc, void *out)
-{
-	struct zynqmp_sha_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	return crypto_shash_export(&dctx->fbk_req, out);
+	fbdesc->tfm = fbtfm;
+	return crypto_shash_import_core(fbdesc, shash_desc_ctx(desc)) ?:
+	       crypto_shash_finup(fbdesc, data, length, out);
 }
 
 static int __zynqmp_sha_digest(struct shash_desc *desc, const u8 *data,
@@ -179,24 +156,20 @@ static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 	.sha3_384 = {
 		.init = zynqmp_sha_init,
 		.update = zynqmp_sha_update,
-		.final = zynqmp_sha_final,
 		.finup = zynqmp_sha_finup,
 		.digest = zynqmp_sha_digest,
-		.export = zynqmp_sha_export,
-		.import = zynqmp_sha_import,
 		.init_tfm = zynqmp_sha_init_tfm,
 		.exit_tfm = zynqmp_sha_exit_tfm,
-		.descsize = sizeof(struct zynqmp_sha_desc_ctx) +
-			    sizeof(struct sha3_state),
-		.statesize = sizeof(struct sha3_state),
+		.descsize = sizeof(struct sha3_state),
 		.digestsize = SHA3_384_DIGEST_SIZE,
 		.base = {
 			.cra_name = "sha3-384",
 			.cra_driver_name = "zynqmp-sha3-384",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				     CRYPTO_ALG_ALLOCATES_MEMORY |
-				     CRYPTO_ALG_NEED_FALLBACK,
+				     CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				     CRYPTO_AHASH_ALG_FINUP_MAX,
 			.cra_blocksize = SHA3_384_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
 			.cra_module = THIS_MODULE,
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 420b90c5f08a..3c2559f51ada 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -25,11 +25,6 @@ struct shash_desc;
 
 struct sha3_state {
 	u64		st[SHA3_STATE_SIZE / 8];
-	unsigned int	rsiz;
-	unsigned int	rsizw;
-
-	unsigned int	partial;
-	u8		buf[SHA3_224_BLOCK_SIZE];
 };
 
 int crypto_sha3_init(struct shash_desc *desc);
-- 
2.39.5

