From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Add load balancing across devices
Date: Wed, 16 Sep 2015 05:33:06 -0700
Message-ID: <20150916123306.9736.13694.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbbIPMez (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2015 08:34:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Load balancing of crypto instances only used a single device.
There was no problem with that on PF, but since there is only
one or two instance per VF we need to loadbalance across devices.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c |   61 +++++++++++++++-------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 07c2f9f..25db27c 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -60,8 +60,8 @@ static struct service_hndl qat_crypto;
 
 void qat_crypto_put_instance(struct qat_crypto_instance *inst)
 {
-	if (atomic_sub_return(1, &inst->refctr) == 0)
-		adf_dev_put(inst->accel_dev);
+	atomic_dec(&inst->refctr);
+	adf_dev_put(inst->accel_dev);
 }
 
 static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
@@ -97,19 +97,26 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 {
 	struct adf_accel_dev *accel_dev = NULL;
-	struct qat_crypto_instance *inst_best = NULL;
+	struct qat_crypto_instance *inst = NULL;
 	struct list_head *itr;
 	unsigned long best = ~0;
 
 	list_for_each(itr, adf_devmgr_get_head()) {
-		accel_dev = list_entry(itr, struct adf_accel_dev, list);
-
-		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
-		     dev_to_node(&GET_DEV(accel_dev)) < 0) &&
-		    adf_dev_started(accel_dev) &&
-		    !list_empty(&accel_dev->crypto_list))
-			break;
-		accel_dev = NULL;
+		struct adf_accel_dev *tmp_dev;
+		unsigned long ctr;
+
+		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+
+		if ((node == dev_to_node(&GET_DEV(tmp_dev)) ||
+		     dev_to_node(&GET_DEV(tmp_dev)) < 0) &&
+		    adf_dev_started(tmp_dev) &&
+		    !list_empty(&tmp_dev->crypto_list)) {
+			ctr = atomic_read(&tmp_dev->ref_count);
+			if (best > ctr) {
+				accel_dev = tmp_dev;
+				best = ctr;
+			}
+		}
 	}
 	if (!accel_dev) {
 		pr_err("QAT: Could not find a device on node %d\n", node);
@@ -118,28 +125,26 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	if (!accel_dev || !adf_dev_started(accel_dev))
 		return NULL;
 
+	best = ~0;
 	list_for_each(itr, &accel_dev->crypto_list) {
-		struct qat_crypto_instance *inst;
-		unsigned long cur;
-
-		inst = list_entry(itr, struct qat_crypto_instance, list);
-		cur = atomic_read(&inst->refctr);
-		if (best > cur) {
-			inst_best = inst;
-			best = cur;
+		struct qat_crypto_instance *tmp_inst;
+		unsigned long ctr;
+
+		tmp_inst = list_entry(itr, struct qat_crypto_instance, list);
+		ctr = atomic_read(&tmp_inst->refctr);
+		if (best > ctr) {
+			inst = tmp_inst;
+			best = ctr;
 		}
 	}
-	if (inst_best) {
-		if (atomic_add_return(1, &inst_best->refctr) == 1) {
-			if (adf_dev_get(accel_dev)) {
-				atomic_dec(&inst_best->refctr);
-				dev_err(&GET_DEV(accel_dev),
-					"Could not increment dev refctr\n");
-				return NULL;
-			}
+	if (inst) {
+		if (adf_dev_get(accel_dev)) {
+			dev_err(&GET_DEV(accel_dev), "Could not increment dev refctr\n");
+			return NULL;
 		}
+		atomic_inc(&inst->refctr);
 	}
-	return inst_best;
+	return inst;
 }
 
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
