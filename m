Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E17C64EC4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Mar 2023 09:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCDJhi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Mar 2023 04:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCDJhc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Mar 2023 04:37:32 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99C613D6E;
        Sat,  4 Mar 2023 01:37:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pYOKJ-000GZ9-VW; Sat, 04 Mar 2023 17:37:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Mar 2023 17:37:15 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sat, 04 Mar 2023 17:37:15 +0800
Subject: [v5 PATCH 4/7] crypto: stm32 - Remove unused hdev->err field
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Message-Id: <E1pYOKJ-000GZ9-VW@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The variable hdev->err is never read so it can be removed.

Also remove a spurious inclusion of linux/crypto.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-hash.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 473809b26566..d7c99c09debe 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
@@ -183,7 +182,6 @@ struct stm32_hash_dev {
 	struct ahash_request	*req;
 	struct crypto_engine	*engine;
 
-	int			err;
 	unsigned long		flags;
 
 	struct dma_chan		*dma_lch;
@@ -894,7 +892,6 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 		stm32_hash_write(hdev, HASH_STR, 0);
 		stm32_hash_write(hdev, HASH_DIN, 0);
 		stm32_hash_write(hdev, HASH_IMR, 0);
-		hdev->err = 0;
 	}
 
 	return 0;
