From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: acomp - report scomp implementations
Date: Wed, 19 Apr 2017 14:26:14 +0100
Message-ID: <20170419132614.3363-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:41087 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752941AbdDSN0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 09:26:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix crypto_has_acomp to report scomp implementations.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 include/crypto/acompress.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e328b52..39871f9 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -162,6 +162,7 @@ static inline int crypto_has_acomp(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_ACOMPRESS;
+	type |= CRYPTO_ALG_TYPE_SCOMPRESS;
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	return crypto_has_alg(alg_name, type, mask);
-- 
2.9.3
