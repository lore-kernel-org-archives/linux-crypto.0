Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1753C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356413AbiDDOgw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354302AbiDDOgq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:36:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944623615C
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082890; x=1680618890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OkER05QTztl9YMzLq2EfjnhlHZ5pE3LhH1CHc/xAeFQ=;
  b=XN4mTCv4sDDbpht8+LwQf1dxCcejKvGGgW0+nXgx7Pj4DRMx868rR1Hl
   gf/d9bmVX6SN5LGSIDTV5SltxTjgfmKZ7O/SKsFM4U4eNx/gMTZ6x9dHb
   0r63YhnKc5uus0/5gojUUKE5bSBEmAUp04U/Wd/aV3OmlELAuwYnhtBGu
   aUYnbiYTNAnPgB4k/ywacIJ2p+xdzHohOAC3K6fKNXmxjR99R9IdOi1QG
   GpKct4l+XWlTW1zoZAoZ7AtVKuSiQsxiI0BkZwyG/iWF0HiY8rmd9dFDn
   eBL8HS8S5MryWwrms0sX84oT5DwiHX4HYOXHZV/CsIgkMOvTxM/3t3yP4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704474"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704474"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521403"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:48 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 2/8] crypto: qat - set COMPRESSION capability for DH895XCC
Date:   Mon,  4 Apr 2022 15:38:23 +0100
Message-Id: <20220404143829.147404-3-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The capability detection logic clears bits for the features that are
disabled in a certain SKU. For example, if the bit associate to
compression is not present in the LEGFUSE register, the correspondent
bit is cleared in the capability mask.
This change adds the compression capability to the mask as this was
missing in the commit that enhanced the capability detection logic.

Fixes: cfe4894eccdc ("crypto: qat - set COMPRESSION capability for QAT GEN2")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index ff13047772e3..61d5467e0d92 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -59,7 +59,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 	capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
-		       ICP_ACCEL_CAPABILITIES_CIPHER;
+		       ICP_ACCEL_CAPABILITIES_CIPHER |
+		       ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
-- 
2.34.1

