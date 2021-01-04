Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A94C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2358C224F4
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhADRXA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:23:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:43978 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbhADRXA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 12:23:00 -0500
IronPort-SDR: EfQjYXaZBZOhMi5FaDW6sqQppNSpWCILre73s0iV2OmHpMeCMugko6GpH947koL1B8UMHR3Yp1
 sAlE727EBuUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177135633"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177135633"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:22:06 -0800
IronPort-SDR: /EdPW77epelDfKgUAqp1IwlmA+E05cbfMEItruirwIrqU8NRuYexPOsTJCnA1m0cQc9eosYIqo
 rPKk7pbyH0mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="345962823"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2021 09:22:05 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/3] crypto: qat - change format string and cast ring size
Date:   Mon,  4 Jan 2021 17:21:58 +0000
Message-Id: <20210104172159.15489-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
References: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Adam Guerin <adam.guerin@intel.com>

Cast ADF_SIZE_TO_RING_SIZE_IN_BYTES() so it can return a 64 bit value.

This issue was detected by smatch:

    drivers/crypto/qat/qat_common/adf_transport_debug.c:65 adf_ring_show() warn: should '(1 << (ring->ring_size - 1)) << 7' be a 64 bit type?

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 1205186ad51e..e69e5907f595 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -62,8 +62,8 @@ static int adf_ring_show(struct seq_file *sfile, void *v)
 		seq_printf(sfile, "head %x, tail %x, empty: %d\n",
 			   head, tail, (empty & 1 << ring->ring_number)
 			   >> ring->ring_number);
-		seq_printf(sfile, "ring size %d, msg size %d\n",
-			   ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size),
+		seq_printf(sfile, "ring size %lld, msg size %d\n",
+			   (long long)ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size),
 			   ADF_MSG_SIZE_TO_BYTES(ring->msg_size));
 		seq_puts(sfile, "----------- Ring data ------------\n");
 		return 0;
-- 
2.29.2

