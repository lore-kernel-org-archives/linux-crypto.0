Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FF6C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359377AbiDDOhF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377525AbiDDOhD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:37:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5293ED39
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082903; x=1680618903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2P3ZFTo0hwl3DMoT8M9WlRcZ08M6P2Jfm7SWkaB5w7c=;
  b=P9+vIats3/Gr2hTULJsSI1R3LDMy43UYEbu9N/U7XlnKn2olmZs8h8QD
   TW5os+nAg1rQqbsVnNXCrdm6cjoqyH6YtDy1WvgehPrRLH8Qf/C0dbosG
   8XbSFHZB0uoLD9I4xA9WkXKHz6A1GixeONIQv9ZpH+Swv7YTVYYt8G6iH
   sIDADNwZ8RFaZuVgbCmgS1qXfsCZkAKLaY8YoLrJWYvsfRb9ovzsebOVD
   2tTu2aih6OBhU8U2l6qxpWvjyE2H1ATd7R6qGCu08wqWeI0WApNoeU7u8
   a2ou/ib0sbqlqG4hwhknM0M1UIiV8QPdrw6bMtv7rm7ibFZWfQ6k3j6dT
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704544"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704544"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521540"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:35:01 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 7/8] crypto: qat - use u32 variables in all GEN4 pfvf_ops
Date:   Mon,  4 Apr 2022 15:38:28 +0100
Message-Id: <20220404143829.147404-8-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
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
index ee0c0ad34a29..619f9c9ff0e9 100644
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

