From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH v2] crypto: qat - use list_for_each_entry*
Date: Sat, 19 Dec 2015 16:22:51 +0800
Message-ID: <bebc7973675a17a9bc0b063e71d7dd9843e46192.1450512996.git.geliangtang@163.com>
References: <56744496.8090000@intel.com>
Cc: Geliang Tang <geliangtang@163.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:46027 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbLSIXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Dec 2015 03:23:14 -0500
In-Reply-To: <56744496.8090000@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use list_for_each_entry*() instead of list_for_each*() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v2:
 - only to qat_crypto.c, and adf_ctl_drv.c.
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 13 ++++---------
 drivers/crypto/qat/qat_common/qat_crypto.c  | 28 ++++++++--------------------
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 2e6d0c5..5c897e6 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -255,12 +255,9 @@ out:
 
 static int adf_ctl_is_device_in_use(int id)
 {
-	struct list_head *itr, *head = adf_devmgr_get_head();
-
-	list_for_each(itr, head) {
-		struct adf_accel_dev *dev =
-				list_entry(itr, struct adf_accel_dev, list);
+	struct adf_accel_dev *dev;
 
+	list_for_each_entry(dev, adf_devmgr_get_head(), list) {
 		if (id == dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (adf_devmgr_in_reset(dev) || adf_dev_in_use(dev)) {
 				dev_info(&GET_DEV(dev),
@@ -275,12 +272,10 @@ static int adf_ctl_is_device_in_use(int id)
 
 static int adf_ctl_stop_devices(uint32_t id)
 {
-	struct list_head *itr, *head = adf_devmgr_get_head();
+	struct adf_accel_dev *accel_dev;
 	int ret = 0;
 
-	list_for_each_prev(itr, head) {
-		struct adf_accel_dev *accel_dev =
-				list_entry(itr, struct adf_accel_dev, list);
+	list_for_each_entry_reverse(accel_dev, adf_devmgr_get_head(), list) {
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (!adf_dev_started(accel_dev))
 				continue;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 4d0c65b..3852d31 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -67,13 +67,10 @@ void qat_crypto_put_instance(struct qat_crypto_instance *inst)
 
 static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 {
-	struct qat_crypto_instance *inst;
-	struct list_head *list_ptr, *tmp;
+	struct qat_crypto_instance *inst, *tmp;
 	int i;
 
-	list_for_each_safe(list_ptr, tmp, &accel_dev->crypto_list) {
-		inst = list_entry(list_ptr, struct qat_crypto_instance, list);
-
+	list_for_each_entry_safe(inst, tmp, &accel_dev->crypto_list, list) {
 		for (i = 0; i < atomic_read(&inst->refctr); i++)
 			qat_crypto_put_instance(inst);
 
@@ -89,7 +86,7 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 		if (inst->pke_rx)
 			adf_remove_ring(inst->pke_rx);
 
-		list_del(list_ptr);
+		list_del(&inst->list);
 		kfree(inst);
 	}
 	return 0;
@@ -97,17 +94,13 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 {
-	struct adf_accel_dev *accel_dev = NULL;
-	struct qat_crypto_instance *inst = NULL;
-	struct list_head *itr;
+	struct adf_accel_dev *accel_dev = NULL, *tmp_dev;
+	struct qat_crypto_instance *inst = NULL, *tmp_inst;
 	unsigned long best = ~0;
 
-	list_for_each(itr, adf_devmgr_get_head()) {
-		struct adf_accel_dev *tmp_dev;
+	list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 		unsigned long ctr;
 
-		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
-
 		if ((node == dev_to_node(&GET_DEV(tmp_dev)) ||
 		     dev_to_node(&GET_DEV(tmp_dev)) < 0) &&
 		    adf_dev_started(tmp_dev) &&
@@ -123,10 +116,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	if (!accel_dev) {
 		pr_info("QAT: Could not find a device on node %d\n", node);
 		/* Get any started device */
-		list_for_each(itr, adf_devmgr_get_head()) {
-			struct adf_accel_dev *tmp_dev;
-
-			tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+		list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 			if (adf_dev_started(tmp_dev) &&
 			    !list_empty(&tmp_dev->crypto_list)) {
 				accel_dev = tmp_dev;
@@ -139,11 +129,9 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		return NULL;
 
 	best = ~0;
-	list_for_each(itr, &accel_dev->crypto_list) {
-		struct qat_crypto_instance *tmp_inst;
+	list_for_each_entry(tmp_inst, &accel_dev->crypto_list, list) {
 		unsigned long ctr;
 
-		tmp_inst = list_entry(itr, struct qat_crypto_instance, list);
 		ctr = atomic_read(&tmp_inst->refctr);
 		if (best > ctr) {
 			inst = tmp_inst;
-- 
2.5.0
