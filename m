Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FA5C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377484AbiDDOg4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359377AbiDDOgx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:36:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F689D54
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082898; x=1680618898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OsCo7h2piN6FhvEfjbFeaiw3RVF+Cd8QUiKbGulTmQI=;
  b=DYLbPPGVtoAWHRnAHZr6CNDmO2bE7f6CCQSUvSQR9tQHm+WKOOj0hcQI
   yR1D/voITAe+XmMXfIgzYmZW6fSr/D7UKTy1k2h9oVjdeXM0Mr0AY/Hwa
   4Ra64ap5y3hZgv2E+LqaqheXaBETvinXgQE7w5uV8zR0WEjve9K33JFG1
   fnAuXg/sYLNfMhJExcWcO6FzIwV6iIJ2w0h18xPYBfYQDfinEe6AnzAnx
   7IzvsYhIvAxRKeeRytcnV/RnNDKbCEnWLXYwegusMi1cBYWyCgq2DgLS6
   JPo4/Oxz7o0s0vfNNKpPGuzAhWpJIlI0mYi6sM1erayuGUwobb7MzLJI5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704512"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704512"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521475"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:55 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 5/8] crypto: qat - leverage the GEN2 VF mask definiton
Date:   Mon,  4 Apr 2022 15:38:26 +0100
Message-Id: <20220404143829.147404-6-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace hard coded VF masks in adf_gen2_pfvf.c with the recently
introduced ADF_GEN2_VF_MSK.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index def4cc8e1039..8df952df18ef 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -15,7 +15,7 @@
  /* VF2PF interrupts */
 #define ADF_GEN2_VF_MSK			0xFFFF
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
-#define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
+#define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & ADF_GEN2_VF_MSK) << 9)
 
 #define ADF_GEN2_PF_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_GEN2_VF_PF2VF_OFFSET	0x200
@@ -55,7 +55,7 @@ static void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
 	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
+	if (vf_mask & ADF_GEN2_VF_MSK) {
 		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
 			  & ~ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
 		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
@@ -66,7 +66,7 @@ static void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					      u32 vf_mask)
 {
 	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
+	if (vf_mask & ADF_GEN2_VF_MSK) {
 		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
 			  | ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
 		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
-- 
2.34.1

