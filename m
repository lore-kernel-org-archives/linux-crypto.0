Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24324226CFE
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214570; cv=none; b=W5jioq+JUdXjOKo5mPcDr0yyqjnXpcXksNG3XcR7x0YvWt11jwZ2/6gLvtOSaehppyyUs6dTokMKTfe/LRnOcBgMps3glcDr+rWrlHcgxjZeyoXs4Km686ROxYuwlWsBnu7NY8VSJwZobKYuylglCuwj8o31/A9sU+olg39QbKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214570; c=relaxed/simple;
	bh=8oEBjQofC4Smx4r1oKj/hZUudqJc9esNnkIB1iREXro=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=qyNO/Sl42C8uMfWWo2BMNP0/kK/QiHMq29I9GSb9vl+VcYSaAzfYDlaAQs7DZmhBSkla3Z6DoGhTxK2GtBJz4YiTJbxzG0lxPyUVtzBEv7m73B9BdDdqWiJ52w0o3S9QHyKmYT+MjM34UZBLYefo3BeSfAxzPI2DeIVEkGnC8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V7Wgol0H; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V7Wgol0H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e1ioazZsYFSNe2fQXe0uDU15CY88bAeWSQiwvQso4aI=; b=V7Wgol0HxMkNJZoV3dOECDrm42
	ir1lko6qsotKkCMnDHZQoUTCog0wk7TsATUxu3x/gJwsBuFbdXsALnlHLega2ZgFRdeiNv5xo+SzM
	0twH/a0+rMhl2RTcbD0RnQlAmSsol6qvorflzcSqWQaO4bO4zspGaX/RyWqWLnlp+JWyj3EyBpb8R
	MP/nYVNcRymUzGbjONfuCzjuyM9Z//CSrRJINbW6kVnZJQFVJWYuTWvtjlJrREh36Mp+IVHms40P9
	ie06jzMrnYgtq/EFkWY9U9hn+A7P+odoc/C0wg7b0azaOaOe3moycHBW2Y9qv5s+iESOYV5eGc7wt
	J4Wkdl+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8K3-0060Ks-1A;
	Wed, 14 May 2025 17:22:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:43 +0800
Date: Wed, 14 May 2025 17:22:43 +0800
Message-Id: <c42b410c937c40068b34ff0950ef90b052a7a5b2.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 07/11] crypto: algapi - Add driver template support to
 crypto_inst_setname
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add support to crypto_inst_setname for having a driver template
name that differs from the algorithm template name.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c         |  8 ++++----
 include/crypto/algapi.h | 12 ++++++++++--
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 25b5519e3b71..e604d0d8b7b4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -923,20 +923,20 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
 
-int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-			struct crypto_alg *alg)
+int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			  const char *driver, struct crypto_alg *alg)
 {
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
 		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     driver, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_inst_setname);
+EXPORT_SYMBOL_GPL(__crypto_inst_setname);
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 423e57eca351..188eface0a11 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -146,8 +146,16 @@ void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-			struct crypto_alg *alg);
+int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			  const char *driver, struct crypto_alg *alg);
+
+#define crypto_inst_setname(inst, name, ...) \
+	CONCATENATE(crypto_inst_setname_, COUNT_ARGS(__VA_ARGS__))( \
+		inst, name, ##__VA_ARGS__)
+#define crypto_inst_setname_1(inst, name, alg) \
+	__crypto_inst_setname(inst, name, name, alg)
+#define crypto_inst_setname_2(inst, name, driver, alg) \
+	__crypto_inst_setname(inst, name, driver, alg)
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
-- 
2.39.5

