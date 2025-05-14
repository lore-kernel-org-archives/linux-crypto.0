Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A9229B07
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214573; cv=none; b=OVkV3vMGDq5khZLY538vJxUQkdPck0WZYNsfYtlEB/OecNYM9D8yK3lUBMK49ugkdQiFyTtiXUwWTEvousZKVxA73R+DwYzyhIP9G8GoXukUFuZ0pq9ySahStm8FOGps86T0Q0wJXGulV9oM7iKb2WrSk7BhxvDhBg6TJEcLQdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214573; c=relaxed/simple;
	bh=DgQKFi+jbu8J43oF5Ufmp8wkGlj9fsbe+wUzMRgbXFA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=KO6Cemfh06oqytPys3pO8bj2TAO60RmiGUtGymOtwLvba55GwtgWRgr+3eaybEOjSSDL8/PZnWpQHAQTaRrzig1qiIGvJMEnU4fSr2kiz7AQbLyICTJArXN1WSim36rzazPXw8N7TH6oTTIOZk8TqtrsQ2S9hrGCtI0+EFfO2hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Bsk81m+f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Bsk81m+f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rIDvfVRNQVG+UmRqnq/k8gaU8pUEd/vXSVQITk4Uv5s=; b=Bsk81m+f0vCxUBYvUULHLOAXDa
	q9oPwUjQjN9e90UKPY8wYuOAx0DsYUl2hYnyMD+Q78h1jXXG6pozjYnJnaJJkuI6CMqhI2Qq3cq5g
	NHVq/7s9Akc6s04Z3F2OWDaCDBIpeCw6xDjISqgieGzs2dimbOo+zSHYzcDtchWVHHKVQczKeSFNP
	4ie+mDcAtazRL31Ymy+D5BcKxMKOSIc2RF6hpydN8d08loiRHLB/e72nLkrvM+r+JfCjaB4QgWM7v
	bp+BJhRtw5erTDdyUiDlAtdG25XXYPf2kL/hkUnXjgxiqfMutGaBqiUCYe6feuhnsvrdLWjw1dI9K
	m7Zuo7Sg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8K7-0060Lc-3C;
	Wed, 14 May 2025 17:22:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:47 +0800
Date: Wed, 14 May 2025 17:22:47 +0800
Message-Id: <60dab74b9f4ddf2d8759b3becbbdf8bcce2b3381.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 09/11] crypto: hmac - Add ahash support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add ahash support to hmac so that drivers that can't do hmac in
hardware do not have to implement duplicate copies of hmac.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/hmac.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index d52d37df5a13..a67bc3543c35 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -314,6 +314,21 @@ static int hmac_import_ahash(struct ahash_request *preq, const void *in)
 	return crypto_ahash_import(req, in);
 }
 
+static int hmac_export_core_ahash(struct ahash_request *preq, void *out)
+{
+	return crypto_ahash_export_core(ahash_request_ctx(preq), out);
+}
+
+static int hmac_import_core_ahash(struct ahash_request *preq, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(preq);
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *req = ahash_request_ctx(preq);
+
+	ahash_request_set_tfm(req, tctx->hash);
+	return crypto_ahash_import_core(req, in);
+}
+
 static int hmac_init_ahash(struct ahash_request *preq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(preq);
@@ -443,6 +458,7 @@ static int __hmac_create_ahash(struct crypto_template *tmpl,
 		return -ENOMEM;
 	spawn = ahash_instance_ctx(inst);
 
+	mask |= CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
 	err = crypto_grab_ahash(spawn, ahash_crypto_instance(inst),
 				crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
@@ -483,6 +499,8 @@ static int __hmac_create_ahash(struct crypto_template *tmpl,
 	inst->alg.digest = hmac_digest_ahash;
 	inst->alg.export = hmac_export_ahash;
 	inst->alg.import = hmac_import_ahash;
+	inst->alg.export_core = hmac_export_core_ahash;
+	inst->alg.import_core = hmac_import_core_ahash;
 	inst->alg.setkey = hmac_setkey_ahash;
 	inst->alg.init_tfm = hmac_init_ahash_tfm;
 	inst->alg.clone_tfm = hmac_clone_ahash_tfm;
-- 
2.39.5

