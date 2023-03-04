Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E38C64EC4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Mar 2023 09:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjCDJh3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Mar 2023 04:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDJh3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Mar 2023 04:37:29 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E4B477;
        Sat,  4 Mar 2023 01:37:27 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pYOKD-000GYe-HX; Sat, 04 Mar 2023 17:37:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Mar 2023 17:37:09 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sat, 04 Mar 2023 17:37:09 +0800
Subject: [v5 PATCH 1/7] crypto: stm32 - Save 54 CSR registers
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Message-Id: <E1pYOKD-000GYe-HX@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CSR registers go from 0 to 53.  So the number of registers
should be 54.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 7bf805563ac2..bde2b40a6a32 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -68,7 +68,7 @@
 #define HASH_MASK_DATA_INPUT		BIT(1)
 
 /* Context swap register */
-#define HASH_CSR_REGISTER_NUMBER	53
+#define HASH_CSR_REGISTER_NUMBER	54
 
 /* Status Flags */
 #define HASH_SR_DATA_INPUT_READY	BIT(0)
