Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BFDEB64DB
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 09:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbjFOJRZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 05:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239143AbjFOJRY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 05:17:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B95199D
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 02:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686820642; x=1718356642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BMCetXizfqjB8K0A/Gg2ow54/kf25i7DfZ2BVGeTRv0=;
  b=NFl1iHWdG7J0Mt+X0gcEZ8VQBTr/0GE/lag9t1LPDJR/Bd5MSiOAafyG
   cg7kiJ4KNvrUQq3E9+yOIENK1ema23kAK5XHanvxEKDPmbrxW6MKrO0zZ
   UwWEa5ZLX0kBVIi2v0WoMLynOVrV+nXBfBA4lo/Y18EiDb01g1gyB+Vnq
   cmdpjUlJ7WuESBjx9oeY1DFlILHrelKd37s1COO75PRvzeeN0rjQ10siJ
   MjL/00LQxMgRwoYzRCOaGJqpVIhMjAXPxs8gfRk4BoPWnNSBkIQu9zq48
   R5HhT71RHaUPTvgOfuLjV+ZsTDp1qy3KgTZ8/wN7N01VIqcxYsfgWdDo9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="356350672"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="356350672"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 02:17:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782456141"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="782456141"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2023 02:17:21 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/4] crypto: qat - add measure clock frequency
Date:   Thu, 15 Jun 2023 11:04:35 +0200
Message-Id: <20230615090437.436796-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615090437.436796-1-damian.muszynski@intel.com>
References: <20230615090437.436796-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The QAT hardware does not expose a mechanism to report its clock
frequency. This is required to implement the Heartbeat feature.

Add a clock measuring algorithm that estimates the frequency by
comparing the internal timestamp counter incremented by the firmware
with the time measured by the kernel.
The frequency value is only used internally and not exposed to
the user.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  10 ++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   4 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  25 ++++
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   7 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  25 ++++
 .../intel/qat/qat_c62x/adf_c62x_hw_data.h     |   7 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  17 +++
 .../crypto/intel/qat/qat_common/adf_clock.c   | 127 ++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_clock.h   |  14 ++
 .../intel/qat/qat_common/adf_common_drv.h     |   1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |   8 ++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |   1 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  10 ++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   5 +
 16 files changed, 264 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 831d460bc503..9cda0c17992a 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -3,6 +3,7 @@
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
 #include <adf_cfg.h>
+#include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen4_dc.h>
 #include <adf_gen4_hw_data.h>
@@ -318,6 +319,14 @@ static void get_admin_info(struct admin_info *admin_csrs_info)
 	admin_csrs_info->admin_msg_lr = ADF_4XXX_ADMINMSGLR_OFFSET;
 }
 
+static u32 get_heartbeat_clock(struct adf_hw_device_data *self)
+{
+	/*
+	 * 4XXX uses KPT counter for HB
+	 */
+	return ADF_4XXX_KPT_COUNTER_FREQ;
+}
+
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_4XXX_PMISC_BAR];
@@ -511,6 +520,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->dev_config = adf_gen4_dev_config;
 	hw_data->start_timer = adf_gen4_timer_start;
 	hw_data->stop_timer = adf_gen4_timer_stop;
+	hw_data->get_hb_clock = get_heartbeat_clock;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
index e5b314d2b60e..bb3d95a8fb21 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -3,6 +3,7 @@
 #ifndef ADF_4XXX_HW_DATA_H_
 #define ADF_4XXX_HW_DATA_H_
 
+#include <linux/units.h>
 #include <adf_accel_devices.h>
 
 /* PCIe configuration space */
@@ -64,6 +65,9 @@
 #define ADF_402XX_ASYM_OBJ	"qat_402xx_asym.bin"
 #define ADF_402XX_ADMIN_OBJ	"qat_402xx_admin.bin"
 
+/* Clocks frequency */
+#define ADF_4XXX_KPT_COUNTER_FREQ (100 * HZ_PER_MHZ)
+
 /* qat_4xxx fuse bits are different from old GENs, redefine them */
 enum icp_qat_4xxx_slice_mask {
 	ICP_ACCEL_4XXX_MASK_CIPHER_SLICE = BIT(0),
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 475643654e64..2c6a1dd9780c 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
@@ -50,6 +51,28 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ~(fuses | straps) & ADF_C3XXX_ACCELENGINES_MASK;
 }
 
+static u32 get_ts_clock(struct adf_hw_device_data *self)
+{
+	/*
+	 * Timestamp update interval is 16 AE clock ticks for c3xxx.
+	 */
+	return self->clock_frequency / 16;
+}
+
+static int measure_clock(struct adf_accel_dev *accel_dev)
+{
+	u32 frequency;
+	int ret;
+
+	ret = adf_dev_measure_clock(accel_dev, &frequency, ADF_C3XXX_MIN_AE_FREQ,
+				    ADF_C3XXX_MAX_AE_FREQ);
+	if (ret)
+		return ret;
+
+	accel_dev->hw_device->clock_frequency = frequency;
+	return 0;
+}
+
 static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_C3XXX_PMISC_BAR;
@@ -127,6 +150,8 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->dev_config = adf_gen2_dev_config;
+	hw_data->measure_clock = measure_clock;
+	hw_data->get_hb_clock = get_ts_clock;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 336a06f11dbd..690c6a1aa172 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -3,6 +3,8 @@
 #ifndef ADF_C3XXX_HW_DATA_H_
 #define ADF_C3XXX_HW_DATA_H_
 
+#include <linux/units.h>
+
 /* PCIe configuration space */
 #define ADF_C3XXX_PMISC_BAR 0
 #define ADF_C3XXX_ETR_BAR 1
@@ -19,6 +21,11 @@
 #define ADF_C3XXX_AE2FUNC_MAP_GRP_A_NUM_REGS 48
 #define ADF_C3XXX_AE2FUNC_MAP_GRP_B_NUM_REGS 6
 
+/* Clocks frequency */
+#define ADF_C3XXX_AE_FREQ (685 * HZ_PER_MHZ)
+#define ADF_C3XXX_MIN_AE_FREQ (533 * HZ_PER_MHZ)
+#define ADF_C3XXX_MAX_AE_FREQ (685 * HZ_PER_MHZ)
+
 /* Firmware Binary */
 #define ADF_C3XXX_FW "qat_c3xxx.bin"
 #define ADF_C3XXX_MMP "qat_c3xxx_mmp.bin"
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index e14270703670..081702be839e 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
@@ -50,6 +51,28 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ~(fuses | straps) & ADF_C62X_ACCELENGINES_MASK;
 }
 
+static u32 get_ts_clock(struct adf_hw_device_data *self)
+{
+	/*
+	 * Timestamp update interval is 16 AE clock ticks for c62x.
+	 */
+	return self->clock_frequency / 16;
+}
+
+static int measure_clock(struct adf_accel_dev *accel_dev)
+{
+	u32 frequency;
+	int ret;
+
+	ret = adf_dev_measure_clock(accel_dev, &frequency, ADF_C62X_MIN_AE_FREQ,
+				    ADF_C62X_MAX_AE_FREQ);
+	if (ret)
+		return ret;
+
+	accel_dev->hw_device->clock_frequency = frequency;
+	return 0;
+}
+
 static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_C62X_PMISC_BAR;
@@ -129,6 +152,8 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->dev_config = adf_gen2_dev_config;
+	hw_data->measure_clock = measure_clock;
+	hw_data->get_hb_clock = get_ts_clock;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.h
index 008c0a3a9769..13e6ebf6fd91 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.h
@@ -3,6 +3,8 @@
 #ifndef ADF_C62X_HW_DATA_H_
 #define ADF_C62X_HW_DATA_H_
 
+#include <linux/units.h>
+
 /* PCIe configuration space */
 #define ADF_C62X_SRAM_BAR 0
 #define ADF_C62X_PMISC_BAR 1
@@ -19,6 +21,11 @@
 #define ADF_C62X_AE2FUNC_MAP_GRP_A_NUM_REGS 80
 #define ADF_C62X_AE2FUNC_MAP_GRP_B_NUM_REGS 10
 
+/* Clocks frequency */
+#define ADF_C62X_AE_FREQ (685 * HZ_PER_MHZ)
+#define ADF_C62X_MIN_AE_FREQ (533 * HZ_PER_MHZ)
+#define ADF_C62X_MAX_AE_FREQ (800 * HZ_PER_MHZ)
+
 /* Firmware Binary */
 #define ADF_C62X_FW "qat_c62x.bin"
 #define ADF_C62X_MMP "qat_c62x_mmp.bin"
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 6a82ef8df733..b3e32d2abf45 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -18,6 +18,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_gen2_dc.o \
 	adf_gen4_dc.o \
 	adf_gen4_timer.o \
+	adf_clock.o \
 	qat_crypto.o \
 	qat_compression.o \
 	qat_comp_algs.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 2198b410b029..c96f59cb7de9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -190,6 +190,8 @@ struct adf_hw_device_data {
 	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
 	int (*start_timer)(struct adf_accel_dev *accel_dev);
 	void (*stop_timer)(struct adf_accel_dev *accel_dev);
+	uint32_t (*get_hb_clock)(struct adf_hw_device_data *self);
+	int (*measure_clock)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	const u32 *(*get_arb_mapping)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 44c54321c8fe..7d1c93739111 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -15,6 +15,7 @@
 #define ADF_CONST_TABLE_SIZE 1024
 #define ADF_ADMIN_POLL_DELAY_US 20
 #define ADF_ADMIN_POLL_TIMEOUT_US (5 * USEC_PER_SEC)
+#define ADF_ONE_AE 1
 
 static const u8 const_tab[1024] __aligned(1024) = {
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -194,6 +195,22 @@ static int adf_set_fw_constants(struct adf_accel_dev *accel_dev)
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
+int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp)
+{
+	struct icp_qat_fw_init_admin_req req = { };
+	struct icp_qat_fw_init_admin_resp resp;
+	unsigned int ae_mask = ADF_ONE_AE;
+	int ret;
+
+	req.cmd_id = ICP_QAT_FW_TIMER_GET;
+	ret = adf_send_admin(accel_dev, &req, &resp, ae_mask);
+	if (ret)
+		return ret;
+
+	*timestamp = resp.timestamp;
+	return 0;
+}
+
 static int adf_get_dc_capabilities(struct adf_accel_dev *accel_dev,
 				   u32 *capabilities)
 {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_clock.c b/drivers/crypto/intel/qat/qat_common/adf_clock.c
new file mode 100644
index 000000000000..092f470ff6a6
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_clock.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/delay.h>
+#include <linux/dev_printk.h>
+#include <linux/export.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
+#include <linux/time64.h>
+#include <linux/types.h>
+#include <linux/units.h>
+#include <asm/errno.h>
+#include "adf_accel_devices.h"
+#include "adf_clock.h"
+#include "adf_common_drv.h"
+
+#define MEASURE_CLOCK_RETRIES 10
+#define MEASURE_CLOCK_DELAY_US 10000
+#define ME_CLK_DIVIDER 16
+#define MEASURE_CLOCK_DELTA_THRESHOLD_US 100
+
+static inline u64 timespec_to_us(const struct timespec64 *ts)
+{
+	return (u64)DIV_ROUND_CLOSEST(timespec64_to_ns(ts), NSEC_PER_USEC);
+}
+
+static inline u64 timespec_to_ms(const struct timespec64 *ts)
+{
+	return (u64)DIV_ROUND_CLOSEST(timespec64_to_ns(ts), NSEC_PER_MSEC);
+}
+
+u64 adf_clock_get_current_time(void)
+{
+	struct timespec64 ts;
+
+	ktime_get_real_ts64(&ts);
+	return timespec_to_ms(&ts);
+}
+
+static int measure_clock(struct adf_accel_dev *accel_dev, u32 *frequency)
+{
+	struct timespec64 ts1, ts2, ts3, ts4;
+	u64 timestamp1, timestamp2, temp;
+	u32 delta_us, tries;
+	int ret;
+
+	tries = MEASURE_CLOCK_RETRIES;
+	do {
+		ktime_get_real_ts64(&ts1);
+		ret = adf_get_fw_timestamp(accel_dev, &timestamp1);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to get fw timestamp\n");
+			return ret;
+		}
+		ktime_get_real_ts64(&ts2);
+		delta_us = timespec_to_us(&ts2) - timespec_to_us(&ts1);
+	} while (delta_us > MEASURE_CLOCK_DELTA_THRESHOLD_US && --tries);
+
+	if (!tries) {
+		dev_err(&GET_DEV(accel_dev), "Excessive clock measure delay\n");
+		return -ETIMEDOUT;
+	}
+
+	fsleep(MEASURE_CLOCK_DELAY_US);
+
+	tries = MEASURE_CLOCK_RETRIES;
+	do {
+		ktime_get_real_ts64(&ts3);
+		if (adf_get_fw_timestamp(accel_dev, &timestamp2)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to get fw timestamp\n");
+			return -EIO;
+		}
+		ktime_get_real_ts64(&ts4);
+		delta_us = timespec_to_us(&ts4) - timespec_to_us(&ts3);
+	} while (delta_us > MEASURE_CLOCK_DELTA_THRESHOLD_US && --tries);
+
+	if (!tries) {
+		dev_err(&GET_DEV(accel_dev), "Excessive clock measure delay\n");
+		return -ETIMEDOUT;
+	}
+
+	delta_us = timespec_to_us(&ts3) - timespec_to_us(&ts1);
+	temp = (timestamp2 - timestamp1) * ME_CLK_DIVIDER * 10;
+	temp = DIV_ROUND_CLOSEST(temp, delta_us);
+	*frequency = temp * HZ_PER_MHZ / 10;
+
+	return 0;
+}
+
+/**
+ * adf_dev_measure_clock() - measures device clock frequency
+ * @accel_dev: Pointer to acceleration device.
+ * @frequency: Pointer to variable where result will be stored
+ * @min: Minimal allowed frequency value
+ * @max: Maximal allowed frequency value
+ *
+ * If the measurement result will go beyond the min/max thresholds the value
+ * will take the value of the crossed threshold.
+ *
+ * This algorithm compares the device firmware timestamp with the kernel
+ * timestamp. So we can't expect too high accuracy from this measurement.
+ *
+ * Return:
+ * * 0 - measurement succeed
+ * * -ETIMEDOUT - measurement failed
+ */
+int adf_dev_measure_clock(struct adf_accel_dev *accel_dev,
+			  u32 *frequency, u32 min, u32 max)
+{
+	int ret;
+	u32 freq;
+
+	ret = measure_clock(accel_dev, &freq);
+	if (ret)
+		return ret;
+
+	*frequency = clamp(freq, min, max);
+
+	if (*frequency != freq)
+		dev_warn(&GET_DEV(accel_dev),
+			 "Measured clock %d Hz is out of range, assuming %d\n",
+			 freq, *frequency);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_dev_measure_clock);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_clock.h b/drivers/crypto/intel/qat/qat_common/adf_clock.h
new file mode 100644
index 000000000000..e309bc0dc35c
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_clock.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_CLOCK_H
+#define ADF_CLOCK_H
+
+#include <linux/types.h>
+
+struct adf_accel_dev;
+
+int adf_dev_measure_clock(struct adf_accel_dev *accel_dev, u32 *frequency,
+			  u32 min, u32 max);
+u64 adf_clock_get_current_time(void);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 15ef47958b2a..20202ff715e4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -97,6 +97,7 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev);
 int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
 int adf_init_admin_pm(struct adf_accel_dev *accel_dev);
 int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
+int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 0acba0f988da..53fca6a7e2af 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -178,6 +178,14 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->measure_clock) {
+		ret = hw_data->measure_clock(accel_dev);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed measure device clock\n");
+			return ret;
+		}
+	}
+
 	/* Set ssm watch dog timer */
 	if (hw_data->set_ssm_wdtimer)
 		hw_data->set_ssm_wdtimer(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 81b344faa755..9b1120d586f0 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -16,6 +16,7 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_HEARTBEAT_SYNC = 7,
 	ICP_QAT_FW_HEARTBEAT_GET = 8,
 	ICP_QAT_FW_COMP_CAPABILITY_GET = 9,
+	ICP_QAT_FW_TIMER_GET = 19,
 	ICP_QAT_FW_PM_STATE_CONFIG = 128,
 };
 
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 1ebe0b351fae..c57403a6fbac 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -44,6 +44,14 @@ static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 	return ADF_DH895XCC_PMISC_BAR;
 }
 
+static u32 get_ts_clock(struct adf_hw_device_data *self)
+{
+	/*
+	 * Timestamp update interval is 16 AE clock ticks for dh895xcc.
+	 */
+	return self->clock_frequency / 16;
+}
+
 static u32 get_etr_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCC_ETR_BAR;
@@ -237,6 +245,8 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->dev_config = adf_gen2_dev_config;
+	hw_data->clock_frequency = ADF_DH895X_AE_FREQ;
+	hw_data->get_hb_clock = get_ts_clock;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 7b674bbe4192..cd3a21985455 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -3,6 +3,8 @@
 #ifndef ADF_DH895x_HW_DATA_H_
 #define ADF_DH895x_HW_DATA_H_
 
+#include <linux/units.h>
+
 /* PCIe configuration space */
 #define ADF_DH895XCC_SRAM_BAR 0
 #define ADF_DH895XCC_PMISC_BAR 1
@@ -30,6 +32,9 @@
 #define ADF_DH895XCC_AE2FUNC_MAP_GRP_A_NUM_REGS 96
 #define ADF_DH895XCC_AE2FUNC_MAP_GRP_B_NUM_REGS 12
 
+/* Clocks frequency */
+#define ADF_DH895X_AE_FREQ (933 * HZ_PER_MHZ)
+
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
 #define ADF_DH895XCC_MMP "qat_895xcc_mmp.bin"
-- 
2.40.1

