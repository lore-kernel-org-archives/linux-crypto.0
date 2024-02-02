Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612AF13B7B4
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871316; cv=none; b=HMS/1nbDlse2j0eCSyhNkPcq+zaRZ5I2cO+LJC8JpTakl/15bNGoCu8DqTS+3a1YoQZRb1NkexIQ7cVHIABoWCHZOQGBKc5ZmeW3jjQS+ON7j12pDuOPvel/zt+FH4BuhwUEvcuVLQdQOp3bB8SmluoV+EdVNA//BElNTe+XEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871316; c=relaxed/simple;
	bh=KHwfFJlIOHLwoabu7yGFzna1/qTm3EkrCCAGubo59p8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dU0XRQCZZqx4LUvdyrwtmIVZZVo0TeadWeu4JRcCE9fIpMuvR8gNho3KAlRHN8V/p8TDNqq8GyBNUsZ+LcfBjhx/W86KNR1zLZoKK5UWZs0E7sfqnUbl801pQKNACI+Ml9j1tIMnmfzoastzOirW6d4oQspf7hzXJe0N1gT4DJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d35bsrGb; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d35bsrGb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871314; x=1738407314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KHwfFJlIOHLwoabu7yGFzna1/qTm3EkrCCAGubo59p8=;
  b=d35bsrGbLcNxn+wqW9xnXu0BbgLDo6KYwOXuij6VJENWpB3p4t4OFUTl
   dvfWESFakdiwH7eqThIrGFWUJ/EGc69ujWuXNYuoG3DgzgEftBo2DDBOA
   5cep8p39z+wtRscsn9uzYw1qOGAMBf5Kcv31FM5BcgaPtpdhIugtp4TVI
   KE9PG8tDH2Zy4RtjDs2DzV+Rdb+Iy+pDiNmrim1pI22AQCnk4nzyJC3In
   /11YJVcuuH1okLguQBoxASonLTAoJAgiN8Eg5Jg6DHIq8wh/zcq9o2Yow
   HDYDPcAsytGF2N6bq5JW/bnQrxH0I3CWnpbf1KfeUkigqO03tJZJbrf+j
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787328"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787328"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53610"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:12 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 5/9] crypto: qat - re-enable sriov after pf reset
Date: Fri,  2 Feb 2024 18:53:20 +0800
Message-Id: <20240202105324.50391-6-mun.chun.yep@intel.com>
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

When a Physical Function (PF) is reset, SR-IOV gets disabled, making the
associated Virtual Functions (VFs) unavailable. Even after reset and
using pci_restore_state, VFs remain uncreated because the numvfs still
at 0. Therefore, it's necessary to reconfigure SR-IOV to re-enable VFs.

This commit introduces the ADF_SRIOV_ENABLED configuration flag to cache
the SR-IOV enablement state. SR-IOV is only re-enabled if it was
previously configured.

This commit also introduces a dedicated workqueue without
`WQ_MEM_RECLAIM` flag for enabling SR-IOV during Heartbeat and CPM error
resets, preventing workqueue flushing warning.

This patch is based on earlier work done by Shashank Gupta.

Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 40 ++++++++++++++++++-
 .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
 .../intel/qat/qat_common/adf_common_drv.h     |  5 +++
 .../crypto/intel/qat/qat_common/adf_sriov.c   | 37 +++++++++++++++--
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index ecb114e1b59f..cd273b31db0e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -15,6 +15,7 @@ struct adf_fatal_error_data {
 };
 
 static struct workqueue_struct *device_reset_wq;
+static struct workqueue_struct *device_sriov_wq;
 
 static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 					   pci_channel_state_t state)
@@ -43,6 +44,13 @@ struct adf_reset_dev_data {
 	struct work_struct reset_work;
 };
 
+/* sriov dev data */
+struct adf_sriov_dev_data {
+	struct adf_accel_dev *accel_dev;
+	struct completion compl;
+	struct work_struct sriov_work;
+};
+
 void adf_reset_sbr(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
@@ -88,11 +96,22 @@ void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	}
 }
 
+static void adf_device_sriov_worker(struct work_struct *work)
+{
+	struct adf_sriov_dev_data *sriov_data =
+		container_of(work, struct adf_sriov_dev_data, sriov_work);
+
+	adf_reenable_sriov(sriov_data->accel_dev);
+	complete(&sriov_data->compl);
+}
+
 static void adf_device_reset_worker(struct work_struct *work)
 {
 	struct adf_reset_dev_data *reset_data =
 		  container_of(work, struct adf_reset_dev_data, reset_work);
 	struct adf_accel_dev *accel_dev = reset_data->accel_dev;
+	unsigned long wait_jiffies = msecs_to_jiffies(10000);
+	struct adf_sriov_dev_data sriov_data;
 
 	adf_dev_restarting_notify(accel_dev);
 	if (adf_dev_restart(accel_dev)) {
@@ -103,6 +122,14 @@ static void adf_device_reset_worker(struct work_struct *work)
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
 	}
+
+	sriov_data.accel_dev = accel_dev;
+	init_completion(&sriov_data.compl);
+	INIT_WORK(&sriov_data.sriov_work, adf_device_sriov_worker);
+	queue_work(device_sriov_wq, &sriov_data.sriov_work);
+	if (wait_for_completion_timeout(&sriov_data.compl, wait_jiffies))
+		adf_pf2vf_notify_restarted(accel_dev);
+
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
@@ -216,7 +243,14 @@ int adf_init_aer(void)
 {
 	device_reset_wq = alloc_workqueue("qat_device_reset_wq",
 					  WQ_MEM_RECLAIM, 0);
-	return !device_reset_wq ? -EFAULT : 0;
+	if (!device_reset_wq)
+		return -EFAULT;
+
+	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
+	if (!device_sriov_wq)
+		return -EFAULT;
+
+	return 0;
 }
 
 void adf_exit_aer(void)
@@ -224,4 +258,8 @@ void adf_exit_aer(void)
 	if (device_reset_wq)
 		destroy_workqueue(device_reset_wq);
 	device_reset_wq = NULL;
+
+	if (device_sriov_wq)
+		destroy_workqueue(device_sriov_wq);
+	device_sriov_wq = NULL;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
index 322b76903a73..e015ad6cace2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
@@ -49,5 +49,6 @@
 	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_CORE_AFFINITY
 #define ADF_ACCEL_STR "Accelerator%d"
 #define ADF_HEARTBEAT_TIMER  "HeartbeatTimer"
+#define ADF_SRIOV_ENABLED "SriovEnabled"
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 8c062d5a8db2..10891c9da6e7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -192,6 +192,7 @@ bool adf_misc_wq_queue_delayed_work(struct delayed_work *work,
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
+void adf_reenable_sriov(struct adf_accel_dev *accel_dev);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask);
 void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
@@ -212,6 +213,10 @@ static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 {
 }
 
+static inline void adf_reenable_sriov(struct adf_accel_dev *accel_dev)
+{
+}
+
 static inline int adf_init_pf_wq(void)
 {
 	return 0;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index cb2a9830f192..87a70c00c41e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -60,7 +60,6 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		/* This ptr will be populated when VFs will be created */
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
-		vf_info->vf_compat_ver = 0;
 
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
@@ -84,6 +83,32 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	return pci_enable_sriov(pdev, totalvfs);
 }
 
+void adf_reenable_sriov(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	char cfg[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	unsigned long val = 0;
+
+	if (adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				    ADF_SRIOV_ENABLED, cfg))
+		return;
+
+	if (!accel_dev->pf.vf_info)
+		return;
+
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
+					&val, ADF_DEC))
+		return;
+
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_DC,
+					&val, ADF_DEC))
+		return;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+	dev_dbg(&pdev->dev, "Re-enabling SRIOV\n");
+	adf_enable_sriov(accel_dev);
+}
+
 /**
  * adf_disable_sriov() - Disable SRIOV for the device
  * @accel_dev:  Pointer to accel device.
@@ -116,8 +141,10 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++)
 		mutex_destroy(&vf->pf2vf_lock);
 
-	kfree(accel_dev->pf.vf_info);
-	accel_dev->pf.vf_info = NULL;
+	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status)) {
+		kfree(accel_dev->pf.vf_info);
+		accel_dev->pf.vf_info = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(adf_disable_sriov);
 
@@ -195,6 +222,10 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		return ret;
 
+	val = 1;
+	adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
+				    &val, ADF_DEC);
+
 	return numvfs;
 }
 EXPORT_SYMBOL_GPL(adf_sriov_configure);
-- 
2.34.1

