Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3445FC433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 08:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA45964E2B
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 08:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhBAIVG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:21:06 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:49345 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232443AbhBAIVF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 03:21:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNWxyjP_1612167612;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNWxyjP_1612167612)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Feb 2021 16:20:20 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     horia.geanta@nxp.com
Cc:     aymen.sghaier@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] crypto: caam -Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Mon,  1 Feb 2021 16:20:11 +0800
Message-Id: <1612167611-15297-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the following coccicheck warning:

./drivers/crypto/caam/debugfs.c:23:0-23: WARNING: caam_fops_u64_ro
should be defined with DEFINE_DEBUGFS_ATTRIBUTE.

./drivers/crypto/caam/debugfs.c:22:0-23: WARNING: caam_fops_u32_ro
should be defined with DEFINE_DEBUGFS_ATTRIBUTE.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/crypto/caam/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/debugfs.c b/drivers/crypto/caam/debugfs.c
index 8ebf183..806bb20 100644
--- a/drivers/crypto/caam/debugfs.c
+++ b/drivers/crypto/caam/debugfs.c
@@ -19,8 +19,8 @@ static int caam_debugfs_u32_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
-DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
 
 #ifdef CONFIG_CAAM_QI
 /*
-- 
1.8.3.1

