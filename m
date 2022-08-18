Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41E8C32772
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiHRSBt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244629AbiHRSBo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C4361707
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845703; x=1692381703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KY79XY+luDxtrWC082NtKh0uWwNqIal1LbUorv4dCB0=;
  b=G2p8i0IHj1oTIFfwQcedM8ZC53XRhBfgaNhj8bRESTe67GzonfgsVMsJ
   VT2lsMHtGyToG+T7qW3AjCd13D/8h2oD6tk/3wLMGmgztPx0nPnlVNiGB
   J4QvWjdfjyqOWee/T66ake8btS+KJS5trWf4YCuCdi13NP9u3bnsRHXCr
   Mdiih4eN/YlkCSdIX9GSCrQv6eBW9Q9HQ9XPvMeM08030h9l3odLimP2+
   9Tm6vJsSoM/dglrQqo/566Kri+aFfCGVAxnJFwrQ2XWyf+5IOBWAwGXxx
   r099cXurBKusB9ptyFhz+g48k8pEq7SIq1T2vuYRIt3ynt0UsCuSb6YLc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109433"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109433"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919515"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:42 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 3/9] crypto: qat - generalize crypto request buffers
Date:   Thu, 18 Aug 2022 19:01:14 +0100
Message-Id: <20220818180120.63452-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The structure qat_crypto_request_buffs which contains the source and
destination buffer lists and correspondent sizes and dma addresses is
also required for the compression service.
Rename it as qat_request_buffs and move it to qat_bl.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_bl.c     |  4 +--
 drivers/crypto/qat/qat_common/qat_bl.h     | 38 ++++++++++++++++++++--
 drivers/crypto/qat/qat_common/qat_crypto.h | 36 ++------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 62834aa5bce7..31addc2ee48e 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -11,7 +11,7 @@
 #include "qat_crypto.h"
 
 void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
-		       struct qat_crypto_request_buffs *buf)
+		       struct qat_request_buffs *buf)
 {
 	struct device *dev = &GET_DEV(accel_dev);
 	struct qat_alg_buf_list *bl = buf->bl;
@@ -50,7 +50,7 @@ void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
 int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			struct scatterlist *sgl,
 			struct scatterlist *sglout,
-			struct qat_crypto_request_buffs *buf,
+			struct qat_request_buffs *buf,
 			gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 902fd7fcde66..7b66c2b92824 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -4,14 +4,46 @@
 #define QAT_BL_H
 #include <linux/scatterlist.h>
 #include <linux/types.h>
-#include "qat_crypto.h"
+
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
+struct qat_request_buffs {
+	struct qat_alg_buf_list *bl;
+	dma_addr_t blp;
+	struct qat_alg_buf_list *blout;
+	dma_addr_t bloutp;
+	size_t sz;
+	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
+};
 
 void qat_alg_free_bufl(struct adf_accel_dev *accel_dev,
-		       struct qat_crypto_request_buffs *buf);
+		       struct qat_request_buffs *buf);
 int qat_alg_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			struct scatterlist *sgl,
 			struct scatterlist *sglout,
-			struct qat_crypto_request_buffs *buf,
+			struct qat_request_buffs *buf,
 			gfp_t flags);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index df3c738ce323..bb116357a568 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include "adf_accel_devices.h"
 #include "icp_qat_fw_la.h"
+#include "qat_bl.h"
 
 struct qat_instance_backlog {
 	struct list_head list;
@@ -35,39 +36,6 @@ struct qat_crypto_instance {
 	struct qat_instance_backlog backlog;
 };
 
-#define QAT_MAX_BUFF_DESC	4
-
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed;
-
-struct qat_alg_fixed_buf_list {
-	struct qat_alg_buf_list sgl_hdr;
-	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
-} __packed __aligned(64);
-
-struct qat_crypto_request_buffs {
-	struct qat_alg_buf_list *bl;
-	dma_addr_t blp;
-	struct qat_alg_buf_list *blout;
-	dma_addr_t bloutp;
-	size_t sz;
-	size_t sz_out;
-	bool sgl_src_valid;
-	bool sgl_dst_valid;
-	struct qat_alg_fixed_buf_list sgl_src;
-	struct qat_alg_fixed_buf_list sgl_dst;
-};
-
 struct qat_crypto_request;
 
 struct qat_crypto_request {
@@ -80,7 +48,7 @@ struct qat_crypto_request {
 		struct aead_request *aead_req;
 		struct skcipher_request *skcipher_req;
 	};
-	struct qat_crypto_request_buffs buf;
+	struct qat_request_buffs buf;
 	void (*cb)(struct icp_qat_fw_la_resp *resp,
 		   struct qat_crypto_request *req);
 	union {
-- 
2.37.1

