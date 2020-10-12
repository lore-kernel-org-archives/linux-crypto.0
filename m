Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDE1C43467
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC58820FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387823AbgJLUjl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387766AbgJLUjk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:40 -0400
IronPort-SDR: CcTt7/7Qn5eHpyZ1U6qzgZUyVHc9ilr7Zpjbd6GUzcYcLDqxAXDgmKtzMutVJ/uMjcCShyH1jj
 MJ/AkjUcddbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913157"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913157"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:40 -0700
IronPort-SDR: n3m6Xdo0rHR7Tw3lfcwF0PvmRUQT/NyStfFTyOr+QL8feyvJCMtD3KX56TooXAevgWZLyo7OoC
 0svJbe/vCs8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328227"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:39 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 20/31] crypto: qat - replace constant masks with GENMASK
Date:   Mon, 12 Oct 2020 21:38:36 +0100
Message-Id: <20201012203847.340030-21-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace constant 0xFFFFFFFFFFFFFFFFULL with GENMASK_ULL(63, 0) and
0xFFFFFFFF with GENMASK(31, 0) as they are masks.
This makes code less error prone.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h | 2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 212ff395201f..04236a442f3c 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -24,7 +24,7 @@
 #define ADF_RING_BUNDLE_SIZE		0x1000
 
 #define BUILD_RING_BASE_ADDR(addr, size) \
-	(((addr) >> 6) & (0xFFFFFFFFFFFFFFFFULL << (size)))
+	(((addr) >> 6) & (GENMASK_ULL(63, 0) << (size)))
 #define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
 	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
 		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index dde6c57ef15a..0e8eab057d2d 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -99,7 +99,7 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-	adf_disable_vf2pf_interrupts(accel_dev, 0xFFFFFFFF);
+	adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
 	hw_data->configure_iov_threads(accel_dev, false);
-- 
2.26.2

