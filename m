Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178CFC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 12:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiKWMLV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiKWMLE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 07:11:04 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DA5654FA
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 04:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669205454; x=1700741454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IP2DGIevAm+lsCx/q/MWnUzRKPLBAVFNQY/guqI7c6M=;
  b=dY05V9QrEGfr4gDFPGD/xpDzctsFaXXMrFHpg0XuI81PDLR8fvORkZNW
   WqbORQt4Nyv+MB5n5pOZNZTvqxfpLoUTp/vtaq0iHaZYhqYrAx7rRqwnE
   rxKEqRQjQ8naap42SYumNELDZfo/6E/6XkVzMeVN3jLFu27rpA4Hy9g+u
   omFAp6OIolEHrKTc8r9S03KtmPhG55+N2jQHZfHDUbu9WzLz0mv/uPbx+
   Kg3r/n/0+uE2DzUGhaF51/wYN+jM5pH/7gSz+nKOGfLSnBVfHT+wxCS9e
   wzmiSMidrbJbLKZ3bGEvlLM69UK/dxENJdKkqALJvZB4ycAI4x6A/I+GE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312752493"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312752493"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:10:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784227489"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784227489"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 04:10:49 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH v2 06/11] crypto: qat - relocate backlog related structures
Date:   Wed, 23 Nov 2022 12:10:27 +0000
Message-Id: <20221123121032.71991-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
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
2.38.1

