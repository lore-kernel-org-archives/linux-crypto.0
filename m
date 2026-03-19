Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F8918DF9D
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 11:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918223; cv=none; b=i3AvB1JBQH/ln/8CwGXyAwZ7c0c2QZO4cUmT4+yxfjeeQbieg5Wl8exGxeBd9mwJaET/pTEqOolI/IlF+KKz6mBskhKpl7cfhuZt6J9JodjCDH6I+ICK/zFZmkv9ARViJGwAr+7cFrn7a/+gliFQJfqw395SkOFtCzWCDH91/ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918223; c=relaxed/simple;
	bh=Wbk1tCEAQyyAXUtc+hvjaAfud4i+L9OPNGzRv7Awe7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FwJro/4jXiUYZDx5arfzz+4sBEtHDKM4HiWn/ijTm65Dd3J007Bi88dnCXXkOotMauHhBeSnhP4Zq0M2RKNQZ1GVM9a17aWqEpFOcvVIHvlTp4Syc6Tpyni5UsxXh+tVKSN00DY97HKh3A9Bb5/en2WbhwYWDODhjnf0NBJM7uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6fMj9SC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6fMj9SC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773918220; x=1805454220;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wbk1tCEAQyyAXUtc+hvjaAfud4i+L9OPNGzRv7Awe7w=;
  b=B6fMj9SC/qpyqPAVUw9yFplVoA0QLM8g8ozk5IoGqG/NbkEUS6h++/gS
   FQNRrFl36onlegbnjGzpsVN1YTpjslGACaPawciSRZ56zsRmGz+bKGAIC
   Z87SRSGTHUo8T+UsX8tOWDCD+eyFk1RpKfbqHeby3x0/hzqAcukqTV3fr
   KaRDLs4tQKWz5OJuerunNawu0eCia+6vr+UJjgqWSq2iE2ilPuMxlHLNb
   to6B9AKzdBNvHyPQznwOdWpecH6rfPap9H3RQ+xme/9F3SaFY3rgBmvnf
   E9Mr51TuYbT/3BkZdg5EE8ijgvymEbyKtOfHUOqGUslZ9cZlAHgJ2RP4L
   Q==;
X-CSE-ConnectionGUID: AjUg2mRqRZCk96FTHv8vRA==
X-CSE-MsgGUID: uDf/kGdsQPqSAqMrFrmo7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="74872198"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="74872198"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 04:03:39 -0700
X-CSE-ConnectionGUID: Gu0k5GzZQ6uZcgn5/EkhEA==
X-CSE-MsgGUID: aY2Gqz5FTd+4cpDPtPyCVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="220322455"
Received: from basrr3dmrap-003.iind.intel.com ([10.49.111.58])
  by fmviesa008.fm.intel.com with ESMTP; 19 Mar 2026 04:03:36 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2] crypto: qat - add anti-rollback support for GEN6 devices
Date: Thu, 19 Mar 2026 11:02:57 +0000
Message-ID: <20260319110331.248189-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Anti-Rollback (ARB) is a QAT GEN6 hardware feature that prevents loading
firmware with a Security Version Number (SVN) lower than an authorized
minimum. This protects against downgrade attacks by ensuring that only
firmware at or above a committed SVN can run on the acceleration device.

During firmware loading, the driver checks the SVN validation status via
a hardware CSR. If the check reports a failure, firmware authentication
is aborted. If it reports a retry status, the driver reissues the
authentication command up to a maximum number of retries.

Extend the firmware admin interface with two new messages,
ICP_QAT_FW_SVN_READ and ICP_QAT_FW_SVN_COMMIT, to query and commit the
SVN, respectively. Integrate the SVN check into the firmware
authentication path in qat_uclo.c so the driver can react to
anti-rollback status during device bring-up.

Expose SVN information to userspace via a new sysfs attribute group,
qat_svn, under the PCI device directory. The group provides read-only
attributes for the active, enforced minimum, and permanent minimum SVN
values, as well as a write-only commit attribute that allows a system
administrator to commit the currently active SVN as the new authorized
minimum.

This is based on earlier work by Ciunas Bennett.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
v1->v2
- Replaced "Secure" with "Security" in the required files as SVN
  means Security version number.
- Style changes in adf_anti_rb.h

 .../ABI/testing/sysfs-driver-qat_svn          | 114 +++++++++++++++
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  16 +++
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |   6 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  70 +++++++++
 .../crypto/intel/qat/qat_common/adf_admin.h   |   2 +
 .../crypto/intel/qat/qat_common/adf_anti_rb.c |  66 +++++++++
 .../crypto/intel/qat/qat_common/adf_anti_rb.h |  37 +++++
 .../crypto/intel/qat/qat_common/adf_init.c    |   3 +
 .../intel/qat/qat_common/adf_sysfs_anti_rb.c  | 133 ++++++++++++++++++
 .../intel/qat/qat_common/adf_sysfs_anti_rb.h  |  11 ++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  15 +-
 .../crypto/intel/qat/qat_common/qat_uclo.c    |  25 +++-
 14 files changed, 497 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_svn
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_svn b/Documentation/ABI/testing/sysfs-driver-qat_svn
new file mode 100644
index 000000000000..3832b523dcb0
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-qat_svn
@@ -0,0 +1,114 @@
+What:		/sys/bus/pci/devices/<BDF>/qat_svn/
+Date:		June 2026
+KernelVersion:	7.1
+Contact:	qat-linux@intel.com
+Description:	Directory containing Security Version Number (SVN) attributes for
+		the Anti-Rollback (ARB) feature. The ARB feature prevents downloading
+		older firmware versions to the acceleration device.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_svn/enforced_min
+Date:		June 2026
+KernelVersion:	7.1
+Contact:	qat-linux@intel.com
+Description:
+		(RO) Reports the minimum allowed firmware SVN.
+
+		Returns an integer greater than zero. Firmware with SVN lower than
+		this value is rejected.
+
+		A write to qat_svn/commit will update this value. The update is not
+		persistent across reboot; on reboot, this value is reset from
+		qat_svn/permanent_min.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/enforced_min
+			2
+
+		This attribute is available only on devices that support
+		Anti-Rollback.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_svn/permanent_min
+Date:		June 2026
+KernelVersion:	7.1
+Contact:	qat-linux@intel.com
+Description:
+		(RO) Reports the persistent minimum SVN used to initialize
+		qat_svn/enforced_min on each reboot.
+
+		Returns an integer greater than zero. A write to qat_svn/commit
+		may update this value, depending on platform/BIOS settings.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/permanent_min
+			3
+
+		This attribute is available only on devices that support
+		Anti-Rollback.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_svn/active
+Date:		June 2026
+KernelVersion:	7.1
+Contact:	qat-linux@intel.com
+Description:
+		(RO) Reports the SVN of the currently active firmware image.
+
+		Returns an integer greater than zero.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/active
+			2
+
+		This attribute is available only on devices that support
+		Anti-Rollback.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_svn/commit
+Date:		June 2026
+KernelVersion:	7.1
+Contact:	qat-linux@intel.com
+Description:
+		(WO) Commits the currently active SVN as the minimum allowed SVN.
+
+		Writing 1 sets qat_svn/enforced_min to the value of qat_svn/active,
+		preventing future firmware loads with lower SVN.
+
+		Depending on platform/BIOS settings, a commit may also update
+		qat_svn/permanent_min.
+
+		Note that on reboot, qat_svn/enforced_min reverts to
+		qat_svn/permanent_min.
+
+		It is advisable to use this attribute with caution, only when
+		it is necessary to set a new minimum SVN for the firmware.
+
+		Before committing the SVN update, it is crucial to check the
+		current values of qat_svn/active, qat_svn/enforced_min and
+		qat_svn/permanent_min. This verification helps ensure that the
+		commit operation aligns with the intended outcome.
+
+		While writing to the file, any value other than '1' will result
+		in an error and have no effect.
+
+		Example usage::
+
+			## Read current values
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/enforced_min
+			2
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/permanent_min
+			2
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/active
+			3
+
+			## Commit active SVN
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat_svn/commit
+
+			## Read updated values
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/enforced_min
+			3
+			# cat /sys/bus/pci/devices/<BDF>/qat_svn/permanent_min
+			3
+
+		This attribute is available only on devices that support
+		Anti-Rollback.
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index f4c61978b048..177bc4eb3c24 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -462,6 +462,21 @@ static int reset_ring_pair(void __iomem *csr, u32 bank_number)
 	return 0;
 }
 
+static bool adf_anti_rb_enabled(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+
+	return !!(hw_data->fuses[0] & ADF_GEN6_ANTI_RB_FUSE_BIT);
+}
+
+static void adf_gen6_init_anti_rb(struct adf_anti_rb_hw_data *anti_rb_data)
+{
+	anti_rb_data->anti_rb_enabled = adf_anti_rb_enabled;
+	anti_rb_data->svncheck_offset = ADF_GEN6_SVNCHECK_CSR_MSG;
+	anti_rb_data->svncheck_retry = 0;
+	anti_rb_data->sysfs_added = false;
+}
+
 static int ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
@@ -1024,6 +1039,7 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	adf_gen6_init_ras_ops(&hw_data->ras_ops);
 	adf_gen6_init_tl_data(&hw_data->tl_data);
 	adf_gen6_init_rl_data(&hw_data->rl_data);
+	adf_gen6_init_anti_rb(&hw_data->anti_rb_data);
 }
 
 void adf_clean_hw_data_6xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
index fa31d6d584e6..e4d433bdd379 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
@@ -53,6 +53,12 @@
 #define ADF_GEN6_ADMINMSGLR_OFFSET	0x500578
 #define ADF_GEN6_MAILBOX_BASE_OFFSET	0x600970
 
+/* Anti-rollback */
+#define ADF_GEN6_SVNCHECK_CSR_MSG	0x640004
+
+/* Fuse bits */
+#define ADF_GEN6_ANTI_RB_FUSE_BIT	BIT(24)
+
 /*
  * Watchdog timers
  * Timeout is in cycles. Clock speed may vary across products but this
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 89845754841b..016b81e60cfb 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -4,6 +4,7 @@ ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_QAT"'
 intel_qat-y := adf_accel_engine.o \
 	adf_admin.o \
 	adf_aer.o \
+	adf_anti_rb.o \
 	adf_bank_state.o \
 	adf_cfg.o \
 	adf_cfg_services.o \
@@ -29,6 +30,7 @@ intel_qat-y := adf_accel_engine.o \
 	adf_rl_admin.o \
 	adf_rl.o \
 	adf_sysfs.o \
+	adf_sysfs_anti_rb.o \
 	adf_sysfs_ras_counters.o \
 	adf_sysfs_rl.o \
 	adf_timer.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 9fe3239f0114..cac110215c5e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/qat/qat_mig_dev.h>
 #include <linux/wordpart.h>
+#include "adf_anti_rb.h"
 #include "adf_cfg_common.h"
 #include "adf_dc.h"
 #include "adf_rl.h"
@@ -328,6 +329,7 @@ struct adf_hw_device_data {
 	struct adf_dev_err_mask dev_err_mask;
 	struct adf_rl_hw_data rl_data;
 	struct adf_tl_hw_data tl_data;
+	struct adf_anti_rb_hw_data anti_rb_data;
 	struct qat_migdev_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 573388c37100..841aa802c79e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -6,8 +6,10 @@
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/delay.h>
 #include "adf_accel_devices.h"
 #include "adf_admin.h"
+#include "adf_anti_rb.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
 #include "adf_heartbeat.h"
@@ -19,6 +21,7 @@
 #define ADF_ADMIN_POLL_DELAY_US 20
 #define ADF_ADMIN_POLL_TIMEOUT_US (5 * USEC_PER_SEC)
 #define ADF_ONE_AE 1
+#define ADF_ADMIN_RETRY_MAX 60
 
 static const u8 const_tab[1024] __aligned(1024) = {
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -536,6 +539,73 @@ int adf_send_admin_tl_stop(struct adf_accel_dev *accel_dev)
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
+static int adf_send_admin_retry(struct adf_accel_dev *accel_dev, u8 cmd_id,
+				struct icp_qat_fw_init_admin_resp *resp,
+				unsigned int sleep_ms)
+{
+	u32 admin_ae_mask = GET_HW_DATA(accel_dev)->admin_ae_mask;
+	struct icp_qat_fw_init_admin_req req = { };
+	unsigned int retries = ADF_ADMIN_RETRY_MAX;
+	int ret;
+
+	req.cmd_id = cmd_id;
+
+	do {
+		ret = adf_send_admin(accel_dev, &req, resp, admin_ae_mask);
+		if (!ret)
+			return 0;
+
+		if (resp->status != ICP_QAT_FW_INIT_RESP_STATUS_RETRY)
+			return ret;
+
+		msleep(sleep_ms);
+	} while (--retries);
+
+	return -ETIMEDOUT;
+}
+
+static int adf_send_admin_svn(struct adf_accel_dev *accel_dev, u8 cmd_id,
+			      struct icp_qat_fw_init_admin_resp *resp)
+{
+	return adf_send_admin_retry(accel_dev, cmd_id, resp, ADF_SVN_RETRY_MS);
+}
+
+int adf_send_admin_arb_query(struct adf_accel_dev *accel_dev, int cmd, u8 *svn)
+{
+	struct icp_qat_fw_init_admin_resp resp = { };
+	int ret;
+
+	ret = adf_send_admin_svn(accel_dev, ICP_QAT_FW_SVN_READ, &resp);
+	if (ret)
+		return ret;
+
+	switch (cmd) {
+	case ARB_ENFORCED_MIN_SVN:
+		*svn = resp.enforced_min_svn;
+		break;
+	case ARB_PERMANENT_MIN_SVN:
+		*svn = resp.permanent_min_svn;
+		break;
+	case ARB_ACTIVE_SVN:
+		*svn = resp.active_svn;
+		break;
+	default:
+		*svn = 0;
+		dev_err(&GET_DEV(accel_dev),
+			"Unknown secure version number request\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int adf_send_admin_arb_commit(struct adf_accel_dev *accel_dev)
+{
+	struct icp_qat_fw_init_admin_resp resp = { };
+
+	return adf_send_admin_svn(accel_dev, ICP_QAT_FW_SVN_COMMIT, &resp);
+}
+
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 {
 	struct adf_admin_comms *admin;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.h b/drivers/crypto/intel/qat/qat_common/adf_admin.h
index 647c8e196752..9704219f2eb7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.h
@@ -27,5 +27,7 @@ int adf_send_admin_tl_start(struct adf_accel_dev *accel_dev,
 			    dma_addr_t tl_dma_addr, size_t layout_sz, u8 *rp_indexes,
 			    struct icp_qat_fw_init_admin_slice_cnt *slice_count);
 int adf_send_admin_tl_stop(struct adf_accel_dev *accel_dev);
+int adf_send_admin_arb_query(struct adf_accel_dev *accel_dev, int cmd, u8 *svn);
+int adf_send_admin_arb_commit(struct adf_accel_dev *accel_dev);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_anti_rb.c b/drivers/crypto/intel/qat/qat_common/adf_anti_rb.c
new file mode 100644
index 000000000000..2c19a82d89ad
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_anti_rb.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kstrtox.h>
+
+#include "adf_accel_devices.h"
+#include "adf_admin.h"
+#include "adf_anti_rb.h"
+#include "adf_common_drv.h"
+#include "icp_qat_fw_init_admin.h"
+
+#define ADF_SVN_RETRY_MAX	60
+
+int adf_anti_rb_commit(struct adf_accel_dev *accel_dev)
+{
+	return adf_send_admin_arb_commit(accel_dev);
+}
+
+int adf_anti_rb_query(struct adf_accel_dev *accel_dev, enum anti_rb cmd, u8 *svn)
+{
+	return adf_send_admin_arb_query(accel_dev, cmd, svn);
+}
+
+int adf_anti_rb_check(struct pci_dev *pdev)
+{
+	struct adf_anti_rb_hw_data *anti_rb;
+	u32 svncheck_sts, cfc_svncheck_sts;
+	struct adf_accel_dev *accel_dev;
+	void __iomem *pmisc_addr;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	if (!accel_dev)
+		return -EINVAL;
+
+	anti_rb = GET_ANTI_RB_DATA(accel_dev);
+	if (!anti_rb->anti_rb_enabled || !anti_rb->anti_rb_enabled(accel_dev))
+		return 0;
+
+	pmisc_addr = adf_get_pmisc_base(accel_dev);
+
+	cfc_svncheck_sts = ADF_CSR_RD(pmisc_addr, anti_rb->svncheck_offset);
+
+	svncheck_sts = FIELD_GET(ADF_SVN_STS_MASK, cfc_svncheck_sts);
+	switch (svncheck_sts) {
+	case ADF_SVN_NO_STS:
+		return 0;
+	case ADF_SVN_PASS_STS:
+		anti_rb->svncheck_retry = 0;
+		return 0;
+	case ADF_SVN_FAIL_STS:
+		dev_err(&GET_DEV(accel_dev), "Security Version Number failure\n");
+		return -EIO;
+	case ADF_SVN_RETRY_STS:
+		if (anti_rb->svncheck_retry++ >= ADF_SVN_RETRY_MAX) {
+			anti_rb->svncheck_retry = 0;
+			return -ETIMEDOUT;
+		}
+		msleep(ADF_SVN_RETRY_MS);
+		return -EAGAIN;
+	default:
+		dev_err(&GET_DEV(accel_dev), "Invalid SVN check status\n");
+		return -EINVAL;
+	}
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_anti_rb.h b/drivers/crypto/intel/qat/qat_common/adf_anti_rb.h
new file mode 100644
index 000000000000..531af41a3db8
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_anti_rb.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2026 Intel Corporation */
+#ifndef ADF_ANTI_RB_H_
+#define ADF_ANTI_RB_H_
+
+#include <linux/types.h>
+
+#define GET_ANTI_RB_DATA(accel_dev) (&(accel_dev)->hw_device->anti_rb_data)
+
+#define ADF_SVN_NO_STS		0x00
+#define ADF_SVN_PASS_STS	0x01
+#define ADF_SVN_RETRY_STS	0x02
+#define ADF_SVN_FAIL_STS	0x03
+#define ADF_SVN_RETRY_MS	250
+#define ADF_SVN_STS_MASK	GENMASK(7, 0)
+
+enum anti_rb {
+	ARB_ENFORCED_MIN_SVN,
+	ARB_PERMANENT_MIN_SVN,
+	ARB_ACTIVE_SVN,
+};
+
+struct adf_accel_dev;
+struct pci_dev;
+
+struct adf_anti_rb_hw_data {
+	bool (*anti_rb_enabled)(struct adf_accel_dev *accel_dev);
+	u32 svncheck_offset;
+	u32 svncheck_retry;
+	bool sysfs_added;
+};
+
+int adf_anti_rb_commit(struct adf_accel_dev *accel_dev);
+int adf_anti_rb_query(struct adf_accel_dev *accel_dev, enum anti_rb cmd, u8 *svn);
+int adf_anti_rb_check(struct pci_dev *pdev);
+
+#endif /* ADF_ANTI_RB_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 46491048e0bb..ec376583b3ae 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -10,6 +10,7 @@
 #include "adf_dbgfs.h"
 #include "adf_heartbeat.h"
 #include "adf_rl.h"
+#include "adf_sysfs_anti_rb.h"
 #include "adf_sysfs_ras_counters.h"
 #include "adf_telemetry.h"
 
@@ -263,6 +264,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 
 	adf_dbgfs_add(accel_dev);
 	adf_sysfs_start_ras(accel_dev);
+	adf_sysfs_start_arb(accel_dev);
 
 	return 0;
 }
@@ -292,6 +294,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	adf_rl_stop(accel_dev);
 	adf_dbgfs_rm(accel_dev);
 	adf_sysfs_stop_ras(accel_dev);
+	adf_sysfs_stop_arb(accel_dev);
 
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c
new file mode 100644
index 000000000000..789341ad1bdc
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include "adf_anti_rb.h"
+#include "adf_common_drv.h"
+#include "adf_sysfs_anti_rb.h"
+
+static ssize_t enforced_min_show(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	int err;
+	u8 svn;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	err = adf_anti_rb_query(accel_dev, ARB_ENFORCED_MIN_SVN, &svn);
+	if (err)
+		return err;
+
+	return sysfs_emit(buf, "%u\n", svn);
+}
+static DEVICE_ATTR_RO(enforced_min);
+
+static ssize_t active_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	int err;
+	u8 svn;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	err = adf_anti_rb_query(accel_dev, ARB_ACTIVE_SVN, &svn);
+	if (err)
+		return err;
+
+	return sysfs_emit(buf, "%u\n", svn);
+}
+static DEVICE_ATTR_RO(active);
+
+static ssize_t permanent_min_show(struct device *dev, struct device_attribute *attr,
+				  char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	int err;
+	u8 svn;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	err = adf_anti_rb_query(accel_dev, ARB_PERMANENT_MIN_SVN, &svn);
+	if (err)
+		return err;
+
+	return sysfs_emit(buf, "%u\n", svn);
+}
+static DEVICE_ATTR_RO(permanent_min);
+
+static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct adf_accel_dev *accel_dev;
+	bool val;
+	int err;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	err = kstrtobool(buf, &val);
+	if (err)
+		return err;
+
+	if (!val)
+		return -EINVAL;
+
+	err = adf_anti_rb_commit(accel_dev);
+	if (err)
+		return err;
+
+	return count;
+}
+static DEVICE_ATTR_WO(commit);
+
+static struct attribute *qat_svn_attrs[] = {
+	&dev_attr_commit.attr,
+	&dev_attr_active.attr,
+	&dev_attr_enforced_min.attr,
+	&dev_attr_permanent_min.attr,
+	NULL
+};
+
+static const struct attribute_group qat_svn_group = {
+	.attrs = qat_svn_attrs,
+	.name = "qat_svn",
+};
+
+void adf_sysfs_start_arb(struct adf_accel_dev *accel_dev)
+{
+	struct adf_anti_rb_hw_data *anti_rb = GET_ANTI_RB_DATA(accel_dev);
+
+	if (!anti_rb->anti_rb_enabled || !anti_rb->anti_rb_enabled(accel_dev))
+		return;
+
+	if (device_add_group(&GET_DEV(accel_dev), &qat_svn_group)) {
+		dev_warn(&GET_DEV(accel_dev),
+			 "Failed to create qat_svn attribute group\n");
+		return;
+	}
+
+	anti_rb->sysfs_added = true;
+}
+
+void adf_sysfs_stop_arb(struct adf_accel_dev *accel_dev)
+{
+	struct adf_anti_rb_hw_data *anti_rb = GET_ANTI_RB_DATA(accel_dev);
+
+	if (!anti_rb->sysfs_added)
+		return;
+
+	device_remove_group(&GET_DEV(accel_dev), &qat_svn_group);
+
+	anti_rb->sysfs_added = false;
+	anti_rb->svncheck_retry = 0;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h b/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h
new file mode 100644
index 000000000000..f0c2b6e464f7
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2026 Intel Corporation */
+#ifndef ADF_SYSFS_ANTI_RB_H_
+#define ADF_SYSFS_ANTI_RB_H_
+
+struct adf_accel_dev;
+
+void adf_sysfs_start_arb(struct adf_accel_dev *accel_dev);
+void adf_sysfs_stop_arb(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_SYSFS_ANTI_RB_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 63cf18e2a4e5..6b0f0d100cb9 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -31,11 +31,15 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_RL_REMOVE = 136,
 	ICP_QAT_FW_TL_START = 137,
 	ICP_QAT_FW_TL_STOP = 138,
+	ICP_QAT_FW_SVN_READ = 146,
+	ICP_QAT_FW_SVN_COMMIT = 147,
 };
 
 enum icp_qat_fw_init_admin_resp_status {
 	ICP_QAT_FW_INIT_RESP_STATUS_SUCCESS = 0,
-	ICP_QAT_FW_INIT_RESP_STATUS_FAIL
+	ICP_QAT_FW_INIT_RESP_STATUS_FAIL = 1,
+	ICP_QAT_FW_INIT_RESP_STATUS_RETRY = 2,
+	ICP_QAT_FW_INIT_RESP_STATUS_UNSUPPORTED = 4,
 };
 
 struct icp_qat_fw_init_admin_tl_rp_indexes {
@@ -159,6 +163,15 @@ struct icp_qat_fw_init_admin_resp {
 		};
 		struct icp_qat_fw_init_admin_slice_cnt slices;
 		__u16 fw_capabilities;
+		struct {
+			__u8 enforced_min_svn;
+			__u8 permanent_min_svn;
+			__u8 active_svn;
+			__u8 resrvd9;
+			__u16 svn_status;
+			__u16 resrvd10;
+			__u64 resrvd11;
+		};
 	};
 } __packed;
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index e61a367b0d17..a00ca2a0900f 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -12,6 +12,7 @@
 #include <linux/pci_ids.h>
 #include <linux/wordpart.h>
 #include "adf_accel_devices.h"
+#include "adf_anti_rb.h"
 #include "adf_common_drv.h"
 #include "icp_qat_uclo.h"
 #include "icp_qat_hal.h"
@@ -1230,10 +1231,11 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
 {
-	u32 fcu_sts, retry = 0;
+	unsigned int retries = FW_AUTH_MAX_RETRY;
 	u32 fcu_ctl_csr, fcu_sts_csr;
 	u32 fcu_dram_hi_csr, fcu_dram_lo_csr;
 	u64 bus_addr;
+	u32 fcu_sts;
 
 	bus_addr = ADD_ADDR(desc->css_hdr_high, desc->css_hdr_low)
 			   - sizeof(struct icp_qat_auth_chunk);
@@ -1248,17 +1250,32 @@ static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_AUTH);
 
 	do {
+		int arb_ret;
+
 		msleep(FW_AUTH_WAIT_PERIOD);
 		fcu_sts = GET_CAP_CSR(handle, fcu_sts_csr);
+
+		arb_ret = adf_anti_rb_check(handle->pci_dev);
+		if (arb_ret == -EAGAIN) {
+			if ((fcu_sts & FCU_AUTH_STS_MASK) == FCU_STS_VERI_FAIL) {
+				SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_AUTH);
+				continue;
+			}
+		} else if (arb_ret) {
+			goto auth_fail;
+		}
+
 		if ((fcu_sts & FCU_AUTH_STS_MASK) == FCU_STS_VERI_FAIL)
 			goto auth_fail;
+
 		if (((fcu_sts >> FCU_STS_AUTHFWLD_POS) & 0x1))
 			if ((fcu_sts & FCU_AUTH_STS_MASK) == FCU_STS_VERI_DONE)
 				return 0;
-	} while (retry++ < FW_AUTH_MAX_RETRY);
+	} while (--retries);
+
 auth_fail:
-	pr_err("authentication error (FCU_STATUS = 0x%x),retry = %d\n",
-	       fcu_sts & FCU_AUTH_STS_MASK, retry);
+	pr_err("authentication error (FCU_STATUS = 0x%x)\n", fcu_sts & FCU_AUTH_STS_MASK);
+
 	return -EINVAL;
 }
 

base-commit: 36ac8112732d88459ca7e240d1a8e39c7d6c52c0
-- 
2.52.0

