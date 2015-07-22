From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2] crypto: qat - Don't attempt to register algorithm
 multiple times
Date: Tue, 21 Jul 2015 22:07:47 -0700
Message-ID: <20150722050747.29108.21322.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, tadeusz.struk@intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64748 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbbGVFIW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 01:08:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When multiple devices are present in the system the driver attempts
to register the same algorithm many times.

Changes in v2:
 - use proper synchronization mechanizm between register and unregister

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 13a76a0..d06c7d2 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -58,6 +58,9 @@
 #include "adf_common_drv.h"
 #include "qat_crypto.h"
 
+static DEFINE_MUTEX(algs_lock);
+static unsigned int active_devs;
+
 struct qat_rsa_input_params {
 	union {
 		struct {
@@ -629,11 +632,21 @@ static struct akcipher_alg rsa = {
 
 int qat_asym_algs_register(void)
 {
-	rsa.base.cra_flags = 0;
-	return crypto_register_akcipher(&rsa);
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (++active_devs == 1) {
+		rsa.base.cra_flags = 0;
+		ret = crypto_register_akcipher(&rsa);
+	}
+	mutex_unlock(&algs_lock);
+	return ret;
 }
 
 void qat_asym_algs_unregister(void)
 {
-	crypto_unregister_akcipher(&rsa);
+	mutex_lock(&algs_lock);
+	if (--active_devs == 0)
+		crypto_unregister_akcipher(&rsa);
+	mutex_unlock(&algs_lock);
 }
