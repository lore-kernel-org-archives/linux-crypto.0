Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31DCC32773
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbiHRSB5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344050AbiHRSBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDAAC6CF5
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845707; x=1692381707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p4KokIhgOuIMKfReUt6bvuY2bA5vePfhGlJet61nFgA=;
  b=jT7TTXMf4CXnVRbU+UOjpt0o9uzVIZqyG61b1pTAdnuIeqipXcHoMUiZ
   pxkuMC9G2DKYodDX1hYx3AikMIKAqFJcAw98aHPuWjO1Pam6rH02TD9/w
   KHAd4cSzVHOEXlxTTw6eCzTZiREnJ5DcX9Gf94EhHw4pqwZbGbRDQcTsy
   6nWWUDplNdbaRY97dfQFDzxgP0uTk3eW2Z2xUVwEL+2OXWbe1UKeSAUYa
   PwsT7YRF5rgBR4v76OkkbsOxGSzWcBLggDC0INHrFTAQOO+ayz0neYwQQ
   P2h/4AaI7b7IZajs2p4Vy0YgBROeX4jEZrmHw6P58Tzgo/MgqV4l++Lxr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109452"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109452"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919557"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:45 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 5/9] crypto: qat - relocate backlog related structures
Date:   Thu, 18 Aug 2022 19:01:16 +0100
Message-Id: <20220818180120.63452-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the structures qat_instance_backlog and qat_alg_req from
qat_crypto.h to qat_algs_send.h since they are not unique to crypto.
Both structures will be used by the compression service to support
requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs_send.h | 16 +++++++++++++++-
 drivers/crypto/qat/qat_common/qat_crypto.h    | 14 +-------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.h b/drivers/crypto/qat/qat_common/qat_algs_send.h
index 5ce9f4f69d8f..0baca16e1eff 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.h
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.h
@@ -3,7 +3,21 @@
 #ifndef QAT_ALGS_SEND_H
 #define QAT_ALGS_SEND_H
 
-#include "qat_crypto.h"
+#include <linux/list.h>
+#include "adf_transport_internal.h"
+
+struct qat_instance_backlog {
+	struct list_head list;
+	spinlock_t lock; /* protects backlog list */
+};
+
+struct qat_alg_req {
+	u32 *fw_req;
+	struct adf_etr_ring_data *tx_ring;
+	struct crypto_async_request *base;
+	struct list_head list;
+	struct qat_instance_backlog *backlog;
+};
 
 int qat_alg_send_message(struct qat_alg_req *req);
 void qat_alg_send_backlog(struct qat_instance_backlog *backlog);
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index bb116357a568..505e881022a7 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -8,21 +8,9 @@
 #include <linux/slab.h>
 #include "adf_accel_devices.h"
 #include "icp_qat_fw_la.h"
+#include "qat_algs_send.h"
 #include "qat_bl.h"
 
-struct qat_instance_backlog {
-	struct list_head list;
-	spinlock_t lock; /* protects backlog list */
-};
-
-struct qat_alg_req {
-	u32 *fw_req;
-	struct adf_etr_ring_data *tx_ring;
-	struct crypto_async_request *base;
-	struct list_head list;
-	struct qat_instance_backlog *backlog;
-};
-
 struct qat_crypto_instance {
 	struct adf_etr_ring_data *sym_tx;
 	struct adf_etr_ring_data *sym_rx;
-- 
2.37.1

