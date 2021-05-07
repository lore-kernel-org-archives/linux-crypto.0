Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53B1C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 09:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD8561451
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 09:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhEGJ7P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 05:59:15 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:55959 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233418AbhEGJ7L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 05:59:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UY2DqqE_1620381488;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UY2DqqE_1620381488)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 May 2021 17:58:09 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nathan@kernel.org, ndesaulniers@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] crypto: cavium/nitrox - Fix kernel-doc
Date:   Fri,  7 May 2021 17:58:07 +0800
Message-Id: <1620381487-45311-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix function name in nitrox_reqmgr.c kernel-doc comment
to remove a warning.

drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:382: warning: expecting
prototype for nitrox_se_request(). Prototype was for
nitrox_process_se_request() instead

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index bc35d4c..4434c92 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -369,7 +369,7 @@ static int nitrox_enqueue_request(struct nitrox_softreq *sr)
 }
 
 /**
- * nitrox_se_request - Send request to SE core
+ * nitrox_process_se_request - Send request to SE core
  * @ndev: NITROX device
  * @req: Crypto request
  *
-- 
1.8.3.1

