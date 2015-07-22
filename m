From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Fix invalid synchronization between
 register/unregister sym algs
Date: Tue, 21 Jul 2015 22:07:47 -0700
Message-ID: <20150722050747.29130.79115.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, tadeusz.struk@intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbbGVFIX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 01:08:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The synchronization method used atomic was bogus.
Use a proper synchronization with mutex.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 31abfd0..9b25ab1 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -73,7 +73,8 @@
 				       ICP_QAT_HW_CIPHER_KEY_CONVERT, \
 				       ICP_QAT_HW_CIPHER_DECRYPT)
 
-static atomic_t active_dev;
+static DEFINE_MUTEX(algs_lock);
+static unsigned int active_devs;
 
 struct qat_alg_buf {
 	uint32_t len;
@@ -1275,7 +1276,10 @@ static struct crypto_alg qat_algs[] = { {
 
 int qat_algs_register(void)
 {
-	if (atomic_add_return(1, &active_dev) == 1) {
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (++active_devs == 1) {
 		int i;
 
 		for (i = 0; i < ARRAY_SIZE(qat_algs); i++)
@@ -1284,21 +1288,25 @@ int qat_algs_register(void)
 				CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC :
 				CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
 
-		return crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
+		ret = crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
 	}
-	return 0;
+	mutex_unlock(&algs_lock);
+	return ret;
 }
 
 int qat_algs_unregister(void)
 {
-	if (atomic_sub_return(1, &active_dev) == 0)
-		return crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
-	return 0;
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (--active_devs == 0)
+		ret = crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	mutex_unlock(&algs_lock);
+	return ret;
 }
 
 int qat_algs_init(void)
 {
-	atomic_set(&active_dev, 0);
 	crypto_get_default_rng();
 	return 0;
 }
