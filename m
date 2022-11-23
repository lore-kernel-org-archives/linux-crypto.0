Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FF5C4167D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 12:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbiKWMLV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiKWMLF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 07:11:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8BE654DA
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 04:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669205455; x=1700741455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QkXJA17vxPLHgK7ybCSCMO/4bxNINAtSrU8jGCC0jJA=;
  b=elApP3rLZEE+e15dbF0x5SGI5H1A793DylDuIbIBJYype5DGNc7rNdfy
   DsGogPagDfjiNwPw8UVoftuI8nhhc1xsggtXbMh8znoOAGnGpUAj3LpKH
   KkIyRdvRKkkTrJ4XIY0vZBmjersrgiLbCrYgIwcSXFDHZsHfsJweQyEea
   sCz2FiOqnA3LtpmEr3qCRBCXO09zH+FS+fWAIxSglYp0nEbx0dQC72jSf
   7CgHn8SlK2pIXMAMV6+7hDU7hRvnR83IhP7XEMgvid8gcHtamw3D9antu
   s0yG8CUpJ1z6rYL69UOUEKYLuvHeCDC01mfqm3oanwSBid4kgJajXQdGY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312752499"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312752499"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784227499"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784227499"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 04:10:51 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH v2 07/11] crypto: qat - relocate qat_algs_alloc_flags()
Date:   Wed, 23 Nov 2022 12:10:28 +0000
Message-Id: <20221123121032.71991-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move qat_algs_alloc_flags() from qat_crypto.h to qat_bl.h as this will
be used also by the compression logic.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_bl.h     | 6 ++++++
 drivers/crypto/qat/qat_common/qat_crypto.h | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 0c174fee9e64..5f2ea8f352f7 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2022 Intel Corporation */
 #ifndef QAT_BL_H
 #define QAT_BL_H
+#include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 
@@ -52,4 +53,9 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		       struct qat_sgl_to_bufl_params *params,
 		       gfp_t flags);
 
+static inline gfp_t qat_algs_alloc_flags(struct crypto_async_request *req)
+{
+	return req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
+
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 505e881022a7..6a0e961bb9dc 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -65,9 +65,4 @@ static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
 	return true;
 }
 
-static inline gfp_t qat_algs_alloc_flags(struct crypto_async_request *req)
-{
-	return req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
-}
-
 #endif
-- 
2.38.1

