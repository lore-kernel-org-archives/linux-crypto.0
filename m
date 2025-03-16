Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5B2AD2D
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088079; cv=none; b=LEzfZn6aU1lg+FCxcO5I6GuqskQRMf791JaMAYrBMKitdw8+jmkcTh2gACKTSVmcFiKcoQmJJP4VhpcRovYES74m3Ywe+jO6GK5TMNcMEpvg2qmo+QAvnbVPzMsHB+46+G8VnIO1jewpoJNjSOKDw4iSiJSRKdYUekM0c42SFeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088079; c=relaxed/simple;
	bh=PZ/wM7DG1Zjv6bB/At3Aq6I3A5YVmjGCsbbh0Qu3fjY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=J36dBYtKsyoRN5yQeU43QrTeia5WzLGE8kbZcYH3adORWCQDxyqO5FWHjr2PaBpQfzU6TsIbQncusJ9MxunJTgGvdnUiitA9rJLtk7wtV7Sz0DuS84Nu2/gNq2EkQRtjPCeaY9q0ukkZ9mrxg/B1RcK1NC6Yv7UvJ8uA0OrC7vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n0LWqARt; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n0LWqARt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YALxWkD1hxy4q5AflIpe5f/lu6dAM2fRYlBxQbAXhLQ=; b=n0LWqARtArVwJfzs3MD86zyzJk
	jpBgOWUM6Xc5taEwDBsEV4KfVIJkYhNW6jYZlMOYx64j/woTz2YrCNEfpyOxmzohCj8X1G0pN30MN
	gfs70/X8BAU/jGaexXe7pkt4avzPNG7Q8e/OrUH/y6HhJ3eZYKjWHkmycNSmoHF3T6EUCyVLLN1uB
	GGeuz95oNquv+uWZ4OSBftUBZMilVHq/WhbDGHbx/7TtGLd4B+rqe7Pq3rjAt/9piuEqAMt+A16P8
	yZzZuof5F6Q3RmEIsFJ/hc7xO0t6hI1Yeop2l2/EN0zEZ3h+DoKYkC/5BOl+fPDpBObot9MVak9AY
	OtQ8wTzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgj-006xYx-0h;
	Sun, 16 Mar 2025 09:21:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:13 +0800
Date: Sun, 16 Mar 2025 09:21:13 +0800
Message-Id: <48edc2e240f811a699b155683dcca6507c19b796.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/11] crypto: lz4hc - drop obsolete 'comp' implementation
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
 crypto/lz4hc.c | 66 ++------------------------------------------------
 1 file changed, 2 insertions(+), 64 deletions(-)

diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 25a95b65aca5..997e76c0183a 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -4,12 +4,11 @@
  *
  * Copyright (c) 2013 Chanho Min <chanho.min@lge.com>
  */
+#include <crypto/internal/scompress.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
-#include <crypto/internal/scompress.h>
 
 struct lz4hc_ctx {
 	void *lz4hc_comp_mem;
@@ -26,29 +25,11 @@ static void *lz4hc_alloc_ctx(void)
 	return ctx;
 }
 
-static int lz4hc_init(struct crypto_tfm *tfm)
-{
-	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->lz4hc_comp_mem = lz4hc_alloc_ctx();
-	if (IS_ERR(ctx->lz4hc_comp_mem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void lz4hc_free_ctx(void *ctx)
 {
 	vfree(ctx);
 }
 
-static void lz4hc_exit(struct crypto_tfm *tfm)
-{
-	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lz4hc_free_ctx(ctx->lz4hc_comp_mem);
-}
-
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -69,16 +50,6 @@ static int lz4hc_scompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4hc_compress_crypto(src, slen, dst, dlen, ctx);
 }
 
-static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
-				 unsigned int slen, u8 *dst,
-				 unsigned int *dlen)
-{
-	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __lz4hc_compress_crypto(src, slen, dst, dlen,
-					ctx->lz4hc_comp_mem);
-}
-
 static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 				     u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -98,26 +69,6 @@ static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
-static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-				   unsigned int slen, u8 *dst,
-				   unsigned int *dlen)
-{
-	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
-}
-
-static struct crypto_alg alg_lz4hc = {
-	.cra_name		= "lz4hc",
-	.cra_driver_name	= "lz4hc-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct lz4hc_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= lz4hc_init,
-	.cra_exit		= lz4hc_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= lz4hc_compress_crypto,
-	.coa_decompress		= lz4hc_decompress_crypto } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lz4hc_alloc_ctx,
 	.free_ctx		= lz4hc_free_ctx,
@@ -132,24 +83,11 @@ static struct scomp_alg scomp = {
 
 static int __init lz4hc_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg_lz4hc);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg_lz4hc);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit lz4hc_mod_fini(void)
 {
-	crypto_unregister_alg(&alg_lz4hc);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

