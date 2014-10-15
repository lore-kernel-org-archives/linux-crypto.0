From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [cryptodev PATCH] qat: fix bad unlock balance
Date: Wed, 15 Oct 2014 11:33:15 -0700
Message-ID: <20141015183315.23860.89921.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, qat-linux@intel.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43757 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJOSdL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 14:33:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The mutex table_lock is unlocked in two functions without first being locked.
Fix the functions to properly protect the accel_table with the table_lock.

Also, fix a spelling error in one of the function's header comment.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/adf_dev_mgr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index ae71555..4a0a829d 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -129,12 +129,13 @@ struct adf_accel_dev *adf_devmgr_get_first(void)
  * Function returns acceleration device associated with the given pci device.
  * To be used by QAT device specific drivers.
  *
- * Return: pinter to accel_dev or NULL if not found.
+ * Return: pointer to accel_dev or NULL if not found.
  */
 struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev)
 {
 	struct list_head *itr;
 
+	mutex_lock(&table_lock);
 	list_for_each(itr, &accel_table) {
 		struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
@@ -144,6 +145,7 @@ struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev)
 			return ptr;
 		}
 	}
+	mutex_unlock(&table_lock);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_pci_to_accel_dev);
@@ -152,6 +154,7 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 {
 	struct list_head *itr;
 
+	mutex_lock(&table_lock);
 	list_for_each(itr, &accel_table) {
 		struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
@@ -161,6 +164,7 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 			return ptr;
 		}
 	}
+	mutex_unlock(&table_lock);
 	return NULL;
 }
 
