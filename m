Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B9AC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A95610E6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhI1Lqj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240396AbhI1Lqj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339059"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339059"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224738"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:58 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 06/12] crypto: qat - use hweight for bit counting
Date:   Tue, 28 Sep 2021 12:44:34 +0100
Message-Id: <20210928114440.355368-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace homegrown bit counting logic in adf_gen2_get_num_accels() and
adf_gen2_get_num_aes() with the functions hweight16() and hweight32(),
respectively.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 1deeeaed9a8c..262bdc05dab4 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -54,31 +54,19 @@ EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
 
 u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self)
 {
-	u32 i, ctr = 0;
-
 	if (!self || !self->accel_mask)
 		return 0;
 
-	for (i = 0; i < self->num_accel; i++)
-		if (self->accel_mask & (1 << i))
-			ctr++;
-
-	return ctr;
+	return hweight16(self->accel_mask);
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_num_accels);
 
 u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self)
 {
-	u32 i, ctr = 0;
-
 	if (!self || !self->ae_mask)
 		return 0;
 
-	for (i = 0; i < self->num_engines; i++)
-		if (self->ae_mask & (1 << i))
-			ctr++;
-
-	return ctr;
+	return hweight32(self->ae_mask);
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_num_aes);
 
-- 
2.31.1

