Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89BC20F088
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746176648; cv=none; b=RDuK94vu0p0W1JgojYqSFLl0hUXfAuqyZAxPPeQm41qT/hmh+71vvHmXXx89+b7goI2xoquJSylM/wInnV9A8YV4iJs25ezU4smNZ6y7rQ16MuYyMYyNSknnwHIoJmhHFo/3V7QYbRIP85nnK45gXnITD5SkbvCX2x0K5W8EW0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746176648; c=relaxed/simple;
	bh=so2Lz7mBkHedkeBNNyDF7eiViz+DLUVidZXRQ56yEc0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=e0i+4FxWzHYfpBjmgjca1/2eZhBPX7OzXQP5eAZ/GLBwrYF3AaZjCpvvR7E6YellASOujoOLHvdXmbdXsVgzgM12FBNJkUivwIFaX1kP6zfxlSpgD27j/Br6KNDUsiJKeVLkQ7CgIXEYUdh6a3+C/9XhzBgRsJPskjHr7CEA/Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HprcNbGO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HprcNbGO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Tl19dpGrL4QNXvMD5O2iyHltmPNju1iv+mD8IQyUn/w=; b=HprcNbGOLcYKUkgYe/KHjPzX2V
	AIsh7jIuusEJV4DJsYDYsfQdO9JUVOHgoEk3XQDbmhYEW2nnRLmb+C+qNqOZP4Bp1r1NFr7iumH2j
	H4vjvYUq2G8gUi0PftBeW+1RnEZhYG6hocFJR/brw2POA8fwIQ4tB0iDsKuhbZR9z66cN9+qrSJbY
	kxXHt5Vo3fpvdb3m6WFlRbI7/f6H1mfj0unxOCiUIczRQwaC6modV4eGS99PDEozbodDhmxUbD0Kg
	ln3m2GAZC5PJab12kLknZICqqETANc2n5rVYKGRtx4pbyWhzqhQTK+b8l5MjLxX9ILcK4CkR60/KV
	YyQrTPJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAmJN-002nsH-1t;
	Fri, 02 May 2025 17:04:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 17:04:01 +0800
Date: Fri, 02 May 2025 17:04:01 +0800
Message-Id: <2e1012848db6e18f538a3917de700b782d0b38d6.1746176535.git.herbert@gondor.apana.org.au>
In-Reply-To: <41f8d44fe2b46ac2e1f0c54e550aa8bffe9e1cf3.1746176535.git.herbert@gondor.apana.org.au>
References: <41f8d44fe2b46ac2e1f0c54e550aa8bffe9e1cf3.1746176535.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: ahash - Enforce MAX_SYNC_HASH_REQSIZE for sync
 ahash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As sync ahash algorithms (currently there are none) are used without
a fallback, ensure that they obey the MAX_SYNC_HASH_REQSIZE rule
just like shash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index cc9885d5cfd2..e3446581370c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -768,6 +768,14 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 		if (err)
 			goto out_free_sync_hash;
 
+		if (!ahash_is_async(hash) && crypto_ahash_reqsize(hash) >
+					     MAX_SYNC_HASH_REQSIZE) {
+			if (tfm->__crt_alg->cra_exit)
+				tfm->__crt_alg->cra_exit(tfm);
+			err = -EINVAL;
+			goto out_free_sync_hash;
+		}
+
 		return 0;
 	}
 
@@ -775,6 +783,14 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	if (err)
 		goto out_free_sync_hash;
 
+	if (!ahash_is_async(hash) && crypto_ahash_reqsize(hash) >
+				     MAX_SYNC_HASH_REQSIZE) {
+		if (alg->exit_tfm)
+			alg->exit_tfm(hash);
+		err = -EINVAL;
+		goto out_free_sync_hash;
+	}
+
 	return 0;
 
 out_free_sync_hash:
@@ -954,6 +970,10 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (base->cra_reqsize && base->cra_reqsize < alg->halg.statesize)
 		return -EINVAL;
 
+	if (!(base->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    base->cra_reqsize > MAX_SYNC_HASH_REQSIZE)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
-- 
2.39.5

