Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF194B1E71
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288482; cv=none; b=HhLf8DA6R9FI02eX6WOVSAvRyB15gwjT9gARNUbqsomcRlqpRRUVRvuJAQfjU6WFqwagAyo2OkRlsQSCkQk2fC9NO6yoXLSz+f2Qk+sGxj5UB48g1XilBZqQJp9cveOE3VMcV/RkiCPKRlvTkcxSLH/4efbMB4Xli/+I9PmydRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288482; c=relaxed/simple;
	bh=q939P5vYDQQvxmVLQUV6RBUrb5sjIBnGrOl4qmke/mU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=sU3mNOfvic8mJwXm+3I27e6o1kJ2jJ0IDOswXsRpSXrTmp/RnWSF81Jh5XAW+KRNGTNZ9baoIjLoaj0+1X2DvTqpXVJ+CIHJyUDBLAFsu4brci82sPp040AtAnbAjTNsgRnLFvUB9PrxHtCLbTO1Dc7k7YqFTGOXV/x6Qf5FII0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=T+iIL+b+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="T+iIL+b+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sodhLEPyUACZrFVgPI4ng4bZJ/rlBs3rDXrFKhEbUa4=; b=T+iIL+b+VytBhMteidSlELWeTC
	GZky/XEUQOdOfGvrQcyQd96cu3ZWRFrA3bRUMKTP2xDS+1w8whPXhpk1a+YWecYGqZ70x7tyWTf3R
	puX2m3sMM6ezkxWWS0ShGhdRM2VFK8azRt9AHRn38n7X+c/uhyI+HT3HoGJqFjCP+W6y6EVYHUTzE
	OTMXMFvAzDuHVxT1Qp+nP8jnP746Icrry20swcOnrHhUgNPwgmhYEeguEVwu826KGrhGjxi2E8XuE
	P/KcDuJBL/zGb4zn/POEx+PRZYxvZOmjKHefPJKDp2K5xvGir088aCSrSvkVzl+IO5qrx3Sm7XzZu
	GY0VSPoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYB-006EbP-1V;
	Thu, 15 May 2025 13:54:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:35 +0800
Date: Thu, 15 May 2025 13:54:35 +0800
Message-Id: <29e69c4ad394afdffe0f749dfcb6fdedb030e1f5.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 02/11] crypto: hash - Add export_core and import_core hooks
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add export_core and import_core hooks.  These are intended to be
used by algorithms which are wrappers around block-only algorithms,
but are not themselves block-only, e.g., hmac.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 22 ++++++++++++++---
 crypto/shash.c                 | 44 +++++++++++++++++++++++++++-------
 include/crypto/hash.h          | 10 ++++++++
 include/crypto/internal/hash.h |  3 +++
 4 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 344bf1b43e71..7d96c76731ef 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -704,7 +704,7 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_export_core(ahash_request_ctx(req), out);
-	return crypto_ahash_alg(tfm)->export(req, out);
+	return crypto_ahash_alg(tfm)->export_core(req, out);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_export_core);
 
@@ -727,7 +727,7 @@ int crypto_ahash_import_core(struct ahash_request *req, const void *in)
 						in);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	return crypto_ahash_alg(tfm)->import(req, in);
+	return crypto_ahash_alg(tfm)->import_core(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import_core);
 
@@ -739,7 +739,7 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 		return crypto_shash_import(prepare_shash_desc(req, tfm), in);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	return crypto_ahash_import_core(req, in);
+	return crypto_ahash_alg(tfm)->import(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import);
 
@@ -971,6 +971,16 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 }
 EXPORT_SYMBOL_GPL(crypto_clone_ahash);
 
+static int ahash_default_export_core(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
+static int ahash_default_import_core(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
 static int ahash_prepare_alg(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
@@ -996,6 +1006,12 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (!alg->setkey)
 		alg->setkey = ahash_nosetkey;
 
+	if (!alg->export_core || !alg->import_core) {
+		alg->export_core = ahash_default_export_core;
+		alg->import_core = ahash_default_import_core;
+		base->cra_flags |= CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
+	}
+
 	return 0;
 }
 
diff --git a/crypto/shash.c b/crypto/shash.c
index dee391d47f51..5bc74a72d5ad 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -203,9 +203,10 @@ int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_tfm_digest);
 
-int crypto_shash_export_core(struct shash_desc *desc, void *out)
+static int __crypto_shash_export(struct shash_desc *desc, void *out,
+				 int (*export)(struct shash_desc *desc,
+					       void *out))
 {
-	int (*export)(struct shash_desc *desc, void *out);
 	struct crypto_shash *tfm = desc->tfm;
 	u8 *buf = shash_desc_ctx(desc);
 	unsigned int plen, ss;
@@ -214,7 +215,6 @@ int crypto_shash_export_core(struct shash_desc *desc, void *out)
 	ss = crypto_shash_statesize(tfm);
 	if (crypto_shash_block_only(tfm))
 		ss -= plen;
-	export = crypto_shash_alg(tfm)->export;
 	if (!export) {
 		memcpy(out, buf, ss);
 		return 0;
@@ -222,6 +222,12 @@ int crypto_shash_export_core(struct shash_desc *desc, void *out)
 
 	return export(desc, out);
 }
+
+int crypto_shash_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_shash_export(desc, out,
+				     crypto_shash_alg(desc->tfm)->export_core);
+}
 EXPORT_SYMBOL_GPL(crypto_shash_export_core);
 
 int crypto_shash_export(struct shash_desc *desc, void *out)
@@ -236,13 +242,14 @@ int crypto_shash_export(struct shash_desc *desc, void *out)
 
 		memcpy(out + ss - plen, buf + descsize - plen, plen);
 	}
-	return crypto_shash_export_core(desc, out);
+	return __crypto_shash_export(desc, out, crypto_shash_alg(tfm)->export);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_export);
 
-int crypto_shash_import_core(struct shash_desc *desc, const void *in)
+static int __crypto_shash_import(struct shash_desc *desc, const void *in,
+				 int (*import)(struct shash_desc *desc,
+					       const void *in))
 {
-	int (*import)(struct shash_desc *desc, const void *in);
 	struct crypto_shash *tfm = desc->tfm;
 	unsigned int descsize, plen, ss;
 	u8 *buf = shash_desc_ctx(desc);
@@ -256,7 +263,6 @@ int crypto_shash_import_core(struct shash_desc *desc, const void *in)
 	buf[descsize - 1] = 0;
 	if (crypto_shash_block_only(tfm))
 		ss -= plen;
-	import = crypto_shash_alg(tfm)->import;
 	if (!import) {
 		memcpy(buf, in, ss);
 		return 0;
@@ -264,6 +270,12 @@ int crypto_shash_import_core(struct shash_desc *desc, const void *in)
 
 	return import(desc, in);
 }
+
+int crypto_shash_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_shash_import(desc, in,
+				     crypto_shash_alg(desc->tfm)->import_core);
+}
 EXPORT_SYMBOL_GPL(crypto_shash_import_core);
 
 int crypto_shash_import(struct shash_desc *desc, const void *in)
@@ -271,7 +283,7 @@ int crypto_shash_import(struct shash_desc *desc, const void *in)
 	struct crypto_shash *tfm = desc->tfm;
 	int err;
 
-	err = crypto_shash_import_core(desc, in);
+	err = __crypto_shash_import(desc, in, crypto_shash_alg(tfm)->import);
 	if (crypto_shash_block_only(tfm)) {
 		unsigned int plen = crypto_shash_blocksize(tfm) + 1;
 		unsigned int descsize = crypto_shash_descsize(tfm);
@@ -436,6 +448,16 @@ int hash_prepare_alg(struct hash_alg_common *alg)
 	return 0;
 }
 
+static int shash_default_export_core(struct shash_desc *desc, void *out)
+{
+	return -ENOSYS;
+}
+
+static int shash_default_import_core(struct shash_desc *desc, const void *in)
+{
+	return -ENOSYS;
+}
+
 static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
@@ -476,6 +498,12 @@ static int shash_prepare_alg(struct shash_alg *alg)
 		BUILD_BUG_ON(MAX_ALGAPI_BLOCKSIZE >= 256);
 		alg->descsize += base->cra_blocksize + 1;
 		alg->statesize += base->cra_blocksize + 1;
+		alg->export_core = alg->export;
+		alg->import_core = alg->import;
+	} else if (!alg->export_core || !alg->import_core) {
+		alg->export_core = shash_default_export_core;
+		alg->import_core = shash_default_import_core;
+		base->cra_flags |= CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
 	}
 
 	if (alg->descsize > HASH_MAX_DESCSIZE)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 9fc9daaaaab4..bf177cf9be10 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -129,6 +129,10 @@ struct ahash_request {
  *	    data so the transformation can continue from this point onward. No
  *	    data processing happens at this point. Driver must not use
  *	    req->result.
+ * @export_core: Export partial state without partial block.  Only defined
+ *		 for algorithms that are not block-only.
+ * @import_core: Import partial state without partial block.  Only defined
+ *		 for algorithms that are not block-only.
  * @init_tfm: Initialize the cryptographic transformation object.
  *	      This function is called only once at the instantiation
  *	      time, right after the transformation context was
@@ -151,6 +155,8 @@ struct ahash_alg {
 	int (*digest)(struct ahash_request *req);
 	int (*export)(struct ahash_request *req, void *out);
 	int (*import)(struct ahash_request *req, const void *in);
+	int (*export_core)(struct ahash_request *req, void *out);
+	int (*import_core)(struct ahash_request *req, const void *in);
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_ahash *tfm);
@@ -200,6 +206,8 @@ struct shash_desc {
  * @digest: see struct ahash_alg
  * @export: see struct ahash_alg
  * @import: see struct ahash_alg
+ * @export_core: see struct ahash_alg
+ * @import_core: see struct ahash_alg
  * @setkey: see struct ahash_alg
  * @init_tfm: Initialize the cryptographic transformation object.
  *	      This function is called only once at the instantiation
@@ -230,6 +238,8 @@ struct shash_alg {
 		      unsigned int len, u8 *out);
 	int (*export)(struct shash_desc *desc, void *out);
 	int (*import)(struct shash_desc *desc, const void *in);
+	int (*export_core)(struct shash_desc *desc, void *out);
+	int (*import_core)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_shash *tfm);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index ef5ea75ac5c8..e9de2bc34a10 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -20,6 +20,9 @@
 /* Set this bit if finup can deal with multiple blocks. */
 #define CRYPTO_AHASH_ALG_FINUP_MAX	0x04000000
 
+/* This bit is set by the Crypto API if export_core is not supported. */
+#define CRYPTO_AHASH_ALG_NO_EXPORT_CORE	0x08000000
+
 #define HASH_FBREQ_ON_STACK(name, req) \
         char __##name##_req[sizeof(struct ahash_request) + \
                             MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
-- 
2.39.5

