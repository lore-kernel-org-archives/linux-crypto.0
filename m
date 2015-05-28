From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/10] crypto: aead - Add aead_alg_instance
Date: Thu, 28 May 2015 22:07:55 +0800
Message-ID: <E1YxyTT-0002JV-29@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56687 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbE1OH6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:07:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that type-safe init/exit functions exist, they often need
to access the underlying aead_instance.  So this patch adds the
helper aead_alg_instance to access aead_instance from a crypto_aead
object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/aead.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 4137330..f068d74 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -52,6 +52,11 @@ static inline struct aead_instance *aead_instance(struct crypto_instance *inst)
 	return container_of(&inst->alg, struct aead_instance, alg.base);
 }
 
+static inline struct aead_instance *aead_alg_instance(struct crypto_aead *aead)
+{
+	return aead_instance(crypto_aead_alg_instance(aead));
+}
+
 static inline void *aead_instance_ctx(struct aead_instance *inst)
 {
 	return crypto_instance_ctx(aead_crypto_instance(inst));
