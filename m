Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AB1AAA11
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454871; cv=none; b=OkaVYTGQ7/owHc6mlae3KzeHH5kgdNixELrFc2Y5KLuiMK5Hr417ZqR7Ec+gEv4S8pvHA4EHiiLGn0UJM1dbIkQs6UkE3VD2FfQYChn9g1nVnWG7rKzqaJ25vZ7kCKA5itbZN02Spe5UMCEiCjuUOkq7w6RiX/IerahzecR9zT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454871; c=relaxed/simple;
	bh=5jpqMz0ZERVZRLORajejVqnY59jYGmamdO//uHzO90Y=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bHtBrtSa6JQ3aT5qY0OaM6CZaf/wS+ppG0IY3UgAQkvCzTWGJu+5UzOpF49Uy838GvtMf61m4IEzPVX7jxowdSTPg+fGC9xwabXtfE3QDLy78Q+GiHgsfjqkfEANPtuidj2iTtwAL9pU4p1jCZszXNuYAOaNCzAM2QG5+OgINlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EMoH7fHx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EMoH7fHx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a1c0u2uGh9l/U4ooJEjJ8n2q1P8tLczI++dE7psnttA=; b=EMoH7fHxS5QPV8REimWKkBmKqT
	VbkgMHw4BAxxCesRvh7Ms2ZpbrVM8vQXyQAIGlB8v+tN/werHaJfNt0Ge9JgCkEEkYdSoa0Vrkzn2
	riH4gY4lgPU5rPoLMooUyKcQsB4YFUIy4dOpOvLdm6gsH+wekyA7ZeEE7RNHk3H8jNgqljXwbQXO+
	haFpG1EhEyVYqLScxJv/R6akcGgKkM0DonrAj4boQ9YO0G2i1vQrxjxgod6CBpFx1N1HRVUCpEusJ
	EkE9VzQIbfdWc8QTov9MskYZxB6jc3UeW2tJxQod+2aemnXc0YOldtEl+cKISmt3U3Oouu7F4Rgaz
	d3lV9yLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YOn-00F5E8-02;
	Sat, 12 Apr 2025 18:47:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:47:45 +0800
Date: Sat, 12 Apr 2025 18:47:45 +0800
Message-Id: <5503c7d841a5403915646a669cdc59f25fd8bd7a.1744454589.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744454589.git.herbert@gondor.apana.org.au>
References: <cover.1744454589.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: hmac - Make descsize an algorithm attribute
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than setting descsize in init_tfm, make it an algorithm
attribute and set it during instance construction.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/hmac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 7cec25ff9889..dfb153511865 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -146,9 +146,6 @@ static int hmac_init_tfm(struct crypto_shash *parent)
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	parent->descsize = sizeof(struct shash_desc) +
-			   crypto_shash_descsize(hash);
-
 	tctx->hash = hash;
 	return 0;
 }
@@ -222,6 +219,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	inst->alg.digestsize = ds;
 	inst->alg.statesize = ss;
+	inst->alg.descsize = sizeof(struct shash_desc) + salg->descsize;
 	inst->alg.init = hmac_init;
 	inst->alg.update = hmac_update;
 	inst->alg.final = hmac_final;
-- 
2.39.5

