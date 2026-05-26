Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6012F3D79E1
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779787733; cv=none; b=RRlZyP/2WnC7jo6jr8FjK1o/w/wrkbNpOqrHGRyVX9kqnIPbAWzTyIHe5o/rF4u6tVn1yFgLx0KDsXhH7XAlWIzH7Vj/gtHai3x/XC/mbVkIwySwCKJFSgofE6+C1/FY3F0LUb550LbxYihbEZ9VeI2yUO0aXXvyTAgAY8Q9xfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779787733; c=relaxed/simple;
	bh=GI4h+KU9ezRFAnRS+T2+cWut44V6XEST/ZaLeqgCNX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5D6OW9KOfyR8NNy+GaAq63MW73x5b3rexvHGU+0l/fA+YONSlbbKfT3DRViJzzIg0kH467vAqnWLECKLrZvPG4pmmCJe1Yczs1fcH3Hc+w0bxAf92aV3VQNiKYia69xn1emPvJ5si83tGOn9aWpslA0Hr8au4fpEwfTOMVgDnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AKUHlUmy; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AKUHlUmy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779787730; x=1811323730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GI4h+KU9ezRFAnRS+T2+cWut44V6XEST/ZaLeqgCNX0=;
  b=AKUHlUmyjPapvGl0OO5QtuLUc/pJwZmDtHaEYeLRimYQ4+MhefxVSmof
   F02lndTVCv+5vivbWTCMGhtO4DRzuBa15qhSs6VHTDyvQvRGgdFLEIdLh
   zz2rw08YmUcQ0ga1ulKmAaKnlS46QbZVaAj12Smj9bTQU0R7qBJHaPheG
   VCQr6oHIQxXR1CZ1tj+c26k06XTAr5i6YJ1JpLVorQCBHxLkWO7rfkn/c
   wssRsgQh8N4Lq6S4j+9dA1EOQfNhumw/aE7HPvFCtFXv2G35+BRfmvP0o
   SXWG8Svl13JevVzJUOCOj4IYBmYypvK2I2QNdjM/YufWg1mpAUkZ+e4N4
   g==;
X-CSE-ConnectionGUID: 2i7NreDRRcCi1P/3wRTe4g==
X-CSE-MsgGUID: 75XCWCJDQBG+F9fiTFFdtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="80780701"
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="80780701"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 02:28:50 -0700
X-CSE-ConnectionGUID: B96Gxj/XT4aXGEL9JHxVCQ==
X-CSE-MsgGUID: zRQSZCfdR128pfFZe4DOjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="279989683"
Received: from dmr-bkc.iind.intel.com ([10.49.111.53])
  by orviesa001.jf.intel.com with ESMTP; 26 May 2026 02:28:47 -0700
From: nitesh.venkatesh@intel.com
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Junyuan Wang <junyuan.wang@intel.com>,
	Nitesh Venkatesh <nitesh.venkatesh@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - add KPT support for GEN6 devices
Date: Tue, 26 May 2026 09:28:39 +0000
Message-ID: <20260526092839.432243-1-nitesh.venkatesh@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Junyuan Wang <junyuan.wang@intel.com>

Add support for Intel Key Protection Technology (KPT) on QAT GEN6
devices.

KPT protects private keys from exposure by keeping them wrapped
(encrypted) while in use, in-flight, and at rest. Keys remain in wrapped
form and are not exposed in plaintext in host memory. This feature
operates outside of the Linux crypto framework and kernel keyring.

Extend the firmware admin interface to enable and configure KPT. During
device initialisation, if KPT is enabled, the driver sends an admin
message to firmware to enable KPT mode and configure parameters such as
the maximum number of SWK (Symmetric Wrapping Key) slots and the SWK
time-to-live (TTL).

Expose KPT configuration via a new sysfs attribute group, "qat_kpt", and
add ABI documentation.

Co-developed-by: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Signed-off-by: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Signed-off-by: Junyuan Wang <junyuan.wang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../ABI/testing/sysfs-driver-qat_kpt          |  97 ++++++
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  21 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |   9 +
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   |   6 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  39 +++
 .../crypto/intel/qat/qat_common/adf_admin.h   |   2 +
 .../crypto/intel/qat/qat_common/adf_init.c    |   8 +
 drivers/crypto/intel/qat/qat_common/adf_kpt.c |  56 ++++
 drivers/crypto/intel/qat/qat_common/adf_kpt.h |  29 ++
 .../intel/qat/qat_common/adf_sysfs_kpt.c      | 296 ++++++++++++++++++
 .../intel/qat/qat_common/adf_sysfs_kpt.h      |  10 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |   8 +
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |   3 +-
 15 files changed, 586 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_kpt
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_kpt.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_kpt.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.h

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_kpt b/Documentation/ABI/testing/sysfs-driver-qat_kpt
new file mode 100644
index 000000000000..c6480ea1fa4f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-qat_kpt
@@ -0,0 +1,97 @@
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		Directory containing attributes related to the QAT Key Protection
+		Technology (KPT) feature. KPT allows cryptographic keys to be used
+		by the accelerator without being exposed in plaintext to the host.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/enable
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		(RW) Enables or disables Key Protection Technology (KPT).
+
+		Write 1 to enable KPT, or 0 to disable it.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_kpt/enable
+			0
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat_kpt/enable
+
+		This attribute is only available on devices that support KPT.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_fn
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		(RW) Configures the maximum number of KPT symmetric wrapping keys
+		(SWKs) that a Virtual Function (VF) may be associated with.
+
+		Valid values range from 0 to 128. A value of 0 indicates no limit.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_fn
+			128
+			# echo 128 > /sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_fn
+
+		This attribute is only available on devices that support KPT.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_pasid
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		(RW) Configures the maximum number of KPT symmetric wrapping keys
+		(SWKs) per Process Address Space ID (PASID).
+
+		Valid values range from 0 to 128. A value of 0 indicates no limit.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_pasid
+			128
+			# echo 128 > /sys/bus/pci/devices/<BDF>/qat_kpt/swk_cnt_per_pasid
+
+		This attribute is only available on devices that support KPT.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/swk_max_ttl
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		(RW) Configures the maximum Time To Live (TTL) for KPT symmetric
+		wrapping keys (SWK).
+
+		Valid values range from 0 to 31536000 seconds. A value of 0
+		indicates that the SWK TTL is unlimited.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_kpt/swk_max_ttl
+			1000
+			# echo 1000 > /sys/bus/pci/devices/<BDF>/qat_kpt/swk_max_ttl
+
+		This attribute is only available on devices that support KPT.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_kpt/swk_shared
+Date:		August 2026
+KernelVersion:	7.2
+Contact:	qat-linux@intel.com
+Description:
+		(RW) Controls shared mode for KPT symmetric wrapping keys (SWK).
+
+		Write 1 to enable shared mode, or 0 to disable it (non-shared mode).
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat_kpt/swk_shared
+			0
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat_kpt/swk_shared
+
+		This attribute is only available on devices that support KPT.
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 205680797e2c..388087e64540 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -752,10 +752,12 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 	unsigned long mask;
 	u32 caps = 0;
 	u32 fusectl1;
+	u32 fusectl0;
 
 	if (adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)))
 		return get_accel_cap_wcy(accel_dev);
 
+	fusectl0 = GET_HW_DATA(accel_dev)->fuses[ADF_FUSECTL0];
 	fusectl1 = GET_HW_DATA(accel_dev)->fuses[ADF_FUSECTL1];
 
 	/* Read accelerator capabilities mask */
@@ -785,7 +787,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			    ICP_ACCEL_CAPABILITIES_SM2 |
-			    ICP_ACCEL_CAPABILITIES_ECEDMONT;
+			    ICP_ACCEL_CAPABILITIES_ECEDMONT |
+			    ICP_ACCEL_CAPABILITIES_KPT;
 
 	if (fusectl1 & ICP_ACCEL_GEN6_MASK_PKE_SLICE) {
 		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
@@ -793,6 +796,9 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
 	}
 
+	if (fusectl0 & ADF_GEN6_KPT_FUSE_BIT)
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_KPT;
+
 	capabilities_dc = ICP_ACCEL_CAPABILITIES_COMPRESSION |
 			  ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION |
 			  ICP_ACCEL_CAPABILITIES_LZ4S_COMPRESSION |
@@ -960,6 +966,18 @@ static int dev_config(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
+static void adf_gen6_init_kpt(struct adf_kpt_hw_data *kpt_data)
+{
+	kpt_data->max_swk_cnt_per_fn_pasid = ADF_6XXX_KPT_MAX_SWK_COUNT_PER_FNPASID;
+	kpt_data->max_swk_ttl = ADF_6XXX_KPT_MAX_SWK_TTL;
+
+	kpt_data->user_input.enable = false;
+	kpt_data->user_input.swk_shared = ADF_6XXX_KPT_DEFAULT_SWK_SHARED_MODE;
+	kpt_data->user_input.swk_max_ttl = ADF_6XXX_KPT_DEFAULT_SWK_TTL;
+	kpt_data->user_input.swk_cnt_per_fn = ADF_6XXX_KPT_DEFAULT_SWK_CNT_PER_FN;
+	kpt_data->user_input.swk_cnt_per_pasid = ADF_6XXX_KPT_DEFAULT_SWK_CNT_PER_PASID;
+}
+
 static void adf_gen6_init_rl_data(struct adf_rl_hw_data *rl_data)
 {
 	rl_data->pciout_tb_offset = ADF_GEN6_RL_TOKEN_PCIEOUT_BUCKET_OFFSET;
@@ -1057,6 +1075,7 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	adf_gen6_init_tl_data(&hw_data->tl_data);
 	adf_gen6_init_rl_data(&hw_data->rl_data);
 	adf_gen6_init_anti_rb(&hw_data->anti_rb_data);
+	adf_gen6_init_kpt(&hw_data->kpt_data);
 }
 
 void adf_clean_hw_data_6xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
index e4d433bdd379..2719ddbc1e05 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
@@ -58,6 +58,7 @@
 
 /* Fuse bits */
 #define ADF_GEN6_ANTI_RB_FUSE_BIT	BIT(24)
+#define ADF_GEN6_KPT_FUSE_BIT		BIT(16)
 
 /*
  * Watchdog timers
@@ -164,6 +165,14 @@
 /* Clock frequency */
 #define ADF_6XXX_AE_FREQ			(1000 * HZ_PER_MHZ)
 
+/* KPT */
+#define ADF_6XXX_KPT_MAX_SWK_COUNT_PER_FNPASID	128
+#define ADF_6XXX_KPT_MAX_SWK_TTL		31536000
+#define ADF_6XXX_KPT_DEFAULT_SWK_SHARED_MODE	1
+#define ADF_6XXX_KPT_DEFAULT_SWK_TTL		0
+#define ADF_6XXX_KPT_DEFAULT_SWK_CNT_PER_FN	0
+#define ADF_6XXX_KPT_DEFAULT_SWK_CNT_PER_PASID	0
+
 enum icp_qat_gen6_slice_mask {
 	ICP_ACCEL_GEN6_MASK_UCS_SLICE = BIT(0),
 	ICP_ACCEL_GEN6_MASK_AUTH_SLICE = BIT(1),
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index ab62b91ecb51..319b4251ad46 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -13,6 +13,7 @@
 #include <adf_cfg.h>
 #include <adf_common_drv.h>
 #include <adf_dbgfs.h>
+#include <adf_sysfs_kpt.h>
 
 #include "adf_gen6_shared.h"
 #include "adf_6xxx_hw_data.h"
@@ -217,6 +218,11 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return ret;
 
 	ret = adf_sysfs_init(accel_dev);
+	if (ret)
+		return ret;
+
+	if (!(hw_data->fuses[ADF_FUSECTL0] & ADF_GEN6_KPT_FUSE_BIT))
+		ret = adf_sysfs_init_kpt(accel_dev);
 
 	return ret;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 2b1649001518..306ec71bb6fa 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -25,12 +25,14 @@ intel_qat-y := adf_accel_engine.o \
 	adf_hw_arbiter.o \
 	adf_init.o \
 	adf_isr.o \
+	adf_kpt.o \
 	adf_module.o \
 	adf_mstate_mgr.o \
 	adf_rl_admin.o \
 	adf_rl.o \
 	adf_sysfs.o \
 	adf_sysfs_anti_rb.o \
+	adf_sysfs_kpt.o \
 	adf_sysfs_ras_counters.o \
 	adf_sysfs_rl.o \
 	adf_timer.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index d9b2a1cf474e..f2d70641c377 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -14,6 +14,7 @@
 #include "adf_anti_rb.h"
 #include "adf_cfg_common.h"
 #include "adf_dc.h"
+#include "adf_kpt.h"
 #include "adf_rl.h"
 #include "adf_telemetry.h"
 #include "adf_pfvf_msg.h"
@@ -335,6 +336,7 @@ struct adf_hw_device_data {
 	struct adf_rl_hw_data rl_data;
 	struct adf_tl_hw_data tl_data;
 	struct adf_anti_rb_hw_data anti_rb_data;
+	struct adf_kpt_hw_data kpt_data;
 	struct qat_migdev_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 841aa802c79e..1eea74c2a8a5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -13,6 +13,7 @@
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
 #include "adf_heartbeat.h"
+#include "adf_kpt.h"
 #include "icp_qat_fw_init_admin.h"
 
 #define ADF_ADMIN_MAILBOX_STRIDE 0x1000
@@ -606,6 +607,44 @@ int adf_send_admin_arb_commit(struct adf_accel_dev *accel_dev)
 	return adf_send_admin_svn(accel_dev, ICP_QAT_FW_SVN_COMMIT, &resp);
 }
 
+static_assert(sizeof(struct icp_qat_fw_init_admin_kpt_cfg) < PAGE_SIZE);
+
+static void adf_cfg_kpt_config(struct adf_accel_dev *accel_dev,
+			       struct icp_qat_fw_init_admin_kpt_cfg *kpt_config)
+{
+	struct adf_kpt_interface_data *user_data = GET_KPT_USER_DATA(accel_dev);
+
+	kpt_config->swk_cnt_per_fn = user_data->swk_cnt_per_fn;
+	kpt_config->swk_cnt_per_pasid = user_data->swk_cnt_per_pasid;
+	kpt_config->swk_ttl_in_secs = user_data->swk_max_ttl;
+	kpt_config->swk_shared_disable = !user_data->swk_shared;
+}
+
+int adf_send_admin_kpt_init(struct adf_accel_dev *accel_dev, void *init_cfg,
+			    size_t init_cfg_sz, dma_addr_t init_ptr)
+{
+	struct icp_qat_fw_init_admin_kpt_cfg *kpt_config = init_cfg;
+	u32 ae_mask = GET_HW_DATA(accel_dev)->admin_ae_mask;
+	struct icp_qat_fw_init_admin_resp resp = { };
+	struct icp_qat_fw_init_admin_req req = { };
+	int ret;
+
+	if (!kpt_config || init_cfg_sz < sizeof(*kpt_config))
+		return -EINVAL;
+
+	adf_cfg_kpt_config(accel_dev, kpt_config);
+
+	req.cmd_id = ICP_QAT_FW_KPT_ENABLE;
+	req.init_cfg_ptr = init_ptr;
+	req.init_cfg_sz = sizeof(*kpt_config);
+
+	ret = adf_send_admin(accel_dev, &req, &resp, ae_mask);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev), "Failed to send KPT init admin message\n");
+
+	return ret;
+}
+
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 {
 	struct adf_admin_comms *admin;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.h b/drivers/crypto/intel/qat/qat_common/adf_admin.h
index 9704219f2eb7..44eb6dc92e45 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.h
@@ -29,5 +29,7 @@ int adf_send_admin_tl_start(struct adf_accel_dev *accel_dev,
 int adf_send_admin_tl_stop(struct adf_accel_dev *accel_dev);
 int adf_send_admin_arb_query(struct adf_accel_dev *accel_dev, int cmd, u8 *svn);
 int adf_send_admin_arb_commit(struct adf_accel_dev *accel_dev);
+int adf_send_admin_kpt_init(struct adf_accel_dev *accel_dev, void *init_cfg,
+			    size_t init_cfg_sz, dma_addr_t init_ptr);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 1c7f9e49914d..3e39c53814de 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -10,6 +10,7 @@
 #include "adf_dbgfs.h"
 #include "adf_heartbeat.h"
 #include "adf_rl.h"
+#include "adf_kpt.h"
 #include "adf_sysfs_anti_rb.h"
 #include "adf_sysfs_ras_counters.h"
 #include "adf_telemetry.h"
@@ -219,6 +220,13 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	/* Enable Key Protection Technology (KPT) */
+	ret = adf_enable_kpt(accel_dev);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Failed to enable KPT\n");
+		return ret;
+	}
+
 	if (hw_data->start_timer) {
 		ret = hw_data->start_timer(accel_dev);
 		if (ret) {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_kpt.c b/drivers/crypto/intel/qat/qat_common/adf_kpt.c
new file mode 100644
index 000000000000..a0430141ea0e
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_kpt.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+#include <linux/dma-mapping.h>
+
+#include "adf_admin.h"
+#include "adf_cfg_services.h"
+#include "adf_common_drv.h"
+#include "adf_kpt.h"
+
+static bool adf_kpt_supported(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+
+	return hw_data->accel_capabilities_mask & ICP_ACCEL_CAPABILITIES_KPT;
+}
+
+int adf_enable_kpt(struct adf_accel_dev *accel_dev)
+{
+	struct adf_kpt_interface_data *user_data = GET_KPT_USER_DATA(accel_dev);
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	dma_addr_t paddr;
+	void *vaddr;
+	int ret;
+	int svc;
+
+	/* Return 0 if KPT is not supported by the hardware */
+	if (!adf_kpt_supported(accel_dev))
+		return 0;
+
+	if (!user_data->enable) {
+		/* Disable KPT capability if user has not enabled it */
+		hw_data->accel_capabilities_mask &= ~ICP_ACCEL_CAPABILITIES_KPT;
+		return 0;
+	}
+
+	svc = adf_get_service_enabled(accel_dev);
+	if (svc < 0)
+		return svc;
+
+	if (svc != SVC_ASYM) {
+		dev_err(&GET_DEV(accel_dev),
+			"KPT can only be enabled when service is configured as 'asym'\n");
+		return -EINVAL;
+	}
+
+	vaddr = dma_alloc_coherent(&GET_DEV(accel_dev), PAGE_SIZE, &paddr,
+				   GFP_KERNEL);
+	if (!vaddr)
+		return -ENOMEM;
+
+	ret = adf_send_admin_kpt_init(accel_dev, vaddr, PAGE_SIZE, paddr);
+
+	dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE, vaddr, paddr);
+
+	return ret;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_kpt.h b/drivers/crypto/intel/qat/qat_common/adf_kpt.h
new file mode 100644
index 000000000000..17d07d24a319
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_kpt.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2026 Intel Corporation */
+#ifndef ADF_KPT_H_
+#define ADF_KPT_H_
+
+#include <linux/types.h>
+
+#define GET_KPT_CFG_DATA(accel_dev) (&(accel_dev)->hw_device->kpt_data)
+#define GET_KPT_USER_DATA(accel_dev) (&(accel_dev)->hw_device->kpt_data.user_input)
+
+struct adf_accel_dev;
+
+struct adf_kpt_interface_data {
+	bool enable;
+	bool swk_shared;
+	unsigned int swk_cnt_per_fn;
+	unsigned int swk_cnt_per_pasid;
+	unsigned int swk_max_ttl;
+};
+
+struct adf_kpt_hw_data {
+	unsigned int max_swk_cnt_per_fn_pasid;
+	unsigned int max_swk_ttl;
+	struct adf_kpt_interface_data user_input;
+};
+
+int adf_enable_kpt(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_KPT_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
new file mode 100644
index 000000000000..1f733ae80bdf
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
@@ -0,0 +1,296 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include "adf_cfg.h"
+#include "adf_cfg_services.h"
+#include "adf_common_drv.h"
+#include "adf_kpt.h"
+#include "adf_sysfs_kpt.h"
+
+static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+
+	return sysfs_emit(buf, "%d\n", user_data->enable);
+}
+
+static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_hw_device_data *hw_data;
+	struct adf_accel_dev *accel_dev;
+	bool enable;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down before enabling KPT\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	if (adf_get_service_enabled(accel_dev) != SVC_ASYM) {
+		dev_info(dev, "KPT can only be enabled when the asymmetric service is enabled\n");
+		return -EINVAL;
+	}
+
+	hw_data = GET_HW_DATA(accel_dev);
+
+	/*
+	 * Restore the KPT capability bit in the device's capabilities mask
+	 * before processing user input, as the bit may have been cleared if
+	 * KPT was previously disabled by the user.
+	 */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
+	if (!hw_data->accel_capabilities_mask)
+		return -EINVAL;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+	user_data->enable = enable;
+
+	return count;
+}
+static DEVICE_ATTR_RW(enable);
+
+static ssize_t swk_shared_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+
+	return sysfs_emit(buf, "%d\n", user_data->swk_shared);
+}
+
+static ssize_t swk_shared_store(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+	bool swk_shared;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down before setting swk_shared\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = kstrtobool(buf, &swk_shared);
+	if (ret)
+		return ret;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+	user_data->swk_shared = swk_shared;
+
+	return count;
+}
+static DEVICE_ATTR_RW(swk_shared);
+
+static ssize_t swk_max_ttl_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+
+	return sysfs_emit(buf, "%u\n", user_data->swk_max_ttl);
+}
+
+static ssize_t swk_max_ttl_store(struct device *dev, struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct adf_kpt_hw_data *kpt_data;
+	struct adf_accel_dev *accel_dev;
+	unsigned int swk_max_ttl;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down before setting swk_max_ttl\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = kstrtouint(buf, 10, &swk_max_ttl);
+	if (ret)
+		return ret;
+
+	kpt_data = GET_KPT_CFG_DATA(accel_dev);
+
+	if (swk_max_ttl > kpt_data->max_swk_ttl) {
+		dev_info(dev, "Configuration value is out of range (%u - %u)\n",
+			 0, kpt_data->max_swk_ttl);
+		return -EINVAL;
+	}
+
+	kpt_data->user_input.swk_max_ttl = swk_max_ttl;
+
+	return count;
+}
+static DEVICE_ATTR_RW(swk_max_ttl);
+
+static ssize_t swk_cnt_per_fn_show(struct device *dev, struct device_attribute *attr,
+				   char *buf)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+
+	return sysfs_emit(buf, "%u\n", user_data->swk_cnt_per_fn);
+}
+
+static ssize_t swk_cnt_per_fn_store(struct device *dev, struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct adf_kpt_hw_data *kpt_data;
+	struct adf_accel_dev *accel_dev;
+	unsigned int swk_cnt_per_fn;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down before setting swk_cnt_per_fn\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = kstrtouint(buf, 10, &swk_cnt_per_fn);
+	if (ret)
+		return ret;
+
+	kpt_data = GET_KPT_CFG_DATA(accel_dev);
+
+	if (swk_cnt_per_fn > kpt_data->max_swk_cnt_per_fn_pasid) {
+		dev_info(dev, "swk_cnt_per_fn: value out of range (0 - %u)\n",
+			 kpt_data->max_swk_cnt_per_fn_pasid);
+		return -EINVAL;
+	}
+
+	kpt_data->user_input.swk_cnt_per_fn = swk_cnt_per_fn;
+
+	return count;
+}
+static DEVICE_ATTR_RW(swk_cnt_per_fn);
+
+static ssize_t swk_cnt_per_pasid_show(struct device *dev, struct device_attribute *attr,
+				      char *buf)
+{
+	struct adf_kpt_interface_data *user_data;
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	user_data = GET_KPT_USER_DATA(accel_dev);
+
+	return sysfs_emit(buf, "%u\n", user_data->swk_cnt_per_pasid);
+}
+
+static ssize_t swk_cnt_per_pasid_store(struct device *dev, struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct adf_kpt_hw_data *kpt_data;
+	struct adf_accel_dev *accel_dev;
+	unsigned int swk_cnt_per_pasid;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down before setting swk_cnt_per_pasid\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = kstrtouint(buf, 10, &swk_cnt_per_pasid);
+	if (ret)
+		return ret;
+
+	kpt_data = GET_KPT_CFG_DATA(accel_dev);
+
+	if (swk_cnt_per_pasid > kpt_data->max_swk_cnt_per_fn_pasid) {
+		dev_info(dev, "swk_cnt_per_pasid: value out of range (0 - %u)\n",
+			 kpt_data->max_swk_cnt_per_fn_pasid);
+		return -EINVAL;
+	}
+
+	kpt_data->user_input.swk_cnt_per_pasid = swk_cnt_per_pasid;
+
+	return count;
+}
+static DEVICE_ATTR_RW(swk_cnt_per_pasid);
+
+static struct attribute *qat_kpt_attrs[] = {
+	&dev_attr_enable.attr,
+	&dev_attr_swk_shared.attr,
+	&dev_attr_swk_max_ttl.attr,
+	&dev_attr_swk_cnt_per_fn.attr,
+	&dev_attr_swk_cnt_per_pasid.attr,
+	NULL,
+};
+
+static const struct attribute_group qat_kpt_group = {
+	.attrs = qat_kpt_attrs,
+	.name = "qat_kpt",
+};
+
+int adf_sysfs_init_kpt(struct adf_accel_dev *accel_dev)
+{
+	int ret;
+
+	ret = devm_device_add_group(&GET_DEV(accel_dev), &qat_kpt_group);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Failed to create qat_kpt attribute group\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_sysfs_init_kpt);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.h b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.h
new file mode 100644
index 000000000000..d9d065f75114
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2026 Intel Corporation */
+#ifndef ADF_SYSFS_KPT_H_
+#define ADF_SYSFS_KPT_H_
+
+struct adf_accel_dev;
+
+int adf_sysfs_init_kpt(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_SYSFS_KPT_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 6b0f0d100cb9..95f7f514cb63 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -31,6 +31,7 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_RL_REMOVE = 136,
 	ICP_QAT_FW_TL_START = 137,
 	ICP_QAT_FW_TL_STOP = 138,
+	ICP_QAT_FW_KPT_ENABLE = 144,
 	ICP_QAT_FW_SVN_READ = 146,
 	ICP_QAT_FW_SVN_COMMIT = 147,
 };
@@ -212,4 +213,11 @@ struct icp_qat_fw_init_admin_pm_info {
 	__u32 resvrd3[6];
 };
 
+struct icp_qat_fw_init_admin_kpt_cfg {
+	__u32 swk_cnt_per_fn;
+	__u32 swk_cnt_per_pasid;
+	__u32 swk_ttl_in_secs;
+	__u32 swk_shared_disable;
+};
+
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index 16ef6d98fa42..e38115d3cd75 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -114,7 +114,8 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION = BIT(24),
 	ICP_ACCEL_CAPABILITIES_LZ4S_COMPRESSION = BIT(25),
 	ICP_ACCEL_CAPABILITIES_AES_V2 = BIT(26),
-	/* Bits 27-28 are currently reserved */
+	ICP_ACCEL_CAPABILITIES_KPT = BIT(27),
+	/* Bit 28 is currently reserved */
 	ICP_ACCEL_CAPABILITIES_ZUC_256 = BIT(29),
 	ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT = BIT(30),
 };

base-commit: 3797750c3b271f24f98cad54c2932a39a8f99e49
-- 
2.52.0

