Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF9BC4708D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Dec 2022 23:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiL0XEh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiL0XEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2022 18:04:12 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3EFDF7A
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:05 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u12so11352499ljj.11
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omVnieNGh1C2BQOqxL85pqNlOA8iwg1l4f9DGmSm+F0=;
        b=NpMquUy6XSCZlHF1B5JCxa1+IGZudC6z51dvvZyQWfgok2tgu+eONhBG59X2PafkeI
         K9nO5jMavETPIF67WKoPGuL+6WIhuWKFd2rOVSYXTXR6Wv7Uja617HpHDc5mv+N9zoDL
         srouCvYvhXyeEu3rHCBmx06/6txqAAy91FnspCCNRW9i+eDikpjySd3WFHrq0JtXSZOJ
         i8w/9xkbSxT0NTgOVQhxKKflSjTrfXlRr7ACVrurfcYE37o0ru88N2jBCtFB1kOjk/eo
         Kxb2cwoZndwWQMzjmEgg496wJ5IUAzr6ebbFKTYj5D7UboN1N5tD09vVUjCIEXVw2/WR
         xB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omVnieNGh1C2BQOqxL85pqNlOA8iwg1l4f9DGmSm+F0=;
        b=Dy93sXr4ZhaxzsC9c+00aibTLFqQbpBoiz9IJgV0m0+hR7EcLE4e0LBQ3VCzf3wJT3
         LHUbyKuE7kRz9wT68XNwKKFtOL5gwpUBAh007cRrwDFMUY5o5+665G8kPl9vpNawL2Be
         LFiNjawX8ZJO6IaKj4VXUYdrTDKtTzVnz5A1tDPvSMYJia9QtSJAuI2R/hpkAKIAj4bZ
         /yvbFdaKIHINs0LITRyVR05TOPsmI30MMkXG2K236+LpEa7DmKaDa+cZJcTO89EmK9M1
         avTsuPpAKqdI31c+BZcPs11WvZ6It99ylLu6O+vTxbTAgUYS11Rzoc+CLXpFxFFiRGgd
         NGuw==
X-Gm-Message-State: AFqh2kq97XzrD8m6q2TxjrHl+kv05Meu3KmEWS0Z/h1Xz5C0a0QGvR8G
        XHNnWYSzP5LLX4/aHWMFu+USjg==
X-Google-Smtp-Source: AMrXdXs6RKKLQeK7L+Utv1AckslGJBa9ecdEOR5vI3IypBndmXbMZ3kAyf/SE1bdQMkdDmv+mh+DiQ==
X-Received: by 2002:a05:651c:1992:b0:27f:b2cf:85a0 with SMTP id bx18-20020a05651c199200b0027fb2cf85a0mr4532982ljb.43.1672182244053;
        Tue, 27 Dec 2022 15:04:04 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id bg25-20020a05651c0b9900b0027fbd4ee003sm876925ljb.124.2022.12.27.15.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:03:57 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 28 Dec 2022 00:03:35 +0100
Subject: [PATCH 3/7] crypto: stm32/hash: Use existing busy poll function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v1-3-b637ac4cda01@linaro.org>
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

When exporting state we are waiting indefinitely in the same
was as the ordinary stm32_hash_wait_busy() poll-for-completion
function but without a timeout, which means we could hang in
an eternal loop. Fix this by waiting for completion like the
rest of the code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/stm32/stm32-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 0473ced7b4ea..cc0a4e413a82 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -960,11 +960,13 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	u32 *preg;
 	unsigned int i;
+	int ret;
 
 	pm_runtime_get_sync(hdev->dev);
 
-	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
-		cpu_relax();
+	ret = stm32_hash_wait_busy(hdev);
+	if (ret)
+		return ret;
 
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),

-- 
2.38.1
