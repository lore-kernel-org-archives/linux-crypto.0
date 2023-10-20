Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD58DC0032E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 15:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377836AbjJTPzu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 11:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377825AbjJTPzr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 11:55:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8050D6E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 08:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697817344; x=1729353344;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oE3sf3lxOEM0BPVFNvdSImHbUhvpxjn2zIJPeKTylhY=;
  b=U1ihjvANv158hBiWOYj747MQjd4ZX7jkRI25SCf5ZtTavqfGRx7dHBEM
   zEAZC0zhZ28YaC5MAOZas6aLbi0gStH2h969C/LTob8ZTLjqmhVRMsmAp
   pxm4ZDOt4XFrW24mGCl5iAy8Lq7SPl0rn5+b8zxrM2r5D3+mI2iJeB7De
   AFwBKB2bl4J03hD8CJwhH6cbw/YPZjjGb7xeQ6GGtdwmkUbJX/Bh4oOYq
   UeIdk6S8DxQkJOCxcQnlbCwQrPZXw1Gu5JRCwKxYl+Lbg7G0mM8JxNN3J
   bYVofhMWhchUv5sAUohQr799gAsP/R5w3UdADlywBLYJmC3tVquKhTu71
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="472745507"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="472745507"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 08:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="827764440"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="827764440"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by fmsmga004.fm.intel.com with ESMTP; 20 Oct 2023 08:55:43 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH] crypto: qat - add heartbeat error simulator
Date:   Fri, 20 Oct 2023 16:55:26 +0100
Message-ID: <20231020155541.240695-1-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Damian Muszynski <damian.muszynski@intel.com>

Add a mechanism that allows to inject a heartbeat error for testing
purposes.
A new attribute `inject_error` is added to debugfs for each QAT device.
Upon a write on this attribute, the driver will inject an error on the
device which can then be detected by the heartbeat feature.
Errors are breaking the device functionality thus they require a
device reset in order to be recovered.

This functionality is not compiled by default, to enable it
CRYPTO_DEV_QAT_ERROR_INJECTION must be set.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Co-developed-by: Shashank Gupta <shashank.gupta@intel.com>
Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat  | 26 +++++++
 drivers/crypto/intel/qat/Kconfig              | 15 ++++
 drivers/crypto/intel/qat/qat_common/Makefile  |  4 +
 .../intel/qat/qat_common/adf_common_drv.h     |  3 +
 .../intel/qat/qat_common/adf_heartbeat.c      |  6 --
 .../intel/qat/qat_common/adf_heartbeat.h      | 12 +++
 .../qat/qat_common/adf_heartbeat_dbgfs.c      | 48 ++++++++++++
 .../qat/qat_common/adf_heartbeat_inject.c     | 76 +++++++++++++++++++
 .../intel/qat/qat_common/adf_hw_arbiter.c     | 34 +++++++++
 9 files changed, 218 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c

diff --git a/Documentation/ABI/testing/debugfs-driver-qat b/Documentation/ABI/testing/debugfs-driver-qat
index b2db010d851e..b9ee628cdf62 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat
+++ b/Documentation/ABI/testing/debugfs-driver-qat
@@ -60,6 +60,32 @@ Description:	(RO) Read returns the device health status.
 		The driver does not monitor for Heartbeat. It is left for a user
 		to poll the status periodically.
 
+What:		/sys/kernel/debug/qat_<device>_<BDF>/heartbeat/inject_error
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:	(WO) Write to inject an error that simulates an heartbeat
+		failure. This is to be used for testing purposes.
+
+		After writing this file, the driver stops arbitration on a
+		random engine and disables the fetching of heartbeat counters.
+		If a workload is running on the device, a job submitted to the
+		accelerator might not get a response and a read of the
+		`heartbeat/status` attribute might report -1, i.e. device
+		unresponsive.
+		The error is unrecoverable thus the device must be restarted to
+		restore its functionality.
+
+		This attribute is available only when the kernel is built with
+		CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION=y.
+
+		A write of 1 enables error injection.
+
+		The following example shows how to enable error injection::
+
+			# cd /sys/kernel/debug/qat_<device>_<BDF>
+			# echo 1 > heartbeat/inject_error
+
 What:		/sys/kernel/debug/qat_<device>_<BDF>/pm_status
 Date:		January 2024
 KernelVersion:	6.7
diff --git a/drivers/crypto/intel/qat/Kconfig b/drivers/crypto/intel/qat/Kconfig
index 1220cc86f910..30340f61700d 100644
--- a/drivers/crypto/intel/qat/Kconfig
+++ b/drivers/crypto/intel/qat/Kconfig
@@ -95,3 +95,18 @@ config CRYPTO_DEV_QAT_C62XVF
 
 	  To compile this as a module, choose M here: the module
 	  will be called qat_c62xvf.
+
+config CRYPTO_DEV_QAT_ERROR_INJECTION
+	bool "Support for Intel(R) QAT Devices Heartbeat Error Injection"
+	default n
+	depends on CRYPTO_DEV_QAT
+	depends on DEBUG_FS
+	help
+	  Enables a mechanism that allows to inject a heartbeat error on
+	  Intel(R) QuickAssist devices for testing purposes.
+
+	  This is intended for developer use only.
+	  If unsure, say N.
+
+	  This functionality is available via debugfs entry of the Intel(R)
+	  QuickAssist device
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 779a8aa0b8d2..08a993124034 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -49,3 +49,7 @@ intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
 			       adf_gen2_pfvf.o adf_gen4_pfvf.o
+
+intel_qat-$(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION) += adf_heartbeat_inject.o
+
+ccflags-$(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION) += -DQAT_HB_ERROR_INJECTION
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index f06188033a93..c0d3c2ddbce6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -90,6 +90,9 @@ void adf_exit_aer(void);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
+#ifdef QAT_HB_ERROR_INJECTION
+int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr);
+#endif
 
 int adf_dev_get(struct adf_accel_dev *accel_dev);
 void adf_dev_put(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index 13f48d2f6da8..f88b1bc6857e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -23,12 +23,6 @@
 
 #define ADF_HB_EMPTY_SIG 0xA5A5A5A5
 
-/* Heartbeat counter pair */
-struct hb_cnt_pair {
-	__u16 resp_heartbeat_cnt;
-	__u16 req_heartbeat_cnt;
-};
-
 static int adf_hb_check_polling_freq(struct adf_accel_dev *accel_dev)
 {
 	u64 curr_time = adf_clock_get_current_time();
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
index b22e3cb29798..9405a4b6bc66 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
@@ -19,6 +19,12 @@ enum adf_device_heartbeat_status {
 	HB_DEV_UNSUPPORTED,
 };
 
+/* Heartbeat counter pair */
+struct hb_cnt_pair {
+	__u16 resp_heartbeat_cnt;
+	__u16 req_heartbeat_cnt;
+};
+
 struct adf_heartbeat {
 	unsigned int hb_sent_counter;
 	unsigned int hb_failed_counter;
@@ -35,6 +41,9 @@ struct adf_heartbeat {
 		struct dentry *cfg;
 		struct dentry *sent;
 		struct dentry *failed;
+#ifdef QAT_HB_ERROR_INJECTION
+		struct dentry *inject_error;
+#endif
 	} dbgfs;
 };
 
@@ -50,6 +59,9 @@ int adf_heartbeat_save_cfg_param(struct adf_accel_dev *accel_dev,
 void adf_heartbeat_status(struct adf_accel_dev *accel_dev,
 			  enum adf_device_heartbeat_status *hb_status);
 void adf_heartbeat_check_ctrs(struct adf_accel_dev *accel_dev);
+#ifdef QAT_HB_ERROR_INJECTION
+int adf_heartbeat_inject_error(struct adf_accel_dev *accel_dev);
+#endif
 
 #else
 static inline int adf_heartbeat_init(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
index 2661af6a2ef6..e59b5bd54828 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
@@ -155,6 +155,45 @@ static const struct file_operations adf_hb_cfg_fops = {
 	.write = adf_hb_cfg_write,
 };
 
+#ifdef QAT_HB_ERROR_INJECTION
+static ssize_t adf_hb_error_inject_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct adf_accel_dev *accel_dev = file->private_data;
+	size_t written_chars;
+	char buf[3];
+	int ret;
+
+	/* last byte left as string termination */
+	if (count != 2)
+		return -EINVAL;
+
+	written_chars = simple_write_to_buffer(buf, sizeof(buf) - 1,
+					       ppos, user_buf, count);
+	if (buf[0] != '1')
+		return -EINVAL;
+
+	ret = adf_heartbeat_inject_error(accel_dev);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"Heartbeat error injection failed with status %d\n",
+			ret);
+		return ret;
+	}
+
+	dev_info(&GET_DEV(accel_dev), "Heartbeat error injection enabled\n");
+
+	return written_chars;
+}
+
+static const struct file_operations adf_hb_error_inject_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = adf_hb_error_inject_write,
+};
+#endif
+
 void adf_heartbeat_dbgfs_add(struct adf_accel_dev *accel_dev)
 {
 	struct adf_heartbeat *hb = accel_dev->heartbeat;
@@ -171,6 +210,11 @@ void adf_heartbeat_dbgfs_add(struct adf_accel_dev *accel_dev)
 					       &hb->hb_failed_counter, &adf_hb_stats_fops);
 	hb->dbgfs.cfg = debugfs_create_file("config", 0600, hb->dbgfs.base_dir,
 					    accel_dev, &adf_hb_cfg_fops);
+#ifdef QAT_HB_ERROR_INJECTION
+	hb->dbgfs.inject_error = debugfs_create_file("inject_error", 0200,
+						     hb->dbgfs.base_dir, accel_dev,
+						     &adf_hb_error_inject_fops);
+#endif
 }
 EXPORT_SYMBOL_GPL(adf_heartbeat_dbgfs_add);
 
@@ -189,6 +233,10 @@ void adf_heartbeat_dbgfs_rm(struct adf_accel_dev *accel_dev)
 	hb->dbgfs.failed = NULL;
 	debugfs_remove(hb->dbgfs.cfg);
 	hb->dbgfs.cfg = NULL;
+#ifdef QAT_HB_ERROR_INJECTION
+	debugfs_remove(hb->dbgfs.inject_error);
+	hb->dbgfs.inject_error = NULL;
+#endif
 	debugfs_remove(hb->dbgfs.base_dir);
 	hb->dbgfs.base_dir = NULL;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
new file mode 100644
index 000000000000..a3b474bdef6c
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+#include <linux/random.h>
+
+#include "adf_admin.h"
+#include "adf_common_drv.h"
+#include "adf_heartbeat.h"
+
+#define MAX_HB_TICKS 0xFFFFFFFF
+
+static int adf_hb_set_timer_to_max(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+
+	accel_dev->heartbeat->hb_timer = 0;
+
+	if (hw_data->stop_timer)
+		hw_data->stop_timer(accel_dev);
+
+	return adf_send_admin_hb_timer(accel_dev, MAX_HB_TICKS);
+}
+
+static void adf_set_hb_counters_fail(struct adf_accel_dev *accel_dev, u32 ae,
+				     u32 thr)
+{
+	struct hb_cnt_pair *stats = accel_dev->heartbeat->dma.virt_addr;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	const size_t max_aes = hw_device->get_num_aes(hw_device);
+	const size_t hb_ctrs = hw_device->num_hb_ctrs;
+	size_t thr_id = ae * hb_ctrs + thr;
+	u16 num_rsp = stats[thr_id].resp_heartbeat_cnt;
+
+	/*
+	 * Inject live.req != live.rsp and live.rsp == last.rsp
+	 * to trigger the heartbeat error detection
+	 */
+	stats[thr_id].req_heartbeat_cnt++;
+	stats += (max_aes * hb_ctrs);
+	stats[thr_id].resp_heartbeat_cnt = num_rsp;
+}
+
+int adf_heartbeat_inject_error(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	const size_t max_aes = hw_device->get_num_aes(hw_device);
+	const size_t hb_ctrs = hw_device->num_hb_ctrs;
+	u32 rand, rand_ae, rand_thr;
+	unsigned long ae_mask;
+	int ret;
+
+	ae_mask = hw_device->ae_mask;
+
+	do {
+		/* Ensure we have a valid ae */
+		get_random_bytes(&rand, sizeof(rand));
+		rand_ae = rand % max_aes;
+	} while (!test_bit(rand_ae, &ae_mask));
+
+	get_random_bytes(&rand, sizeof(rand));
+	rand_thr = rand % hb_ctrs;
+
+	/* Increase the heartbeat timer to prevent FW updating HB counters */
+	ret = adf_hb_set_timer_to_max(accel_dev);
+	if (ret)
+		return ret;
+
+	/* Configure worker threads to stop processing any packet */
+	ret = adf_disable_arb_thd(accel_dev, rand_ae, rand_thr);
+	if (ret)
+		return ret;
+
+	/* Change HB counters memory to simulate a hang */
+	adf_set_hb_counters_fail(accel_dev, rand_ae, rand_thr);
+
+	return 0;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
index da6956699246..8592bb961b9f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
@@ -103,3 +103,37 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 		csr_ops->write_csr_ring_srv_arb_en(csr, i, 0);
 }
 EXPORT_SYMBOL_GPL(adf_exit_arb);
+
+#ifdef QAT_HB_ERROR_INJECTION
+static void adf_write_arb_wt2sam(void __iomem *csr_addr, u32 csr_offset,
+				 u32 wrk_to_ser_map_offset, size_t index, u32 value)
+{
+	WRITE_CSR_ARB_WT2SAM(csr_addr, csr_offset, wrk_to_ser_map_offset, index,
+			     value);
+}
+
+int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr)
+{
+	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	const u32 *thd_2_arb_cfg;
+	struct arb_info info;
+	u32 ae_thr_map;
+
+	if (ADF_AE_STRAND0_THREAD == thr || ADF_AE_STRAND1_THREAD == thr)
+		thr = ADF_AE_ADMIN_THREAD;
+
+	hw_data->get_arb_info(&info);
+	thd_2_arb_cfg = hw_data->get_arb_mapping(accel_dev);
+	if (!thd_2_arb_cfg)
+		return -EFAULT;
+
+	/* Disable scheduling for this particular AE and thread */
+	ae_thr_map = *(thd_2_arb_cfg + ae);
+	ae_thr_map &= ~(0x0F << (thr * 4));
+
+	adf_write_arb_wt2sam(csr, info.arb_offset, info.wt2sam_offset, ae,
+			     ae_thr_map);
+	return 0;
+}
+#endif

base-commit: 36c3294e09436a7616dc68c9134ece30bb2d4578
-- 
2.41.0

