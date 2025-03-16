Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB3428366
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088074; cv=none; b=Ob7jpSM2OMzKvJS/lkb/MstOcoFRZCHSBzKWIIhG7gtKPJy950HmHYbIiKnGGPCARA5F1auyJwD7Pqigfe0aYhE/egacjDVDQwIykPdSs7lTTXWaqr9pkGMq9oqMuV9Yo76gYkwmmhn1IREcFhJBbwVzUqIpkTDRjj8+tpRhfB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088074; c=relaxed/simple;
	bh=0qeCDuwDjUInxtG+RLgoJAu+XUjRVqI9KVOIR6LLbMw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=IXsf8pp0iixouVrF0RRkuLdrlA+rH6b0XBuXdvV2WbPXqQBMdl0+RAQPJl5rWYmD7oYeWPAFEjSNe/6+PKUHUvaXBDvgtj4juDPNGfSDix7L+mPDpJWAbtRP5SVh3F3Sp9DSKx8xGAlrb3ijyXtrluIG/PBWmjqpvIe5L1C4o4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DDmpUExj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DDmpUExj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+JGvVLBj32PYZhDS468IFfO0K4N3h+A1P3EUPvLKmSg=; b=DDmpUExjMtO3tfAQVDihZaQiXF
	2UxEEqzWeQxCaZ4IgwiurEi2ijRJp4Jwy1KC3PMiU1ndDpmR1z8dfSt26J0wPXuFpzt01oGlu9kXf
	S7wKDGptx16mcRfeO+O7BQkMQFoCiYCIPL9DL0+v/EGPqG8HSbo5aub790xE0+CuUnvEF4qq32oMj
	9TtPbCy2FRfn45aiqhXKwyagHFQQmT8O5l2ei/yEtZcKWrjIvdDivnCqHXgok8RAjSudqCGxO9xi4
	jHAObe21nwLAIj61LaNcnvwGLKzSjX5rmE8s37pqFeRiK7ccHFbdrfMe5MC2DZh/1JSjUi//UjRac
	CFYi7Tww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcge-006xYY-1w;
	Sun, 16 Mar 2025 09:21:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:08 +0800
Date: Sun, 16 Mar 2025 09:21:08 +0800
Message-Id: <9ce438ef6ad005bf95e77916da3dc0b292faab62.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 03/11] crypto: deflate - drop obsolete 'comp' implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

No users of the obsolete 'comp' crypto compression API remain, so let's
drop the software deflate version of it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/deflate.c | 58 +-----------------------------------------------
 1 file changed, 1 insertion(+), 57 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 1bf7184ad670..5c346c544093 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -130,13 +130,6 @@ static void *deflate_alloc_ctx(void)
 	return ctx;
 }
 
-static int deflate_init(struct crypto_tfm *tfm)
-{
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_init(ctx);
-}
-
 static void __deflate_exit(void *ctx)
 {
 	deflate_comp_exit(ctx);
@@ -149,13 +142,6 @@ static void deflate_free_ctx(void *ctx)
 	kfree_sensitive(ctx);
 }
 
-static void deflate_exit(struct crypto_tfm *tfm)
-{
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	__deflate_exit(ctx);
-}
-
 static int __deflate_compress(const u8 *src, unsigned int slen,
 			      u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -185,14 +171,6 @@ static int __deflate_compress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_compress(src, slen, dst, dlen, dctx);
-}
-
 static int deflate_scompress(struct crypto_scomp *tfm, const u8 *src,
 			     unsigned int slen, u8 *dst, unsigned int *dlen,
 			     void *ctx)
@@ -241,14 +219,6 @@ static int __deflate_decompress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_decompress(src, slen, dst, dlen, dctx);
-}
-
 static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			       unsigned int slen, u8 *dst, unsigned int *dlen,
 			       void *ctx)
@@ -256,19 +226,6 @@ static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __deflate_decompress(src, slen, dst, dlen, ctx);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "deflate",
-	.cra_driver_name	= "deflate-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct deflate_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= deflate_init,
-	.cra_exit		= deflate_exit,
-	.cra_u			= { .compress = {
-	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= deflate_alloc_ctx,
 	.free_ctx		= deflate_free_ctx,
@@ -283,24 +240,11 @@ static struct scomp_alg scomp = {
 
 static int __init deflate_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit deflate_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

