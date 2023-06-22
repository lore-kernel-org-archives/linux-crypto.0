Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876F9EB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 18:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjFVSTG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjFVSSx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 14:18:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DDB2107
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 11:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687457931; x=1718993931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UkvBzDfs02XhTEtfgb3b4jtKFXkM4YaMgh7b2eCJbJg=;
  b=CIl3JASdu/R2Q5rqeng9ild8WhlQFDTvflom9sCguwR6KbjIG2zeK8ql
   YyCG0bb8dklvg1YG5Byjjt/XlK1pjAH1Ud7WCck0udtlJvdFVvTHEd9y9
   QNyQJzu9OMsJsDCyAGds2kxHriAGc4Gnmwa8ng2g1/kbcf8nFV6d0Hh9d
   14U/nGJR+04QMQjz9c5iat6dWP4O7xTvbsaA1N3ZM4MXAwyXL+btH7WAL
   de065Jt/FopvjovzWvBe6LLgEqeyL0G0eJmrXWftDArGihe0yQ6zdAaeA
   725/Qo+ANQchjyg9iLWKIPxa8LztQ2wIlN0o1BmLAvt7vxzrVHRvpO4UG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="340175977"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="340175977"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 11:18:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="665163065"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="665163065"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2023 11:18:35 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 5/5] crypto: qat - add heartbeat counters check
Date:   Thu, 22 Jun 2023 20:04:06 +0200
Message-Id: <20230622180405.133298-6-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230622180405.133298-1-damian.muszynski@intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A firmware update for QAT GEN2 changed the format of a data
structure used to report the heartbeat counters.

To support all firmware versions, extend the heartbeat logic
with an algorithm that detects the number of counters returned
by firmware. The algorithm detects the number of counters to
be used (and size of the corresponding data structure) by the
comparison the expected size of the data in memory, with the data
which was written by the firmware.

Firmware detection is done one time during the first read of heartbeat
debugfs file to avoid increasing the time needed to load the module.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  2 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../intel/qat/qat_common/adf_heartbeat.c      | 68 +++++++++++++++++++
 .../intel/qat/qat_common/adf_heartbeat.h      |  6 ++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  2 +
 6 files changed, 81 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index e81d11409426..9c00c441b602 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -8,6 +8,7 @@
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c3xxx_hw_data.h"
+#include "adf_heartbeat.h"
 #include "icp_qat_hw.h"
 
 /* Worker thread to service arbiter mappings */
@@ -153,6 +154,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->measure_clock = measure_clock;
 	hw_data->get_hb_clock = get_ts_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
+	hw_data->check_hb_ctrs = adf_heartbeat_check_ctrs;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 1a8c8e3a48e9..355a781693eb 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -8,6 +8,7 @@
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c62x_hw_data.h"
+#include "adf_heartbeat.h"
 #include "icp_qat_hw.h"
 
 /* Worker thread to service arbiter mappings */
@@ -155,6 +156,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->measure_clock = measure_clock;
 	hw_data->get_hb_clock = get_ts_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
+	hw_data->check_hb_ctrs = adf_heartbeat_check_ctrs;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index ab897e1717e0..e57abde66f4f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -190,6 +190,7 @@ struct adf_hw_device_data {
 	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
 	int (*start_timer)(struct adf_accel_dev *accel_dev);
 	void (*stop_timer)(struct adf_accel_dev *accel_dev);
+	void (*check_hb_ctrs)(struct adf_accel_dev *accel_dev);
 	uint32_t (*get_hb_clock)(struct adf_hw_device_data *self);
 	int (*measure_clock)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index 7358aac8e56d..beef9a5f6c75 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -20,6 +20,8 @@
 #include "adf_transport_internal.h"
 #include "icp_qat_fw_init_admin.h"
 
+#define ADF_HB_EMPTY_SIG 0xA5A5A5A5
+
 /* Heartbeat counter pair */
 struct hb_cnt_pair {
 	__u16 resp_heartbeat_cnt;
@@ -42,6 +44,57 @@ static int adf_hb_check_polling_freq(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
+/**
+ * validate_hb_ctrs_cnt() - checks if the number of heartbeat counters should
+ * be updated by one to support the currently loaded firmware.
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Return:
+ * * true - hb_ctrs must increased by ADF_NUM_PKE_STRAND
+ * * false - no changes needed
+ */
+static bool validate_hb_ctrs_cnt(struct adf_accel_dev *accel_dev)
+{
+	const size_t hb_ctrs = accel_dev->hw_device->num_hb_ctrs;
+	const size_t max_aes = accel_dev->hw_device->num_engines;
+	const size_t hb_struct_size = sizeof(struct hb_cnt_pair);
+	const size_t exp_diff_size = array3_size(ADF_NUM_PKE_STRAND, max_aes,
+						 hb_struct_size);
+	const size_t dev_ctrs = size_mul(max_aes, hb_ctrs);
+	const size_t stats_size = size_mul(dev_ctrs, hb_struct_size);
+	const u32 exp_diff_cnt = exp_diff_size / sizeof(u32);
+	const u32 stats_el_cnt = stats_size / sizeof(u32);
+	struct hb_cnt_pair *hb_stats = accel_dev->heartbeat->dma.virt_addr;
+	const u32 *mem_to_chk = (u32 *)(hb_stats + dev_ctrs);
+	u32 el_diff_cnt = 0;
+	int i;
+
+	/* count how many bytes are different from pattern */
+	for (i = 0; i < stats_el_cnt; i++) {
+		if (mem_to_chk[i] == ADF_HB_EMPTY_SIG)
+			break;
+
+		el_diff_cnt++;
+	}
+
+	return el_diff_cnt && el_diff_cnt == exp_diff_cnt;
+}
+
+void adf_heartbeat_check_ctrs(struct adf_accel_dev *accel_dev)
+{
+	struct hb_cnt_pair *hb_stats = accel_dev->heartbeat->dma.virt_addr;
+	const size_t hb_ctrs = accel_dev->hw_device->num_hb_ctrs;
+	const size_t max_aes = accel_dev->hw_device->num_engines;
+	const size_t dev_ctrs = size_mul(max_aes, hb_ctrs);
+	const size_t stats_size = size_mul(dev_ctrs, sizeof(struct hb_cnt_pair));
+	const size_t mem_items_to_fill = size_mul(stats_size, 2) / sizeof(u32);
+
+	/* fill hb stats memory with pattern */
+	memset32((uint32_t *)hb_stats, ADF_HB_EMPTY_SIG, mem_items_to_fill);
+	accel_dev->heartbeat->ctrs_cnt_checked = false;
+}
+EXPORT_SYMBOL_GPL(adf_heartbeat_check_ctrs);
+
 static int get_timer_ticks(struct adf_accel_dev *accel_dev, unsigned int *value)
 {
 	char timer_str[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = { };
@@ -123,6 +176,13 @@ static int adf_hb_get_status(struct adf_accel_dev *accel_dev)
 	size_t ae = 0;
 	int ret = 0;
 
+	if (!accel_dev->heartbeat->ctrs_cnt_checked) {
+		if (validate_hb_ctrs_cnt(accel_dev))
+			hw_device->num_hb_ctrs += ADF_NUM_PKE_STRAND;
+
+		accel_dev->heartbeat->ctrs_cnt_checked = true;
+	}
+
 	live_stats = accel_dev->heartbeat->dma.virt_addr;
 	last_stats = live_stats + dev_ctrs;
 	count_fails = (u16 *)(last_stats + dev_ctrs);
@@ -221,6 +281,11 @@ int adf_heartbeat_init(struct adf_accel_dev *accel_dev)
 	if (!hb->dma.virt_addr)
 		goto err_free;
 
+	/*
+	 * Default set this flag as true to avoid unnecessary checks,
+	 * it will be reset on platforms that need such a check
+	 */
+	hb->ctrs_cnt_checked = true;
 	accel_dev->heartbeat = hb;
 
 	return 0;
@@ -241,6 +306,9 @@ int adf_heartbeat_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (accel_dev->hw_device->check_hb_ctrs)
+		accel_dev->hw_device->check_hb_ctrs(accel_dev);
+
 	ret = get_timer_ticks(accel_dev, &timer_ticks);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
index 297147f44150..b22e3cb29798 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
@@ -24,6 +24,7 @@ struct adf_heartbeat {
 	unsigned int hb_failed_counter;
 	unsigned int hb_timer;
 	u64 last_hb_check_time;
+	bool ctrs_cnt_checked;
 	struct hb_dma_addr {
 		dma_addr_t phy_addr;
 		void *virt_addr;
@@ -48,6 +49,7 @@ int adf_heartbeat_save_cfg_param(struct adf_accel_dev *accel_dev,
 				 unsigned int timer_ms);
 void adf_heartbeat_status(struct adf_accel_dev *accel_dev,
 			  enum adf_device_heartbeat_status *hb_status);
+void adf_heartbeat_check_ctrs(struct adf_accel_dev *accel_dev);
 
 #else
 static inline int adf_heartbeat_init(struct adf_accel_dev *accel_dev)
@@ -69,5 +71,9 @@ static inline int adf_heartbeat_save_cfg_param(struct adf_accel_dev *accel_dev,
 {
 	return 0;
 }
+
+static inline void adf_heartbeat_check_ctrs(struct adf_accel_dev *accel_dev)
+{
+}
 #endif
 #endif /* ADF_HEARTBEAT_H_ */
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 8fbab905c5cc..09551f949126 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -7,6 +7,7 @@
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_dh895xcc_hw_data.h"
+#include "adf_heartbeat.h"
 #include "icp_qat_hw.h"
 
 #define ADF_DH895XCC_VF_MSK	0xFFFFFFFF
@@ -248,6 +249,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->clock_frequency = ADF_DH895X_AE_FREQ;
 	hw_data->get_hb_clock = get_ts_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
+	hw_data->check_hb_ctrs = adf_heartbeat_check_ctrs;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
-- 
2.40.1

