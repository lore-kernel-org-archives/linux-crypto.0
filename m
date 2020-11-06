Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8325CC2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31004206B2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgKFL2k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgKFL2i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:38 -0500
IronPort-SDR: BP4KxSkaZ+JtFLcBkMN0WRHNZuIdBdE2diNuVRPS+k4nW0JkLzmDCHTOs7ieZLlteuXe1fO//R
 0qzYMthERbqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698280"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:38 -0800
IronPort-SDR: viUn8gl7275sIiDbox9ZevvEnXRLLnxY/Ik9Q+OxWetpV9TUU63dwAH/D3QC2HW8XBcAJ4/xra
 aGxvLm1Rdt4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779176"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:36 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 03/32] crypto: qat - loader: fix CSR access
Date:   Fri,  6 Nov 2020 19:27:41 +0800
Message-Id: <20201106112810.2566-4-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Do not mask the AE number with the AE mask when accessing the AE local
CSRs. Bit 12 of the local CSR address is the start of AE number so just
take out the AE mask here.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_hal.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index c0e9fc0c93dd..b48b313623fe 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -94,15 +94,13 @@ enum fcu_sts {
 #define SET_GLB_CSR(handle, csr, val) SET_CAP_CSR(handle, csr + GLOBAL_CSR, val)
 #define GET_GLB_CSR(handle, csr) GET_CAP_CSR(handle, GLOBAL_CSR + csr)
 #define AE_CSR(handle, ae) \
-	((char __iomem *)handle->hal_cap_ae_local_csr_addr_v + \
-	((ae & handle->hal_handle->ae_mask) << 12))
+	((char __iomem *)handle->hal_cap_ae_local_csr_addr_v + (ae << 12))
 #define AE_CSR_ADDR(handle, ae, csr) (AE_CSR(handle, ae) + (0x3ff & csr))
 #define SET_AE_CSR(handle, ae, csr, val) \
 	ADF_CSR_WR(AE_CSR_ADDR(handle, ae, csr), 0, val)
 #define GET_AE_CSR(handle, ae, csr) ADF_CSR_RD(AE_CSR_ADDR(handle, ae, csr), 0)
 #define AE_XFER(handle, ae) \
-	((char __iomem *)handle->hal_cap_ae_xfer_csr_addr_v + \
-	((ae & handle->hal_handle->ae_mask) << 12))
+	((char __iomem *)handle->hal_cap_ae_xfer_csr_addr_v + (ae << 12))
 #define AE_XFER_ADDR(handle, ae, reg) (AE_XFER(handle, ae) + \
 	((reg & 0xff) << 2))
 #define SET_AE_XFER(handle, ae, reg, val) \
-- 
2.25.4

