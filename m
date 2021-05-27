Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E011C47089
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9D36135F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhE0TPJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:15:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:7489 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhE0TPE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:15:04 -0400
IronPort-SDR: P46tAeRsni+ZSZaDx10A2TK72nBTU6yCAssit4Zo0vmDvhrOPnuTNEXvD+77KaVV5DSAlSIJyZ
 mHZL0Z5vXhAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012446"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012446"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:30 -0700
IronPort-SDR: v+Ha6DZs0z9w2HCJYKzaZ9h8J/jKDqPKg80r+OIEH3sJ7w+5YE7BAiAOkLNZhkD+SMV8kA0zNv
 KIMSGDXPW8tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717776"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:29 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 06/10] crypto: qat - prevent spurious MSI interrupt in VF
Date:   Thu, 27 May 2021 20:12:47 +0100
Message-Id: <20210527191251.6317-7-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527191251.6317-1-marco.chiappero@intel.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

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
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 3e4f64d248f9..c603979e4a4c 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -18,6 +18,7 @@
 #include "adf_pf2vf_msg.h"
 
 #define ADF_VINTSOU_OFFSET	0x204
+#define ADF_VINTMSK_OFFSET	0x208
 #define ADF_VINTSOU_BUN		BIT(0)
 #define ADF_VINTSOU_PF2VF	BIT(1)
 
@@ -161,11 +162,17 @@ static irqreturn_t adf_isr(int irq, void *privdata)
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
+	/* Recompute v_int ignoring sources that are masked */
+	v_int &= ~v_mask;
+
 	/* Check for PF2VF interrupt */
 	if (v_int & ADF_VINTSOU_PF2VF) {
 		/* Disable PF to VF interrupt */
-- 
2.26.2

