From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - adf_dev_stop should not be called in atomic
 context
Date: Tue, 29 Mar 2016 10:20:36 -0700
Message-ID: <20160329172036.2482.65213.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbcC2RZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2016 13:25:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

VFs call adf_dev_stop() from a PF to VF interrupt bottom half.
This causes an oops "scheduling while atomic", because it tries
to aquire a mutex to unregister crypto algorithms.
This patch fixes the issue by calling adf_dev_stop() asynchronusely.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c |   31 +++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 09427b3..8702b0e 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/kthread.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
@@ -90,6 +91,18 @@ static void adf_disable_msi(struct adf_accel_dev *accel_dev)
 	pci_disable_msi(pdev);
 }
 
+static int adf_dev_stop_async(void *vf)
+{
+	struct adf_accel_dev *accel_dev = vf;
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+	/* Re-enable PF2VF interrupts */
+	adf_enable_pf2vf_interrupts(accel_dev);
+	return 0;
+}
+
 static void adf_pf2vf_bh_handler(void *data)
 {
 	struct adf_accel_dev *accel_dev = data;
@@ -107,11 +120,23 @@ static void adf_pf2vf_bh_handler(void *data)
 		goto err;
 
 	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
-	case ADF_PF2VF_MSGTYPE_RESTARTING:
+	case ADF_PF2VF_MSGTYPE_RESTARTING: {
+		struct task_struct *tsk;
+
 		dev_dbg(&GET_DEV(accel_dev),
 			"Restarting msg received from PF 0x%x\n", msg);
-		adf_dev_stop(accel_dev);
-		break;
+		tsk = kthread_run(adf_dev_stop_async, accel_dev,
+				  "adf_stop_vf%d", accel_dev->accel_id);
+		if (IS_ERR(tsk))
+			dev_err(&GET_DEV(accel_dev),
+				"Couldn't schedule stop for vf_%d\n",
+				accel_dev->accel_id);
+
+		/* To ack, clear the PF2VFINT bit */
+		msg &= ~BIT(0);
+		ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
+		return;
+	}
 	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
 		dev_dbg(&GET_DEV(accel_dev),
 			"Version resp received from PF 0x%x\n", msg);
