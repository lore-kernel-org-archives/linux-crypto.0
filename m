Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF09CCA48B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiGUNoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiGUNnW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:22 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610C83F26
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t1so2842517lft.8
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pmSASrhJHn6ivFdlVEJYXb7R4srgTjTFkdflVpjygv8=;
        b=IdFYhGuUDDZtzDwEay5CBmdNBTQm0pTARSgLybdSal4/UR7uz4/ls4vEupVLwS5ZMS
         wJIZIZaxIwDThGwx21tAtohhZoXkccszD+nED/NGp+Vp1u1HOU32FzT1udkepuxGsRFH
         huubjJDVVIYC3hizzYjeJ24clq80YQWecxgeadDabHBddkuXoT6Veibu8zU2aWYn+w38
         L4zBYSxMs3fHJlhnYl+fqsGcDtDVwflBpZ3RNPQN8US7ErTT6ChuQcD1XiOiFUUD7QvD
         IfGCJJISou1GTkA7VmMuQomGadNAxKDhaELBm8SCYzYVN2ZH/q4/SWc/Zpi4mXV/c0b1
         npkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pmSASrhJHn6ivFdlVEJYXb7R4srgTjTFkdflVpjygv8=;
        b=O/NXcPqOUIJsT74buLmgjuBOSdKT/+QzHeHXNqWQMiCgEH2igP4ViOHKPtvuhHa7mi
         3Q3Ynnrog6HgYh8kzowv/vGYB2tNdfPtAf+oUT08LTjlRhqGhbLbsuei5IljGW6qyraC
         p1tdgc/VvvJD1f1hKPOpHz5gNxQ5x3WBVe5KglITEnkAvqT35Pg5wwUFm9g+YUkCQ+PM
         n3lWPv0sAc0W7xljCvqFWBqyC4EqUjlzX88n/HiPgV0704giTqLNvaw9W5tbrH//SPEJ
         Lo+0WqM6jgFC/1BrjCbAU5X8EL4fOVKBwNSJGbkFczGpPqmiPb2jkuyV7IbUI4W4EzQQ
         64oA==
X-Gm-Message-State: AJIora/LJDzqcHZX+n10XDw0oELIQZSj1bAZe8+Q/BCZ6uZnAvFLAn8q
        T72LVSjv6suJl0ryAs0hCeXXGQs+xlGTrA==
X-Google-Smtp-Source: AGRyM1sFV4rNCGoH1/mlb2Jg+Y6/gMWTCs6jaIazqSvm5Af7YyfWmAGFiUE0aQb3Pao0wQr5rfEgvg==
X-Received: by 2002:a05:6512:3d11:b0:489:d28c:10d9 with SMTP id d17-20020a0565123d1100b00489d28c10d9mr21653956lfv.467.1658410977675;
        Thu, 21 Jul 2022 06:42:57 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/15] crypto: ux500/hash: Pass ctx to hash_setconfiguration()
Date:   Thu, 21 Jul 2022 15:40:36 +0200
Message-Id: <20220721134050.1047866-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
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
index 265ef3e96fdd..dfdf3e35d94f 100644
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
2.36.1

