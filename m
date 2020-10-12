Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCD0C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CF12145D
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgJLUja (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:34011 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgJLUj3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:29 -0400
IronPort-SDR: ldapMlVdusreSCSIBHGuDeGqFVjxkq6GjDJhZC302EiXVSAX4P2FpWzCRjVeudzAkUAlMLYpzt
 u21mEEzWiCQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913125"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913125"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:29 -0700
IronPort-SDR: zep0n+mu2xgZJzxpzKTIr/8IoQBacU2tQ18CguSQCZ1BOsLZQNSC7NggBwEZkjKiWGuby3pOlM
 9CXM+pPjv5GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328192"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:27 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 14/31] crypto: qat - remove unused macros in arbiter module
Date:   Mon, 12 Oct 2020 21:38:30 +0100
Message-Id: <20201012203847.340030-15-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the unused macros ADF_ARB_WTR_SIZE, ADF_ARB_WTR_OFFSET
and ADF_ARB_RO_EN_OFFSET.
These macros were left in commit 34074205bb9f ("crypto: qat - remove
redundant arbiter configuration") that removed the logic that used those
defines.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index cbb9f0b8ff74..be2fd264a223 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -6,11 +6,8 @@
 
 #define ADF_ARB_NUM 4
 #define ADF_ARB_REG_SIZE 0x4
-#define ADF_ARB_WTR_SIZE 0x20
 #define ADF_ARB_OFFSET 0x30000
 #define ADF_ARB_REG_SLOT 0x1000
-#define ADF_ARB_WTR_OFFSET 0x010
-#define ADF_ARB_RO_EN_OFFSET 0x090
 #define ADF_ARB_WRK_2_SER_MAP_OFFSET 0x180
 #define ADF_ARB_RINGSRVARBEN_OFFSET 0x19C
 
-- 
2.26.2

