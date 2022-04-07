Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB750C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbiDGQx2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiDGQxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD1BFFF4F
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350278; x=1680886278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z0y+Zc+jA65k+m5pFf7+hb/A0UbOEjpvYopaTiA8KHk=;
  b=frUCbWKqSRJ23BbRIfn4idgR3E9OB7B+juMINH6eYk7VQrMtqmLGtoSE
   eZoQdwLOlcN1/HvHpdedY+AxHhAwazhZws56HHQ7CICBXestvBi054WHR
   cTrbRqPXtwNv1IQOPYaoemOszHMoI4ekWFIIrlp/kTyUtbtaWLJm5inL5
   UsZXx6MllkOZoO9sDwrRMYbEQDovVifNUr8CRCLrVCJbgF3dU3rchNrBz
   RfnEic+eNPVecx5VWG1J1ZoLtFIKUSHtqVPIUMKHudop0exq9MKUVVtev
   Lf469IoAC5k0vLdqGd0NICs+2Gopr6iG4C93P1FfIbnxsxxoy2fIEOBJ4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312073"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312073"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898373"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:17 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 10/16] crypto: qat - fix wording and formatting in code comment
Date:   Thu,  7 Apr 2022 17:54:49 +0100
Message-Id: <20220407165455.256777-11-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove an unintentional extra space and improve the readability of a
PFVF related code comment.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 9c37a2661392..204a42438992 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -8,8 +8,8 @@
 /*
  * PF<->VF Gen2 Messaging format
  *
- * The PF has an array of 32-bit PF2VF registers, one for each VF.  The
- * PF can access all these registers; each VF can access only the one
+ * The PF has an array of 32-bit PF2VF registers, one for each VF. The
+ * PF can access all these registers while each VF can access only the one
  * register associated with that particular VF.
  *
  * The register functionally is split into two parts:
-- 
2.34.1

