Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AE5C6FD1F
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Mar 2023 09:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCPJFL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 05:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCPJFJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 05:05:09 -0400
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302DB1A79;
        Thu, 16 Mar 2023 02:05:02 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 77B371A00A90;
        Thu, 16 Mar 2023 17:05:02 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eQsYFf5tV3lD; Thu, 16 Mar 2023 17:05:01 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 97E2A1A0079E;
        Thu, 16 Mar 2023 17:05:00 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     olivia@selenic.com, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com,
        Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] hwrng: xgene - remove unnecessary (void*) conversions
Date:   Thu, 16 Mar 2023 17:04:12 +0800
Message-Id: <20230316090412.4383-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pointer variables of void * type do not require type cast.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 drivers/char/hw_random/xgene-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 008e6db9ce01..1ddeb32ec597 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -200,7 +200,7 @@ static void xgene_rng_chk_overflow(struct xgene_rng_dev *ctx)
 
 static irqreturn_t xgene_rng_irq_handler(int irq, void *id)
 {
-	struct xgene_rng_dev *ctx = (struct xgene_rng_dev *) id;
+	struct xgene_rng_dev *ctx = id;
 
 	/* RNG Alarm Counter overflow */
 	xgene_rng_chk_overflow(ctx);
-- 
2.11.0

