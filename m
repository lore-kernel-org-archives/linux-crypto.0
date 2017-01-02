From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: kpp - clear CRYPTO_ALG_DEAD bit in prepare_alg
Date: Mon,  2 Jan 2017 13:33:41 +0000
Message-ID: <1483364021-103771-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65224 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdABNca (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2017 08:32:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make sure CRYPTO_ALG_DEAD is not set when preparing for
alg registration. This fixes qat-dh registration that occurs
when reloading qat_c62x module.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/kpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/kpp.c b/crypto/kpp.c
index d36ce05..d1adef8e 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -101,6 +101,7 @@ static void kpp_prepare_alg(struct kpp_alg *alg)
 
 	base->cra_type = &crypto_kpp_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags &= ~CRYPTO_ALG_DEAD;
 	base->cra_flags |= CRYPTO_ALG_TYPE_KPP;
 }
 
-- 
2.4.11
