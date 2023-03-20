Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E29C6FD1D
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Mar 2023 00:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCUAVC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Mar 2023 20:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUAVB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2023 20:21:01 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Mar 2023 17:20:59 PDT
Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7D7F23C4E
        for <linux-crypto@vger.kernel.org>; Mon, 20 Mar 2023 17:20:59 -0700 (PDT)
Received: from localhost.localdomain ([78.31.41.93])
        by smtp.orange.fr with ESMTPA
        id ePCEpUM95Kb31ePCGpjTnR; Tue, 21 Mar 2023 00:45:54 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 21 Mar 2023 00:45:54 +0100
X-ME-IP: 78.31.41.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: caam: Clear some memory in instantiate_rng()
Date:   Tue, 21 Mar 2023 00:45:43 +0100
Message-Id: <16d6bf3bd7a6e96a8262fcd4680e3ccbb5a50478.1679355849.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to the comment at the end of the 'for' loop just a few lines
below, it looks needed to clear 'desc'.

So it should also be cleared for the first iteration.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative, but can't hurt.

Maybe the memset() at the end of the 'for' loop could be removed instead.
---
 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 32253a064d0f..e4e971dc0f96 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -276,7 +276,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	int ret = 0, sh_idx;
 
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
+	desc = kzalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.32.0

