Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90403C43219
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67854206BF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfD1Idb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 04:33:31 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:53870 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfD1Idb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 04:33:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39B89374;
        Sun, 28 Apr 2019 01:33:31 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E0CE3F5AF;
        Sun, 28 Apr 2019 01:33:29 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, kbuild test robot <lkp@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree: use a proper le32 type for le32 val
Date:   Sun, 28 Apr 2019 11:33:22 +0300
Message-Id: <20190428083322.26175-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We build an explicit little endian value from the IDR register
values. Use a proper le32 type to mark the var as such to
satisfy Sparse.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: kbuild test robot <lkp@intel.com>
Fixes: dcf6285d18ea1 ("crypto: ccree - add CID and PID support")
---
 drivers/crypto/ccree/cc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 902f196d4be1..208957726cff 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -103,7 +103,7 @@ static u32 cc_read_idr(struct cc_drvdata *drvdata, const u32 *idr_offsets)
 	int i;
 	union {
 		u8 regs[CC_NUM_IDRS];
-		u32 val;
+		__le32 val;
 	} idr;
 
 	for (i = 0; i < CC_NUM_IDRS; ++i)
-- 
2.21.0

