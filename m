From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: scomp - allow registration of multiple scomps
Date: Wed, 19 Apr 2017 15:11:41 +0100
Message-ID: <20170419141142.3678-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59504 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934725AbdDSOL7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 10:11:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add crypto_register_scomps and crypto_unregister_scomps to allow
the registration of multiple implementations with one call.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/scompress.c                  | 29 +++++++++++++++++++++++++++++
 include/crypto/internal/scompress.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 6b048b3..ae1d3cf 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -353,5 +353,34 @@ int crypto_unregister_scomp(struct scomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
 
+int crypto_register_scomps(struct scomp_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_scomp(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_scomp(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_scomps);
+
+void crypto_unregister_scomps(struct scomp_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_scomp(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_scomps);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous compression type");
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 3fda3c5..ccad9b2 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -133,4 +133,7 @@ int crypto_register_scomp(struct scomp_alg *alg);
  */
 int crypto_unregister_scomp(struct scomp_alg *alg);
 
+int crypto_register_scomps(struct scomp_alg *algs, int count);
+void crypto_unregister_scomps(struct scomp_alg *algs, int count);
+
 #endif
-- 
2.9.3
