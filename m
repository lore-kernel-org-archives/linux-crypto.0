Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98777267F5C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945223; cv=none; b=FuiQeBCNcsMvWRovte4qj1GLR1l7MSR083CgqJJBZmjNSlwN91aNykn4x3PPTrQcV5o7fV7Mk9rpndsySYfxsCMyPiBayP+h6s9klYd/xRLDLTKt+Cz+ri3gMH2PZYbxjtOY1Dh9pUZGbULRRz/aLKUKMDWs4IR4USzEbvYtJC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945223; c=relaxed/simple;
	bh=LIXd7XtcjRaZHVTen5JoRDFeDdiCtjOX2Tl4JxGRoJ4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=tB+rmQUahG+fmudY1WyOu+3Jzr1vtJluq9V90GCdYJAqHqmn4rIYm4QIhdS3JOFdiKBdtdB/Fr1aelO/WqofQBJdPdowriUMZGURGhpR+US3HFUt6Qw+9l2VGRT3iE5BvG4EgWVGSIH51/km2vo4uSmMoRvVdTI6ugW0G+/udIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rmy1J/MV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rmy1J/MV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I2uAmTfPKTJbQyjSFsroBV+qS+nJPQFJ/XME/5jqo9s=; b=Rmy1J/MV4/jSS0aF+8H5xB73DF
	QA4r85Z9D0HqiNQPeetswP7nnDo9iKJ1ygo8MqoaeR6SbY0GCkNs5F1ha4KmsvaGR1sKMMwU9Ej89
	BnomOZFO9Ee21plQ6/xLNlDNdmKq+ddLZPoQUZrSw8LOf30jWc9dATCJwSxiWzHFec2TIZknvelEi
	5B/jq0UhOibmwJDdEeUIZSkFo1Tfsh19cyj7Qr524awCJiyTxEnJm9v4iGwfgLPSehOv5lkedqraZ
	8Z8l/HOI2TuiA6NxQ+kHSv/RT8pVcLwT1uZ9ftGmNmF3BtpHOmxBXBWJ0KTsSKQ4zJSVLZjnfkeEX
	qmwD7syw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxi-00GeBv-0L;
	Fri, 18 Apr 2025 11:00:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:18 +0800
Date: Fri, 18 Apr 2025 11:00:18 +0800
Message-Id: <792c47012301a12045f70d3b2730a9f857a483af.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 43/67] crypto: zynqmp-sha - Use API partial block handling
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

