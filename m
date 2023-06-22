Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91663EB64DC
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 18:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjFVSSw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjFVSSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 14:18:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C58F2112
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 11:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687457925; x=1718993925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hr/CV+dg+IKFXmyiac2FLX76c4euPNCzErUste/pjZY=;
  b=Dlw50XxCtq/sZLKgVzpDQyMoMXatgf27f1byXRPEzzmrkD/QydGLKia0
   i3ZRAiOwUyUs/Uu1rarpy/V2qvE0QHFQmSTMWkYth6L9gmzWffvQ34Jlm
   ZPdns+4vpY1w2IrIvcSbWDxI8RxjfVLJqncYQ6sjCmy3bWy3hdeNv7scj
   N5lYGQgCryg5Lnlx/bfYH+D8R+QU7N067LWJ5JNpsGYZQabK/Zambk27N
   fGsVm5J6ZdRATrSC4cxx96YL1T5ZtcvMSqkY0JtVHpRto42ePqtSWKSSZ
   cbQ1bKB6ai9knzP1CNLWxHT3hIi6GnjkCsx/Wbxx7k19ovJGFXslxPAAz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="340175939"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="340175939"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 11:18:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="665162998"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="665162998"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2023 11:18:29 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/5] crypto: qat - drop obsolete heartbeat interface
Date:   Thu, 22 Jun 2023 20:04:03 +0200
Message-Id: <20230622180405.133298-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230622180405.133298-1-damian.muszynski@intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
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

