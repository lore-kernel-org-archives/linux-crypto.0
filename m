Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6AAC25B0C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Aug 2022 16:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiHKQGu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiHKQGf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Aug 2022 12:06:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F019F0ED;
        Thu, 11 Aug 2022 08:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD7E60F92;
        Thu, 11 Aug 2022 15:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0646DC433C1;
        Thu, 11 Aug 2022 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233190;
        bh=XlGk8IX1wN1ZNzCe5TFWky6S5v+Ns8c93X8nxKeGupM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRtrN5lTNPSfUSHOps2pONW1fh7Mt5HaXJh9AyS0DfLCQGKADI3ARKYtGn2XB486n
         mdGqdncwxAp8kaMcEvJgL0JsLAymx18ysa7zG+9aJHNrv+HzhHZArueyD317ATW6RN
         mpCjty/CgoMG0M0UOaLIHpmSVMet/9SGSaCHukutGHueBAN1TgHqmYyq+Zorq48ElT
         6Gk+iow6V6nPoH4OnlrPnAVIo047H78BD1XCUbxP3a3o5udDHF2jzOEg/x3Cn1RhdK
         S587uHMrJE+zZX+s5qnerNuGU0MmYscGaBqNDytPG18Y/rIFzkWalzVLE8isLtiYwF
         l7+NyCZfYeZ1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuan Can <yuancan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, gilad@benyossef.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 64/93] crypto: ccree - Add missing clk_disable_unprepare() in cc_pm_resume()
Date:   Thu, 11 Aug 2022 11:41:58 -0400
Message-Id: <20220811154237.1531313-64-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 30fb034361ff1b9bfc569b2d8d66b544ea3eb18f ]

Add clk_disable_unprepare() on error path in cc_pm_resume().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index d5421b0c6831..6124fbbbed94 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -41,6 +41,7 @@ static int cc_pm_resume(struct device *dev)
 	/* wait for Cryptocell reset completion */
 	if (!cc_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 
@@ -48,6 +49,7 @@ static int cc_pm_resume(struct device *dev)
 	rc = init_cc_regs(drvdata);
 	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);
+		clk_disable_unprepare(drvdata->clk);
 		return rc;
 	}
 	/* check if tee fips error occurred during power down */
-- 
2.35.1

