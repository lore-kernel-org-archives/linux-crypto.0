Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC18C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A94208D5
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgJLUjs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:34076 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387766AbgJLUjo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:44 -0400
IronPort-SDR: gxfXxc2G3aO+5F1kJH+UFyLAV2oVG5CRpOovA7UgaEop17DzCnshNhS7f93fRWyT+FONgIkvmU
 gNnGH+7t0+QQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913166"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913166"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:43 -0700
IronPort-SDR: 6fo66sZ+ViTz8OSPqzOKfS1HwGR18AjdPmDoIUYsryzl/33ope3FIQboI/wjQVOnrkEkhuaQNu
 /6ilLXsp/Z8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328241"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:41 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 22/31] crypto: qat - abstract writes to arbiter enable
Date:   Mon, 12 Oct 2020 21:38:38 +0100
Message-Id: <20201012203847.340030-23-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Abstract writes to the service arbiter enable register.

This is in preparation for the introduction of the qat_4xxx driver since
the arbitration enable register differes between QAT GEN2 and QAT GEN4
devices.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |  2 ++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c  |  7 +++++++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h  |  6 ++++++
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c    | 15 +++++----------
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 1fd32c56b119..a3b63dfe4d7b 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -133,6 +133,8 @@ struct adf_hw_csr_ops {
 				      u32 value);
 	void (*write_csr_int_flag_and_col)(void __iomem *csr_base_addr,
 					   u32 bank, u32 value);
+	void (*write_csr_ring_srv_arb_en)(void __iomem *csr_base_addr, u32 bank,
+					  u32 value);
 };
 
 struct adf_cfg_device_data;
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 5de359165ab4..1aa17303838d 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -127,6 +127,12 @@ static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
 	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
 }
 
+static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
+				      u32 value)
+{
+	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
+}
+
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 {
 	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
@@ -142,6 +148,7 @@ void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
 	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
 	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
+	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_hw_csr_ops);
 
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 04236a442f3c..3816e6500352 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -103,6 +103,12 @@ do { \
 #define ADF_ARB_OFFSET			0x30000
 #define ADF_ARB_WRK_2_SER_MAP_OFFSET	0x180
 #define ADF_ARB_CONFIG			(BIT(31) | BIT(6) | BIT(0))
+#define ADF_ARB_REG_SLOT		0x1000
+#define ADF_ARB_RINGSRVARBEN_OFFSET	0x19C
+
+#define WRITE_CSR_RING_SRV_ARB_EN(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
+	(ADF_ARB_REG_SLOT * (index)), value)
 
 /* Power gating */
 #define ADF_POWERGATE_PKE		BIT(24)
diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index bd03c8f54eb4..9f5240d9488b 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -6,12 +6,6 @@
 
 #define ADF_ARB_NUM 4
 #define ADF_ARB_REG_SIZE 0x4
-#define ADF_ARB_REG_SLOT 0x1000
-#define ADF_ARB_RINGSRVARBEN_OFFSET 0x19C
-
-#define WRITE_CSR_ARB_RINGSRVARBEN(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
-	(ADF_ARB_REG_SLOT * index), value)
 
 #define WRITE_CSR_ARB_SARCONFIG(csr_addr, arb_offset, index, value) \
 	ADF_CSR_WR(csr_addr, (arb_offset) + \
@@ -57,6 +51,7 @@ void adf_update_ring_arb(struct adf_etr_ring_data *ring)
 {
 	struct adf_accel_dev *accel_dev = ring->bank->accel_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
 	u32 tx_ring_mask = hw_data->tx_rings_mask;
 	u32 shift = hw_data->tx_rx_gap;
 	u32 arben, arben_tx, arben_rx;
@@ -73,14 +68,14 @@ void adf_update_ring_arb(struct adf_etr_ring_data *ring)
 	arben_rx = (ring->bank->ring_mask & rx_ring_mask) >> shift;
 	arben = arben_tx & arben_rx;
 
-	WRITE_CSR_ARB_RINGSRVARBEN(ring->bank->csr_addr,
-				   ring->bank->bank_number,
-				   arben);
+	csr_ops->write_csr_ring_srv_arb_en(ring->bank->csr_addr,
+					   ring->bank->bank_number, arben);
 }
 
 void adf_exit_arb(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
 	u32 arb_off, wt_off;
 	struct arb_info info;
 	void __iomem *csr;
@@ -107,6 +102,6 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 
 	/* Disable arbitration on all rings */
 	for (i = 0; i < GET_MAX_BANKS(accel_dev); i++)
-		WRITE_CSR_ARB_RINGSRVARBEN(csr, i, 0);
+		csr_ops->write_csr_ring_srv_arb_en(csr, i, 0);
 }
 EXPORT_SYMBOL_GPL(adf_exit_arb);
-- 
2.26.2

