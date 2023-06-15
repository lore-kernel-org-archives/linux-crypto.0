Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E9FEB64DC
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 09:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbjFOJRV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 05:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbjFOJRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 05:17:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D7A199D
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 02:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686820640; x=1718356640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y1ygsHaE2vZN2x1I7iSciEluspM+V6QxlPDgZTRslDA=;
  b=GR88C605/l62aCwCrATf4/mbJAcXx+YXOrKRsZN6xkGt2S3Xrb/iD7Rc
   Uwz1UOOqXletOOy/oFMWepwA4I71qfGdpSfmZlP6ce4QFxYuKqunGJok1
   8jbut/w2GRpcsC08azpyAuvm8Yg+OvITIWvCvpz977HD8b5NbjJFthW9f
   HCXyft+V8oLbzpo5j3loYauI9liLY5aXgBwjS/nupUwPgtH2rTCfdrBiR
   ZLvHxWefa0C3auG+pNVF8iIWZE9ORMqzbtZmD1FWXyWZtPbvgT2d9mllt
   dBWCiIarAozLJCrw1HhJwKNJe2jS2xKK0aMkhKR9GaKzQvqI0P+NP1N8d
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="356350661"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="356350661"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 02:17:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782456126"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="782456126"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2023 02:17:19 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/4] crypto: qat - drop obsolete heartbeat interface
Date:   Thu, 15 Jun 2023 11:04:34 +0200
Message-Id: <20230615090437.436796-2-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615090437.436796-1-damian.muszynski@intel.com>
References: <20230615090437.436796-1-damian.muszynski@intel.com>
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
index 7233b62cfaa7..81b344faa755 100644
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

