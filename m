Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D2DC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E49A21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y4AyQA13"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfGBTmu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37963 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGBTmt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:49 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so18181790ljg.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=II4IaI2l8ysBnoBGFcY14xsKlW45HqjpdlGpUkQ7rBQ=;
        b=Y4AyQA13rcUlRIXMIl6Mk3NNAkJq4EQnuk82FBjoq/Qv+Zwd6RhPeTxLusCR8WustC
         r1+2xoT5ECWF5WuYISoiLeM5jQWSXe//Swi827ZKtsu0IFTo4xkstqpFoTQEjgoQB+rS
         t+pYWKzVpFB3TNV6s6VKBeLJZE9cKibesYLscNDUbJ/dsusDr/ZWmIY7n3cUy47hDSr7
         0gHhD3GM6YZqhE7e2G0NkSuENaFunDkqJpWKM2ndKGoyfcEv4deJYy04KjAtp6GACG/U
         H0/KIEKUScE3ovwYMDBIQme49SbhUYvyMKsC4iDjmujVPtagpRgMFM+lfsDxmNu9aHrk
         QEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=II4IaI2l8ysBnoBGFcY14xsKlW45HqjpdlGpUkQ7rBQ=;
        b=elXG9DY4wVFFmQZHbepx6/e4fwz5BbtOygLi7EiPBVQVI+raEUr0Zuk4Lv2k0xVRMQ
         /mJXVRqXKR7J99ffRVz748mgOFnEM/htqi4lroKPn16ah+3b4PJ3MuwaDXk7lwPmNsnz
         xpzQxGcrkOgtCkYR1TKAX+YMpvadW7sp6c+qzSEsQkKvaBQ4/GZKOXhfA3URjfOTdLe0
         68wjXi2h65zLijCm4R1oJJNvy+qn7DwS0t6QYCmT+x8kw1l1XGajiIIQrHBXGVNgcISM
         oeLblpOL0ppQy2wjAhaQvr+toxSrjvNyLuPYiWYVLP3cMlOgEuM7dhuhu9nF4z6uRIVw
         Hp6g==
X-Gm-Message-State: APjAAAUx5H7AsxLyMrzh0H7b2iJWGl3V2+YwPSsJp9vEQaw4QsOkwVBg
        YggTCKo0ES3TrJZ7QYiGIQ8fFmRYq6qVU86b
X-Google-Smtp-Source: APXvYqyfsXdG3kw1MeKROcnru8SJ9LxM79cAX+I2lzPJogDaoJYgF4jwr38WtymU2cCodpxLAIc5OA==
X-Received: by 2002:a2e:b1c1:: with SMTP id e1mr18245038lja.228.1562096567433;
        Tue, 02 Jul 2019 12:42:47 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 28/32] crypto: lib/aes - export sbox and inverse sbox
Date:   Tue,  2 Jul 2019 21:41:46 +0200
Message-Id: <20190702194150.10405-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are a few copies of the AES S-boxes floating around, so export
the ones from the AES library so that we can reuse them in other
modules.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/aes.h | 3 +++
 lib/crypto/aes.c     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index df8426fd8051..8e0f4cf948e5 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -67,4 +67,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
  */
 void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 
+extern const u8 crypto_aes_sbox[];
+extern const u8 crypto_aes_inv_sbox[];
+
 #endif
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 9928b23e0a8a..4e100af38c51 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -82,6 +82,12 @@ static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
 	0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
 };
 
+extern const u8 crypto_aes_sbox[256] __alias(aes_sbox);
+extern const u8 crypto_aes_inv_sbox[256] __alias(aes_inv_sbox);
+
+EXPORT_SYMBOL(crypto_aes_sbox);
+EXPORT_SYMBOL(crypto_aes_inv_sbox);
+
 static u32 mul_by_x(u32 w)
 {
 	u32 x = w & 0x7f7f7f7f;
-- 
2.17.1

