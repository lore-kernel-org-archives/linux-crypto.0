Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F24C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Mar 2022 18:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbiCDSEz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241155AbiCDSEx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Mar 2022 13:04:53 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B2CB1A
        for <linux-crypto@vger.kernel.org>; Fri,  4 Mar 2022 10:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646417041; x=1677953041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESJkjFrtdBYgKRHjc5+6EJ83n41XVoBRF4xGFcDkx3o=;
  b=POrKdXB5Uda1pMPDdUtDpAw/0Rl/yknC1oSJemyBFRFZ9DFQQp7qIt1L
   czlDxtvaeyJTnvyPgS3wE1KfudprtjwyA34NxfQ6ZlkFbzERxgb1x2TOD
   ijOjQXue9Bz5HzvUR3Sbq6mwK1+XntHg3afidFA1VXwQE8M6e2LqrMx62
   W4guwLXPJHmxVhQWi6kojNsMp5BsaW8pneMLUEYBLmTM9jfAZoX/dsn8S
   RFwu2vuSHwH5HCNXz36f5OCSC6nheibQs6E+4g/Z5E2fxm3AldGbx20/U
   l4SzwmdbI2kN3Z6SeEwDYP3lsKd5G0TAL6b9gAq4pCTstrzP0+e365T0/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="314744408"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="314744408"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552308532"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2022 10:04:00 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - remove unneeded assignment
Date:   Fri,  4 Mar 2022 18:03:54 +0000
Message-Id: <20220304180356.22469-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
References: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_gen4_get_vf2pf_sources() computes a mask which is
stored in a variable which is returned and not used.
Remove superfluous assignment of variable.

This is to fix the following warning when compiling the QAT driver
with clang scan-build:

    drivers/crypto/qat/qat_common/adf_gen4_pfvf.c:46:9: warning: Although the value stored to 'sou' is used in the enclosing expression, the value is never actually read from 'sou' [deadcode.DeadStores]
            return sou &= ~mask;
                   ^      ~~~~~

Fixes: 5901b4af6e07 ("crypto: qat - fix access to PFVF interrupt registers for GEN4")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 3b3ea849c5e5..d80d493a7756 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -43,7 +43,7 @@ static u32 adf_gen4_get_vf2pf_sources(void __iomem *pmisc_addr)
 	sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU);
 	mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK);
 
-	return sou &= ~mask;
+	return sou & ~mask;
 }
 
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
-- 
2.35.1

