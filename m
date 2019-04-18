Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6917C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833E820675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389226AbfDRNmB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:01 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33734 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388858AbfDRNmB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E669B1688;
        Thu, 18 Apr 2019 06:42:00 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AAE83F5AF;
        Thu, 18 Apr 2019 06:41:59 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/35] crypto: ccree: allow more AEAD assoc data fragments
Date:   Thu, 18 Apr 2019 16:39:03 +0300
Message-Id: <20190418133913.9122-29-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Increase the maximum supported AEAD associated data fragments.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_lli_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_lli_defs.h b/drivers/crypto/ccree/cc_lli_defs.h
index 43aca6b79b9b..f891ab813f41 100644
--- a/drivers/crypto/ccree/cc_lli_defs.h
+++ b/drivers/crypto/ccree/cc_lli_defs.h
@@ -14,7 +14,7 @@
 #define CC_MAX_MLLI_ENTRY_SIZE 0xFFFF
 
 #define LLI_MAX_NUM_OF_DATA_ENTRIES 128
-#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
+#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 8
 #define MLLI_TABLE_MIN_ALIGNMENT 4 /* 32 bit alignment */
 #define MAX_NUM_OF_BUFFERS_IN_MLLI 4
 #define MAX_NUM_OF_TOTAL_MLLI_ENTRIES \
-- 
2.21.0

