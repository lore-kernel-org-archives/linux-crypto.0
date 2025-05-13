Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33A77DA93
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116239; cv=none; b=sSL44kLEh4lmTFYldNUumk/wPs9Wp93HflM8YOPZG85oRUXSio/NIOHyHTcS/LAL6SgDZ2OelLWBBJlNujQR27pdvreIZ53yxZf1U12uk3uQL+bASIjGbQT6BWlxZZuxD5DVS2kG2gwMdmMptuIxmfFxDkE/Ii9fHJ3JrV4g1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116239; c=relaxed/simple;
	bh=uSVeXeccOdGfKhG0iE5HadTiaRQA8oz68+np6d7O5nc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=kScatg35U51sCqfUcB03HoNKnyQXyy0oFVBaD+LnJae1+RmUG78XCzN7tnqnxfGiB2nYPeF3MGFD5BW+go8Zzht+j520dgXNzjudt+d9yAEWAuFJ097zwCe/PxXJSu80UoX+0KX0MbANcUAe6QWt1RF7/TjbT5HFcngyHOiUXOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OYLFLiKe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OYLFLiKe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g5TyIwjCBw1+nLoen01HIIVGROBiFVaqY1TIdUAEmyU=; b=OYLFLiKeUNWggRDoB/iPzRELlN
	P7Cjy+3h/SABOv8UFh9KCC+JSt8a+0ZA8PvxCI3eFAoS8xzaUfBPGUzxQTkl2cPFDcP5J9rVl24ZY
	ftYNv2Qr24c/A6YUL9I2JUuSR97n5w89aEnfg+hDRPA1RxOGnQSxOCj9GUvs6DLo2d+ur7J61s2a1
	w4y0Z+njJR7M0yHQ+njnte0v4e3yv2dBVgrqvbtwAHmnHv95Xy9LLycTBl81ZNBriZuyladmrSAYF
	rGpzHtQGDbTJKX/Q9oYgf7zpx0NlV9aJP7eHAN83ddDVA53atc0lvc9LyxKy3z/Ba3BjsD/toOPsK
	fhLy/wGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEik4-005g4f-2F;
	Tue, 13 May 2025 14:03:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:52 +0800
Date: Tue, 13 May 2025 14:03:52 +0800
Message-Id: <03bd7038c76f33a0cdb76a13ca8b377c0b6c5a3a.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 03/11] crypto: aspeed/hash - Use init_tfm instead of cra_init
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the init_tfm interface instead of cra_init.

Also get rid of the dynamic reqsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 0bcec2d40ed6..4a479a204331 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -660,18 +660,15 @@ static int aspeed_sham_digest(struct ahash_request *req)
 	return aspeed_sham_init(req) ? : aspeed_sham_finup(req);
 }
 
-static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
+static int aspeed_sham_cra_init(struct crypto_ahash *tfm)
 {
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
-	struct aspeed_sham_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_alg *ast_alg;
 
 	ast_alg = container_of(alg, struct aspeed_hace_alg, alg.ahash.base);
 	tctx->hace_dev = ast_alg->hace_dev;
 
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct aspeed_sham_reqctx));
-
 	return 0;
 }
 
@@ -703,6 +700,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -715,9 +713,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA1_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
 				}
 			}
 		},
@@ -734,6 +732,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -746,9 +745,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA256_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
 				}
 			}
 		},
@@ -765,6 +764,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -777,9 +777,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA224_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
 				}
 			}
 		},
@@ -799,6 +799,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -811,9 +812,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA384_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
 				}
 			}
 		},
@@ -830,6 +831,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -842,9 +844,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA512_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
 				}
 			}
 		},
-- 
2.39.5

