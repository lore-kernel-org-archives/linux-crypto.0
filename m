Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2610BC433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 09:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C3D613D6
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 09:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhEGJ6D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 05:58:03 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:57219 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhEGJ6C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 05:58:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UY2dZi5_1620381419;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UY2dZi5_1620381419)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 May 2021 17:57:00 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nathan@kernel.org, ndesaulniers@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] crypto: cavium/nitrox - Remove redundant initialization of 'sg'
Date:   Fri,  7 May 2021 17:56:57 +0800
Message-Id: <1620381417-44442-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pointer 'sg' is being initialized however this value is never
read as 'sg' is assigned a same value in for_each_sg().
Remove the redundant assignment.

Cleans up clang warning:

drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:161:22: warning: Value
stored to 'sg' during its initialization is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index df95ba2..bc35d4c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -159,7 +159,7 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
 			  struct se_crypto_request *req)
 {
 	struct device *dev = DEV(sr->ndev);
-	struct scatterlist *sg = req->src;
+	struct scatterlist *sg;
 	int i, nents, ret = 0;
 
 	nents = dma_map_sg(dev, req->src, sg_nents(req->src),
-- 
1.8.3.1

