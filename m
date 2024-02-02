Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F149F13BEB0
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871313; cv=none; b=fxeBs6Ghg9DbyB/HlXYLF2JVFPUovuws6S9l/49Eb4gCfPh1SHYNPWi6wyj8iL5XEF/TgRfAu3CpECRT/hsLKteXf4hQ7l4mkk94QWJk44VKgJfSbO3YKzOJI9ueeYcuJp53YpdffSOaLllB+1fEWktDdxk7qXFJrqCgb0ts27o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871313; c=relaxed/simple;
	bh=q1ckhf4tF9nXGLVI/HYNhoEeNl1p98L8Uik789wGNbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KFBa9sbXGob6RKpq+UQrDQdPreeBRH/r10YJXHyxel6jChGnZ341s9YRkDg7fK1O9we17xk9IugklBXeH40updyCfAghjBLlhCKiR5cGKEeSmA4EM6BC/RPAUIfQ+OL/jdnyrs+ZkyX4Cqv2mHNBa+ePoFG17/yGVufwzVHFnXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YlJM5JjX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YlJM5JjX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871312; x=1738407312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1ckhf4tF9nXGLVI/HYNhoEeNl1p98L8Uik789wGNbI=;
  b=YlJM5JjXc/W24OJQb9EvhdV7iW1UE25R+F56JUGxt8av5lFojMrEtev/
   y7hsrGKnwQbw60e+7AprcoMoOCeQTRv+nJXXfPSsB0yndjxXo6uZJ6YN7
   r3nd0Y2d8/hvl59HpAwXLNG3SMRbQzkZBFEB0FCkxDHi0c9++S9Y9KQpD
   EBIXJeAQ4UkTD+uF5OW9X/egeSNwUFlQh4Nx+UB0c14m0JoKxDb25KJh+
   OP1yHtakYFLLgTJ/qagUx2TiqfBT0wEDCVFSW/jYqbomt0i1/gGdlz8hx
   lYsY+XWgVPMK5Yg+mY4PNrFt47GjETPcZ5CwsjP+ET9hjDnyMH+q6EaQV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787310"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787310"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53597"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:10 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 4/9] crypto: qat - update PFVF protocol for recovery
Date: Fri,  2 Feb 2024 18:53:19 +0800
Message-Id: <20240202105324.50391-5-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the PFVF logic to handle restart and recovery. This adds the
following functions:

  * adf_pf2vf_notify_fatal_error(): allows the PF to notify VFs that the
    device detected a fatal error and requires a reset. This sends to
    VF the event `ADF_PF2VF_MSGTYPE_FATAL_ERROR`.
  * adf_pf2vf_wait_for_restarting_complete(): allows the PF to wait for
    `ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE` events from active VFs
    before proceeding with a reset.
  * adf_pf2vf_notify_restarted(): enables the PF to notify VFs with
    an `ADF_PF2VF_MSGTYPE_RESTARTED` event after recovery, indicating that
    the device is back to normal. This prompts VF drivers switch back to
    use the accelerator for workload processing.

These changes improve the communication and synchronization between PF
and VF drivers during system restart and recovery processes.

Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 drivers/crypto/intel/qat/qat_common/adf_aer.c |  3 +
 .../intel/qat/qat_common/adf_pfvf_msg.h       |  7 +-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.c    | 64 ++++++++++++++++++-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.h    | 21 ++++++
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |  8 +++
 .../intel/qat/qat_common/adf_pfvf_vf_proto.c  |  6 ++
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  1 +
 8 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index a16c7e6edc65..4a3c36aaa7ca 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -332,6 +332,7 @@ struct adf_accel_vf_info {
 	struct ratelimit_state vf2pf_ratelimit;
 	u32 vf_nr;
 	bool init;
+	bool restarting;
 	u8 vf_compat_ver;
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index acbbd32bd815..ecb114e1b59f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -7,6 +7,7 @@
 #include <linux/delay.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
+#include "adf_pfvf_pf_msg.h"
 
 struct adf_fatal_error_data {
 	struct adf_accel_dev *accel_dev;
@@ -189,6 +190,8 @@ static void adf_notify_fatal_error_worker(struct work_struct *work)
 		/* Disable arbitration to stop processing of new requests */
 		if (hw_device->exit_arb)
 			hw_device->exit_arb(accel_dev);
+		if (accel_dev->pf.vf_info)
+			adf_pf2vf_notify_fatal_error(accel_dev);
 	}
 
 	kfree(wq_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/intel/qat/qat_common/adf_pfvf_msg.h
index 204a42438992..d1b3ef9cadac 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_msg.h
@@ -99,6 +99,8 @@ enum pf2vf_msgtype {
 	ADF_PF2VF_MSGTYPE_RESTARTING		= 0x01,
 	ADF_PF2VF_MSGTYPE_VERSION_RESP		= 0x02,
 	ADF_PF2VF_MSGTYPE_BLKMSG_RESP		= 0x03,
+	ADF_PF2VF_MSGTYPE_FATAL_ERROR		= 0x04,
+	ADF_PF2VF_MSGTYPE_RESTARTED		= 0x05,
 /* Values from 0x10 are Gen4 specific, message type is only 4 bits in Gen2 devices. */
 	ADF_PF2VF_MSGTYPE_RP_RESET_RESP		= 0x10,
 };
@@ -112,6 +114,7 @@ enum vf2pf_msgtype {
 	ADF_VF2PF_MSGTYPE_LARGE_BLOCK_REQ	= 0x07,
 	ADF_VF2PF_MSGTYPE_MEDIUM_BLOCK_REQ	= 0x08,
 	ADF_VF2PF_MSGTYPE_SMALL_BLOCK_REQ	= 0x09,
+	ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE	= 0x0a,
 /* Values from 0x10 are Gen4 specific, message type is only 4 bits in Gen2 devices. */
 	ADF_VF2PF_MSGTYPE_RP_RESET		= 0x10,
 };
@@ -124,8 +127,10 @@ enum pfvf_compatibility_version {
 	ADF_PFVF_COMPAT_FAST_ACK		= 0x03,
 	/* Ring to service mapping support for non-standard mappings */
 	ADF_PFVF_COMPAT_RING_TO_SVC_MAP		= 0x04,
+	/* Fallback compat */
+	ADF_PFVF_COMPAT_FALLBACK		= 0x05,
 	/* Reference to the latest version */
-	ADF_PFVF_COMPAT_THIS_VERSION		= 0x04,
+	ADF_PFVF_COMPAT_THIS_VERSION		= 0x05,
 };
 
 /* PF->VF Version Response */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
index 14c069f0d71a..0e31f4b41844 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
@@ -1,21 +1,83 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include "adf_accel_devices.h"
 #include "adf_pfvf_msg.h"
 #include "adf_pfvf_pf_msg.h"
 #include "adf_pfvf_pf_proto.h"
 
+#define ADF_PF_WAIT_RESTARTING_COMPLETE_DELAY	100
+#define ADF_VF_SHUTDOWN_RETRY			100
+
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_vf_info *vf;
 	struct pfvf_message msg = { .type = ADF_PF2VF_MSGTYPE_RESTARTING };
 	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
 
+	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify restarting\n");
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		if (vf->init && adf_send_pf2vf_msg(accel_dev, i, msg))
+		vf->restarting = false;
+		if (!vf->init)
+			continue;
+		if (adf_send_pf2vf_msg(accel_dev, i, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send restarting msg to VF%d\n", i);
+		else if (vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
+			vf->restarting = true;
+	}
+}
+
+void adf_pf2vf_wait_for_restarting_complete(struct adf_accel_dev *accel_dev)
+{
+	int num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
+	int i, retries = ADF_VF_SHUTDOWN_RETRY;
+	struct adf_accel_vf_info *vf;
+	bool vf_running;
+
+	dev_dbg(&GET_DEV(accel_dev), "pf2vf wait for restarting complete\n");
+	do {
+		vf_running = false;
+		for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++)
+			if (vf->restarting)
+				vf_running = true;
+		if (!vf_running)
+			break;
+		msleep(ADF_PF_WAIT_RESTARTING_COMPLETE_DELAY);
+	} while (--retries);
+
+	if (vf_running)
+		dev_warn(&GET_DEV(accel_dev), "Some VFs are still running\n");
+}
+
+void adf_pf2vf_notify_restarted(struct adf_accel_dev *accel_dev)
+{
+	struct pfvf_message msg = { .type = ADF_PF2VF_MSGTYPE_RESTARTED };
+	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
+	struct adf_accel_vf_info *vf;
+
+	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify restarted\n");
+	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
+		if (vf->init && vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK &&
+		    adf_send_pf2vf_msg(accel_dev, i, msg))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send restarted msg to VF%d\n", i);
+	}
+}
+
+void adf_pf2vf_notify_fatal_error(struct adf_accel_dev *accel_dev)
+{
+	struct pfvf_message msg = { .type = ADF_PF2VF_MSGTYPE_FATAL_ERROR };
+	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
+	struct adf_accel_vf_info *vf;
+
+	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify fatal error\n");
+	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
+		if (vf->init && vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK &&
+		    adf_send_pf2vf_msg(accel_dev, i, msg))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send fatal error msg to VF%d\n", i);
 	}
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.h b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.h
index e8982d1ac896..f203d88c919c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.h
@@ -5,7 +5,28 @@
 
 #include "adf_accel_devices.h"
 
+#if defined(CONFIG_PCI_IOV)
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
+void adf_pf2vf_wait_for_restarting_complete(struct adf_accel_dev *accel_dev);
+void adf_pf2vf_notify_restarted(struct adf_accel_dev *accel_dev);
+void adf_pf2vf_notify_fatal_error(struct adf_accel_dev *accel_dev);
+#else
+static inline void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_pf2vf_wait_for_restarting_complete(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_pf2vf_notify_restarted(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_pf2vf_notify_fatal_error(struct adf_accel_dev *accel_dev)
+{
+}
+#endif
 
 typedef int (*adf_pf2vf_blkmsg_provider)(struct adf_accel_dev *accel_dev,
 					 u8 *buffer, u8 compat);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
index 388e58bcbcaf..9ab93fbfefde 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
@@ -291,6 +291,14 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 		vf_info->init = false;
 		}
 		break;
+	case ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE:
+		{
+		dev_dbg(&GET_DEV(accel_dev),
+			"Restarting Complete received from VF%d\n", vf_nr);
+		vf_info->restarting = false;
+		vf_info->init = false;
+		}
+		break;
 	case ADF_VF2PF_MSGTYPE_LARGE_BLOCK_REQ:
 	case ADF_VF2PF_MSGTYPE_MEDIUM_BLOCK_REQ:
 	case ADF_VF2PF_MSGTYPE_SMALL_BLOCK_REQ:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_proto.c
index 1015155b6374..dc284a089c88 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_proto.c
@@ -308,6 +308,12 @@ static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev,
 
 		adf_pf2vf_handle_pf_restarting(accel_dev);
 		return false;
+	case ADF_PF2VF_MSGTYPE_RESTARTED:
+		dev_dbg(&GET_DEV(accel_dev), "Restarted message received from PF\n");
+		return true;
+	case ADF_PF2VF_MSGTYPE_FATAL_ERROR:
+		dev_err(&GET_DEV(accel_dev), "Fatal error received from PF\n");
+		return true;
 	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
 	case ADF_PF2VF_MSGTYPE_BLKMSG_RESP:
 	case ADF_PF2VF_MSGTYPE_RP_RESET_RESP:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index f44025bb6f99..cb2a9830f192 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -103,6 +103,7 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 		return;
 
 	adf_pf2vf_notify_restarting(accel_dev);
+	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-- 
2.34.1

