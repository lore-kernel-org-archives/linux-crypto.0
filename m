From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/10] crypto: aead - Add multiple algorithm registration interface
Date: Thu, 28 May 2015 22:07:59 +0800
Message-ID: <E1YxyTX-0002KK-1g@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43011 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbE1OIC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helpers that allow the registration and removal
of multiple algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |   29 +++++++++++++++++++++++++++++
 include/crypto/internal/aead.h |    2 ++
 2 files changed, 31 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index ac44792..07bf997 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -896,6 +896,35 @@ void crypto_unregister_aead(struct aead_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_aead);
 
+int crypto_register_aeads(struct aead_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_aead(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_aead(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_aeads);
+
+void crypto_unregister_aeads(struct aead_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_aead(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_aeads);
+
 int aead_register_instance(struct crypto_template *tmpl,
 			   struct aead_instance *inst)
 {
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 3cb35d8..ba52c37b8 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -152,6 +152,8 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
 
 int crypto_register_aead(struct aead_alg *alg);
 void crypto_unregister_aead(struct aead_alg *alg);
+int crypto_register_aeads(struct aead_alg *algs, int count);
+void crypto_unregister_aeads(struct aead_alg *algs, int count);
 int aead_register_instance(struct crypto_template *tmpl,
 			   struct aead_instance *inst);
 
