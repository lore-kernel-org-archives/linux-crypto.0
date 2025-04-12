Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35EF1C862C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455462; cv=none; b=VAI7Urh1omgvhMawCQ99gS5taXlWoxqTV9+YOxMpcnTBEyF8LaCMHBS4f2R9V/SCWVI4il3ZgEzrsbgPvR/+ZGpmb02GoFt9g6+fX7ryKTqBnw28GUzKVpsG6iQXWi5kA1Wz23QXdkZ+xe3q1IIzcIYCTcJsdR70C6jvD8Dq+MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455462; c=relaxed/simple;
	bh=x+04D51BGwAKirMor+dh+udJI+7znfGSkRayyzJDgtM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=WiuFLGPQlzV1GPW4Vas07R+SLo4hKosapQ6HGspqaKjaNhuF8ASdnBXqNQMl88iRDr2VA6Eu+WDDomiUiHvgBZksiw1BguzHDae4ugt/Z2p4YiUFQBr/ztP1xFfLFh/pgLDyfyyB/Jh36d0r3nbn48jb8jv/aodHZbhCSpoSBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NbG5ReDC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NbG5ReDC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=snn0at3HupIii1fvoyqel7Ht3Az/ClmDHkDuxn217D4=; b=NbG5ReDCwzAyeKu99zK+Hc9tK0
	cGfWIEJBm5QiecGlp/cQ/HyrkpIabbHKRF57tNWDIN6ZxHwKJcrK7IEAuOa6sQRg5vGEp6MQytZct
	I5tFNx61z+lyWIVirUlZEjlvqBbSVVVrmggF5xb7MeP0ZhjSrkgs6+mfWZo6Dc2ehAdQ2B1clyE5K
	Kvu1cmPpaVQ9zY0XdWcBC+LFj0l7ELtJktGup4yLfmotuP29xL3Xjp38uurKcm5RuhftKisDe+vxW
	9wmaFIWaqXdsI82koRGzlI+wojAFhgFuYwax3WcqPiZ460b6uQLLcI/XBXJRyLMLKWjB210VWYWGe
	MVYl2JOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YYK-00F5LY-0T;
	Sat, 12 Apr 2025 18:57:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:36 +0800
Date: Sat, 12 Apr 2025 18:57:36 +0800
Message-Id: <2030fb8be1522fd60c5d5b3dcbb82ffb56ec217b.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: cbcmac - Set block size properly
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The block size of a hash algorithm is meant to be the number of
bytes its block function can handle.  For cbcmac that should be
the block size of the underlying block cipher instead of one.

Set the block size of all cbcmac implementations accordingly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/aes-glue.c                 | 2 +-
 arch/arm64/crypto/sm4-ce-glue.c              | 2 +-
 crypto/ccm.c                                 | 2 +-
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index b0150999743f..5ca3b5661749 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -1009,7 +1009,7 @@ static struct shash_alg mac_algs[] = { {
 	.base.cra_name		= "cbcmac(aes)",
 	.base.cra_driver_name	= "cbcmac-aes-" MODE,
 	.base.cra_priority	= PRIO,
-	.base.cra_blocksize	= 1,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct mac_tfm_ctx),
 	.base.cra_module	= THIS_MODULE,
 
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 43741bed874e..f11cf26e5a20 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -723,7 +723,7 @@ static struct shash_alg sm4_mac_algs[] = {
 			.cra_name		= "cbcmac(sm4)",
 			.cra_driver_name	= "cbcmac-sm4-ce",
 			.cra_priority		= 400,
-			.cra_blocksize		= 1,
+			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_mac_tfm_ctx),
 			.cra_module		= THIS_MODULE,
 		},
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 06476b53b491..a0610ff6ce02 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -883,7 +883,7 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
-	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 
 	inst->alg.digestsize = alg->cra_blocksize;
 	inst->alg.descsize = sizeof(struct cbcmac_desc_ctx) +
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index f44c08f5f5ec..d2b632193beb 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2043,7 +2043,7 @@ struct safexcel_alg_template safexcel_alg_cbcmac = {
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
-				.cra_blocksize = 1,
+				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
 				.cra_init = safexcel_ahash_cra_init,
 				.cra_exit = safexcel_ahash_cra_exit,
-- 
2.39.5

