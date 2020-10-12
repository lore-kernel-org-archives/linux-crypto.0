Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBEAC433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A272620FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgJLUja (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:34003 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbgJLUj2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:28 -0400
IronPort-SDR: VmaZI0JsA+B45EYI9mdVK4rM61uu2PdyKt21buKO6HkTE+cbc582euWfsFeMMLUHS/w5ko4bnH
 uFmIPsOLGs4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913117"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913117"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:27 -0700
IronPort-SDR: /xaw5n6BIQduLJeBproiv9WHMzmKTKvE2jj0VmVekMKvCpUCP0WfJOyAW/O+4LT4BhpKE3r7Px
 bD9BjdF2T1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328189"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 13/31] crypto: qat - remove writes into WQCFG
Date:   Mon, 12 Oct 2020 21:38:29 +0100
Message-Id: <20201012203847.340030-14-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

WQCFG registers contain the correct values after reset in all
generations of QAT. No need to write into them.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index d4162783f970..cbb9f0b8ff74 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -11,7 +11,6 @@
 #define ADF_ARB_REG_SLOT 0x1000
 #define ADF_ARB_WTR_OFFSET 0x010
 #define ADF_ARB_RO_EN_OFFSET 0x090
-#define ADF_ARB_WQCFG_OFFSET 0x100
 #define ADF_ARB_WRK_2_SER_MAP_OFFSET 0x180
 #define ADF_ARB_RINGSRVARBEN_OFFSET 0x19C
 
@@ -28,10 +27,6 @@
 	ADF_ARB_WRK_2_SER_MAP_OFFSET) + \
 	(ADF_ARB_REG_SIZE * index), value)
 
-#define WRITE_CSR_ARB_WQCFG(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_WQCFG_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
-
 int adf_init_arb(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
@@ -45,10 +40,6 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 	for (arb = 0; arb < ADF_ARB_NUM; arb++)
 		WRITE_CSR_ARB_SARCONFIG(csr, arb, arb_cfg);
 
-	/* Setup worker queue registers */
-	for (i = 0; i < hw_data->num_engines; i++)
-		WRITE_CSR_ARB_WQCFG(csr, i, i);
-
 	/* Map worker threads to service arbiters */
 	hw_data->get_arb_mapping(accel_dev, &thd_2_arb_cfg);
 
@@ -84,10 +75,6 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 	for (i = 0; i < ADF_ARB_NUM; i++)
 		WRITE_CSR_ARB_SARCONFIG(csr, i, 0);
 
-	/* Shutdown work queue */
-	for (i = 0; i < hw_data->num_engines; i++)
-		WRITE_CSR_ARB_WQCFG(csr, i, 0);
-
 	/* Unmap worker threads to service arbiters */
 	for (i = 0; i < hw_data->num_engines; i++)
 		WRITE_CSR_ARB_WRK_2_SER_MAP(csr, i, 0);
-- 
2.26.2

