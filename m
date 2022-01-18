Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8782C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 10:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiARKfV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:35:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:5874 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235295AbiARKfU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 05:35:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642502120; x=1674038120;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6AJKbu49rpyuZwA711GK3TxhZxOQXUI1e5GQsGxfgAI=;
  b=h+YLmIns7C+rJ05rlvy+pkIDjTpCWCe0bKEElsHmQCyqfL+XxdXgSB1d
   2EvwQEvulVzz2HNrPFNzB2PvFyWIaX+vHevXobFpo6jjZJ75AB5e43rmt
   yOedCGMAtsSZj52BfvgnHNaTFdYV97IgUIIxTslOHK63gMY6xWNFzSriJ
   uaWQ/F8+ImgB08RbHyP5i/XFl8JTcFS8VLdfcrZHAlggdhdFep3ZLmQy3
   4FHWmDs2zwk1GanmogzPWBCN8iiO+kU5l3Kp4DB65iEYKkeBWiAzgNgGs
   vZv5o7HeRfQIxhsQleHEqQu67bpxdmywOYsGuvpp2xf6PLyTIAbr1NoS4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="331135286"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="331135286"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 02:35:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="615312836"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2022 02:35:18 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Siming Wan <siming.wan@intel.com>,
        Xin Zeng <xin.zeng@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH] crypto: qat - fix access to PFVF interrupt registers for GEN4
Date:   Tue, 18 Jan 2022 10:35:15 +0000
Message-Id: <20220118103515.51374-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The logic that detects, enables and disables pfvf interrupts was
expecting a single CSR per VF. Instead, the source and mask register are
two registers with a bit per VF.
Due to this, the driver is reading and setting reserved CSRs and not
masking the correct source of interrupts.

Fix the access to the source and mask register for QAT GEN4 devices by
removing the outer loop in adf_gen4_get_vf2pf_sources(),
adf_gen4_enable_vf2pf_interrupts() and
adf_gen4_disable_vf2pf_interrupts() and changing the helper macros
ADF_4XXX_VM2PF_SOU and ADF_4XXX_VM2PF_MSK.

Fixes: a9dc0d966605 ("crypto: qat - add PFVF support to the GEN4 host driver")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Siming Wan <siming.wan@intel.com>
Signed-off-by: Siming Wan <siming.wan@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 42 ++++---------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 8efbedf63bc8..3b3ea849c5e5 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -9,15 +9,12 @@
 #include "adf_pfvf_pf_proto.h"
 #include "adf_pfvf_utils.h"
 
-#define ADF_4XXX_MAX_NUM_VFS		16
-
 #define ADF_4XXX_PF2VM_OFFSET(i)	(0x40B010 + ((i) * 0x20))
 #define ADF_4XXX_VM2PF_OFFSET(i)	(0x40B014 + ((i) * 0x20))
 
 /* VF2PF interrupt source registers */
-#define ADF_4XXX_VM2PF_SOU(i)		(0x41A180 + ((i) * 4))
-#define ADF_4XXX_VM2PF_MSK(i)		(0x41A1C0 + ((i) * 4))
-#define ADF_4XXX_VM2PF_INT_EN_MSK	BIT(0)
+#define ADF_4XXX_VM2PF_SOU		0x41A180
+#define ADF_4XXX_VM2PF_MSK		0x41A1C0
 
 #define ADF_PFVF_GEN4_MSGTYPE_SHIFT	2
 #define ADF_PFVF_GEN4_MSGTYPE_MASK	0x3F
@@ -41,51 +38,30 @@ static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 
 static u32 adf_gen4_get_vf2pf_sources(void __iomem *pmisc_addr)
 {
-	int i;
 	u32 sou, mask;
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	u32 vf_mask = 0;
 
-	for (i = 0; i < num_csrs; i++) {
-		sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU(i));
-		mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK(i));
-		sou &= ~mask;
-		vf_mask |= sou << i;
-	}
+	sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU);
+	mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK);
 
-	return vf_mask;
+	return sou &= ~mask;
 }
 
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	unsigned long mask = vf_mask;
 	unsigned int val;
-	int i;
-
-	for_each_set_bit(i, &mask, num_csrs) {
-		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
 
-		val = ADF_CSR_RD(pmisc_addr, offset) & ~ADF_4XXX_VM2PF_INT_EN_MSK;
-		ADF_CSR_WR(pmisc_addr, offset, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) & ~vf_mask;
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
 static void adf_gen4_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					      u32 vf_mask)
 {
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	unsigned long mask = vf_mask;
 	unsigned int val;
-	int i;
-
-	for_each_set_bit(i, &mask, num_csrs) {
-		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
 
-		val = ADF_CSR_RD(pmisc_addr, offset) | ADF_4XXX_VM2PF_INT_EN_MSK;
-		ADF_CSR_WR(pmisc_addr, offset, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) | vf_mask;
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
 static int adf_gen4_pfvf_send(struct adf_accel_dev *accel_dev,
-- 
2.34.1

