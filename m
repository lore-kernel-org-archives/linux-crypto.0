Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76A231CB1
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021277; cv=none; b=Vlgx4RH/gBzvUw8cVB3fsoS1NKnTRPHluW1y1oyt5wWwZrkYmFfEOhb8momeTyHmo87HHA7I2x+RzqxL9qfh73zDf0eZrRgA+y5TlsLYUkoEEhI6ZDMiVNNY9rDCMlovewg/zFBOftWFUtamcag207eIqicb/vhLQseJA3t9wXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021277; c=relaxed/simple;
	bh=URGOOPMPuEmN0woASfDItr4J8Xl/wlRxVryJ99II2UA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=TvcEirZSngHOMZQX84aTRJSdY+5zXrCGSJSeAEW57iLwZQEbh1VSaogqoL3yIoMMjdSM4QPIId1rKGti/2bumANqRI2CjF3eMETsnbezSvAEh9KOlVVYL643s+frAj2LMG9XDN5LPk0dn585J+yK2L6oYAmy3AZEtJn5+dUZizo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YPOehdFH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YPOehdFH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KN8MzGXwX3i5I2knxUFiz7FggD6oVD9Kp+wiKNw5MB8=; b=YPOehdFHimRzrRo9Y6mLI03B1v
	/34Nmt1O4i+zir+CIoe5MBovOYtXsE3isX4heMrmcz21OyEJfjpXOFP49QTL/CQGJ1YT5ogzE7/x2
	Jx0cGoh9FgktFwMpFRkpgUZ2DpccPL2NIFYBhXCK173pstJ+Gd61z5MtXZ8m6xWj9xQhBcWwCvgSq
	+VJxaemgGsUomKQohZRexYO9h/HRXWNZ/MFEsPAOovE4GW5kLQZ3uATQx82csnaoyQhRkeaJvDxW1
	rwinzUVMk1cHLc37esltBmuJ8oKPxdfU7FGF3P/hVT66Vwo1OfI4ru60wd9RjevqMWVoVvB9re61e
	hmRVprTQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jbL-00DTa9-1C;
	Mon, 07 Apr 2025 18:21:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:21:11 +0800
Date: Mon, 07 Apr 2025 18:21:11 +0800
Message-Id: <3ed884e168b4e8de7ef647e96cecbae6c47698a2.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/7] crypto: ahash - Use cra_reqsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the common reqsize field and remove reqsize from ahash_alg.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 4 ++--
 include/crypto/hash.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 079216180ad1..ad3f1e011a69 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -723,7 +723,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
-	crypto_ahash_set_reqsize(hash, alg->reqsize);
+	crypto_ahash_set_reqsize(hash, crypto_tfm_alg_reqsize(tfm));
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
@@ -889,7 +889,7 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
-	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+	if (base->cra_reqsize && base->cra_reqsize < alg->halg.statesize)
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index c14a3a90613f..a80dfa57656f 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -135,7 +135,6 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
- * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -152,8 +151,6 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
-	unsigned int reqsize;
-
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5

