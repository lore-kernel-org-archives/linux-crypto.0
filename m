Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013B32C8B
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088076; cv=none; b=lFhjYMjWcYJPovEi7SOrGKhPEU9qDnnokU/86/LNvYx7vlSILlX6vJFZhEtKIrgnlLuLMpxY3B4xcBKii0Wq4xLZMScZ/4RttDQgzDoKgF6Zbq1Uj+1A877HXb3rlBVia7J76epaD+Hwvg4l1rFMpY/2UkoXZFlWxunyRPGhLmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088076; c=relaxed/simple;
	bh=C7cmkIlp6V5pz/6rkErfy9Kzb7Lnmtx5SNagBUzTE4g=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=PyBs+YLhGF628cpiAuYV32sOtZnAZEvqEPHzVVwfj/5wWaC2VFYAlB3dkBUnPF4V7vm3eLik4Pnrb4GMPDqWSNh7uySeR04qp68ZSm5mek6Oc53jBLGSsxG5UYCaTeQwhJSaBHzKlEjWbDuQoeXA4irzNdyPnG+lGCqoUMVIFGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YjyGVzIp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YjyGVzIp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E1dh3AuGvtMLr35ZzONmq6qRP45oxrtrwNmWXqUif/M=; b=YjyGVzIpKYpTzypNfXicu1Lqeu
	EoaFME/cT6JLv38wbWFgyzPWKaE3ptYs+EQh2OxYCIJuHDKTW039mJ0a9Nv1Jng1hG8tL2kNQl9pL
	FbnatTNKgHEvL+R2T7jlwYD0ZWCPZ+oclo73T5MvZ2IQ1guwcCmtyO/DBfMeWlYZ5tPejIEO2znVy
	V/Bq9+p5qFW3uzQXOXMcOKid3/Oh5JFg+la50dvaSNtpVefb0ZheHm9EyMGJc1jWKkmUI7oBmqSUq
	MUDRy/xq3huopy9FK/JJYIsUxEu0g7AJbxjHuJ03pbztK0PwqNuI1KOjx+XmMwmxdphJVLccGudP4
	Ufk0WtDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgg-006xYk-31;
	Sun, 16 Mar 2025 09:21:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:10 +0800
Date: Sun, 16 Mar 2025 09:21:10 +0800
Message-Id: <c83f9ecdcdcbdf5dec8daea57c8a1b4674dfdc16.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 04/11] crypto: lz4 - drop obsolete 'comp' implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The 'comp' API is obsolete and will be removed, so remove this comp
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lz4.c | 61 +---------------------------------------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index e66c6d1ba34f..82588607fb2e 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -27,29 +27,11 @@ static void *lz4_alloc_ctx(void)
 	return ctx;
 }
 
-static int lz4_init(struct crypto_tfm *tfm)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->lz4_comp_mem = lz4_alloc_ctx();
-	if (IS_ERR(ctx->lz4_comp_mem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void lz4_free_ctx(void *ctx)
 {
 	vfree(ctx);
 }
 
-static void lz4_exit(struct crypto_tfm *tfm)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lz4_free_ctx(ctx->lz4_comp_mem);
-}
-
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -70,14 +52,6 @@ static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
 }
 
-static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			       unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
-}
-
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -97,26 +71,6 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
-static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-				 unsigned int slen, u8 *dst,
-				 unsigned int *dlen)
-{
-	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
-}
-
-static struct crypto_alg alg_lz4 = {
-	.cra_name		= "lz4",
-	.cra_driver_name	= "lz4-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct lz4_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= lz4_init,
-	.cra_exit		= lz4_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lz4_alloc_ctx,
 	.free_ctx		= lz4_free_ctx,
@@ -131,24 +85,11 @@ static struct scomp_alg scomp = {
 
 static int __init lz4_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg_lz4);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg_lz4);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit lz4_mod_fini(void)
 {
-	crypto_unregister_alg(&alg_lz4);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

