Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5C4C5517A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9503B206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgKFL2n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgKFL2n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:43 -0500
IronPort-SDR: RVkljc9GNWkpERx90M7SDM9uV4UGBNAWmkbgjF0sfCEgZiSCQY97YSJAQ2p64fjvmgRU2zYW+a
 0pJuyDbbLH2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698286"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698286"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:43 -0800
IronPort-SDR: txDVnNMCLDbs4U9TygvLz6zteGcvRjDOfC5luSR5BEUmFC0UlEDzg7Qf6E2kDDjWA7/6L5JMmz
 h5K8UvO0Vniw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779198"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:41 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 06/32] crypto: qat - loader: introduce additional parenthesis
Date:   Fri,  6 Nov 2020 19:27:44 +0800
Message-Id: <20201106112810.2566-7-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce additional parenthesis to resolve a warninga reported by
checkpatch.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_hal.h | 14 +++++++-------
 drivers/crypto/qat/qat_common/qat_hal.c     |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index b48b313623fe..5640bb278bb1 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -88,23 +88,23 @@ enum fcu_sts {
 #define FW_AUTH_MAX_RETRY   300
 
 #define SET_CAP_CSR(handle, csr, val) \
-	ADF_CSR_WR(handle->hal_cap_g_ctl_csr_addr_v, csr, val)
+	ADF_CSR_WR((handle)->hal_cap_g_ctl_csr_addr_v, csr, val)
 #define GET_CAP_CSR(handle, csr) \
-	ADF_CSR_RD(handle->hal_cap_g_ctl_csr_addr_v, csr)
+	ADF_CSR_RD((handle)->hal_cap_g_ctl_csr_addr_v, csr)
 #define SET_GLB_CSR(handle, csr, val) SET_CAP_CSR(handle, csr + GLOBAL_CSR, val)
 #define GET_GLB_CSR(handle, csr) GET_CAP_CSR(handle, GLOBAL_CSR + csr)
 #define AE_CSR(handle, ae) \
-	((char __iomem *)handle->hal_cap_ae_local_csr_addr_v + (ae << 12))
-#define AE_CSR_ADDR(handle, ae, csr) (AE_CSR(handle, ae) + (0x3ff & csr))
+	((char __iomem *)(handle)->hal_cap_ae_local_csr_addr_v + ((ae) << 12))
+#define AE_CSR_ADDR(handle, ae, csr) (AE_CSR(handle, ae) + (0x3ff & (csr)))
 #define SET_AE_CSR(handle, ae, csr, val) \
 	ADF_CSR_WR(AE_CSR_ADDR(handle, ae, csr), 0, val)
 #define GET_AE_CSR(handle, ae, csr) ADF_CSR_RD(AE_CSR_ADDR(handle, ae, csr), 0)
 #define AE_XFER(handle, ae) \
-	((char __iomem *)handle->hal_cap_ae_xfer_csr_addr_v + (ae << 12))
+	((char __iomem *)(handle)->hal_cap_ae_xfer_csr_addr_v + ((ae) << 12))
 #define AE_XFER_ADDR(handle, ae, reg) (AE_XFER(handle, ae) + \
-	((reg & 0xff) << 2))
+	(((reg) & 0xff) << 2))
 #define SET_AE_XFER(handle, ae, reg, val) \
 	ADF_CSR_WR(AE_XFER_ADDR(handle, ae, reg), 0, val)
 #define SRAM_WRITE(handle, addr, val) \
-	ADF_CSR_WR(handle->hal_sram_addr_v, addr, val)
+	ADF_CSR_WR((handle)->hal_sram_addr_v, addr, val)
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index bbfb2b1b6fee..c628ea30e3c2 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -33,7 +33,7 @@
 		((((const_val) << 12) & 0x0FF00000ull) | \
 		(((const_val) <<  0) & 0x000000FFull))))
 
-#define AE(handle, ae) handle->hal_handle->aes[ae]
+#define AE(handle, ae) ((handle)->hal_handle->aes[ae])
 
 static const u64 inst_4b[] = {
 	0x0F0400C0000ull, 0x0F4400C0000ull, 0x0F040000300ull, 0x0F440000300ull,
@@ -150,8 +150,8 @@ static int qat_hal_wait_cycles(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define CLR_BIT(wrd, bit) (wrd & ~(1 << bit))
-#define SET_BIT(wrd, bit) (wrd | 1 << bit)
+#define CLR_BIT(wrd, bit) ((wrd) & ~(1 << (bit)))
+#define SET_BIT(wrd, bit) ((wrd) | 1 << (bit))
 
 int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_handle *handle,
 			    unsigned char ae, unsigned char mode)
-- 
2.25.4

