From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: api - Clear CRYPTO_ALG_DEAD bit before registering an alg
Date: Fri, 13 Jan 2017 11:54:08 +0000
Message-ID: <1484308448-3225-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14863 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdAMLzJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:55:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make sure CRYPTO_ALG_DEAD bit is cleared before proceeding with
the algorithm registration. This fixes qat-dh registration when
driver is restarted

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/algapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index df939b5..1fad2a6 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -356,6 +356,7 @@ int crypto_register_alg(struct crypto_alg *alg)
 	struct crypto_larval *larval;
 	int err;
 
+	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
 	err = crypto_check_alg(alg);
 	if (err)
 		return err;
-- 
2.7.4
