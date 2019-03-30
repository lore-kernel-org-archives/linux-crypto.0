Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1EEC43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 05:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306F9218A3
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 05:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfC3Ftr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 01:49:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbfC3Ftr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 01:49:47 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DD616C7B137ACBAB41B7;
        Sat, 30 Mar 2019 13:49:41 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Sat, 30 Mar 2019
 13:49:32 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: marvell - remove set but not used variable 'index'
Date:   Sat, 30 Mar 2019 13:28:58 +0800
Message-ID: <20190330052858.24128-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/marvell/hash.c: In function 'mv_cesa_ahash_pad_req':
drivers/crypto/marvell/hash.c:138:15: warning: variable 'index' set but not used [-Wunused-but-set-variable]

It's never used and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/marvell/hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 99ff54c..fd456dd 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -135,11 +135,10 @@ static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
 
 static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
 {
-	unsigned int index, padlen;
+	unsigned int padlen;
 
 	buf[0] = 0x80;
 	/* Pad out to 56 mod 64 */
-	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
 	padlen = mv_cesa_ahash_pad_len(creq);
 	memset(buf + 1, 0, padlen - 1);
 
-- 
2.7.0


