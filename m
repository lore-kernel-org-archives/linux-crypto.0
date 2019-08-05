Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF86C32751
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B10062075B
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ve7cF51U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfHERCf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53826 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbfHERCe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so75470295wmj.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6OhjbF2M4HRdeN0EH1XAkAXt0Z8G30cJBFEK1XTbAV0=;
        b=ve7cF51UDM8GKtpnt3c0ZOMXwuYbMzLdGmkJNZFrwyl8m2/bvpwtP5076qo7fWKvzV
         moI1ez+/fU3iIaRuFnFS84anGgzFD2hxYtgFxMEIcZgcXBnYDDGDOnB54WCen6g2Ezjg
         YG80M/DYx5Di8X8gAPZyrsQ4PWG9uRn8eoXQgAh9CpU/K93MRSuKvBywUL1PKva7SBh5
         639M7HQAWH/4F4Q2ed/94+SBZuhOKIIttFa2EFBRqDjJihpj5/7FGExqXylWyMNugXw2
         1lTsd8wZh+0FWUtkqEIwEO25PbHsfJvIIsCeN6UTXFGduFv/ydTm0yESQvXQ/nn1Mw7O
         YxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6OhjbF2M4HRdeN0EH1XAkAXt0Z8G30cJBFEK1XTbAV0=;
        b=siE6gLzSLv2iKtAmwCicPkhdhlOGzCPcqgqrSO7vArVi5IKccm0x3MkQCz9s1b/3mM
         dAKnwbA0cgF2kFOri+PiJF50qPbMJKJYlQ18I2zJkrZJyGe/HHFtfGNXrzIaA58sAp+o
         IIPT1R/ktRVrV2MvA4zbUi0C65WOKu9qiw5oJpOZgljfipWyFTWcSgSG6CeMfOKWB7JZ
         NfKHSB2Tk9+J58HoVjRj8DD2DN1nbqi6GUo7aj+wRfA6tfwn8gtugtWkZ/mN+MIwfQzz
         69L138DLZ8tIGkKX+USC0bf0E0YCwGTlOAEGfuNBfQ544/e2VTkhEyh3M4vCWXeUAU/d
         WQwQ==
X-Gm-Message-State: APjAAAU9nHhMxfQ0ZAaolNNpkdZf88oUD2uVkfhJIaREvFOtism5JpcA
        uTcFyoOP91QlOakxwyQpAFewYg0U+BtlIw==
X-Google-Smtp-Source: APXvYqyrNusodS6at8McQUF16hI8QSbd0HfG4qr2CWTbQ73UUEfkov64PPP4/CEgHlFtCPmMkWrVCA==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr19962693wma.78.1565024552290;
        Mon, 05 Aug 2019 10:02:32 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:31 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 29/30] crypto: des - remove now unused __des3_ede_setkey()
Date:   Mon,  5 Aug 2019 20:00:36 +0300
Message-Id: <20190805170037.31330-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/des_generic.c | 13 -------------
 include/crypto/des.h |  3 ---
 2 files changed, 16 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index e021a321f584..6e13a4a29ecb 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -51,19 +51,6 @@ static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_decrypt(dctx, dst, src);
 }
 
-int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-		      unsigned int keylen)
-{
-	int err;
-
-	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	des_ekey(expkey, key);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__des3_ede_setkey);
-
 static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2c864a4e6707..7812b4331ae4 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -54,7 +54,4 @@ int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
 int des3_ede_expand_key(struct des3_ede_ctx *ctx, const u8 *key,
 			unsigned int keylen);
 
-extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-			     unsigned int keylen);
-
 #endif /* __CRYPTO_DES_H */
-- 
2.17.1

