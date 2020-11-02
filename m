Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21176C388F2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF78720786
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgKBRFC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:05:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:19151 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgKBRFC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Nov 2020 12:05:02 -0500
IronPort-SDR: +wK6zkB8SrU0MmePryqXy68VYYuObKRBZ04cwcVg1SyY/7Pz28RXA9OdMgV18zO9taM+YIb6EM
 fCYbLo09tTIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="230548447"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="230548447"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 09:05:01 -0800
IronPort-SDR: vkVL7SQD7VL5jFdqhNJHA0zstdnawejRBQhAIPxcPZ00KaxkbRnwBJvBPO0FmzmJHMuP1TFc4w
 Xg/BZhR5jcbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="528085770"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga005.fm.intel.com with ESMTP; 02 Nov 2020 09:04:59 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove cast for mailbox CSR
Date:   Mon,  2 Nov 2020 17:04:54 +0000
Message-Id: <20201102170454.716263-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Adam Guerin <adam.guerin@intel.com>

Remove cast for mailbox CSR in adf_admin.c as it is not needed.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 7c2ca54229aa..43680e178242 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -254,7 +254,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 	hw_data->get_admin_info(&admin_csrs_info);
 
 	mailbox_offset = admin_csrs_info.mailbox_offset;
-	mailbox = (void __iomem *)((uintptr_t)csr + mailbox_offset);
+	mailbox = csr + mailbox_offset;
 	adminmsg_u = admin_csrs_info.admin_msg_ur;
 	adminmsg_l = admin_csrs_info.admin_msg_lr;
 
-- 
2.28.0

