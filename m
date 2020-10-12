Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0B8C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58ABD20FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbgJLUjk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbgJLUjj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:39 -0400
IronPort-SDR: zlwA/5mxPgAn7Hy9kfFKOBcd9d1PyezveiHeB/L5McV34hjKcaSbIHirLjDOn8++pmKEuUjAZa
 yrWLNN0Qi1hQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913151"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913151"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:39 -0700
IronPort-SDR: hlXmNHP9pBadaZIBhVCQqVQUrRyUfOjuuu1o2fiGj4EmakEFzT/NSaGgMU43fcQE4T3cVQGpZY
 MhjhQgQoYzPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328223"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:37 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 19/31] crypto: qat - abstract build ring base
Date:   Mon, 12 Oct 2020 21:38:35 +0100
Message-Id: <20201012203847.340030-20-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Abstract the implementation of BUILD_RING_BASE_ADDR.

This is in preparation for the introduction of the qat_4xxx driver since
the value of the ring base differs between QAT GEN2 and QAT GEN4
devices.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h           | 1 +
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c            | 6 ++++++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h            | 2 ++
 drivers/crypto/qat/qat_common/adf_transport.c               | 4 +++-
 drivers/crypto/qat/qat_common/adf_transport_access_macros.h | 2 --
 5 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 692e39e5e878..1fd32c56b119 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -110,6 +110,7 @@ struct admin_info {
 };
 
 struct adf_hw_csr_ops {
+	u64 (*build_csr_ring_base_addr)(dma_addr_t addr, u32 size);
 	u32 (*read_csr_ring_head)(void __iomem *csr_base_addr, u32 bank,
 				  u32 ring);
 	void (*write_csr_ring_head)(void __iomem *csr_base_addr, u32 bank,
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index d5560e714167..5de359165ab4 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -55,6 +55,11 @@ void adf_gen2_get_arb_info(struct arb_info *arb_info)
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_arb_info);
 
+static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
+{
+	return BUILD_RING_BASE_ADDR(addr, size);
+}
+
 static u32 read_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring)
 {
 	return READ_CSR_RING_HEAD(csr_base_addr, bank, ring);
@@ -124,6 +129,7 @@ static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
 
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 {
+	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
 	csr_ops->read_csr_ring_head = read_csr_ring_head;
 	csr_ops->write_csr_ring_head = write_csr_ring_head;
 	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 6c860aedb301..212ff395201f 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -23,6 +23,8 @@
 #define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
 #define ADF_RING_BUNDLE_SIZE		0x1000
 
+#define BUILD_RING_BASE_ADDR(addr, size) \
+	(((addr) >> 6) & (0xFFFFFFFFFFFFFFFFULL << (size)))
 #define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
 	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
 		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 03fb7812818b..dd8f94fcb9a8 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -180,7 +180,9 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 	else
 		adf_configure_rx_ring(ring);
 
-	ring_base = BUILD_RING_BASE_ADDR(ring->dma_addr, ring->ring_size);
+	ring_base = csr_ops->build_csr_ring_base_addr(ring->dma_addr,
+						      ring->ring_size);
+
 	csr_ops->write_csr_ring_base(ring->bank->csr_addr,
 				     ring->bank->bank_number, ring->ring_number,
 				     ring_base);
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 4642b0b5cfb0..12b1605a740e 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -56,6 +56,4 @@
 	((watermark_nf << ADF_RING_CONFIG_NEAR_FULL_WM)	\
 	| (watermark_ne << ADF_RING_CONFIG_NEAR_EMPTY_WM) \
 	| size)
-#define BUILD_RING_BASE_ADDR(addr, size) \
-	((addr >> 6) & (0xFFFFFFFFFFFFFFFFULL << size))
 #endif
-- 
2.26.2

