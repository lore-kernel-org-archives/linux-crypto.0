Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFA4C10F1B
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Dec 2022 23:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiL0XEg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiL0XEC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2022 18:04:02 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2C1DF88
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:03:56 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id bn6so5165615ljb.13
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2N7NNifAQ86WoZ7rTUxWJfmzgVYj68lx1CkkjLHfuc=;
        b=oKTHfe5WpDJ+0S0x9Q64mivXn6gj2tUZMKKd+8RnEujrrZl0qNLXkvCbulXJooqt04
         EoqpfufbUrXy9fHKA/OlX/D7kQNF3+6GgR5OXGr5Gkp61L/j4g6Pb6bS64LBj7/OVVX0
         42UnDcK2eAj9hkH+31lKbADQ5LIwKAK6CiSzZkIrvYw9oUvs5icpP537v50zIj435cCu
         B0TADlrv2/+zvFxwe8Y8/mmkevlhPAIZ0zCY+4W2dKqmmFRJD8SXZyQMXRUdrRXq2KZR
         nYV7FVyieFgWYBAHV4DIim/oxTMFmGRoFTXhYm2Aab//s3485UxwOZ0URpjJj6ppgvJu
         AkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2N7NNifAQ86WoZ7rTUxWJfmzgVYj68lx1CkkjLHfuc=;
        b=woD84F+kpSIa1LFY1LJZbo4/XcgtwnAUxTy/5N9yVozbW6BsnUJ1ZP8ZnMzUAgALsu
         Rzk8fwZgUdvAwssEaI1ZSV2Ojw9s/PZNRsEAK48c1j2HtYbwiJ0mXWvYP94BfhbU+Qrs
         HTh3uzbFNePBpLVqStd/Le8FZ6YCcDJ0P9l+fRY7GeSEuj1E4QeRD4rUkBYpDOKJT0ah
         H/hHsp88w+qlLGA5AEuR3PLVIchHqCXB+TuJKFuu3CzlV59WBaHMar8rt52pdMZG2pv9
         cJVqS2k3/K02aS7SOsnDi96ALcGu7uQPNBLQdBKeefbp29AOkMg4ZNuQeZ0rzS247QIk
         GD7g==
X-Gm-Message-State: AFqh2krai9Ycq5i+4lKxV1QnMqmQ4CFbkEYSGyhllVQ+n5JXqqh8Mxx5
        s8B0ywk9LOwVMxPV9G0+qbtWRA==
X-Google-Smtp-Source: AMrXdXvrQu86e9KN1tewvOMgrDxWfgLXTRrdS3k1l5PdDsuMATBoNzZFvn6HMaqHHB4dG5xK1SAnpA==
X-Received: by 2002:a2e:954f:0:b0:27f:c258:b24a with SMTP id t15-20020a2e954f000000b0027fc258b24amr1866334ljh.11.1672182235821;
        Tue, 27 Dec 2022 15:03:55 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id bg25-20020a05651c0b9900b0027fbd4ee003sm876925ljb.124.2022.12.27.15.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:03:49 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 28 Dec 2022 00:03:34 +0100
Subject: [PATCH 2/7] crypto: stm32/hash: Simplify code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v1-2-b637ac4cda01@linaro.org>
References: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We are passing (rctx->flags & HASH_FLAGS_FINUP) as indicator
for the final request but we already know this to be true since
we are in the (final) arm of an if-statement set from the same
flag. Just open-code it as true.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/stm32/stm32-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f76..0473ced7b4ea 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -399,8 +399,7 @@ static int stm32_hash_update_cpu(struct stm32_hash_dev *hdev)
 	if (final) {
 		bufcnt = rctx->bufcnt;
 		rctx->bufcnt = 0;
-		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt,
-					  (rctx->flags & HASH_FLAGS_FINUP));
+		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt, 1);
 	}
 
 	return err;

-- 
2.38.1
