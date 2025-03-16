Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87B92770B
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088085; cv=none; b=VFyVAwldRs4YuzsmR1ea6UU4wknDq+FmaG93923pjzeynG3oJ+kqV6s/lgjKTAgLLmJw5cDdswpo3IKAZBthOklWUyZR3krFJhbiJGKP9736XMVumNHtiSjBQEvCCt7TH2KubrLWHi+nOG3hL8KqZ7nqKPi2C4klNCAe8Jh0EsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088085; c=relaxed/simple;
	bh=78ZheLBkUKP+2SuEeh7hPilSE7bA3XB4kzYwf5L6XsA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=IpCWO7CVew07bs9uH4mDYquN45XyW1HHS9FCIQHvfuLgFTJ6OY97ONq4/0wnAueLf/1DjdpBV0Wfw35A/ldQK4MPO0zJTiDE4AaIp1nWts0B1Hwgt860VCDLaq5wAmnrNWJhn0IiXy5TJzqwrjOESh/ZZElIfZodF7234tojTlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eTGdsYtb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eTGdsYtb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=b0TytzC8hSAlC8kE6vzpzVmuoFu88kND8FGSz4yLvIg=; b=eTGdsYtbM+EaT8oO8KnJ3CXxf9
	1LhboaxsFkSCb3WnsZnaNBzJOs2BWUSm8SsdZ3JRrIGLhVo3kCDTkSHDKBJjPEPwaLfC4ATzw9R7C
	JlbSL+CHko56bGGDU57WearGnFrrOPH2/qVWa6HaIogwWNPO2ot5fKChpdghPl5tvSOfi45qMRdG8
	2u1HINKyWro+Qujll4QElpZZxL+v4dtewN+MNOlH79f+v5hyXsY/iK1KmsV97IP1Ft4mFWPZaKmiy
	5vi0zT5OaAveKJJHkZ25s0Q1LBQ1+5de1PQBuAHiCeGSsMuC0N2qjG+KGDB2mZNyjDljJLt5PWDHd
	G0gMDH2Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgq-006xZx-0Q;
	Sun, 16 Mar 2025 09:21:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:20 +0800
Date: Sun, 16 Mar 2025 09:21:20 +0800
Message-Id: <d62feb10e2f79ee3ecd668dcc03f9eb94caeebcb.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 08/11] crypto: zstd - drop obsolete 'comp' implementation
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
 crypto/zstd.c | 56 +--------------------------------------------------
 1 file changed, 1 insertion(+), 55 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 68a093427944..90bb4f36f846 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -121,13 +121,6 @@ static void *zstd_alloc_ctx(void)
 	return ctx;
 }
 
-static int zstd_init(struct crypto_tfm *tfm)
-{
-	struct zstd_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __zstd_init(ctx);
-}
-
 static void __zstd_exit(void *ctx)
 {
 	zstd_comp_exit(ctx);
@@ -140,13 +133,6 @@ static void zstd_free_ctx(void *ctx)
 	kfree_sensitive(ctx);
 }
 
-static void zstd_exit(struct crypto_tfm *tfm)
-{
-	struct zstd_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	__zstd_exit(ctx);
-}
-
 static int __zstd_compress(const u8 *src, unsigned int slen,
 			   u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -161,14 +147,6 @@ static int __zstd_compress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int zstd_compress(struct crypto_tfm *tfm, const u8 *src,
-			 unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct zstd_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __zstd_compress(src, slen, dst, dlen, ctx);
-}
-
 static int zstd_scompress(struct crypto_scomp *tfm, const u8 *src,
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx)
@@ -189,14 +167,6 @@ static int __zstd_decompress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int zstd_decompress(struct crypto_tfm *tfm, const u8 *src,
-			   unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct zstd_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __zstd_decompress(src, slen, dst, dlen, ctx);
-}
-
 static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			    unsigned int slen, u8 *dst, unsigned int *dlen,
 			    void *ctx)
@@ -204,19 +174,6 @@ static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __zstd_decompress(src, slen, dst, dlen, ctx);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "zstd",
-	.cra_driver_name	= "zstd-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct zstd_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= zstd_init,
-	.cra_exit		= zstd_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= zstd_compress,
-	.coa_decompress		= zstd_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= zstd_alloc_ctx,
 	.free_ctx		= zstd_free_ctx,
@@ -231,22 +188,11 @@ static struct scomp_alg scomp = {
 
 static int __init zstd_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret)
-		crypto_unregister_alg(&alg);
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit zstd_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

