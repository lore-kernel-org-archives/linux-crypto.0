Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8160CC636D7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 05:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjBWFT1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 00:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjBWFTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 00:19:18 -0500
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBDA47432;
        Wed, 22 Feb 2023 21:19:05 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 5896C1A00A14;
        Thu, 23 Feb 2023 13:19:44 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yXrtiH0GntNQ; Thu, 23 Feb 2023 13:19:40 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 10B9E1A0092F;
        Thu, 23 Feb 2023 13:19:40 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] stm32: stm32-hash: Add kmalloc_array allocation check
Date:   Sat, 25 Feb 2023 05:50:19 +0800
Message-Id: <20230224215019.3687-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If rctx->hw_context allocation of the context pointer failed. Returning
-ENOMEM and assigning NULL to the out pointer should improve the
robustness of the function.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/crypto/stm32/stm32-hash.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f76..18e79f62be96 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -970,6 +970,10 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),
 					 GFP_KERNEL);
+	if (rctx->hw_context == NULL) {
+		out = NULL;
+		return -ENOMEM;
+	}
 
 	preg = rctx->hw_context;
 
-- 
2.18.2

