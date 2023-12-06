Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8C2232A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815814; cv=none; b=tP3rM2AP5uStIMSc6UlbOJzJXH+o8iRb/zJaVM5eELZxWp22ChkqYxvxMOa7gdNhiO8Kc/dWkeojM6cZporMBfBxr65nzUYAmW+7OQvQEOykBJ5+zV0iglOj2ai60ORUwCxhqa7t0fVmDPXYDrW3+pk8FT1xsNCbUmkZS5n6ZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815814; c=relaxed/simple;
	bh=9Ak7H/5KVfRgBEwSFXs6FAoNW/zABl3zisZ6vfxE7YU=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=KD4LDFgAE3MBpJVVzJwQll7lQI6dT67xNbtZHahcMaZnZmZ6O1AAtq2Nb+J5KLEZX8qHnx43/wiq8OxcsYrd9qXAWJsdJH4XXyTcYKM3WxmMozakanXvPXJSZp9HO0uJLE/+vdmZw/xB3H5fOSqPW8RhHhMUXY2orPBMDO9bRFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouC-00D1rI-TT; Tue, 13 Feb 2024 17:16:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:58 +0800
Message-Id: <5c621b286eb6138151c467b07c3e713af1e27910.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 6 Dec 2023 14:05:16 +0800
Subject: [PATCH 10/15] crypto: skcipher - Move nesting check into ecb
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The lskcipher simple template does not allow nesting.  The intention
is to prevent instances such as ecb(ecb(aes)).  However, as the
simple template itself can obviously be nested (e.g., xts(ecb(aes))),
move the check into ecb instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ecb.c       | 4 ++++
 crypto/lskcipher.c | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index e3a67789050e..2b61c557e307 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -189,6 +189,10 @@ static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (cipher_alg->co.ivsize)
 		return -EINVAL;
 
+	/* Don't allow nesting. */
+	if ((cipher_alg->co.base.cra_flags & CRYPTO_ALG_INSTANCE))
+		return -ELOOP;
+
 	inst->alg.co.base.cra_ctxsize = cipher_alg->co.base.cra_ctxsize;
 	inst->alg.setkey = cipher_alg->setkey;
 	inst->alg.encrypt = cipher_alg->encrypt;
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 10e082f3cde6..8660d6e3ccce 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -636,11 +636,6 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 			     "%s(%s)", tmpl->name, cipher_name) >=
 		    CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
-	} else {
-		/* Don't allow nesting. */
-		err = -ELOOP;
-		if ((cipher_alg->co.base.cra_flags & CRYPTO_ALG_INSTANCE))
-			goto err_free_inst;
 	}
 
 	inst->free = lskcipher_free_instance_simple;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

