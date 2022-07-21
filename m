Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17277C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiGUNoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiGUNnR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:17 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF3282F98
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id p6so1860510ljc.8
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KTtKtpahYRj5RrvQ3U2GaLKtIGWmV90iOPLY5xwmgyQ=;
        b=t7AnqB2RV3V6BS2xjRZKiX3uRPu8cnMe5JDuwFXelSwR/3GatO5Q5VZ7RzajZ2qyQu
         A6ZT6B7I4pbWADQutw3FmF2q0QMcCd6DtMjpoq5ACBMgvjsARtBfUL+m7zn6L2QJgtKH
         7nJxhuJP1vhZ/MNJ8nLgwit364aJXwzIbCAkDITDMlerwI4+2LOBZgJyF6oFtp4ZLpXG
         DNvNnlwqT9p/x6ElGPd+qIDXNR01DYG2CcoQlhSdzaWecLLNd84/eyjZxkp7wmsdy46J
         v3QA+pnoXokBSYgLplf1EsUIBhACMTE+MB8WXeB100kMEJ4utBucXJPhD6EATF5gYBjF
         s7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTtKtpahYRj5RrvQ3U2GaLKtIGWmV90iOPLY5xwmgyQ=;
        b=L7+m8SrF2+eEUjPSxzD5O7XbGHMua/IV/Wks92qaO+lhte6OaJWIJfQjhbJQwcuMy3
         HKLicCGHlbNNwwgiifxj6SulveWN9XeEdwwNIEwc15XYZ2Vge4PoSmF+NNkMJfPV5wsp
         p4nHeRwGHWYUZ8jlpPrPyrXMiXAgHUoifEQkNgjKTDCQlAGSO4c5unckA5XOXPlRH10C
         rtnR12rAAIxeoqNMwFpLjU3Eye5hLTq2SOwZF9bueQGLyCwFBk9kvYwykMnF/EN7+XDY
         GJoWNd/TaYPacx8s0daWssQOr+l0Rf0PSo8X02MGaDW6yWuVWfzL63arLEgui31l1QQi
         p+Bw==
X-Gm-Message-State: AJIora/Tc6GgSupkC8ns4ZrnJoo+ZZa5z23s4HDNneEDRj0LiSCYDvzf
        kUHVddGEiCcOaiLOh32OFarYbrn83JMj/w==
X-Google-Smtp-Source: AGRyM1tyyylXEb8hvr6ScBCQEhjqYd1WYVb1G8WydKAzGjpNztUbbcKBRYpMlMrNlb6DqquPbu90fA==
X-Received: by 2002:a2e:8954:0:b0:25d:6936:849a with SMTP id b20-20020a2e8954000000b0025d6936849amr19723517ljk.370.1658410980632;
        Thu, 21 Jul 2022 06:43:00 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:00 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/15] crypto: ux500/hash: Pass context to zero message digest
Date:   Thu, 21 Jul 2022 15:40:38 +0200
Message-Id: <20220721134050.1047866-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function obtains the current context from the device state
pointer, which is fragile. Pass the context explicitly instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index fd7a862244ac..884046e87262 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -183,11 +183,10 @@ static int hash_dma_write(struct hash_ctx *ctx,
  * @zero_digest:	True if zero_digest returned.
  */
 static int get_empty_message_digest(
-		struct hash_device_data *device_data,
+		struct hash_device_data *device_data, struct hash_ctx *ctx,
 		u8 *zero_hash, u32 *zero_hash_size, bool *zero_digest)
 {
 	int ret = 0;
-	struct hash_ctx *ctx = device_data->current_ctx;
 	*zero_digest = false;
 
 	/**
@@ -889,7 +888,7 @@ static int hash_hw_final(struct ahash_request *req)
 		 * Use a pre-calculated empty message digest
 		 * (workaround since hw return zeroes, hw bug!?)
 		 */
-		ret = get_empty_message_digest(device_data, &zero_hash[0],
+		ret = get_empty_message_digest(device_data, ctx, &zero_hash[0],
 				&zero_hash_size, &zero_digest);
 		if (!ret && likely(zero_hash_size == ctx->digestsize) &&
 		    zero_digest) {
-- 
2.36.1

