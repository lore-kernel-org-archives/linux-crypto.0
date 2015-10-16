From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix crypto_get_instance_node function
Date: Fri, 16 Oct 2015 11:40:56 -0700
Message-ID: <20151016184056.21772.40366.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbbJPSnY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 14:43:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

qat_crypto_get_instance_node function needs to handle situation when the
first dev in the list is not started.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 25db27c..9cab154 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -118,11 +118,23 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 			}
 		}
 	}
-	if (!accel_dev) {
-		pr_err("QAT: Could not find a device on node %d\n", node);
-		accel_dev = adf_devmgr_get_first();
+	if (!accel_dev)
+		pr_info("QAT: Could not find a device on node %d\n", node);
+
+	/* Get any started device */
+	list_for_each(itr, adf_devmgr_get_head()) {
+		struct adf_accel_dev *tmp_dev;
+
+		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+
+		if (adf_dev_started(tmp_dev) &&
+		    !list_empty(&tmp_dev->crypto_list)) {
+			accel_dev = tmp_dev;
+			break;
+		}
 	}
-	if (!accel_dev || !adf_dev_started(accel_dev))
+
+	if (!accel_dev)
 		return NULL;
 
 	best = ~0;
