Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEF3C28B2B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiHPODZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiHPODW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:22 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BA711C0E
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:14 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x9so10604201ljj.13
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=BucOQJ+RxRyfe7V8KdF0CMOvkh9OJz+op1Vzn2l8TaI=;
        b=plyvCoCTKbp1iyvBxIByGkPq5XPf5JjPoxHi4wrLtRK9PYzCxxnnWnuiEYPDqnEqvv
         Dp0cYFrLBM+gWuIyw+guAFcS5oovVqhvX9et6tiXlbta5Y7LQVHeSdmsJQzFZKPXb3PJ
         VklCXn+d/8KNkOvxQF3+kw++eTm/j0qZ3QROQtPUFutRb4f9Ly6Q8BTCs8DNU/X0e4rH
         peUrEjGD7NgWHYU8OZ0S7LRGrpKoehVlLOtpX9cBKJqBKb4LZG91lX0tRbP7gNwSIfGP
         yGfMY+4D4IdOy1CBdlSUhdlaysr7Zx04JMWfYd2Tvd9ev0QfmGl2KnCoaGPHV9pcs0R3
         7GiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BucOQJ+RxRyfe7V8KdF0CMOvkh9OJz+op1Vzn2l8TaI=;
        b=KDgbTqzg4iaqkpmf+8r/hOERRu2LAQ3ejxItVlzZpOJfUMZd4C3/3vTsknyy/3Vl1M
         1on3QnaxgC4I4x23th0oTb4Kjv5yhYQjtuoOqTaUViMV+APGYVCn/t0f591AhdWuHjnd
         0pTgO7gPmsG0FMKQ13qX7Oymg5skMjcTW8duP9rYQbuSxhMq7VSByoAJNLxJkcdjZAlS
         sNkkdXOh5zvk7YYnpWIXb+kq5pCQkUkJsQeTQ4Oo0NlmxnrbxeZGWgSlImROwJTEhVDu
         DH9UVcbn8Gvd+vuzAkJd7rL5DmnaA1AApbsSxEbb+tIvyE+STSIyQvR4UB9AfD4beoPx
         f5Kg==
X-Gm-Message-State: ACgBeo2gJDCK8Wswwdmt5tCu2rGgd7MM6tOyOIGgXjRXfs/GIyhahNVA
        OSUYaxPh6Xoosde4FqeJVA5XYhf2zN/DWg==
X-Google-Smtp-Source: AA6agR5tsORCszE2ajIvLeglxtR4bch+K6I9q91kE3TfHjvCaAQWfaaMQc27gfzJsxkmkPUHoWMbcw==
X-Received: by 2002:a2e:9dd0:0:b0:261:71bc:d3ef with SMTP id x16-20020a2e9dd0000000b0026171bcd3efmr6635246ljj.190.1660658592664;
        Tue, 16 Aug 2022 07:03:12 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:12 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 01/16] crypto: ux500/hash: Pass ctx to hash_setconfiguration()
Date:   Tue, 16 Aug 2022 16:00:34 +0200
Message-Id: <20220816140049.102306-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function was dereferencing device_data->current_ctx
to get the context. This is not a good idea, the device_data
is serialized with an awkward semaphore construction and
fragile.

Also fix a checkpatch warning about putting compared constants
to the right in an expression.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_alg.h  |  2 +-
 drivers/crypto/ux500/hash/hash_core.c | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 7c9bcc15125f..26e8b7949d7c 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -380,7 +380,7 @@ struct hash_device_data {
 int hash_check_hw(struct hash_device_data *device_data);
 
 int hash_setconfiguration(struct hash_device_data *device_data,
-		struct hash_config *config);
+			  struct hash_ctx *ctx);
 
 void hash_begin(struct hash_device_data *device_data, struct hash_ctx *ctx);
 
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index f104e8a43036..1662e176de44 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -473,7 +473,7 @@ static int init_hash_hw(struct hash_device_data *device_data,
 {
 	int ret = 0;
 
-	ret = hash_setconfiguration(device_data, &ctx->config);
+	ret = hash_setconfiguration(device_data, ctx);
 	if (ret) {
 		dev_err(device_data->dev, "%s: hash_setconfiguration() failed!\n",
 			__func__);
@@ -672,11 +672,12 @@ static void hash_incrementlength(struct hash_req_ctx *ctx, u32 incr)
  * hash_setconfiguration - Sets the required configuration for the hash
  *                         hardware.
  * @device_data:	Structure for the hash device.
- * @config:		Pointer to a configuration structure.
+ * @ctx:		Current context
  */
 int hash_setconfiguration(struct hash_device_data *device_data,
-			  struct hash_config *config)
+			  struct hash_ctx *ctx)
 {
+	struct hash_config *config = &ctx->config;
 	int ret = 0;
 
 	if (config->algorithm != HASH_ALGO_SHA1 &&
@@ -711,12 +712,12 @@ int hash_setconfiguration(struct hash_device_data *device_data,
 	 * MODE bit. This bit selects between HASH or HMAC mode for the
 	 * selected algorithm. 0b0 = HASH and 0b1 = HMAC.
 	 */
-	if (HASH_OPER_MODE_HASH == config->oper_mode)
+	if (config->oper_mode == HASH_OPER_MODE_HASH) {
 		HASH_CLEAR_BITS(&device_data->base->cr,
 				HASH_CR_MODE_MASK);
-	else if (HASH_OPER_MODE_HMAC == config->oper_mode) {
+	} else if (config->oper_mode == HASH_OPER_MODE_HMAC) {
 		HASH_SET_BITS(&device_data->base->cr, HASH_CR_MODE_MASK);
-		if (device_data->current_ctx->keylen > HASH_BLOCK_SIZE) {
+		if (ctx->keylen > HASH_BLOCK_SIZE) {
 			/* Truncate key to blocksize */
 			dev_dbg(device_data->dev, "%s: LKEY set\n", __func__);
 			HASH_SET_BITS(&device_data->base->cr,
@@ -878,7 +879,7 @@ static int hash_dma_final(struct ahash_request *req)
 			goto out;
 		}
 	} else {
-		ret = hash_setconfiguration(device_data, &ctx->config);
+		ret = hash_setconfiguration(device_data, ctx);
 		if (ret) {
 			dev_err(device_data->dev,
 				"%s: hash_setconfiguration() failed!\n",
-- 
2.37.2

