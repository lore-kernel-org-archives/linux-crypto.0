From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/10] crypto: aead - Ignore return value from crypto_unregister_alg
Date: Thu, 28 May 2015 22:07:57 +0800
Message-ID: <E1YxyTV-0002K3-N4@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49727 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbE1OIB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No new code should be using the return value of crypto_unregister_alg
as it will become void soon.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |    4 ++--
 include/crypto/internal/aead.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 4bab3cf..ac44792 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -890,9 +890,9 @@ int crypto_register_aead(struct aead_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_aead);
 
-int crypto_unregister_aead(struct aead_alg *alg)
+void crypto_unregister_aead(struct aead_alg *alg)
 {
-	return crypto_unregister_alg(&alg->base);
+	crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_aead);
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index f068d74..3cb35d8 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -151,7 +151,7 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
 }
 
 int crypto_register_aead(struct aead_alg *alg);
-int crypto_unregister_aead(struct aead_alg *alg);
+void crypto_unregister_aead(struct aead_alg *alg);
 int aead_register_instance(struct crypto_template *tmpl,
 			   struct aead_instance *inst);
 
