From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: api - Add crypto_type_has_alg helper
Date: Sat, 23 Jan 2016 13:51:01 +0800
Message-ID: <20160123055101.GA24235@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36335 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbcAWFvF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Jan 2016 00:51:05 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_type_has_alg which is meant
to replace crypto_has_alg for new-style crypto types.  Rather
than hard-coding type/mask information they're now retrieved
from the crypto_type object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 7be76aa..731255a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -987,6 +987,21 @@ unsigned int crypto_alg_extsize(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_extsize);
 
+int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
+			u32 type, u32 mask)
+{
+	int ret = 0;
+	struct crypto_alg *alg = crypto_find_alg(name, frontend, type, mask);
+
+	if (!IS_ERR(alg)) {
+		crypto_mod_put(alg);
+		ret = 1;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_type_has_alg);
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
diff --git a/crypto/internal.h b/crypto/internal.h
index 00e42a3..7eefcdb 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -104,6 +104,9 @@ int crypto_probing_notify(unsigned long val, void *v);
 
 unsigned int crypto_alg_extsize(struct crypto_alg *alg);
 
+int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
+			u32 type, u32 mask);
+
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
 	atomic_inc(&alg->cra_refcnt);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
