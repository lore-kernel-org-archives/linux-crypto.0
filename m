Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07995C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245582AbiDGQx3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345875AbiDGQxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AC3125288
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350280; x=1680886280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ag8oQez9QMVo7GHVLX/xgXST3CfceUYSTaga7K1lAqU=;
  b=KXRh6ye+QuGns+H4BnUsPIaw3zwSuApkpOuDoT0vRMydYM2LZTFp8L6C
   EVM8ke91KFn7Qo2yLL+CUZKhCuKBp1+jHwgWARhMg7AyLdZEOETlBwmEE
   JB6KxfOpy3MGaKfURGeMw8j4x0GRw0Pf+o0MbVmw/Jv8p4ArMIkqTWIES
   eP3x+9+qndyqdktUFVWWmBrUttYVmwz2f8HwiURyce51dzRprSrqbm3Wt
   LmUU1OBXNIBVKj/PIVe/PrDyX7B9g4VELjun3y4JbjZZ+ZK9pY/gwRGTu
   63dZwl/RGeSN67u++9anler10RyknO+pCnNzQIarKeUlUhZxSqBkeUOPY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312080"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312080"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898381"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:18 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 11/16] crypto: qat - fix off-by-one error in PFVF debug print
Date:   Thu,  7 Apr 2022 17:54:50 +0100
Message-Id: <20220407165455.256777-12-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PFVF Block Message requests for CRC use 0-based values to indicate
amounts, which have to be remapped to 1-based values on the receiving
side.

This patch fixes one debug print which was however using the wire value.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index c059b98836aa..388e58bcbcaf 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -154,7 +154,7 @@ static struct pfvf_message handle_blkmsg_req(struct adf_accel_vf_info *vf_info,
 	if (FIELD_GET(ADF_VF2PF_BLOCK_CRC_REQ_MASK, req.data)) {
 		dev_dbg(&GET_DEV(vf_info->accel_dev),
 			"BlockMsg of type %d for CRC over %d bytes received from VF%d\n",
-			blk_type, blk_byte, vf_info->vf_nr);
+			blk_type, blk_byte + 1, vf_info->vf_nr);
 
 		if (!adf_pf2vf_blkmsg_get_data(vf_info, blk_type, blk_byte,
 					       byte_max, &resp_data,
-- 
2.34.1

