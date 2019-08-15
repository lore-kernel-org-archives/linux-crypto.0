Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73749C32757
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A656218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L6O8XAd5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfHOJCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40089 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730559AbfHOJCJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so1586270wrd.7
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yCESPLK8PsPxTY0h56e7rMqRQ6UHxShhjY396ceo/NE=;
        b=L6O8XAd5mt7jKpY4cPiwdBmabAPEOW4TR4TLxBMzhZsp5WsCm+Do/lj7nMJGtqT5Jy
         1Ek6PT3ZitfbxBzJTuxouP8nqkv2+wqaXnXMOZ8hdvYuaXbmP1v6Mxs3Nnh1tyCv69fO
         zi3Cds2t2atcffWQkEv0K0MCWtXGUJVFJYdpfbJGYU0bIpoiXRimV0/B9JMy00XWaw4b
         hAPTp8uQKoORavnFZaQd6yeEbqsI0aGNwfqezCRCN9H7dYdH4+7ffHpkw1Qv21OHdVMK
         jzQzmoBMubEOo/Kc6IG1JbfbYcraS4GO+pKPEuBF1ZhF5RSKU14+8vW6jjZyCAOkC5xc
         THxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yCESPLK8PsPxTY0h56e7rMqRQ6UHxShhjY396ceo/NE=;
        b=VSIhIZ9UuvTD7wFf0FGA7ZSSunbf4vv7FAm9qoI5vnYGz3NF6NIUFqItZpLfd5EL5B
         NU7I0LWDrCR+dpIWdfwHChJFA68e8cOhiqd0EyfFUKDEUe599TV9IZwcQpWM5R9p6Y47
         ICuPIw4x9EqPeuMrNMyxhN051z5ZYNrCdIa3DXHUbgsrCj1bYDVzKiGNF2S2lkycW5Tn
         LhsgmJL5SFP3HrWEBARHb1DrQmdWGQ0iNwQY8LYS76SPM/aelOW2yg4oxkDZlAEWvnDm
         SYSBDJzVwZRS4Qdisw21DpWexv3hzGwQ6uAEwZiHldn0MO6HVZWEUyl98DBHg+uVAUEl
         RBPA==
X-Gm-Message-State: APjAAAWQgaU0rj2xhMnWBoveh6hiVTWI0838dY60oIZouLmDHrw+tQZc
        azMffTUwAkqwdYQHp/CNxRyQLUMvBwy/aLEW
X-Google-Smtp-Source: APXvYqxgC6qsNLydtsDgKPuB+dEIm+KDx7pp5N+puoNGUgYT9bm1hUiUFrLzYSkM5wHpKABXOGehbQ==
X-Received: by 2002:adf:a2cd:: with SMTP id t13mr3989590wra.251.1565859727693;
        Thu, 15 Aug 2019 02:02:07 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 25/30] crypto: 3des - move verification out of exported routine
Date:   Thu, 15 Aug 2019 12:01:07 +0300
Message-Id: <20190815090112.9377-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of moving the shared key expansion routine into the
DES library, move the verification done by __des3_ede_setkey() into
its callers.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c |  4 ++++
 crypto/des_generic.c            | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 968386c21ef4..ec608babc22b 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -348,6 +348,10 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
+		return err;
+
 	/* Generate encryption context using generic implementation. */
 	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
 	if (err < 0)
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c4d8ecda4ddf..f15ae7660f1b 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -846,10 +846,6 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 {
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
-		return err;
-
 	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	des_ekey(expkey, key);
@@ -862,8 +858,12 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 *expkey = dctx->expkey;
+	int err;
+
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	return __des3_ede_setkey(expkey, flags, key, keylen);
 }
-- 
2.17.1

