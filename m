Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C831C43219
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiDGQx1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345862AbiDGQxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA60C6EE8
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350277; x=1680886277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MYFEFSWz5boVOSRwjsbs8SCDfn1zJK3CrTcS9OsVqcw=;
  b=Jjgr7HbC8W8+OYIrGSzOEHu20o85uWjuJkx327Sz3owTYuzeYdqCKFfI
   W2avQUxuXKWRUSuxus2KOmgMCIglOU2E1eFT4JNLhFsn8RwWVhlKN6vTd
   bHoJL2wCSMf6AwuSP+sz1j2lvBhb8aVNJTWYtdFMmGhOog711mdeA6UB2
   5xv9kjK+xth718bkBt6cQIdnUk6+zyED/rDpBR0x0Tlz2yoqNQRMWXjiF
   gf7x91rSBbfz3Ax9JELltAmqtXlbTy8pARGMxeG8WXcJe35tQwvwVYdxw
   /Ij2rzHhBVK24NqgzWAw4Snf2AL9rL7u1wZ/6X49yyit0ww0M64yzyv71
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312066"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312066"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898365"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:15 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 09/16] crypto: qat - test PFVF registers for spurious interrupts on GEN4
Date:   Thu,  7 Apr 2022 17:54:48 +0100
Message-Id: <20220407165455.256777-10-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Spurious PFVF interrupts can happen when either the ISR is invoked
without a valid source being set or, otherwise, when no interrupt bit
is set in the PFVF register containing the message.

The latter test was present for GEN2 devices but missing for GEN4, this
patch fills the gap.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index d80d493a7756..f7860bf612da 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -96,10 +96,16 @@ static struct pfvf_message adf_gen4_pfvf_recv(struct adf_accel_dev *accel_dev,
 					      u32 pfvf_offset, u8 compat_ver)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	struct pfvf_message msg = { 0 };
 	u32 csr_val;
 
 	/* Read message from the CSR */
 	csr_val = ADF_CSR_RD(pmisc_addr, pfvf_offset);
+	if (!(csr_val & ADF_PFVF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious PFVF interrupt, msg 0x%.8x. Ignored\n", csr_val);
+		return msg;
+	}
 
 	/* We can now acknowledge the message reception by clearing the
 	 * interrupt bit
-- 
2.34.1

