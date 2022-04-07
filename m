Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC69C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345833AbiDGQxZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbiDGQxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F211A37
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350276; x=1680886276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fmltnfxcr440AqeR4iM7RcgLXqxDxaud8Rf3z7URLf8=;
  b=WS3kyUV7aN/EB0+8XMmgHn42dTxsqyqn/dDff9lstKUUbVo1QbLYOmQL
   Os9L1M6gF1/u4myr7o/YcNXTfhRf0gfiIQDo6lsD2igaPoXSTIiCvsrJO
   T3U2XDMtHluFPqK6uqnXVdvXui+jp2Y+DCZSY57wMFSHPkhpfODNlKwo9
   Mh5SwD9gh/R+KRr8aOX/WsmPPHlRmDZCj5yM36DErBFtlMiwSMdbLDZ2v
   GtkWi4Fwe1W/wwBHxC6qkonaQO2nk59xZLJ6cA89BuTAMytrDDQQHvL/G
   FGGBZIIaBaCLRJKDvwlZ+NmKU9UraDoAbhVXpMozvc8z/8fvsXLM2VZGO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312058"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312058"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898359"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:14 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 08/16] crypto: qat - add check for invalid PFVF protocol version 0
Date:   Thu,  7 Apr 2022 17:54:47 +0100
Message-Id: <20220407165455.256777-9-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

PFVF protocol version 0 is not a valid version, but PF drivers
currently would report any such version from VFs as compatible.
This patch adds an extra check for the invalid PFVF protocol
version 0.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 588352de1ef0..c059b98836aa 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -242,7 +242,9 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 			"VersionRequest received from VF%d (vers %d) to PF (vers %d)\n",
 			vf_nr, vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
 
-		if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION)
+		if (vf_compat_ver == 0)
+			compat = ADF_PF2VF_VF_INCOMPATIBLE;
+		else if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION)
 			compat = ADF_PF2VF_VF_COMPATIBLE;
 		else
 			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
-- 
2.34.1

