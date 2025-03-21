Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD9612E7F
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 04:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742532267; cv=none; b=aOd+U0v0b/1xC4H0Bnh3wMpap7KngOY+eCKKKdbJmAaeyOvlxieJODV3Q0alEB6aWFaCyDE8b8mXC9m4alDYMuySEoDiHpnEJTOXyrq5t+0eZGtpSRbIhEz3iRXmp2sbnGV6lJCwxV0vFjegPlRyvaORBpreWGRyw8DMc2vhEVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742532267; c=relaxed/simple;
	bh=q/13FDWC4C4r1Mc9gnkeIugIdUAtOFfOtznl9h0v+wU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZT6v7xVujrYND5GOhemeYgSP87dKNawt77gE5VkoXHjBXGFL3ceer8lfdXF8m4yiUXaAUxPFxlYHzLik/pxncm4V4p1Mn0YDDbKFlTHIY3DdfLnJKd2LeIS3AkQUK/aVR7yNXaVzcjtJAR83fDMwA1Whpd2FxPVXbI89re7YKFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CQE2jqzV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CQE2jqzV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YI5dWgKMYFsup0F8kcS9BJz7L09NEiNoYBE1u5vgaMY=; b=CQE2jqzVdTcH+oGz7nn4ynmSC6
	LGCvSk30QzKfozZITHFhunrH2UT561lMwh4LLQ5Rtv5nxmLszoCrYRwNAUmBQUKzL86JgI/ge0Dp9
	ZeBZLO8zWqYfix7rofPXxzT3YIRkv1FViGJtP1ssmdRcxZKLRtDq0Wz15SBwkkxU2/V1+JKSv9lEv
	28sAIuZwzmkleaWteGDMPGmIjKs4zE3Nq1ziTDPe3Vr6YL0ywRgxBlbSxOSdQ4Ag2x6NzumU9m2Tz
	auHzXYPhV5TadID+UCTmO+wXFf0cgV18rVOYBl3SWkSnDM0aS/4WDFcGTWrixGK+tsT374FF/iqfe
	BLDAJZbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvUF2-008vTn-35;
	Fri, 21 Mar 2025 12:44:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 12:44:20 +0800
Date: Fri, 21 Mar 2025 12:44:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm/ghash-ce - Remove SIMD fallback code path
Message-ID: <Z9zupEU1itUXzaMn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Remove the obsolete fallback code path for SIMD and remove the
cryptd-based ghash-ce algorithm.  Rename the shash algorithm to
ghash-ce.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/ghash-ce-glue.c | 197 ++------------------------------
 1 file changed, 8 insertions(+), 189 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index dab66b520b6e..aabfcf522a2c 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -55,10 +55,6 @@ struct ghash_desc_ctx {
 	u32 count;
 };
 
-struct ghash_async_ctx {
-	struct cryptd_ahash *cryptd_tfm;
-};
-
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
 				       u64 const h[][2], const char *head);
 
@@ -78,34 +74,12 @@ static int ghash_init(struct shash_desc *desc)
 static void ghash_do_update(int blocks, u64 dg[], const char *src,
 			    struct ghash_key *key, const char *head)
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_neon_begin();
-		if (static_branch_likely(&use_p64))
-			pmull_ghash_update_p64(blocks, dg, src, key->h, head);
-		else
-			pmull_ghash_update_p8(blocks, dg, src, key->h, head);
-		kernel_neon_end();
-	} else {
-		be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
-
-		do {
-			const u8 *in = src;
-
-			if (head) {
-				in = head;
-				blocks++;
-				head = NULL;
-			} else {
-				src += GHASH_BLOCK_SIZE;
-			}
-
-			crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
-			gf128mul_lle(&dst, &key->k);
-		} while (--blocks);
-
-		dg[0] = be64_to_cpu(dst.b);
-		dg[1] = be64_to_cpu(dst.a);
-	}
+	kernel_neon_begin();
+	if (static_branch_likely(&use_p64))
+		pmull_ghash_update_p64(blocks, dg, src, key->h, head);
+	else
+		pmull_ghash_update_p8(blocks, dg, src, key->h, head);
+	kernel_neon_end();
 }
 
 static int ghash_update(struct shash_desc *desc, const u8 *src,
@@ -206,162 +180,13 @@ static struct shash_alg ghash_alg = {
 	.descsize		= sizeof(struct ghash_desc_ctx),
 
 	.base.cra_name		= "ghash",
-	.base.cra_driver_name	= "ghash-ce-sync",
-	.base.cra_priority	= 300 - 1,
+	.base.cra_driver_name	= "ghash-ce",
+	.base.cra_priority	= 300,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
 };
 
-static int ghash_async_init(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
-
-	desc->tfm = child;
-	return crypto_shash_init(desc);
-}
-
-static int ghash_async_update(struct ahash_request *req)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
-		return crypto_ahash_update(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		return shash_ahash_update(req, desc);
-	}
-}
-
-static int ghash_async_final(struct ahash_request *req)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
-		return crypto_ahash_final(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		return crypto_shash_final(desc, req->result);
-	}
-}
-
-static int ghash_async_digest(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
-		return crypto_ahash_digest(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
-
-		desc->tfm = child;
-		return shash_ahash_digest(req, desc);
-	}
-}
-
-static int ghash_async_import(struct ahash_request *req, const void *in)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-
-	desc->tfm = cryptd_ahash_child(ctx->cryptd_tfm);
-
-	return crypto_shash_import(desc, in);
-}
-
-static int ghash_async_export(struct ahash_request *req, void *out)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-
-	return crypto_shash_export(desc, out);
-}
-
-static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
-
-	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
-			       & CRYPTO_TFM_REQ_MASK);
-	return crypto_ahash_setkey(child, key, keylen);
-}
-
-static int ghash_async_init_tfm(struct crypto_tfm *tfm)
-{
-	struct cryptd_ahash *cryptd_tfm;
-	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_tfm = cryptd_alloc_ahash("ghash-ce-sync", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ctx->cryptd_tfm = cryptd_tfm;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct ahash_request) +
-				 crypto_ahash_reqsize(&cryptd_tfm->base));
-
-	return 0;
-}
-
-static void ghash_async_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ahash(ctx->cryptd_tfm);
-}
-
-static struct ahash_alg ghash_async_alg = {
-	.init			= ghash_async_init,
-	.update			= ghash_async_update,
-	.final			= ghash_async_final,
-	.setkey			= ghash_async_setkey,
-	.digest			= ghash_async_digest,
-	.import			= ghash_async_import,
-	.export			= ghash_async_export,
-	.halg.digestsize	= GHASH_DIGEST_SIZE,
-	.halg.statesize		= sizeof(struct ghash_desc_ctx),
-	.halg.base		= {
-		.cra_name	= "ghash",
-		.cra_driver_name = "ghash-ce",
-		.cra_priority	= 300,
-		.cra_flags	= CRYPTO_ALG_ASYNC,
-		.cra_blocksize	= GHASH_BLOCK_SIZE,
-		.cra_ctxsize	= sizeof(struct ghash_async_ctx),
-		.cra_module	= THIS_MODULE,
-		.cra_init	= ghash_async_init_tfm,
-		.cra_exit	= ghash_async_exit_tfm,
-	},
-};
-
-
 void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
 		       struct gcm_key const *k, char *dst,
 		       const char *iv, int rounds, u32 counter);
@@ -759,14 +584,9 @@ static int __init ghash_ce_mod_init(void)
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
 		goto err_aead;
-	err = crypto_register_ahash(&ghash_async_alg);
-	if (err)
-		goto err_shash;
 
 	return 0;
 
-err_shash:
-	crypto_unregister_shash(&ghash_alg);
 err_aead:
 	if (elf_hwcap2 & HWCAP2_PMULL)
 		crypto_unregister_aeads(gcm_aes_algs,
@@ -776,7 +596,6 @@ static int __init ghash_ce_mod_init(void)
 
 static void __exit ghash_ce_mod_exit(void)
 {
-	crypto_unregister_ahash(&ghash_async_alg);
 	crypto_unregister_shash(&ghash_alg);
 	if (elf_hwcap2 & HWCAP2_PMULL)
 		crypto_unregister_aeads(gcm_aes_algs,
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
