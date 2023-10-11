Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2FBCD6E63
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbjJKMgV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjJKMgR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800AB93
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027775; x=1728563775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H/A/WVqUqYdcGFqJ6PVvMWVZwAtHtFnKEw3cw/XGTrk=;
  b=PaGZjoPWPChx+lCcCyyrJi4wbf3ENlr4AqzxUQlicnPaQ1GfRAbF1Xj5
   K2VjnIyPy1q1gEGXlYZa4cfwIDfNE4xKMVFUPW0f0IHgaYTN7hdiJ6L2H
   ayBgr4rqT9hSjDY8k5xxEHe3Vi/ZxWnvbTQFzKyic5GAgPrE16FOa/I5E
   GGp43P0d+dfY0OCC9ZU9Ck0yYyLeNWYSXGJB6qQFTLwTdhGhTPt0Z4iPB
   KmIqo53xRCIBfYxn6gjqWeUnirS3H437L7DuzB6tRdsQTgqkdmrtNWLOI
   mCOGs4vsro0+yLSgxwsiyKo57tUupSIpbyyIGRF+QDvVQJI+Ufrf0BUdz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992860"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992860"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124659"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124659"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:14 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 04/11] crypto: qat - move admin api
Date:   Wed, 11 Oct 2023 14:15:02 +0200
Message-ID: <20231011121934.45255-5-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The admin API is growing and deserves its own include.
Move it from adf_common_drv.h to adf_admin.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  1 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.h   | 19 +++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_clock.c   |  1 +
 .../intel/qat/qat_common/adf_cnv_dbgfs.c      |  1 +
 .../intel/qat/qat_common/adf_common_drv.h     | 10 ----------
 .../intel/qat/qat_common/adf_fw_counters.c    |  1 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  1 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      |  1 +
 .../intel/qat/qat_common/adf_gen4_timer.c     |  1 +
 .../intel/qat/qat_common/adf_heartbeat.c      |  1 +
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |  1 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  1 +
 15 files changed, 32 insertions(+), 10 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_admin.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index a5691ba0b724..8a80701b7791 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 - 2021 Intel Corporation */
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_cfg.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 9c00c441b602..a882e0ea2279 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 355a781693eb..48cf3eb7c734 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 3a04e743497f..15ffda582334 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
 #include "adf_heartbeat.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.h b/drivers/crypto/intel/qat/qat_common/adf_admin.h
new file mode 100644
index 000000000000..03507ec3a51d
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_ADMIN
+#define ADF_ADMIN
+
+struct adf_accel_dev;
+
+int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
+void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
+int adf_send_admin_init(struct adf_accel_dev *accel_dev);
+int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
+int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
+int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
+int adf_send_admin_hb_timer(struct adf_accel_dev *accel_dev, uint32_t ticks);
+int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp);
+int adf_get_pm_info(struct adf_accel_dev *accel_dev, dma_addr_t p_state_addr, size_t buff_size);
+int adf_get_cnv_stats(struct adf_accel_dev *accel_dev, u16 ae, u16 *err_cnt, u16 *latest_err);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_clock.c b/drivers/crypto/intel/qat/qat_common/adf_clock.c
index dc0778691eb0..01e0a389e462 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_clock.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_clock.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/units.h>
 #include <asm/errno.h>
+#include "adf_admin.h"
 #include "adf_accel_devices.h"
 #include "adf_clock.h"
 #include "adf_common_drv.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
index aa5b6ff1dfb4..07119c487da0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_cnv_dbgfs.h"
 #include "qat_compression.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 18a382508542..ad9f4a464496 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -87,16 +87,6 @@ void adf_reset_flr(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
-int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
-void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
-int adf_send_admin_init(struct adf_accel_dev *accel_dev);
-int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
-int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
-int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
-int adf_send_admin_hb_timer(struct adf_accel_dev *accel_dev, uint32_t ticks);
-int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp);
-int adf_get_pm_info(struct adf_accel_dev *accel_dev, dma_addr_t p_state_addr, size_t buff_size);
-int adf_get_cnv_stats(struct adf_accel_dev *accel_dev, u16 ae, u16 *err_cnt, u16 *latest_err);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
index 6abe4736eab8..98fb7ccfed9f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_fw_counters.h"
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index c663d3a20c5b..5dafd9a270db 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
 #include "adf_cfg_strings.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
index 5114759287c6..ee0b5079de3e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/stringify.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
 #include "icp_qat_fw_init_admin.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
index 646c57922fcd..35ccb91d6ec1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
+#include "adf_admin.h"
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_timer.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index beef9a5f6c75..13f48d2f6da8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <asm/errno.h>
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "adf_clock.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
index 803cbfd838f0..2661af6a2ef6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/types.h>
+#include "adf_admin.h"
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 #include "adf_heartbeat.h"
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 09551f949126..af14090cc4be 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
-- 
2.41.0

