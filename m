Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4278A225771
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214562; cv=none; b=VDRdSa8PO1hCNGayzpVq+NnJ6qgDmV7yV5utHYPzTCAhxq13T7yZ4TPg9p+Mpm6C4a5cKfhRliQ8EYZrasVUSDVw6ZiPjLrWGQ7cj7leMKCiiqiWziNDjO0xyYDjnfC5ouxxKi14vSbYcciKCabSl0wdh2dci9E+OH9phdC6tq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214562; c=relaxed/simple;
	bh=OEtrYjh+OnXnBeVDlTZkPiZOK3YV9DDwJd7JqbiNGNg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=NeBFRcTcKdCQXCb7jvfd0Y0sKiOMYkHeLXO+hzgagm6C7ep/854UWs7cVpupqJK14pn06eL7qFJIpCScQvArMbJBOm2GOA2KGuM40TFpDPDgZQTL1flzEWfo41YgUi5KkTK5Hj4GKnjN5QiyybcvrTmIT7b/V5dUMUa0+Sdt1B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VHg2X7Ah; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VHg2X7Ah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fIgqEnX3h4ql/3S6yRDsAqYNc6fg5z5m6YGDMX2ixn4=; b=VHg2X7Ah2vz1Ab5Q2YiQ1l5rB3
	ZmWKuCq9eOXJOhNxg2KBFz5AqC7YfSa+Xyvcnk3sgjJ8TIQO1k1hfkptM+l8IYZYqjpY0mDHtBLU0
	oetd5Aeu0gEV/NYt6HOzxSJwOAGX7M1UIfBgsps5f/6RdDWmyILj9GQJ21fHyjPX//GEmNvWhJkHD
	QN1yJMP06Od8HBCaa+NkF9L0q4xbqT9uzJhG/fH/NDTGGVM0hpPjPryVsCRJyfKW0D1VKEYIxhsd7
	v+aw5hjPxdjGLnW0LW3eNBHzHrfz8Qh6Rp7kwhERt4dwWU2OkXlf1ZgsPKgh/tSVe2ZR4/r6Df6xx
	9PWXVf2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8Jw-0060KK-1M;
	Wed, 14 May 2025 17:22:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:36 +0800
Date: Wed, 14 May 2025 17:22:36 +0800
Message-Id: <cf30ecb080b8f2529cd74e16d7ffa9f1e685ce9c.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 04/11] crypto: hmac - Zero shash desc in setkey
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

