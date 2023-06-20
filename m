Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC4BEB64D7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 13:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjFTNXq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 09:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjFTNX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 09:23:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4DC1BE6
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687267368; x=1718803368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hr/CV+dg+IKFXmyiac2FLX76c4euPNCzErUste/pjZY=;
  b=KtPZ+ZvbQ5bNwOc5VZBAnGAriwuFnjWjrnR/LU/KZS/mnIqiMEI/tIfK
   ZymV1ecqzTPQzuYLSAZrkp2wroByKGUoHbLPt4ZJU8Lpydl0blxjPjvFJ
   Cc8URt6AGRLFDJEGhcjhpaGpmlXzBNejn+BNTlwtSWwg84DXToYldCr9i
   G7jyEjV1oWGqZUhe7ekKIr5JAmdUYBGxayr9xDrq8kHQWMdyjBVrAe4Va
   9s5p91wZ8rTxm3H0BSvHlvp32xLY9YlR4hIwBFMA2Xi4fEkQhvE78PFgJ
   lmUX01gK/gWalEaTL62Mzlkuvbcruz8Q8erfCgJvEN5BCxO+xsCkXx92F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="446229750"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="446229750"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 06:22:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="743785427"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="743785427"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2023 06:22:19 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/5] crypto: qat - drop obsolete heartbeat interface
Date:   Tue, 20 Jun 2023 15:08:20 +0200
Message-Id: <20230620130823.27004-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230620130823.27004-1-damian.muszynski@intel.com>
References: <20230620130823.27004-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop legacy heartbeat interface from FW API as it is no longer used.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_common/icp_qat_fw_init_admin.h  | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index d853c9242acf..6ea19b4fb0ce 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -102,19 +102,4 @@ struct icp_qat_fw_init_admin_resp {
 
 #define ICP_QAT_FW_SYNC ICP_QAT_FW_HEARTBEAT_SYNC
 
-#define ICP_QAT_FW_COMN_HEARTBEAT_OK 0
-#define ICP_QAT_FW_COMN_HEARTBEAT_BLOCKED 1
-#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_BITPOS 0
-#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_MASK 0x1
-#define ICP_QAT_FW_COMN_STATUS_RESRVD_FLD_MASK 0xFE
-#define ICP_QAT_FW_COMN_HEARTBEAT_HDR_FLAG_GET(hdr_t) \
-	ICP_QAT_FW_COMN_HEARTBEAT_FLAG_GET(hdr_t.flags)
-
-#define ICP_QAT_FW_COMN_HEARTBEAT_HDR_FLAG_SET(hdr_t, val) \
-	ICP_QAT_FW_COMN_HEARTBEAT_FLAG_SET(hdr_t, val)
-
-#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_GET(flags) \
-	QAT_FIELD_GET(flags, \
-		 ICP_QAT_FW_COMN_HEARTBEAT_FLAG_BITPOS, \
-		 ICP_QAT_FW_COMN_HEARTBEAT_FLAG_MASK)
 #endif
-- 
2.40.1

