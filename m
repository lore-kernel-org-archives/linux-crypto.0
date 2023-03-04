Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A41C64EC4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Mar 2023 09:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCDJhr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Mar 2023 04:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCDJhi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Mar 2023 04:37:38 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B48823303;
        Sat,  4 Mar 2023 01:37:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pYOKO-000GZd-4n; Sat, 04 Mar 2023 17:37:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Mar 2023 17:37:20 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sat, 04 Mar 2023 17:37:20 +0800
Subject: [v5 PATCH 6/7] crypto: stm32 - Remove unused HASH_FLAGS_ERRORS
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Message-Id: <E1pYOKO-000GZd-4n@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The bit HASH_FLAGS_ERRORS was never used.  Remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-hash.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 7cdde961b626..fd9189472235 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -95,7 +95,6 @@
 #define HASH_FLAGS_SHA1			BIT(19)
 #define HASH_FLAGS_SHA224		BIT(20)
 #define HASH_FLAGS_SHA256		BIT(21)
-#define HASH_FLAGS_ERRORS		BIT(22)
 #define HASH_FLAGS_HMAC			BIT(23)
 
 #define HASH_OP_UPDATE			1
@@ -870,7 +869,6 @@ static int stm32_hash_finish(struct ahash_request *req)
 static void stm32_hash_finish_req(struct ahash_request *req, int err)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct stm32_hash_state *state = &rctx->state;
 	struct stm32_hash_dev *hdev = rctx->hdev;
 
 	if (!err && (HASH_FLAGS_FINAL & hdev->flags)) {
@@ -881,8 +879,6 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 				 HASH_FLAGS_OUTPUT_READY | HASH_FLAGS_HMAC |
 				 HASH_FLAGS_HMAC_INIT | HASH_FLAGS_HMAC_FINAL |
 				 HASH_FLAGS_HMAC_KEY);
-	} else {
-		state->flags |= HASH_FLAGS_ERRORS;
 	}
 
 	pm_runtime_mark_last_busy(hdev->dev);
