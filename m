Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBB0C3F6B0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244629AbiHRSB6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbiHRSBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A804621A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845709; x=1692381709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KqX6ZfC7WpaZCWdx5CLiE23r2JBHlSkefEhlb0KtcEU=;
  b=fpFkf8e51gypKbSaNREE9cOO8fDJbBQWc+YfxMwZvBUQ/+0yCzkPIEVP
   GARJfKrKCIxAZqQlxsImX76vCFhUcUGA5Pmq3K6a9TxDYJtpZGCxHgte2
   OEMaQ+0fvFm8zsbO1ExMlwQJVFikjmORrBWhRAtY5Mu7WYspL4CnWNbNl
   GhOSGT3O4T1qDUGfUG0erjseDmXB1I60ULoulJCkj3b0JRP2ov2zycVC6
   LE9O2I147/MVgRq+H4yjVZSLdc275qnv5c4zhAxHgfak2Om7gcfxLRjyJ
   AOMNuPDkdwuwYnJ2HErXa2QJ3AcwvJfy9CWuc2sJw1EdWdWOOsi7Oa4Ys
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109458"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109458"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919581"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:47 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 6/9] crypto: qat - relocate qat_algs_alloc_flags()
Date:   Thu, 18 Aug 2022 19:01:17 +0100
Message-Id: <20220818180120.63452-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
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
index e8c02a02415a..6033c79cb93c 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2022 Intel Corporation */
 #ifndef QAT_BL_H
 #define QAT_BL_H
+#include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 
@@ -52,4 +53,9 @@ int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
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
2.37.1

