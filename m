Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987FFC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6A464F8D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhBCOfh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbhBCOes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:34:48 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B96C061351
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:17 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id e11so30628qtg.6
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KjZ2FfLW1/QZmo1tCtVZh16jkU5d2sBI2rN7J1hvIYw=;
        b=qAx/D5BiFOnHn97BwkyayC1pEdlp7lg77Shm0+zyftyMKEovfrABt1m7MxpP79jjje
         KPXkPgBjt/8U0iwg8lE/T2xE+Dg8QuAhVg/y4pkK0tCUVLamzZLRd578KdhzBlr2Pr4C
         puSlgFZfFMwbRyCF1ztVHI3blsfqH458We9sol4zp2Pca+ijbrZnCwHk8+aFJU/F5P2p
         TnJ2MDQ46kEpZdpwD/w+1a1uQ5gvXNE8GYISkqXswP7YbMJ2PW4jfj8dvV1mU4UyjyDb
         GlqLh0AK8LZpLGV+at6AesnQWxLCw1ZQRZRlpkRdZ3w7JigOo01gOLhl8IXEgyPm6uTC
         1cWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KjZ2FfLW1/QZmo1tCtVZh16jkU5d2sBI2rN7J1hvIYw=;
        b=l8tsmZLBYjUQSr8XkLkY9BYtz7uYs7bySlKA9gLncfgaydWmBn5XV424I9tNlfqlEE
         tKjYTClZV0UC7rlkpqJ5DGfchBlRPAqNQxQ0lYIpoRcdkHTUV1h05RBZNlCVHvBq8hdk
         qjUKmwxcF/t5hrWPbWofHt2TesVMr2xRKcsV6XS3xIM2wu1lp0ABz+l+iCoI7k4B1Rsk
         SzIOGP1gnLMp8RQkitBfQGjuAq6ysfV9P9Sm37z6yR9m9aJPnqV40QxK585/RqRkwALb
         yXEAQ15I6YC/hlqaA+ZYeX1+kRsEhozvZXK/3GeXDRSxRj2xUqIVjt+NFxyLJcuUEzT3
         CtGg==
X-Gm-Message-State: AOAM531tGku2ebpKXk/5NjXCvC6DBsvU/YBWaWdMEfAnbmpoBVKUZ7cK
        VgJvOqR+VPzhMUbRw3/ea0KG4Q==
X-Google-Smtp-Source: ABdhPJyGTyzCp2GcprImfbxOpOGqHMbDBWnrcqGGWqNA2JyY99Gwid+Drcm45EP97wXKbPmXMgvkIA==
X-Received: by 2002:ac8:5ac9:: with SMTP id d9mr2534250qtd.123.1612362796444;
        Wed, 03 Feb 2021 06:33:16 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:15 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/11] crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
Date:   Wed,  3 Feb 2021 09:33:03 -0500
Message-Id: <20210203143307.1351563-8-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB transformations do not have an IV and hence set the ivsize to 0 for
ecb(aes).

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 28bea9584c33..10e85b1fc0fd 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -356,7 +356,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 	},
-- 
2.25.1

