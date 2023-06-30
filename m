Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396ABEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 17:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjF3RUj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 13:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjF3RUi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 13:20:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A314CDF
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688145637; x=1719681637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hr/CV+dg+IKFXmyiac2FLX76c4euPNCzErUste/pjZY=;
  b=B+4/yuE5z3nA6KE8uJHNFlRCrmYA6XbUJMVd8TBBbHzWfWqpMqieegzx
   W7fL5P6X6ki+OM3JIl5GI1i+5QVm/ZIPYvrSYj1hvtW6FTM/cEIXD3JWU
   eB+l3RgKjlx1GG7ZusAtI7paHHVeX0QCNiiuaL0ctLEYzv7/zU/H6RQ4v
   PL5ppLhjrJyWo4FjCrZOE3bccBIVqFR4RRbPuU9cnUMa2z4lKjmyISASP
   V/cOCvU/No9+SO+sVhHQMUFT0V+jNxCGU68Aq8PtqM753wIHCUK6hVTIF
   132pyiT7jxTi+vjnnwvoQ+8CF9IaY9fsjXF790J+HU6iNou/dK0GxyVfL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="359922933"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="359922933"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 10:20:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="721038711"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="721038711"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2023 10:20:36 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 2/5] crypto: qat - drop obsolete heartbeat interface
Date:   Fri, 30 Jun 2023 19:03:55 +0200
Message-Id: <20230630170356.177654-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230630170356.177654-1-damian.muszynski@intel.com>
References: <20230630170356.177654-1-damian.muszynski@intel.com>
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

