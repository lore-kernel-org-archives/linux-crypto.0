From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: acomp - allow registration of multiple acomps
Date: Wed, 19 Apr 2017 14:23:05 +0100
Message-ID: <20170419132305.3127-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26731 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763662AbdDSNXW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 09:23:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add crypto_register_acomps and crypto_unregister_acomps to allow
the registration of multiple implementations with one call.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/acompress.c                  | 29 +++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 47d1162..1544b7c 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,5 +166,34 @@ int crypto_unregister_acomp(struct acomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_acomp);
 
+int crypto_register_acomps(struct acomp_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_acomp(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_acomp(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_acomps);
+
+void crypto_unregister_acomps(struct acomp_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_acomp(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_acomps);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 1de2b5a..51052f6 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -78,4 +78,7 @@ int crypto_register_acomp(struct acomp_alg *alg);
  */
 int crypto_unregister_acomp(struct acomp_alg *alg);
 
+int crypto_register_acomps(struct acomp_alg *algs, int count);
+void crypto_unregister_acomps(struct acomp_alg *algs, int count);
+
 #endif
-- 
2.9.3
