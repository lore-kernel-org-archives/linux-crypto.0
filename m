Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD7226527
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214566; cv=none; b=mwnTBXZ73aUDmrHIkIeMPIUI0Le4B49nLAZiGeGY0VuA6PZdipveWjyoOW6K2VzZkU2ox7Go9m6Ib1bfO7apEzGSyeBI5bt1rrSq/LBYS66VqcZhHeSSE0cQ+KEChnqdbmGTB7LN+evTJQb1XBJPXOh8lk+AWrBQBob14aedzfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214566; c=relaxed/simple;
	bh=CggDUZZ3Rg6NschhxywR7eHTZpZ0wiPSBuYXuH/NW3U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Plp2L06FjE/EJnVG7y4KLdaSCrUz2yyKikKwILowUPNXpG4FuIikSFAdcnvkAcftgFru6RELlXexkB02sp2Hptvnf6g3d47GdkGm4RXlCss7d9oOKjNhzK5zU+gC3zrkIg0H5tjSrsaLQLVhFaytC+ikmPTz0nvHh2YSrwtUSy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=H7kBcPE3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="H7kBcPE3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LvDpq1k220Eyavl+82y8qrgK0eIpA441buPEHXaxAiU=; b=H7kBcPE3CkML/DUr86bm9B9URk
	qVJxbZ6juddhtdT32qx8IQspbD7VAYtBru8mM5HIgWjSbYFbtEqbUWEp9lQ7NPSBb49/MugVe1vUx
	OXEW1huabuuIuv3AW9aiF3Loc3quA8rRAJuOq6fEG0zEyX5pxkFxkBmAcVhxbPDteHsQAcp/V6s8e
	RMouczbrSvXT1E+6hJ/4fQb/unP9Eo015j2psAPBbvNsBxF2Sl5LWdvCsJnNO/N6EcqupqBhAJR0v
	YVQHvbpPOaRJVuMA15DuTF42sRN/dHBfpQ3TtU97x2tp1c+DWYJdKn0eZNErXRuNsxGX2h0EfGVov
	pcc0PUfA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8K1-0060Kg-0A;
	Wed, 14 May 2025 17:22:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:41 +0800
Date: Wed, 14 May 2025 17:22:41 +0800
Message-Id: <0bf80da692aa96dfb89ff94c7d9a2a4f03ecbd34.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 06/11] crypto: shash - Set reqsize in shash_alg
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
index cf8bbe7e54c0..bf8375bb32c9 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -286,7 +286,6 @@ static int crypto_init_ahash_using_shash(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
-	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index 5bc74a72d5ad..37537d7995c7 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -511,6 +511,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	if (alg->statesize > HASH_MAX_STATESIZE)
 		return -EINVAL;
 
+	base->cra_reqsize = sizeof(struct shash_desc) + alg->descsize;
+
 	return 0;
 }
 
-- 
2.39.5

