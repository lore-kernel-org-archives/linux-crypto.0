Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820D9C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47618208D5
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgJLUjQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:33900 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:14 -0400
IronPort-SDR: gM7mF6YBgd0toe8aoeCGx9E4mmeVsVnMpFXh+GgCCLaWBNhTnRewYCk6sV0xRjZ0a2VYU9wufP
 NInnQVlGAPow==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913075"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913075"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:14 -0700
IronPort-SDR: ULtCZEexEKlnpqAzvymPQV1qtkAx6bdvOIq2lwP/RAb9Xv0Npg9rUW6w0ohF13OdDJxVnnCSeH
 CFZ6RFRsiGfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328146"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:12 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 06/31] crypto: qat - relocate GEN2 CSR access code
Date:   Mon, 12 Oct 2020 21:38:22 +0100
Message-Id: <20201012203847.340030-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move gen2 specific transport macros to adf_gen2_hw_data.c.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  1 -
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 68 +++++++++++++++++++
 .../qat_common/adf_transport_access_macros.h  | 64 -----------------
 3 files changed, 68 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 07a9211bf7f9..9011c94156a9 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
 #include "adf_gen2_hw_data.h"
-#include "adf_transport_access_macros.h"
 
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs)
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index e6d3919a56a1..592aee627762 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -5,6 +5,74 @@
 
 #include "adf_accel_devices.h"
 
+/* Transport access */
+#define ADF_BANK_INT_SRC_SEL_MASK_0	0x4444444CUL
+#define ADF_BANK_INT_SRC_SEL_MASK_X	0x44444444UL
+#define ADF_RING_CSR_RING_CONFIG	0x000
+#define ADF_RING_CSR_RING_LBASE		0x040
+#define ADF_RING_CSR_RING_UBASE		0x080
+#define ADF_RING_CSR_RING_HEAD		0x0C0
+#define ADF_RING_CSR_RING_TAIL		0x100
+#define ADF_RING_CSR_E_STAT		0x14C
+#define ADF_RING_CSR_INT_FLAG		0x170
+#define ADF_RING_CSR_INT_SRCSEL		0x174
+#define ADF_RING_CSR_INT_SRCSEL_2	0x178
+#define ADF_RING_CSR_INT_COL_EN		0x17C
+#define ADF_RING_CSR_INT_COL_CTL	0x180
+#define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
+#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
+#define ADF_RING_BUNDLE_SIZE		0x1000
+
+#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
+#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
+#define READ_CSR_E_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_E_STAT)
+#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2), value)
+#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
+do { \
+	u32 l_base = 0, u_base = 0; \
+	l_base = (u32)((value) & 0xFFFFFFFF); \
+	u_base = (u32)(((value) & 0xFFFFFFFF00000000ULL) >> 32); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_LBASE + ((ring) << 2), l_base); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_UBASE + ((ring) << 2), u_base); \
+} while (0)
+
+#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2), value)
+#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
+#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_FLAG, value)
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+do { \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+	ADF_RING_CSR_INT_SRCSEL_2, ADF_BANK_INT_SRC_SEL_MASK_X); \
+} while (0)
+#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_COL_EN, value)
+#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_COL_CTL, \
+		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
+#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_FLAG_AND_COL, value)
+
 /* AE to function map */
 #define AE2FUNCTION_MAP_A_OFFSET	(0x3A400 + 0x190)
 #define AE2FUNCTION_MAP_B_OFFSET	(0x3A400 + 0x310)
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 950d1988556c..4642b0b5cfb0 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -4,23 +4,7 @@
 #define ADF_TRANSPORT_ACCESS_MACROS_H
 
 #include "adf_accel_devices.h"
-#define ADF_BANK_INT_SRC_SEL_MASK_0 0x4444444CUL
-#define ADF_BANK_INT_SRC_SEL_MASK_X 0x44444444UL
 #define ADF_BANK_INT_FLAG_CLEAR_MASK 0xFFFF
-#define ADF_RING_CSR_RING_CONFIG 0x000
-#define ADF_RING_CSR_RING_LBASE 0x040
-#define ADF_RING_CSR_RING_UBASE 0x080
-#define ADF_RING_CSR_RING_HEAD 0x0C0
-#define ADF_RING_CSR_RING_TAIL 0x100
-#define ADF_RING_CSR_E_STAT 0x14C
-#define ADF_RING_CSR_INT_FLAG	0x170
-#define ADF_RING_CSR_INT_SRCSEL 0x174
-#define ADF_RING_CSR_INT_SRCSEL_2 0x178
-#define ADF_RING_CSR_INT_COL_EN 0x17C
-#define ADF_RING_CSR_INT_COL_CTL 0x180
-#define ADF_RING_CSR_INT_FLAG_AND_COL 0x184
-#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
-#define ADF_RING_BUNDLE_SIZE 0x1000
 #define ADF_RING_CONFIG_NEAR_FULL_WM 0x0A
 #define ADF_RING_CONFIG_NEAR_EMPTY_WM 0x05
 #define ADF_COALESCING_MIN_TIME 0x1FF
@@ -74,52 +58,4 @@
 	| size)
 #define BUILD_RING_BASE_ADDR(addr, size) \
 	((addr >> 6) & (0xFFFFFFFFFFFFFFFFULL << size))
-#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_RING_HEAD + (ring << 2))
-#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_RING_TAIL + (ring << 2))
-#define READ_CSR_E_STAT(csr_base_addr, bank) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_E_STAT)
-#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-		ADF_RING_CSR_RING_CONFIG + (ring << 2), value)
-#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
-do { \
-	u32 l_base = 0, u_base = 0; \
-	l_base = (u32)(value & 0xFFFFFFFF); \
-	u_base = (u32)((value & 0xFFFFFFFF00000000ULL) >> 32); \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-		ADF_RING_CSR_RING_LBASE + (ring << 2), l_base);	\
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-		ADF_RING_CSR_RING_UBASE + (ring << 2), u_base);	\
-} while (0)
-#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-		ADF_RING_CSR_RING_HEAD + (ring << 2), value)
-#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-		ADF_RING_CSR_RING_TAIL + (ring << 2), value)
-#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-			ADF_RING_CSR_INT_FLAG, value)
-#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
-do { \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0);	\
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-	ADF_RING_CSR_INT_SRCSEL_2, ADF_BANK_INT_SRC_SEL_MASK_X); \
-} while (0)
-#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_INT_COL_EN, value)
-#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_INT_COL_CTL, \
-			ADF_RING_CSR_INT_COL_CTL_ENABLE | value)
-#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
-			ADF_RING_CSR_INT_FLAG_AND_COL, value)
 #endif
-- 
2.26.2

