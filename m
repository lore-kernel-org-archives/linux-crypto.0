Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9595C432BE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB3460C3F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbhHLUWZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236956AbhHLUWW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474021"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474021"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608591"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:47 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 06/20] crypto: qat - prevent spurious MSI interrupt in VF
Date:   Thu, 12 Aug 2021 21:21:15 +0100
Message-Id: <20210812202129.18831-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QAT GEN2 devices suffer from a defect where the MSI interrupt can be
sent multiple times.

If the second (spurious) interrupt is handled before the bottom half
handler runs, then the extra interrupt is effectively ignored because
the bottom half is only scheduled once.
However, if the top half runs again after the bottom half runs, this
will appear as a spurious PF to VF interrupt.

This can be avoided by checking the interrupt mask register in addition
to the interrupt source register in the interrupt handler.

This patch is based on earlier work done by Conor McLoughlin.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 3e4f64d248f9..4359ca633ea9 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -18,6 +18,7 @@
 #include "adf_pf2vf_msg.h"
 
 #define ADF_VINTSOU_OFFSET	0x204
+#define ADF_VINTMSK_OFFSET	0x208
 #define ADF_VINTSOU_BUN		BIT(0)
 #define ADF_VINTSOU_PF2VF	BIT(1)
 
@@ -161,11 +162,20 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
 	bool handled = false;
-	u32 v_int;
+	u32 v_int, v_mask;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
 	v_int = ADF_CSR_RD(pmisc_bar_addr, ADF_VINTSOU_OFFSET);
 
+	/* Read VF INT mask CSR to determine which sources are masked */
+	v_mask = ADF_CSR_RD(pmisc_bar_addr, ADF_VINTMSK_OFFSET);
+
+	/*
+	 * Recompute v_int ignoring sources that are masked. This is to
+	 * avoid rescheduling the tasklet for interrupts already handled
+	 */
+	v_int &= ~v_mask;
+
 	/* Check for PF2VF interrupt */
 	if (v_int & ADF_VINTSOU_PF2VF) {
 		/* Disable PF to VF interrupt */
-- 
2.31.1

