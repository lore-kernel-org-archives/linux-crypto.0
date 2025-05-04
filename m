Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C58EEA6
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746339237; cv=none; b=ZECbOm3AZn6wCzdrHtA34Va+LJ7a9prcxxxKqySthBNCz2TARr0CvjveaicUDFokLFUpaoTuyvUydfSJalERBKlcBA1WzoaKQiXSq8Uswcyq7QJpVNGhHncQnAV+LmrVy5+Aoz/zpNhMDacA4YnRfKYzfdhOTlHd4vLtGX5gNaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746339237; c=relaxed/simple;
	bh=5Icq9J8Omj8x1+6UCb4dwN07ImC82QpH8jrxEPrvuwM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mitONhUg7Gk0WHgi79HmV7ie7Xh0qpY9jJCTuJhVXEUeqyshsH8Zg2VGrZs3b9pJcxiefdTc4GYlCnR1szHXUTiQejkC2eJepOwKntmLwBtjveYD67qjJnbvNpG2Ovyy2oti+WbdWPj64KNyL1YSxzTc8i7Gt8m33hyBfqM7JcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IJYy1jkf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IJYy1jkf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1XmS7rRPhB3TPkxz0Hm+9gSModKDXu9vJWrNodu1piA=; b=IJYy1jkfLalJFq3zG1jlARiUy+
	6t0kcu3L000g8hM1NiayVfAnrcgil6Gp/xik96NrJSQho6iWCvtY5C7j+Zn+TMvfG9kXCXvxZBNO4
	EN4L1yV/N8RvR2le/QwlBIZfoRrRgZiUqTbM/xPQVHEotoLbZva4AOEuDOC21XFLwIc+CZ/TkLaZq
	5fbmnQ49AAxG5aSzgEadgPMi4BskkQIjyZqsgAM38ljTneV4FbOOawoutjtp60GhMwrA3ELS0CnSu
	nZuhPoS2sU/cYUFz08slfoouSwoe3OIPv4sS5fSMfLaWhsL+EoKQNEGN9qYKkrarcjcdW38kay5in
	9nUKyDAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBSbm-003BkX-1t;
	Sun, 04 May 2025 14:13:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 14:13:50 +0800
Date: Sun, 4 May 2025 14:13:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: zynqmp-sha - Fix partial block implementation
Message-ID: <aBcFnjYJPkikKqE7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The zynqmp-sha partial block was based on an old design of the
partial block API where the leftover calculation was done in the
Crypto API.  As the leftover calculation is now done by the
algorithm, fix this by passing the partial blocks to the fallback.

Also zero the stack descriptors.

Fixes: 201e9ec3b621 ("crypto: zynqmp-sha - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 30 +++++++++++++++++++-----------
 include/crypto/sha3.h              |  4 ++++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 67cf8d990a1d..5813017b6b79 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -59,7 +59,7 @@ static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 
 	if (crypto_shash_descsize(hash) <
-	    crypto_shash_descsize(tfm_ctx->fbk_tfm)) {
+	    crypto_shash_statesize(tfm_ctx->fbk_tfm)) {
 		crypto_free_shash(fallback_tfm);
 		return -EINVAL;
 	}
@@ -76,15 +76,24 @@ static void zynqmp_sha_exit_tfm(struct crypto_shash *hash)
 	crypto_free_shash(tfm_ctx->fbk_tfm);
 }
 
+static int zynqmp_sha_continue(struct shash_desc *desc,
+			       struct shash_desc *fbdesc, int err)
+{
+	err = err ?: crypto_shash_export(fbdesc, shash_desc_ctx(desc));
+	shash_desc_zero(fbdesc);
+	return err;
+}
+
 static int zynqmp_sha_init(struct shash_desc *desc)
 {
 	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct crypto_shash *fbtfm = tctx->fbk_tfm;
 	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
+	int err;
 
 	fbdesc->tfm = fbtfm;
-	return crypto_shash_init(fbdesc) ?:
-	       crypto_shash_export_core(fbdesc, shash_desc_ctx(desc));
+	err = crypto_shash_init(fbdesc);
+	return zynqmp_sha_continue(desc, fbdesc, err);
 }
 
 static int zynqmp_sha_update(struct shash_desc *desc, const u8 *data, unsigned int length)
@@ -92,11 +101,12 @@ static int zynqmp_sha_update(struct shash_desc *desc, const u8 *data, unsigned i
 	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct crypto_shash *fbtfm = tctx->fbk_tfm;
 	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
+	int err;
 
 	fbdesc->tfm = fbtfm;
-	return crypto_shash_import_core(fbdesc, shash_desc_ctx(desc)) ?:
-	       crypto_shash_update(fbdesc, data, length) ?:
-	       crypto_shash_export_core(fbdesc, shash_desc_ctx(desc));
+	err = crypto_shash_import(fbdesc, shash_desc_ctx(desc)) ?:
+	      crypto_shash_update(fbdesc, data, length);
+	return zynqmp_sha_continue(desc, fbdesc, err);
 }
 
 static int zynqmp_sha_finup(struct shash_desc *desc, const u8 *data, unsigned int length, u8 *out)
@@ -106,7 +116,7 @@ static int zynqmp_sha_finup(struct shash_desc *desc, const u8 *data, unsigned in
 	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
 
 	fbdesc->tfm = fbtfm;
-	return crypto_shash_import_core(fbdesc, shash_desc_ctx(desc)) ?:
+	return crypto_shash_import(fbdesc, shash_desc_ctx(desc)) ?:
 	       crypto_shash_finup(fbdesc, data, length, out);
 }
 
@@ -160,16 +170,14 @@ static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 		.digest = zynqmp_sha_digest,
 		.init_tfm = zynqmp_sha_init_tfm,
 		.exit_tfm = zynqmp_sha_exit_tfm,
-		.descsize = sizeof(struct sha3_state),
+		.descsize = SHA3_384_EXPORT_SIZE,
 		.digestsize = SHA3_384_DIGEST_SIZE,
 		.base = {
 			.cra_name = "sha3-384",
 			.cra_driver_name = "zynqmp-sha3-384",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				     CRYPTO_ALG_NEED_FALLBACK |
-				     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-				     CRYPTO_AHASH_ALG_FINUP_MAX,
+				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = SHA3_384_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
 			.cra_module = THIS_MODULE,
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 3c2559f51ada..41e1b83a6d91 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -9,15 +9,19 @@
 
 #define SHA3_224_DIGEST_SIZE	(224 / 8)
 #define SHA3_224_BLOCK_SIZE	(200 - 2 * SHA3_224_DIGEST_SIZE)
+#define SHA3_224_EXPORT_SIZE	SHA3_STATE_SIZE + SHA3_224_BLOCK_SIZE + 1
 
 #define SHA3_256_DIGEST_SIZE	(256 / 8)
 #define SHA3_256_BLOCK_SIZE	(200 - 2 * SHA3_256_DIGEST_SIZE)
+#define SHA3_256_EXPORT_SIZE	SHA3_STATE_SIZE + SHA3_256_BLOCK_SIZE + 1
 
 #define SHA3_384_DIGEST_SIZE	(384 / 8)
 #define SHA3_384_BLOCK_SIZE	(200 - 2 * SHA3_384_DIGEST_SIZE)
+#define SHA3_384_EXPORT_SIZE	SHA3_STATE_SIZE + SHA3_384_BLOCK_SIZE + 1
 
 #define SHA3_512_DIGEST_SIZE	(512 / 8)
 #define SHA3_512_BLOCK_SIZE	(200 - 2 * SHA3_512_DIGEST_SIZE)
+#define SHA3_512_EXPORT_SIZE	SHA3_STATE_SIZE + SHA3_512_BLOCK_SIZE + 1
 
 #define SHA3_STATE_SIZE		200
 
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
