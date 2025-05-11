Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D31A08A6
	for <linux-crypto@vger.kernel.org>; Sun, 11 May 2025 09:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746954583; cv=none; b=VXUPy+nAhtPlAm6xVpvNSwKFQ8o6O4CLtunAIzn0hssMUfMCzG5d5bH59TapGIPSh3/8GxY4n9e6gwALrBD2AHAXVyYPu9LhO2Hnnb/jlsxluzPn7eJfGs/CeSGaUrmCtVPmcAygZ7HwzUAQJB7Vg00qHzNGNRrVsayjEUcj1Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746954583; c=relaxed/simple;
	bh=9tWgCCNwY+gnw3L+QWy6wpABYFI2a3P8NYtGBFSdLmg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=id2RDgUD72+6bglELSSOt3hJ4jefaWhtEK5ByZLQHlot9RNXBNp9vNuVckrwY0UVoDzlDfkWQKlOqigFh7qPHwRXXFwZc9wU1Bt5RCDhy6lgzb/qsKZDYN/3a5ZIUtJJD+ItpwhhESMdV19WEws1IFYLmneGqwET3zfB17rJzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fWX5njCb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fWX5njCb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CGAbShIUEA8/KbiKCV87SA1/aAXSgLsxqitpuP7LbaA=; b=fWX5njCbaM469+z2wjdGR9yYGw
	3X7xz76cLmeWIdzdrl5E4y2sUZYImpIo4CihCCfLaLvQgRcx+KV3axqba6n0jZzDk6kwoyiIIcSkq
	TXbJGzCliMzXjT3ZOp3FNbWTlxiMjsGEhH389w9+8/OOYIUm+caY/dP1xupxRSdCWKo8JR2KizmDp
	FVUsPQQdi38skS1yfW/QiOUEPFu4lQtvgOdYkJn4ArUNbh893M+9yuN6PIQkUy9J+EinpOXIx9hYH
	vWoSsMFgZ9HsV7T9MzQMbbtVfIFRwUxsrhWiYHUyWWijqxQaMxlVIfhPB0arz62S3V0ZoKisngbFj
	chvUbkqA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uE2gk-005CPY-1R;
	Sun, 11 May 2025 17:09:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 17:09:38 +0800
Date: Sun, 11 May 2025 17:09:38 +0800
Message-Id: <7cdd299b7111b6218042f6e50118812452db6a73.1746954402.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746954402.git.herbert@gondor.apana.org.au>
References: <cover.1746954402.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/6] crypto: shash - Set reqsize in shash_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Make reqsize static for shash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 1 -
 crypto/shash.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index c474aad88f68..8f0215b2bfc4 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -286,7 +286,6 @@ static int crypto_init_ahash_using_shash(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
-	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index dee391d47f51..dd3b7de89309 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -483,6 +483,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	if (alg->statesize > HASH_MAX_STATESIZE)
 		return -EINVAL;
 
+	base->cra_reqsize = sizeof(struct shash_desc) + alg->descsize;
+
 	return 0;
 }
 
-- 
2.39.5

