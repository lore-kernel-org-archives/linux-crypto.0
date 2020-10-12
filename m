Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFFEC43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6660E214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgJLUjS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:33900 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:18 -0400
IronPort-SDR: RkaLEVI4JHZn62UYp4UDUu9vgh8DSlm1gh95C8vrlFs15kINSpeBeCXqFqidRWiPJ/+mst5OFi
 TqQI+s8Cvnow==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913086"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:18 -0700
IronPort-SDR: aVsqO9JZ4tUZkjM4HSLngfPazOmGb6wv6FdT17UIi/lkWB+vLoi2Pm9RsWP9QcJlms+X8bphGG
 kzOPCCRFO9gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328157"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:16 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 08/31] crypto: qat - add packed to init admin structures
Date:   Mon, 12 Oct 2020 21:38:24 +0100
Message-Id: <20201012203847.340030-9-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add packed attribute to the structures icp_qat_fw_init_admin_req and
icp_qat_fw_init_admin_resp as they are accessed by firmware.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
index d4d188cd7ed0..3868bcbed252 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
@@ -39,7 +39,7 @@ struct icp_qat_fw_init_admin_req {
 	};
 
 	__u32 resrvd4;
-};
+} __packed;
 
 struct icp_qat_fw_init_admin_resp {
 	__u8 flags;
@@ -92,7 +92,7 @@ struct icp_qat_fw_init_admin_resp {
 			__u64 resrvd8;
 		};
 	};
-};
+} __packed;
 
 #define ICP_QAT_FW_COMN_HEARTBEAT_OK 0
 #define ICP_QAT_FW_COMN_HEARTBEAT_BLOCKED 1
-- 
2.26.2

