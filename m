Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A652AC433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345871AbiDGQxg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbiDGQx2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1731443CE
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350288; x=1680886288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PzA2sjHRaaIz3uWBzkkvvC8/a2sLme9fB64qaxbwL+k=;
  b=jPob8GZJAj6xPDlnxMOMoMl4bcjCXTZIMaVWeO3OphYYs/OJ+HFlRTqS
   r+BhsegJ9Z48fzZ68xQbRXjS+NKgmw+STv+4buiLvE24zKeZTDqjndU0K
   gyz53dTDZPyR/VRb3MQxKhsw1k/ztKyODWXZTx0BCklefXZVhwDu174FL
   WuNvtt006Nbb7+KVlHdekG0R/In/7CDD2EbI2CkIHBWlwUQdu44pRoNBt
   xQZAr7IjdhABSoBzKYxDf50gjXzGsQnIiqROPAicDuZhlmGJWXYnNi9+q
   zSR7qN/attEVPHqqeLWZj9mhyueRb4UO3Ef4wakL5CyLnKzHpRCGKQj2n
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312112"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312112"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898403"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:25 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 15/16] crypto: qat - use u32 variables in all GEN4 pfvf_ops
Date:   Thu,  7 Apr 2022 17:54:54 +0100
Message-Id: <20220407165455.256777-16-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change adf_gen4_enable_vf2pf_interrupts() to use a u32 variable,
consistently with both other GEN4 pfvf_ops and pfvf_ops of other
generations.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 8091fc52e13a..73ec8defb2d3 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -40,7 +40,7 @@ static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
-	unsigned int val;
+	u32 val;
 
 	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) & ~vf_mask;
 	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
-- 
2.34.1

