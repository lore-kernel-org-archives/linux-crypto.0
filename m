Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D40EC5DF60
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 00:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F306621A49
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 00:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfKFAxP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 19:53:15 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45074 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727252AbfKFAxP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 19:53:15 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6C8ADFC0E4BEAB798F2;
        Wed,  6 Nov 2019 08:53:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 6 Nov 2019 08:53:04 +0800
From:   Tian Tao <tiantao6@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH] crypto: tgr192 remove unneeded semicolon
Date:   Wed, 6 Nov 2019 08:53:41 +0800
Message-ID: <1573001621-58594-1-git-send-email-tiantao6@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the warning below.
./crypto/tgr192.c:558:43-44: Unneeded semicolon
./crypto/tgr192.c:586:44-45: Unneeded semicolon

Fixes: f63fbd3d501b ("crypto: tgr192 - Switch to shash")

Signed-off-by: Tian Tao <tiantao6@huawei.com>
---
 crypto/tgr192.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 052648e..aa29c52 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -555,7 +555,7 @@ static int tgr192_final(struct shash_desc *desc, u8 * out)
 	__le32 *le32p;
 	u32 t, msb, lsb;
 
-	tgr192_update(desc, NULL, 0); /* flush */ ;
+	tgr192_update(desc, NULL, 0); /* flush */
 
 	msb = 0;
 	t = tctx->nblocks;
@@ -583,7 +583,7 @@ static int tgr192_final(struct shash_desc *desc, u8 * out)
 		while (tctx->count < 64) {
 			tctx->hash[tctx->count++] = 0;
 		}
-		tgr192_update(desc, NULL, 0); /* flush */ ;
+		tgr192_update(desc, NULL, 0); /* flush */
 		memset(tctx->hash, 0, 56);    /* fill next block with zeroes */
 	}
 	/* append the 64 bit count */
-- 
2.7.4

