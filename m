From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/8] crypto: akcipher - return status from
 crypto_unregister_alg
Date: Wed, 09 Sep 2015 09:15:01 -0700
Message-ID: <20150909161501.2828.78012.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9754 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbbIIQQ6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:16:58 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return status from crypto_unregister_alg to the caller.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/akcipher.c                  |    4 ++--
 include/crypto/internal/akcipher.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 528ae6a..9cd84f7 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -107,9 +107,9 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_akcipher);
 
-void crypto_unregister_akcipher(struct akcipher_alg *alg)
+int crypto_unregister_akcipher(struct akcipher_alg *alg)
 {
-	crypto_unregister_alg(&alg->base);
+	return crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
 
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 9a2bda1..9ea7bc9 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -55,6 +55,8 @@ int crypto_register_akcipher(struct akcipher_alg *alg);
  * Function unregisters an implementation of a public key verify algorithm
  *
  * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
  */
-void crypto_unregister_akcipher(struct akcipher_alg *alg);
+int crypto_unregister_akcipher(struct akcipher_alg *alg);
 #endif
