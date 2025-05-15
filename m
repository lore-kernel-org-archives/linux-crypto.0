Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7C4B1E71
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288486; cv=none; b=P7XCN1Wq1N7wa0dR88L3m+flfBaKbrk58P8vkwSFHIzThvxbbx9HWjwWkz5DEZ8Bitc/TVFNoaz/ZbjNcMxfDN9bUuvrbaOKT/9ImRGH/w0dU9Dpkvep5pSdOhIVQeIQGSmtOpSlZBktKc+Y76L40ubDgRrBo48u29KkbagCgQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288486; c=relaxed/simple;
	bh=OEtrYjh+OnXnBeVDlTZkPiZOK3YV9DDwJd7JqbiNGNg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=L7OBwc3tnTke6Zp0boNgh469QFS6mRdjMH+60OgSLxq85HBgIKlqnN6FMP7sj1coUXuoQLNRb5rh8U9wZl+X2yJHVO3CgxeBoTj52IQfy4qTwqmvpGzul6/8Jh3POU/vH8KPH0RqHR2ceF+cKlkkDsGmsG9RP5worRSm+QSo/f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VFxF+1nC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VFxF+1nC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fIgqEnX3h4ql/3S6yRDsAqYNc6fg5z5m6YGDMX2ixn4=; b=VFxF+1nCd4WFKNLUiVCSoGaaK8
	USsLAV7t+n+w6DNl1LU6saDQgO0AMkq39bWgcnvng8TU0KTIEwiJVUsqq80M3hXXmfuCQCCsvRD9N
	5Vm8MQJXpiqIXNXLHeoe3XVPBiUN0+uFrO468gDMfrnJU9u5ZU/iX6Er+FuHAzuEdqVyj/GRaUssA
	mKmhbDUxZzbceeqe+1PgW0EU43x7Ke7IOUJZmfHW4ZgHuEkzN/jwAYfHYGLKjArAqCuvYqi7XUzzz
	9Hm8I7UQawJtZufdmenuo0YH4YTa8G2C5MioEYjPlmgLWkt0slMUtugeKPaMjSpjOemcddAj66Lbc
	dEUz6+NQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYG-006Ebl-0V;
	Thu, 15 May 2025 13:54:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:40 +0800
Date: Thu, 15 May 2025 13:54:40 +0800
Message-Id: <fe45532f288acb605e09ce3445e07b52528b560e.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 04/11] crypto: hmac - Zero shash desc in setkey
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The shash desc needs to be zeroed after use in setkey as it is
not finalised (finalisation automatically zeroes it).

Also remove the final function as it's been superseded by finup.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/hmac.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index ba36ddf50037..4517e04bfbaa 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -13,13 +13,11 @@
 
 #include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
-#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/fips.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 struct hmac_ctx {
@@ -39,7 +37,7 @@ static int hmac_setkey(struct crypto_shash *parent,
 	u8 *ipad = &tctx->pads[0];
 	u8 *opad = &tctx->pads[ss];
 	SHASH_DESC_ON_STACK(shash, hash);
-	unsigned int i;
+	int err, i;
 
 	if (fips_enabled && (keylen < 112 / 8))
 		return -EINVAL;
@@ -65,12 +63,14 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^= HMAC_OPAD_VALUE;
 	}
 
-	return crypto_shash_init(shash) ?:
-	       crypto_shash_update(shash, ipad, bs) ?:
-	       crypto_shash_export(shash, ipad) ?:
-	       crypto_shash_init(shash) ?:
-	       crypto_shash_update(shash, opad, bs) ?:
-	       crypto_shash_export(shash, opad);
+	err = crypto_shash_init(shash) ?:
+	      crypto_shash_update(shash, ipad, bs) ?:
+	      crypto_shash_export(shash, ipad) ?:
+	      crypto_shash_init(shash) ?:
+	      crypto_shash_update(shash, opad, bs) ?:
+	      crypto_shash_export(shash, opad);
+	shash_desc_zero(shash);
+	return err;
 }
 
 static int hmac_export(struct shash_desc *pdesc, void *out)
@@ -105,20 +105,6 @@ static int hmac_update(struct shash_desc *pdesc,
 	return crypto_shash_update(desc, data, nbytes);
 }
 
-static int hmac_final(struct shash_desc *pdesc, u8 *out)
-{
-	struct crypto_shash *parent = pdesc->tfm;
-	int ds = crypto_shash_digestsize(parent);
-	int ss = crypto_shash_statesize(parent);
-	const struct hmac_ctx *tctx = crypto_shash_ctx(parent);
-	const u8 *opad = &tctx->pads[ss];
-	struct shash_desc *desc = shash_desc_ctx(pdesc);
-
-	return crypto_shash_final(desc, out) ?:
-	       crypto_shash_import(desc, opad) ?:
-	       crypto_shash_finup(desc, out, ds, out);
-}
-
 static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 		      unsigned int nbytes, u8 *out)
 {
@@ -222,7 +208,6 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.descsize = sizeof(struct shash_desc) + salg->descsize;
 	inst->alg.init = hmac_init;
 	inst->alg.update = hmac_update;
-	inst->alg.final = hmac_final;
 	inst->alg.finup = hmac_finup;
 	inst->alg.export = hmac_export;
 	inst->alg.import = hmac_import;
-- 
2.39.5

