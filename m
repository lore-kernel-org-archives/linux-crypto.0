Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC19EC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhLPJLn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:9683 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhLPJLg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645896; x=1671181896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9fKadJNwRewxgSuGvvj7AlcsOYz/M0hB2IU85sIKf/Q=;
  b=P7QZg/X1yIwPOkSKqXdUnB0fg8MmNA6tSBdgEdOUMBrlaVJnZM7DTHE3
   83h2sZa0H1LcosZiRAbhXRtw2iU77l1BMXxhpPQR69/sDsJbhBLFOyMux
   zJOoKdihojHtFY1o5guktK3IJ1jHh1ZpFinJVV+AX1UZ7cxdYRI7gxQX+
   SwfRVGDkcK6hkutuPlO7m3fsFLOgEqWijWVePthPghJI/3twlQvSqsxeo
   HxnLlR7nJ1SR6wztNlQdk3LzI7hfVTRbzzrnXvREd83ZMbeSQOGxMdFo7
   GFpYq1qxtXpPmJCtIH7OAQLgYGv38ivryToS2W+v9zhh9ej/UkxT6u286
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458446"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458446"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968521"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:34 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 13/24] crypto: qat - improve the ACK timings in PFVF send
Date:   Thu, 16 Dec 2021 09:13:23 +0000
Message-Id: <20211216091334.402420-14-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Review the ACK timings in adf_gen2_pfvf_send() to improve the latency
by reducing the polling interval. Also increase the timeout, for higher
tolerance in highly loaded systems, and reposition these new values to
allow for inclusion by the future GEN4 devices too.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c  | 3 ---
 drivers/crypto/qat/qat_common/adf_pfvf_utils.h | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 53c2e124944d..feab01ec4bbb 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -37,9 +37,6 @@ static const struct pfvf_csr_format csr_gen2_fmt = {
 	{ ADF_PFVF_GEN2_MSGDATA_SHIFT, ADF_PFVF_GEN2_MSGDATA_MASK },
 };
 
-#define ADF_PFVF_MSG_ACK_DELAY_US	2000
-#define ADF_PFVF_MSG_ACK_MAX_DELAY_US	(ADF_PFVF_MSG_ACK_DELAY_US * 100)
-
 #define ADF_PFVF_MSG_RETRY_DELAY	5
 #define ADF_PFVF_MSG_MAX_RETRIES	3
 
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_utils.h b/drivers/crypto/qat/qat_common/adf_pfvf_utils.h
index 7b73b5992d03..7676fdddbe26 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_utils.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_utils.h
@@ -6,6 +6,10 @@
 #include <linux/types.h>
 #include "adf_pfvf_msg.h"
 
+/* How long to wait for far side to acknowledge receipt */
+#define ADF_PFVF_MSG_ACK_DELAY_US	4
+#define ADF_PFVF_MSG_ACK_MAX_DELAY_US	(1 * USEC_PER_SEC)
+
 struct pfvf_field_format {
 	u8  offset;
 	u32 mask;
-- 
2.31.1

