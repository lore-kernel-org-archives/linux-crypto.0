From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix get instance function
Date: Thu, 22 Oct 2015 06:30:36 -0700
Message-ID: <20151022133036.3097.59054.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:40706 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbbJVNdE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Oct 2015 09:33:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the logic in case we have found a device on a given node.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 603c12d..4d0c65b 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -119,19 +119,19 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 			}
 		}
 	}
-	if (!accel_dev)
-		pr_info("QAT: Could not find a device on node %d\n", node);
-
-	/* Get any started device */
-	list_for_each(itr, adf_devmgr_get_head()) {
-		struct adf_accel_dev *tmp_dev;
 
-		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+	if (!accel_dev) {
+		pr_info("QAT: Could not find a device on node %d\n", node);
+		/* Get any started device */
+		list_for_each(itr, adf_devmgr_get_head()) {
+			struct adf_accel_dev *tmp_dev;
 
-		if (adf_dev_started(tmp_dev) &&
-		    !list_empty(&tmp_dev->crypto_list)) {
-			accel_dev = tmp_dev;
-			break;
+			tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+			if (adf_dev_started(tmp_dev) &&
+			    !list_empty(&tmp_dev->crypto_list)) {
+				accel_dev = tmp_dev;
+				break;
+			}
 		}
 	}
 
