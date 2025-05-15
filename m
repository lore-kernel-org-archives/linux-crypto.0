Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79629616C
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288490; cv=none; b=MbikpAQDvPPZveMglNYLx3nMGs4/xjs5/nbGaodb1ERWV7nfRvPw8HcqRKhRhHpUO1WZ3rx1vFYPxn8P4bOCzM2nDtnaB5qRQtyFNODZD+GFWYKfnFknkJZUpzkCrKrlDYhvCSysYV951Onuz7U4eqrMinoWhfzgBXr4StSNLL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288490; c=relaxed/simple;
	bh=CggDUZZ3Rg6NschhxywR7eHTZpZ0wiPSBuYXuH/NW3U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=K1AmzSojCyFLNPLU6gJdA1ke19qgP18v8bwrBHqtI3hNnFE9G2sGmvuCFXs/Tj9R1cHPQxhXmjf2oHs1+0p1xi1uKD3LR4c+rqAucHUIxIREzSNBfRh2JlJfhsovttZXdfLPAr40M7Pw/P1xjLRH1g0TuMVZ3wzhBLuQvjFgYMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LfAGQwQJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LfAGQwQJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LvDpq1k220Eyavl+82y8qrgK0eIpA441buPEHXaxAiU=; b=LfAGQwQJd8V6pXzGKwWHavdY15
	osUIQTX2B7NEzhyAHuJAFnAplB7PuRUU/KoPpxNUQYel0TX8UvfNCK5URyAYrUcJ9Xs3HcNub8Xb8
	Gcf69/I8/N1XjCqAC8bCkfL9DWQYjvlH6ooKI8ItOt0T1MFo00KhKtoPFkJ38D46gcPoCsIUNQNIl
	VNX/xbT+dr/RuLGsxPeRVkT5ipBGeF6iSGyyMUsvMB1xQzcO51TwwNqeZu55pg3AwYXvFGFQni2C9
	gxtcJV/OLTEm4JAXnrj3WCLdyfGFLGuzkkAP0p+W2J+hmnxDkokbHMDIKo0j+4wqO0nP43eP4IbK7
	g0AH/sEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYK-006EcV-2m;
	Thu, 15 May 2025 13:54:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:44 +0800
Date: Thu, 15 May 2025 13:54:44 +0800
Message-Id: <fd7a42ad4da30a7f9020d1095554a4a4272f40d6.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 06/11] crypto: shash - Set reqsize in shash_alg
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

