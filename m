Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3B5C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 14:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E71205F4
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 14:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DeUw93E3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfHPOGg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:06:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40667 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfHPOGg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 10:06:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so1665781wrd.7
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=FDmnpjEbDvIvEVLNq8R7T0AYfQ4p5jgV5DbMjGWZEWg=;
        b=DeUw93E3HJ0D037HC4xGonLxRTV/6nyj1dVW94whegeI0gf/K5qH9GABzkUDkDVZN+
         WTLbHlHTK0y88Wj4BmhZ5VDDzNzMnVo4ltmNvdMmST7lfJjggn4qF8wsVo65ArPg51Bv
         uYKq03pUe8c+uWHG2JN5/zBvuxzWw4yrYY5n5eINw7q9F/ygy8FGHeiZY5DjEJONitCP
         dRBA+eBaVwvQYsLTfixFhL4vYRZnuzwrgRs1dzNzIzo6s9aPWMdp3UdP1/VJCjZAQAbQ
         uzwxjFhRp+wySx257SX66O0HD3+ZifJ6oiJrubsnuG/aLd6qCwvQZJ0Tu+s3sJCtoqCz
         LQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FDmnpjEbDvIvEVLNq8R7T0AYfQ4p5jgV5DbMjGWZEWg=;
        b=dUMmPwMWAW2Gaq6bkgQ63EIXfgnVbhBtJgXie1S/yyjpk++31aAdCUQx+xPGcog5Eq
         pdwmXP+g7rFN2jUBpzAxppGaiZ9OaUb3q9z/yujGWt7sCH7z5fStOZ7LuS16YZTRFMeL
         y195R28GjK+GH4LvudfJu4GYlaKoeamlEsDCDLhp+WxPb5ohyj3LPPLe0aCnkc4nefKV
         uaOnIv0NwlIXhUxocrGaWCIbVGxyBnswdb+IivF1ElomdbRxKpy3hF7QMYOYU+fpMu/v
         BsCPIq9Z8e4AEJ1a0MtW2tTefOeMGkNZeetskQxvlk51qVJXxMH56klZy6pwfjM8k29N
         ScFQ==
X-Gm-Message-State: APjAAAXf6zrksuan84VUpYQX70+Z7St8PDIDzvfR/o8/Ch9PPqnxvhzE
        Gf7GyW6wW9rLOQC/GXsCrFCdU1DyKVko3cT5
X-Google-Smtp-Source: APXvYqwjlT2fObW89eSEj/9Rqi4lP6b9Xwub7KTaPTtCrYXtLZl5qAA61xrBg3XaNc1JyjC9Se/4cA==
X-Received: by 2002:adf:ecc3:: with SMTP id s3mr11573963wro.302.1565964394407;
        Fri, 16 Aug 2019 07:06:34 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id i5sm5465389wrn.48.2019.08.16.07.06.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:06:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linuxppc-dev@lists.ozlabs.org, leitao@debian.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: vmx/xts - use fallback for ciphertext stealing
Date:   Fri, 16 Aug 2019 17:06:24 +0300
Message-Id: <20190816140625.27053-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For correctness and compliance with the XTS-AES specification, we are
adding support for ciphertext stealing to XTS implementations, even
though no use cases are known that will be enabled by this.

Since the Power8 implementation already has a fallback skcipher standby
for other purposes, let's use it for this purpose as well. If ciphertext
stealing use cases ever become a bottleneck, we can always revisit this.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/vmx/aes_xts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 49f7258045fa..d59e736882f6 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -84,7 +84,7 @@ static int p8_aes_xts_crypt(struct skcipher_request *req, int enc)
 	u8 tweak[AES_BLOCK_SIZE];
 	int ret;
 
-	if (!crypto_simd_usable()) {
+	if (!crypto_simd_usable() || (req->cryptlen % XTS_BLOCK_SIZE) != 0) {
 		struct skcipher_request *subreq = skcipher_request_ctx(req);
 
 		*subreq = *req;
-- 
2.17.1

