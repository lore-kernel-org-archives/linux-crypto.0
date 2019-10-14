Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D94FECE58E
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 387682084B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nZpjXYJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbfJNMTw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:19:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38980 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730052AbfJNMTw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:19:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so19483324wrj.6
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lIZcqfC0xhMTbTw2eMsrTKpkwPVrbw6wba0eQebSEA0=;
        b=nZpjXYJnxtwxCKRKWxEQ0A/+tBRKo8pczz3RbQtTpz9oqHH8t36+Nnfu8MxBxi49BE
         98lTuISguCQ80IBNglY4jCojSjc1lnY1ziCEJDXEZCRc666Id0e7tKid0t2aXL3xCaYH
         mdb66mauI690hAoJ5hwoSQWMx7iOwk49iHDqhkG8kR24QnCsFEvvv2jAREA9/S1vrO5O
         o11qLRpnfyGPhRcB+OU1sYfhN54glqhQy8orOcqsc6iOukW8nn59KQFTd6CgSRzie0EB
         2f6k1P/K4PUrB1Q5n+GvkeldX3avoUUb5Jc27ty+SMdhgHqW/W43IBXscYxxFyYYEiMM
         p2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIZcqfC0xhMTbTw2eMsrTKpkwPVrbw6wba0eQebSEA0=;
        b=V7dB3TWwfEokdDWr93nc51zWXKSkX/n5sOPqOQVkqWMtLrQhwmolJJ7LUL5zuvaUEa
         7zAWP5CVULIkYMCpRa/gXwfDbLEahsnd/tbC7r0RfKCTcL7f9HfdqISwvN13YqYSNEpm
         L8xxmG9RGOR1c2QE/CDhWd9ItvTROcUyJyv8PGou7l+lzF5mys86jEo42tp+WOrnjHqy
         IicxxgA9sRkN4UqKaeGBeF0Z6gkFDPedFY2maxUFlOyqUcXO44psuJ5AGuvBZF1LoixT
         QLH2jkEGFs9kwFCYK9d8h0udmGjTzQl//sfJDFy8IJM6VxC4LAXd4zPm3PCvSCYxFBl9
         Fjkg==
X-Gm-Message-State: APjAAAULOZtJqdlAyD30DSnstjl2cDQAJl6RcXk81D9JoQ0yUw1pRB06
        dqLFzUlze0lF0D0Jz5nQ713uC4tPvhpK8w==
X-Google-Smtp-Source: APXvYqzGV4X4qEN65JI0UtuXky4UjVLQKcb/mtgrnjRV07EgNyRzR2OjAopWZAtnlkgMNXYXrPaoTQ==
X-Received: by 2002:a5d:5444:: with SMTP id w4mr9302645wrv.18.1571055590020;
        Mon, 14 Oct 2019 05:19:50 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:19:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/25] crypto: nitrox - remove cra_type reference to ablkcipher
Date:   Mon, 14 Oct 2019 14:18:56 +0200
Message-Id: <20191014121910.7264-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Setting the cra_type field is not necessary for skciphers, and ablkcipher
will be removed, so drop the assignment from the nitrox driver.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index ec3aaadc6fd7..97af4d50d003 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -493,7 +493,6 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
-		.cra_type = &crypto_ablkcipher_type,
 		.cra_module = THIS_MODULE,
 	},
 	.min_keysize = AES_MIN_KEY_SIZE,
-- 
2.20.1

