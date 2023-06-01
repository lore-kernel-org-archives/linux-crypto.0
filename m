Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC7EC77B7A
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 09:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjFAJ0W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjFAJ0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 05:26:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EF099
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 02:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685611579; x=1717147579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6NFhgaWa0+t1f2IAroVolYLbXE+184pZxsPCKLEqTsU=;
  b=npy9WLqPFl6BhDmrQM6P0deCie3/o6LyZX0xiMwze3+aKHyuJ1cqPZtl
   7+taf2nGWGrymc1b9tbztG8OUh5/2hFTjAZFUs679RCfWkLGM3SHT+osS
   ndNdwMBB2S8qSMUDOMwRVNIUVNkFTzJXUZHL6F92nLobJ4C4MMLghPoMo
   4kXhtxwmVevfRsgQjEDjBevTQ75P/gqIa+Ry5z1LKLH9GUhCyUv9xE9yP
   EVdX001hQD05fbRYDSEq2+BpciTUgJWx833zt23/AIoGuN5g8KuKfSr3m
   xo1f1ZBewGEx9EGX+luir2P7XInexxyDe376PXFyIj8mopQN8Ax9yj3Pu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="355512014"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="355512014"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 02:26:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037418557"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="1037418557"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2023 02:26:18 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add internal timer for qat 4xxx
Date:   Thu,  1 Jun 2023 11:13:40 +0200
Message-Id: <20230601091340.12626-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The power management feature in QAT 4xxx devices can disable clock
sources used to implement timers. Because of that, the firmware needs to
get an external reliable source of time.

Add a kernel timer that periodically sends an event to the firmware.
This is triggered every 200ms. At each timeout event, the driver
sends a sync request to the firmware reporting the current timestamp
counter value.

This is a pre-requisite for enabling the heartbeat, telemetry and
rate limiting features.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  3 +
 drivers/crypto/intel/qat/qat_common/Makefile  |  1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  3 +
 .../crypto/intel/qat/qat_common/adf_admin.c   | 12 ++++
 .../intel/qat/qat_common/adf_common_drv.h     |  1 +
 .../intel/qat/qat_common/adf_gen4_timer.c     | 72 +++++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_timer.h     | 23 ++++++
 .../crypto/intel/qat/qat_common/adf_init.c    | 13 ++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  5 ++
 9 files changed, 133 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 7324b86a4f40..d7d5850af703 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -8,6 +8,7 @@
 #include <adf_gen4_hw_data.h>
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
+#include <adf_gen4_timer.h>
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -405,6 +406,8 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;
+	hw_data->start_timer = adf_gen4_timer_start;
+	hw_data->stop_timer = adf_gen4_timer_stop;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 38de3aba6e8c..0db463200495 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -17,6 +17,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_gen4_pm.o \
 	adf_gen2_dc.o \
 	adf_gen4_dc.o \
+	adf_gen4_timer.o \
 	qat_crypto.o \
 	qat_compression.o \
 	qat_comp_algs.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index bd19e6460899..93938bb0fca0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -188,6 +188,8 @@ struct adf_hw_device_data {
 	int (*init_admin_comms)(struct adf_accel_dev *accel_dev);
 	void (*exit_admin_comms)(struct adf_accel_dev *accel_dev);
 	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
+	int (*start_timer)(struct adf_accel_dev *accel_dev);
+	void (*stop_timer)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	const u32 *(*get_arb_mapping)(struct adf_accel_dev *accel_dev);
@@ -295,6 +297,7 @@ struct adf_accel_dev {
 	struct list_head list;
 	struct module *owner;
 	struct adf_accel_pci accel_pci_dev;
+	struct adf_timer *timer;
 	union {
 		struct {
 			/* protects VF2PF interrupts access */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 3b6184c35081..f4f698ec3a4e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -223,6 +223,18 @@ static int adf_get_dc_capabilities(struct adf_accel_dev *accel_dev,
 	return 0;
 }
 
+int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt)
+{
+	u32 ae_mask = accel_dev->hw_device->ae_mask;
+	struct icp_qat_fw_init_admin_req req = { };
+	struct icp_qat_fw_init_admin_resp resp;
+
+	req.cmd_id = ICP_QAT_FW_SYNC;
+	req.int_timer_ticks = cnt;
+
+	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
+}
+
 /**
  * adf_send_admin_init() - Function sends init message to FW
  * @accel_dev: Pointer to acceleration device.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index db79759bee61..2c2ac4dc9753 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -95,6 +95,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
 int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
+int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
new file mode 100644
index 000000000000..9b403e7140b8
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_gen4_timer.h"
+
+#define ADF_GEN4_TIMER_VALUE_MS 200
+
+static unsigned long adf_get_next_timeout(void)
+{
+	unsigned long timeout = msecs_to_jiffies(ADF_GEN4_TIMER_VALUE_MS);
+
+	return rounddown(jiffies + timeout, timeout);
+}
+
+/* This periodic update is used to trigger HB, RL & TL fw events */
+static void timer_handler_bh(struct work_struct *work)
+{
+	struct adf_timer *timer_ctx = container_of(work, struct adf_timer, timer_bh);
+	struct adf_accel_dev *accel_dev = timer_ctx->accel_dev;
+
+	if (adf_send_admin_tim_sync(accel_dev, timer_ctx->cnt))
+		dev_err(&GET_DEV(accel_dev), "Failed to synchronize qat timer\n");
+}
+
+static void timer_handler(struct timer_list *tl)
+{
+	struct adf_timer *timer_ctx = from_timer(timer_ctx, tl, timer);
+	unsigned long timeout_val = adf_get_next_timeout();
+
+	/* Schedule a work queue to send admin request */
+	adf_misc_wq_queue_work(&timer_ctx->timer_bh);
+
+	timer_ctx->cnt++;
+	mod_timer(tl, timeout_val);
+}
+
+int adf_gen4_timer_start(struct adf_accel_dev *accel_dev)
+{
+	unsigned long timeout_val = adf_get_next_timeout();
+	struct adf_timer *timer_ctx;
+
+	timer_ctx = kzalloc(sizeof(*timer_ctx), GFP_KERNEL);
+	if (!timer_ctx)
+		return -ENOMEM;
+
+	timer_ctx->accel_dev = accel_dev;
+	timer_ctx->cnt = 0;
+	accel_dev->timer = timer_ctx;
+
+	INIT_WORK(&timer_ctx->timer_bh, timer_handler_bh);
+	timer_setup(&timer_ctx->timer, timer_handler, 0);
+	mod_timer(&timer_ctx->timer, timeout_val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_timer_start);
+
+void adf_gen4_timer_stop(struct adf_accel_dev *accel_dev)
+{
+	struct adf_timer *timer_ctx = accel_dev->timer;
+
+	if (!timer_ctx)
+		return;
+
+	del_timer_sync(&timer_ctx->timer);
+
+	kfree(timer_ctx);
+	accel_dev->timer = NULL;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_timer_stop);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
new file mode 100644
index 000000000000..f5ea4bb1774b
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+
+#ifndef ADF_GEN4_TIMER_H_
+#define ADF_GEN4_TIMER_H_
+
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/types.h>
+
+#include "adf_accel_devices.h"
+
+struct adf_timer {
+	struct adf_accel_dev *accel_dev;
+	struct timer_list timer;
+	struct work_struct timer_bh;
+	u32 cnt;
+};
+
+int adf_gen4_timer_start(struct adf_accel_dev *accel_dev);
+void adf_gen4_timer_stop(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_GEN4_TIMER_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 826179c98524..0acba0f988da 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -163,6 +163,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
 	struct list_head *list_itr;
+	int ret;
 
 	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
 
@@ -187,6 +188,14 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->start_timer) {
+		ret = hw_data->start_timer(accel_dev);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed to start internal sync timer\n");
+			return ret;
+		}
+	}
+
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
@@ -235,6 +244,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
  */
 static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	bool wait = false;
@@ -270,6 +280,9 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 		}
 	}
 
+	if (hw_data->stop_timer)
+		hw_data->stop_timer(accel_dev);
+
 	if (wait)
 		msleep(100);
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 56cb827f93ea..a304fd23ec50 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -37,6 +37,9 @@ struct icp_qat_fw_init_admin_req {
 			__u16 ibuf_size_in_kb;
 			__u16 resrvd3;
 		};
+		struct {
+			u32 int_timer_ticks;
+		};
 		__u32 idle_filter;
 	};
 
@@ -97,6 +100,8 @@ struct icp_qat_fw_init_admin_resp {
 	};
 } __packed;
 
+#define ICP_QAT_FW_SYNC ICP_QAT_FW_HEARTBEAT_SYNC
+
 #define ICP_QAT_FW_COMN_HEARTBEAT_OK 0
 #define ICP_QAT_FW_COMN_HEARTBEAT_BLOCKED 1
 #define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_BITPOS 0

base-commit: 8fd3bb7fdffbe273831d727501725547cb9b1b5d
-- 
2.40.1

