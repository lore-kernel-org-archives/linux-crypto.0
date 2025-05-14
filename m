Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548A225A39
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214564; cv=none; b=YZlqJj3Ouw38xEgrAwb+htFIeZm9ziSCnrxVLkK8j8fiM2Dt1kIkRJ6Dn4aISz+qOVAEYOrZf4Y/hkxn+KWqR8jnCvexEFsPKHTng0ttWHpBuksiLOb+eZtXUKDsHNNRO3dp01LRcDYjiRUw60F+cETxb/OHqz0atD46RFEClsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214564; c=relaxed/simple;
	bh=yLiK9w2W9Ej8s5fxIsdntF8CI7Q7pSpEf5wOxyhTzY0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=DC7QWsUs63VlGUqZ5QptWuGB71zKrLzd0lGFtOsMSxkrbWpUO0tZUPnTVO27rT7KYfYKUdyzEUiVcq09Q94AKgTwulnhL3bdijDcrkZ79++oS0018cWSKzsL6uu39j1BOUjFQbrn4+ZWifBt+Ls4Q+LIDU8MhzoXNbo5+AAzZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Betl2YoU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Betl2YoU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k6w4oe3QfmEb/hHyMA8Dg0EXufmhZP5QwxnZ0IPkc6I=; b=Betl2YoURiegsrkSKS+EoieZcn
	nXcYhfT3OWA6o0Z051zFGMJRJmVqowgYo2C7YVNT8U/bg8jqmUdGAf5jcFUT8tIUUKP8CzICgJlMz
	XnAbHdq82SHpnLQbNOgaZ2tuHy28LmbUdTdbKjnHv1EapeWrKd07m0tbL9WQQmqahpnF+Y6l5m2ez
	CpSdfnB4lel772WyeluGhkd+CdDeO+NTI0f1ujvUMxUpafzlMVkaN8nSKJacLOHGwdK2PEIK9y/HF
	oLnTScuNRiXsjp06AUpT3q+cl2T45obiGgGbWTV/85Ldse6h6iA3mJa80LCjYZvW2+NElc7OjSqL9
	IBAO9spA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8Jy-0060KV-2N;
	Wed, 14 May 2025 17:22:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:38 +0800
Date: Wed, 14 May 2025 17:22:38 +0800
Message-Id: <1b9ec629aac1a9eb78d31133ae0ec5771a077717.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 05/11] crypto: hmac - Add export_core and import_core
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add export_import and import_core so that hmac can be used as a
fallback by block-only drivers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/hmac.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4517e04bfbaa..e4749a1f93dd 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -90,6 +90,22 @@ static int hmac_import(struct shash_desc *pdesc, const void *in)
 	return crypto_shash_import(desc, in);
 }
 
+static int hmac_export_core(struct shash_desc *pdesc, void *out)
+{
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
+
+	return crypto_shash_export_core(desc, out);
+}
+
+static int hmac_import_core(struct shash_desc *pdesc, const void *in)
+{
+	const struct hmac_ctx *tctx = crypto_shash_ctx(pdesc->tfm);
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
+
+	desc->tfm = tctx->hash;
+	return crypto_shash_import_core(desc, in);
+}
+
 static int hmac_init(struct shash_desc *pdesc)
 {
 	const struct hmac_ctx *tctx = crypto_shash_ctx(pdesc->tfm);
@@ -177,6 +193,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return -ENOMEM;
 	spawn = shash_instance_ctx(inst);
 
+	mask |= CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
 	err = crypto_grab_shash(spawn, shash_crypto_instance(inst),
 				crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
@@ -211,6 +228,8 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.finup = hmac_finup;
 	inst->alg.export = hmac_export;
 	inst->alg.import = hmac_import;
+	inst->alg.export_core = hmac_export_core;
+	inst->alg.import_core = hmac_import_core;
 	inst->alg.setkey = hmac_setkey;
 	inst->alg.init_tfm = hmac_init_tfm;
 	inst->alg.clone_tfm = hmac_clone_tfm;
-- 
2.39.5

