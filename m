Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6506129672C
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288488; cv=none; b=CvvQb2thZBgCKs2Y/J0/kzVqntYbgYGcywY+bgg05Mg8yf7a2WB5y8M8+aPPRsSS1cwZWrf959kg8NIW8nTF54zvk/uwnnaRqjlSPyJmMv3WgV5HfZeiSM8FhLN3XBz5WqnIrVF4w1wRjS9qz/IhgWs8F7J0MxXtjJiLRokSdcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288488; c=relaxed/simple;
	bh=yLiK9w2W9Ej8s5fxIsdntF8CI7Q7pSpEf5wOxyhTzY0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=TN2waMDCpL4rZgKfjgYQZlmvCiQqN3GqBRMWVqFTy5At6tmCuzjbfnafjqgMpSK4C7WLMWLlWW7DSjqkMx27apL/OrSw7cX/gpkC4ryvyshAyPTe351/uxVcUiSKJcGuvmtk6701SsyXYb5KKpROE9jEbrXgqkEgis6EzwJcso8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=X9OG546o; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="X9OG546o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k6w4oe3QfmEb/hHyMA8Dg0EXufmhZP5QwxnZ0IPkc6I=; b=X9OG546oiE0OzBe3wl9/RXU78z
	CrR1w1nqlWSuPv5+Exx2RYgMyibIT2E1UihA7F9fg8Uu/qfUwsSB4u/HmYiPTS0RcGe1c+LzCDrSe
	HjDQvYvD9yiEbTIlGdb2BTb9xMfwK8nlc97A3mzworZzuna49dOWjZ1phe9Nu/bgDaZ+WHd4Uw4oB
	TQ3Sk52FHX81wbVZKiwFuifUlGEvlFvVJPTnhiMwuK8uv8jx1gJR2l3QkhnIYklK07jrYsZpNskZX
	S4cssnfQdGu0mWWuNOTS7oq0hgP7wnTV/qV8y7naYM74s2qgDwSSl5l1jc5Wb1XoIUlHgPzvSD3tl
	9wDKQe6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYI-006Ebw-1v;
	Thu, 15 May 2025 13:54:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:42 +0800
Date: Thu, 15 May 2025 13:54:42 +0800
Message-Id: <1237c244a2192dc69d72415d5a0c7b90d051c7a4.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 05/11] crypto: hmac - Add export_core and import_core
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

