From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - explicitly stop all VFs first
Date: Tue, 29 Mar 2016 10:20:52 -0700
Message-ID: <20160329172052.2522.93778.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567AbcC2RZp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2016 13:25:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When stopping devices it is not enought to loop backwards.
We need to explicitly stop all VFs first.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 5c897e6..7403356 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -275,7 +275,26 @@ static int adf_ctl_stop_devices(uint32_t id)
 	struct adf_accel_dev *accel_dev;
 	int ret = 0;
 
-	list_for_each_entry_reverse(accel_dev, adf_devmgr_get_head(), list) {
+	list_for_each_entry(accel_dev, adf_devmgr_get_head(), list) {
+		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
+			if (!adf_dev_started(accel_dev))
+				continue;
+
+			/* First stop all VFs */
+			if (!accel_dev->is_vf)
+				continue;
+
+			if (adf_dev_stop(accel_dev)) {
+				dev_err(&GET_DEV(accel_dev),
+					"Failed to stop qat_dev%d\n", id);
+				ret = -EFAULT;
+			} else {
+				adf_dev_shutdown(accel_dev);
+			}
+		}
+	}
+
+	list_for_each_entry(accel_dev, adf_devmgr_get_head(), list) {
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (!adf_dev_started(accel_dev))
 				continue;
