Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61137C7EE23
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jun 2023 13:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbjFLN1P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbjFLN1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 09:27:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A1FDB
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 06:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686576428; x=1718112428;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2MjM/F9cSPF3rmLFbhMq2t7zClbMBYI9Rj7tuXmoAW0=;
  b=LLwGkHwMPJMlTj0XypO8yb9gR3yM0k2RbZarJtAPGy5C7lqm8l66b6u1
   teAE21UM0MbdjoGa8rhGkOU7HxLK86ytkcMCxHb551EKUOfqK862jQDnP
   F+tf4ZnIdoMiUWvoSFlAIhePUKFRZkqwV3UiKekJa3BMVjR7DJ9+cT72I
   uoz4IDW/dB0ME+vrUBxXK/fga6FJC5ydPf9chG4VJgfqg1ukVDK0TUVeO
   FyE20KPN3gdeh62sUim8xky/uMEun2lDkYVMaB4foUze9cTtdmRiNhjxg
   CFIHO0MH00nV83K6JUTuTW4DpibnfH6jAYgyGGqMbsy0oCc5vMzSOz38B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421627284"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="421627284"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 06:27:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="855627186"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="855627186"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2023 06:27:03 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - add fw_counters debugfs file
Date:   Mon, 12 Jun 2023 15:26:31 +0200
Message-Id: <20230612132631.96630-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose FW counters statistics by providing the "fw_counters" file
under debugfs. Currently the statistics include the number of
requests sent to the FW and the number of responses received
from the FW for each Acceleration Engine, for all the QAT product
line.

This patch is based on earlier work done by Marco Chiappero.

Co-developed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat  |  10 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  18 ++
 .../intel/qat/qat_common/adf_common_drv.h     |   1 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   7 +
 .../intel/qat/qat_common/adf_fw_counters.c    | 264 ++++++++++++++++++
 .../intel/qat/qat_common/adf_fw_counters.h    |  11 +
 8 files changed, 313 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-qat
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_counters.h

diff --git a/Documentation/ABI/testing/debugfs-driver-qat b/Documentation/ABI/testing/debugfs-driver-qat
new file mode 100644
index 000000000000..f75eeff4bc7a
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-driver-qat
@@ -0,0 +1,10 @@
+What:		/sys/kernel/debug/qat_<device>_<BDF>/qat/fw_counters
+Date:		June 2023
+KernelVersion:	6.5
+Contact:	qat-linux@intel.com
+Description:	(RO) Read returns the number of requests sent to the FW and the number of responses
+		received from the FW for each Acceleration Engine
+		Reported firmware counters::
+
+			<N>: Number of requests sent from Acceleration Engine N to FW and responses
+			     Acceleration Engine N received from FW
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 0db463200495..6a82ef8df733 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -29,6 +29,7 @@ intel_qat-objs := adf_cfg.o \
 	qat_bl.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
+				adf_fw_counters.o \
 				adf_dbgfs.o
 
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 5240185a023e..2198b410b029 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -294,6 +294,7 @@ struct adf_accel_dev {
 	unsigned long status;
 	atomic_t ref_count;
 	struct dentry *debugfs_dir;
+	struct dentry *fw_cntr_dbgfile;
 	struct list_head list;
 	struct module *owner;
 	struct adf_accel_pci accel_pci_dev;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index f4f698ec3a4e..804c40768d21 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -235,6 +235,24 @@ int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt)
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
+int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps)
+{
+	struct icp_qat_fw_init_admin_resp resp = { };
+	struct icp_qat_fw_init_admin_req req = { };
+	int ret;
+
+	req.cmd_id = ICP_QAT_FW_COUNTERS_GET;
+
+	ret = adf_put_admin_msg_sync(accel_dev, ae, &req, &resp);
+	if (ret || resp.status)
+		return -EFAULT;
+
+	*reqs = resp.req_rec_count;
+	*resps = resp.resp_sent_count;
+
+	return 0;
+}
+
 /**
  * adf_send_admin_init() - Function sends init message to FW
  * @accel_dev: Pointer to acceleration device.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 9976cfe65488..40e7ea95528b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -94,6 +94,7 @@ void adf_exit_aer(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
+int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
 int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
 int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
index d0a2f892e6eb..5080ecffab03 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -6,6 +6,7 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 #include "adf_dbgfs.h"
+#include "adf_fw_counters.h"
 
 /**
  * adf_dbgfs_init() - add persistent debugfs entries
@@ -56,6 +57,9 @@ void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
 {
 	if (!accel_dev->debugfs_dir)
 		return;
+
+	if (!accel_dev->is_vf)
+		adf_fw_counters_dbgfs_add(accel_dev);
 }
 
 /**
@@ -66,4 +70,7 @@ void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
 {
 	if (!accel_dev->debugfs_dir)
 		return;
+
+	if (!accel_dev->is_vf)
+		adf_fw_counters_dbgfs_rm(accel_dev);
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
new file mode 100644
index 000000000000..cb6e09ef5c9f
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/types.h>
+
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_fw_counters.h"
+
+#define ADF_FW_COUNTERS_MAX_PADDING 16
+
+enum adf_fw_counters_types {
+	ADF_FW_REQUESTS,
+	ADF_FW_RESPONSES,
+	ADF_FW_COUNTERS_COUNT
+};
+
+static const char * const adf_fw_counter_names[] = {
+	[ADF_FW_REQUESTS] = "Requests",
+	[ADF_FW_RESPONSES] = "Responses",
+};
+
+static_assert(ARRAY_SIZE(adf_fw_counter_names) == ADF_FW_COUNTERS_COUNT);
+
+struct adf_ae_counters {
+	u16 ae;
+	u64 values[ADF_FW_COUNTERS_COUNT];
+};
+
+struct adf_fw_counters {
+	u16 ae_count;
+	struct adf_ae_counters ae_counters[];
+};
+
+static void adf_fw_counters_parse_ae_values(struct adf_ae_counters *ae_counters, u32 ae,
+					    u64 req_count, u64 resp_count)
+{
+	ae_counters->ae = ae;
+	ae_counters->values[ADF_FW_REQUESTS] = req_count;
+	ae_counters->values[ADF_FW_RESPONSES] = resp_count;
+}
+
+static int adf_fw_counters_load_from_device(struct adf_accel_dev *accel_dev,
+					    struct adf_fw_counters *fw_counters)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	unsigned long ae_mask;
+	unsigned int i;
+	unsigned long ae;
+
+	/* Ignore the admin AEs */
+	ae_mask = hw_data->ae_mask & ~hw_data->admin_ae_mask;
+
+	if (hweight_long(ae_mask) > fw_counters->ae_count)
+		return -EINVAL;
+
+	i = 0;
+	for_each_set_bit(ae, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
+		u64 req_count, resp_count;
+		int ret;
+
+		ret = adf_get_ae_fw_counters(accel_dev, ae, &req_count, &resp_count);
+		if (ret)
+			return ret;
+
+		adf_fw_counters_parse_ae_values(&fw_counters->ae_counters[i++], ae,
+						req_count, resp_count);
+	}
+
+	return 0;
+}
+
+static struct adf_fw_counters *adf_fw_counters_allocate(unsigned long ae_count)
+{
+	struct adf_fw_counters *fw_counters;
+
+	if (unlikely(!ae_count))
+		return ERR_PTR(-EINVAL);
+
+	fw_counters = kmalloc(struct_size(fw_counters, ae_counters, ae_count), GFP_KERNEL);
+	if (!fw_counters)
+		return ERR_PTR(-ENOMEM);
+
+	fw_counters->ae_count = ae_count;
+
+	return fw_counters;
+}
+
+/**
+ * adf_fw_counters_get() - Return FW counters for the provided device.
+ * @accel_dev: Pointer to a QAT acceleration device
+ *
+ * Allocates and returns a table of counters containing execution statistics
+ * for each non-admin AE available through the supplied acceleration device.
+ * The caller becomes the owner of such memory and is responsible for
+ * the deallocation through a call to kfree().
+ *
+ * Returns: a pointer to a dynamically allocated struct adf_fw_counters
+ *          on success, or a negative value on error.
+ */
+static struct adf_fw_counters *adf_fw_counters_get(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	struct adf_fw_counters *fw_counters;
+	unsigned long ae_count;
+	int ret;
+
+	if (!adf_dev_started(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "QAT Device not started\n");
+		return ERR_PTR(-EFAULT);
+	}
+
+	/* Ignore the admin AEs */
+	ae_count = hweight_long(hw_data->ae_mask & ~hw_data->admin_ae_mask);
+
+	fw_counters = adf_fw_counters_allocate(ae_count);
+	if (IS_ERR(fw_counters))
+		return fw_counters;
+
+	ret = adf_fw_counters_load_from_device(accel_dev, fw_counters);
+	if (ret) {
+		kfree(fw_counters);
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to create QAT fw_counters file table [%d].\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	return fw_counters;
+}
+
+static void *qat_fw_counters_seq_start(struct seq_file *sfile, loff_t *pos)
+{
+	struct adf_fw_counters *fw_counters = sfile->private;
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	if (*pos > fw_counters->ae_count)
+		return NULL;
+
+	return &fw_counters->ae_counters[*pos - 1];
+}
+
+static void *qat_fw_counters_seq_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	struct adf_fw_counters *fw_counters = sfile->private;
+
+	(*pos)++;
+
+	if (*pos > fw_counters->ae_count)
+		return NULL;
+
+	return &fw_counters->ae_counters[*pos - 1];
+}
+
+static void qat_fw_counters_seq_stop(struct seq_file *sfile, void *v) {}
+
+static int qat_fw_counters_seq_show(struct seq_file *sfile, void *v)
+{
+	int i;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(sfile, "AE ");
+		for (i = 0; i < ADF_FW_COUNTERS_COUNT; ++i)
+			seq_printf(sfile, " %*s", ADF_FW_COUNTERS_MAX_PADDING,
+				   adf_fw_counter_names[i]);
+	} else {
+		struct adf_ae_counters *ae_counters = (struct adf_ae_counters *)v;
+
+		seq_printf(sfile, "%2d:", ae_counters->ae);
+		for (i = 0; i < ADF_FW_COUNTERS_COUNT; ++i)
+			seq_printf(sfile, " %*llu", ADF_FW_COUNTERS_MAX_PADDING,
+				   ae_counters->values[i]);
+	}
+	seq_putc(sfile, '\n');
+
+	return 0;
+}
+
+static const struct seq_operations qat_fw_counters_sops = {
+	.start = qat_fw_counters_seq_start,
+	.next = qat_fw_counters_seq_next,
+	.stop = qat_fw_counters_seq_stop,
+	.show = qat_fw_counters_seq_show,
+};
+
+static int qat_fw_counters_file_open(struct inode *inode, struct file *file)
+{
+	struct adf_accel_dev *accel_dev = inode->i_private;
+	struct seq_file *fw_counters_seq_file;
+	struct adf_fw_counters *fw_counters;
+	int ret;
+
+	fw_counters = adf_fw_counters_get(accel_dev);
+	if (IS_ERR(fw_counters))
+		return PTR_ERR(fw_counters);
+
+	ret = seq_open(file, &qat_fw_counters_sops);
+	if (unlikely(ret)) {
+		kfree(fw_counters);
+		return ret;
+	}
+
+	fw_counters_seq_file = file->private_data;
+	fw_counters_seq_file->private = fw_counters;
+	return ret;
+}
+
+static int qat_fw_counters_file_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+
+	kfree(seq->private);
+	seq->private = NULL;
+
+	return seq_release(inode, file); }
+
+static const struct file_operations qat_fw_counters_fops = {
+	.owner = THIS_MODULE,
+	.open = qat_fw_counters_file_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = qat_fw_counters_file_release,
+};
+
+/**
+ * adf_fw_counters_dbgfs_add() - Create a debugfs file containing FW
+ * execution counters.
+ * @accel_dev:  Pointer to a QAT acceleration device
+ *
+ * Function creates a file to display a table with statistics for the given
+ * QAT acceleration device. The table stores device specific execution values
+ * for each AE, such as the number of requests sent to the FW and responses
+ * received from the FW.
+ *
+ * Return: void
+ */
+void adf_fw_counters_dbgfs_add(struct adf_accel_dev *accel_dev)
+{
+	accel_dev->fw_cntr_dbgfile = debugfs_create_file("fw_counters", 0400,
+							 accel_dev->debugfs_dir,
+							 accel_dev,
+							 &qat_fw_counters_fops);
+}
+
+/**
+ * adf_fw_counters_dbgfs_rm() - Remove the debugfs file containing FW counters.
+ * @accel_dev:  Pointer to a QAT acceleration device.
+ *
+ * Function removes the file providing the table of statistics for the given
+ * QAT acceleration device.
+ *
+ * Return: void
+ */
+void adf_fw_counters_dbgfs_rm(struct adf_accel_dev *accel_dev)
+{
+	debugfs_remove(accel_dev->fw_cntr_dbgfile);
+	accel_dev->fw_cntr_dbgfile = NULL;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.h b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.h
new file mode 100644
index 000000000000..91b3b6a95f1f
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_FW_COUNTERS_H
+#define ADF_FW_COUNTERS_H
+
+struct adf_accel_dev;
+
+void adf_fw_counters_dbgfs_add(struct adf_accel_dev *accel_dev);
+void adf_fw_counters_dbgfs_rm(struct adf_accel_dev *accel_dev);
+
+#endif

base-commit: 029644bf0e67bade842496a5042605c8dd56a0b9
-- 
2.39.2

