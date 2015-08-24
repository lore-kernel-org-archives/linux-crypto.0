From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - enable legacy VFs
Date: Mon, 24 Aug 2015 11:56:02 -0700
Message-ID: <20150824185602.30820.25788.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6435 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbbHXS5U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 14:57:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We need to support legacy VFs as well as VFs running on different OSes.
To do so the compatibility check need needs to be relaxed.
This patch moves the logic responsible for VF to PF version and
compatibility checking from adfsriov.c to adf_pf2vf_msg.c,
where it belongs, and changes the logic enable legacy VFs.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    1 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c  |  102 +++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h  |    2 
 drivers/crypto/qat/qat_common/adf_sriov.c      |  119 +++---------------------
 4 files changed, 118 insertions(+), 106 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 0f5f5e8..7836dff 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -111,6 +111,7 @@ void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
 int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info);
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
 
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index c5790cd..5fdbad8 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -256,6 +256,108 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 }
 EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
+void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
+{
+	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	u32 msg, resp = 0, vf_nr = vf_info->vf_nr;
+
+	/* Read message from the VF */
+	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
+
+	/* To ACK, clear the VF2PFINT bit */
+	msg &= ~ADF_VF2PF_INT;
+	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
+
+	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM))
+		/* Ignore legacy non-system (non-kernel) VF2PF messages */
+		goto err;
+
+	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
+	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
+		{
+		u8 vf_compat_ver = msg >> ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+
+		resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
+			 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
+			  ADF_PF2VF_MSGTYPE_SHIFT) |
+			 (ADF_PFVF_COMPATIBILITY_VERSION <<
+			  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
+
+		dev_dbg(&GET_DEV(accel_dev),
+			"Compatibility Version Request from VF%d vers=%u\n",
+			vf_nr + 1, vf_compat_ver);
+
+		if (vf_compat_ver < hw_data->min_iov_compat_ver) {
+			dev_err(&GET_DEV(accel_dev),
+				"VF (vers %d) incompatible with PF (vers %d)\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_INCOMPATIBLE <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		} else if (vf_compat_ver > ADF_PFVF_COMPATIBILITY_VERSION) {
+			dev_err(&GET_DEV(accel_dev),
+				"VF (vers %d) compat with PF (vers %d) unkn.\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_COMPAT_UNKNOWN <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		} else {
+			dev_dbg(&GET_DEV(accel_dev),
+				"VF (vers %d) compatible with PF (vers %d)\n",
+				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
+			resp |= ADF_PF2VF_VF_COMPATIBLE <<
+				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		}
+		}
+		break;
+	case ADF_VF2PF_MSGTYPE_VERSION_REQ:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Legacy VersionRequest received from VF%d 0x%x\n",
+			vf_nr + 1, msg);
+		resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
+			 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
+			  ADF_PF2VF_MSGTYPE_SHIFT) |
+			 (ADF_PFVF_COMPATIBILITY_VERSION <<
+			  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
+		resp |= ADF_PF2VF_VF_COMPATIBLE <<
+			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		/* Set legacy major and minor version num */
+		resp |= 1 << ADF_PF2VF_MAJORVERSION_SHIFT |
+			1 << ADF_PF2VF_MINORVERSION_SHIFT;
+		break;
+	case ADF_VF2PF_MSGTYPE_INIT:
+		{
+		dev_dbg(&GET_DEV(accel_dev),
+			"Init message received from VF%d 0x%x\n",
+			vf_nr + 1, msg);
+		vf_info->init = true;
+		}
+		break;
+	case ADF_VF2PF_MSGTYPE_SHUTDOWN:
+		{
+		dev_dbg(&GET_DEV(accel_dev),
+			"Shutdown message received from VF%d 0x%x\n",
+			vf_nr + 1, msg);
+		vf_info->init = false;
+		}
+		break;
+	default:
+		goto err;
+	}
+
+	if (resp && adf_iov_putmsg(accel_dev, resp, vf_nr))
+		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
+
+	/* re-enable interrupt on PF from this VF */
+	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_nr));
+	return;
+err:
+	dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
+		vf_nr + 1, msg);
+}
+
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_vf_info *vf;
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
index 3ceaa38..5acd531 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
@@ -113,6 +113,8 @@
 #define ADF_PF2VF_VERSION_RESP_VERS_SHIFT	6
 #define ADF_PF2VF_VERSION_RESP_RESULT_MASK	0x0000C000
 #define ADF_PF2VF_VERSION_RESP_RESULT_SHIFT	14
+#define ADF_PF2VF_MINORVERSION_SHIFT		6
+#define ADF_PF2VF_MAJORVERSION_SHIFT		10
 #define ADF_PF2VF_VF_COMPATIBLE			1
 #define ADF_PF2VF_VF_INCOMPATIBLE		2
 #define ADF_PF2VF_VF_COMPAT_UNKNOWN		3
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 069b9ea..2f77a4a 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -79,125 +79,32 @@ static struct workqueue_struct *pf2vf_resp_wq;
 	ADF_CSR_WR(pmisc_bar_addr, ME2FUNCTION_MAP_B_OFFSET +		\
 		   ME2FUNCTION_MAP_REG_SIZE * index, value)
 
-struct adf_pf2vf_resp_data {
+struct adf_pf2vf_resp {
 	struct work_struct pf2vf_resp_work;
-	struct adf_accel_dev *accel_dev;
-	u32 resp;
-	u8 vf_nr;
+	struct adf_accel_vf_info *vf_info;
 };
 
 static void adf_iov_send_resp(struct work_struct *work)
 {
-	struct adf_pf2vf_resp_data *pf2vf_resp_data =
-		container_of(work, struct adf_pf2vf_resp_data, pf2vf_resp_work);
-
-	if (adf_iov_putmsg(pf2vf_resp_data->accel_dev, pf2vf_resp_data->resp,
-			   pf2vf_resp_data->vf_nr)) {
-		dev_err(&GET_DEV(pf2vf_resp_data->accel_dev),
-			"Failed to send response\n");
-	}
+	struct adf_pf2vf_resp *pf2vf_resp =
+		container_of(work, struct adf_pf2vf_resp, pf2vf_resp_work);
 
-	kfree(pf2vf_resp_data);
+	adf_vf2pf_req_hndl(pf2vf_resp->vf_info);
+	kfree(pf2vf_resp);
 }
 
 static void adf_vf2pf_bh_handler(void *data)
 {
 	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
-	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 msg;
-
-	/* Read message from the VF */
-	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_info->vf_nr));
-
-	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM))
-		/* Ignore legacy non-system (non-kernel) VF2PF messages */
-		goto err;
-
-	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
-	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
-		{
-		u8 vf_compat_ver = msg >> ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
-		struct adf_pf2vf_resp_data *pf2vf_resp_data;
-		u32 resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
-				 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
-				  ADF_PF2VF_MSGTYPE_SHIFT) |
-				 (ADF_PFVF_COMPATIBILITY_VERSION <<
-				  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
-
-		dev_dbg(&GET_DEV(accel_dev),
-			"Compatibility Version Request from VF%d vers=%u\n",
-			vf_info->vf_nr + 1, vf_compat_ver);
-
-		if (vf_compat_ver < hw_data->min_iov_compat_ver) {
-			dev_err(&GET_DEV(accel_dev),
-				"VF (vers %d) incompatible with PF (vers %d)\n",
-				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
-			resp |= ADF_PF2VF_VF_INCOMPATIBLE <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		} else if (vf_compat_ver > ADF_PFVF_COMPATIBILITY_VERSION) {
-			dev_err(&GET_DEV(accel_dev),
-				"VF (vers %d) compat with PF (vers %d) unkn.\n",
-				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
-			resp |= ADF_PF2VF_VF_COMPAT_UNKNOWN <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		} else {
-			dev_dbg(&GET_DEV(accel_dev),
-				"VF (vers %d) compatible with PF (vers %d)\n",
-				vf_compat_ver, ADF_PFVF_COMPATIBILITY_VERSION);
-			resp |= ADF_PF2VF_VF_COMPATIBLE <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		}
-
-		pf2vf_resp_data = kzalloc(sizeof(*pf2vf_resp_data), GFP_ATOMIC);
-		if (!pf2vf_resp_data)
-			return;
-
-		pf2vf_resp_data->accel_dev = accel_dev;
-		pf2vf_resp_data->vf_nr = vf_info->vf_nr;
-		pf2vf_resp_data->resp = resp;
-		INIT_WORK(&pf2vf_resp_data->pf2vf_resp_work, adf_iov_send_resp);
-		queue_work(pf2vf_resp_wq, &pf2vf_resp_data->pf2vf_resp_work);
-		}
-		break;
-	case ADF_VF2PF_MSGTYPE_INIT:
-		{
-		dev_dbg(&GET_DEV(accel_dev),
-			"Init message received from VF%d 0x%x\n",
-			vf_info->vf_nr + 1, msg);
-		vf_info->init = true;
-		}
-		break;
-	case ADF_VF2PF_MSGTYPE_SHUTDOWN:
-		{
-		dev_dbg(&GET_DEV(accel_dev),
-			"Shutdown message received from VF%d 0x%x\n",
-			vf_info->vf_nr + 1, msg);
-		vf_info->init = false;
-		}
-		break;
-	case ADF_VF2PF_MSGTYPE_VERSION_REQ:
-		dev_err(&GET_DEV(accel_dev),
-			"Incompatible VersionRequest received from VF%d 0x%x\n",
-			vf_info->vf_nr + 1, msg);
-		break;
-	default:
-		goto err;
-	}
+	struct adf_pf2vf_resp *pf2vf_resp;
 
-	/* To ACK, clear the VF2PFINT bit */
-	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_info->vf_nr), msg);
+	pf2vf_resp = kzalloc(sizeof(*pf2vf_resp), GFP_ATOMIC);
+	if (!pf2vf_resp)
+		return;
 
-	/* re-enable interrupt on PF from this VF */
-	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_info->vf_nr));
-	return;
-err:
-	dev_err(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
-		vf_info->vf_nr + 1, msg);
+	pf2vf_resp->vf_info = vf_info;
+	INIT_WORK(&pf2vf_resp->pf2vf_resp_work, adf_iov_send_resp);
+	queue_work(pf2vf_resp_wq, &pf2vf_resp->pf2vf_resp_work);
 }
 
 static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
