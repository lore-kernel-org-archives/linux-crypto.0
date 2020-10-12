Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19722C43467
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF21920BED
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbgJLUjs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:34081 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387830AbgJLUjq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:46 -0400
IronPort-SDR: GCuXdty2PwHmOECC5byjjSnaSW6tI+QCfCcO/CTrTPa7dGRntBtkvnzNN9py7t7RvQrCHmEpWT
 PU5Jz+/P5zOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913172"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913172"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:45 -0700
IronPort-SDR: Owa7jcMrtMb6d5ed6JugewsNtLX+IfSHFPH6SURJIDr3JrJsiAxNNxn4rnaZ7b3PUJKHhASBTX
 Pz6DdWDdq6HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328249"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:43 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 23/31] crypto: qat - remove hardcoded bank irq clear flag mask
Date:   Mon, 12 Oct 2020 21:38:39 +0100
Message-Id: <20201012203847.340030-24-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace hardcoded value of the bank interrupt clear flag mask with a
value calculated on the fly which is based on the number of rings
present in a bank. This is to support devices that have a number of
rings per bank different than 16.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c               | 4 ++--
 drivers/crypto/qat/qat_common/adf_transport_access_macros.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index dd8f94fcb9a8..5a7030acdc33 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -374,6 +374,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u8 num_rings_per_bank = hw_data->num_rings_per_bank;
 	struct adf_hw_csr_ops *csr_ops = &hw_data->csr_ops;
+	u32 irq_mask = BIT(num_rings_per_bank) - 1;
 	struct adf_etr_ring_data *ring;
 	struct adf_etr_ring_data *tx_ring;
 	u32 i, coalesc_enabled = 0;
@@ -431,8 +432,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 		goto err;
 	}
 
-	csr_ops->write_csr_int_flag(csr_addr, bank_num,
-				    ADF_BANK_INT_FLAG_CLEAR_MASK);
+	csr_ops->write_csr_int_flag(csr_addr, bank_num, irq_mask);
 	csr_ops->write_csr_int_srcsel(csr_addr, bank_num);
 
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 12b1605a740e..3b6b0267bbec 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -4,7 +4,6 @@
 #define ADF_TRANSPORT_ACCESS_MACROS_H
 
 #include "adf_accel_devices.h"
-#define ADF_BANK_INT_FLAG_CLEAR_MASK 0xFFFF
 #define ADF_RING_CONFIG_NEAR_FULL_WM 0x0A
 #define ADF_RING_CONFIG_NEAR_EMPTY_WM 0x05
 #define ADF_COALESCING_MIN_TIME 0x1FF
-- 
2.26.2

