Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2C0C43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E10E214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387766AbgJLUjs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387764AbgJLUjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:42 -0400
IronPort-SDR: 5xVaKrcN5XjP5xLl13deA5Aiw6ArgOMxWCiuYk+3ERRv5l1dQ3MAiz9x8m/bO+bswzjoekvrY2
 s9ET87nO3pwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913159"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913159"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:41 -0700
IronPort-SDR: uKjXrXQR7v9QcxDPnQyx2aLhlZPfFmSXEINEHuh07Z7ZP5QEwNSzPkEAP+68ahNvxXvemYuIMA
 klYjrOCW6aIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328232"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:40 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 21/31] crypto: qat - use BIT_ULL() - 1 pattern for masks
Date:   Mon, 12 Oct 2020 21:38:37 +0100
Message-Id: <20201012203847.340030-22-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace occurrences of the pattern GENMASK_ULL(var - 1, 0)) with
BIT_ULL(var) - 1 since it produces better code and it is easier to read.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c              | 2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 0e8eab057d2d..9a0f6db83106 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -65,7 +65,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	adf_enable_vf2pf_interrupts(accel_dev, GENMASK_ULL(totalvfs - 1, 0));
+	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
 
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 7970ebb67f28..1e83d9397b11 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -195,7 +195,7 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 	/* Enable bundle and misc interrupts */
 	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF0_MASK_OFFSET,
 		   accel_dev->pf.vf_info ? 0 :
-			GENMASK_ULL(GET_MAX_BANKS(accel_dev) - 1, 0));
+			BIT_ULL(GET_MAX_BANKS(accel_dev)) - 1);
 	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF1_MASK_OFFSET,
 		   ADF_DH895XCC_SMIA1_MASK);
 }
-- 
2.26.2

