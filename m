From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Don't attempt to register algorithm multiple
 times
Date: Mon, 20 Jul 2015 18:45:38 -0700
Message-ID: <20150721014538.25720.17568.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63619 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbbGUBqX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 21:46:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When multiple devices are present in the system the driver attempts
to register the same algorithm many times.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 557a740..3e3c5c8 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -58,6 +58,8 @@
 #include "adf_common_drv.h"
 #include "qat_crypto.h"
 
+static atomic_t active_devs;
+
 struct qat_rsa_input_params {
 	union {
 		struct {
@@ -629,11 +631,16 @@ static struct akcipher_alg rsa = {
 
 int qat_asym_algs_register(void)
 {
-	rsa.base.cra_flags = 0;
-	return crypto_register_akcipher(&rsa);
+	if (atomic_add_return(1, &active_devs) == 1) {
+		rsa.base.cra_flags = 0;
+		return crypto_register_akcipher(&rsa);
+	}
+
+	return 0;
 }
 
 void qat_asym_algs_unregister(void)
 {
-	crypto_unregister_akcipher(&rsa);
+	if (atomic_sub_return(1, &active_devs) == 0)
+		crypto_unregister_akcipher(&rsa);
 }
