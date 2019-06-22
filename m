Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE0FC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4179E2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TfhS/DaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfFVAcM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43592 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFVAcM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so8087724wru.10
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KG8WnE1mm/pt8XuVucBEWIW6qbyg1qS4SYR7MAokAw0=;
        b=TfhS/DaSlC9dCB66BhT5FNJX1QKZLTuaXnrT0U82MfiFZcgv0jTRrJodZWpLJxxaqh
         zsYOfiyUqYpGFhi993m+CjA3BK/9wDTKMo3Q2R6sKfBkKtY/lcog+f5PI/JkVpl2Suej
         pB32wGzfuA2oAa2ouWw5UMFMR6zgVmCW5ZVDt+dXpZuck7RJBJk3DVx0ggyQ/6ju+qL7
         LuSc0wExvvjeqHYerLOa5QEXBd1OkBVnJBng9T6iiACA215kEHa+nRUgdjw1Hvyn1Fcv
         vZjqQCs8GeLVzpdHcHZn861cCRTxkz++x84DWjQr/JKOR6BgQmATenuxT2KmNY3XIpau
         LjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KG8WnE1mm/pt8XuVucBEWIW6qbyg1qS4SYR7MAokAw0=;
        b=Gf9H8VPwCypj1CKFJWwAAYkzQYRSvrVEvtaCuf1/TvoNHS//WNwaje1kUF5IrKbyjw
         +HaxIWj0E39lfdt6XZmuVwInzMkUKYvc2Nf6zUrYb5hMKjeCtbbGS7rdMXrFBV+GDcvT
         tpQTFopUG1HAwgiwUeeB6fyeTpsN2g2DXjGKT++VGVE0unIyE13Bpsz9Wtb0TyFoRPLP
         7fbGYpA0Df3aSIdccZECQ039xIefeATPOxsL7X3WQZfdh+TtEt+ETJQI4jsw6l8XfQ0N
         22KIrDiTc9CS+2P2eN93RR9nSAO8adIrHaBjDfLUspLmVKdVUNr4Osoz+9L5WOGrqT7j
         PH2g==
X-Gm-Message-State: APjAAAUPq3rHZwWPr6uELOBeM0lOH+lYEizFbHUVs2CNizwPPQ/MImRr
        YpWFWC2N7FBfHO4bTjfYtlRrc65I1Cr3BRRJ
X-Google-Smtp-Source: APXvYqyaCqCthAYwA7Mhha34+za6vZnxQW13pYEc1zFPrTlPejl/LlkNExngYFs60Pa2sOI6PlMi3g==
X-Received: by 2002:adf:dc45:: with SMTP id m5mr31140866wrj.148.1561163530349;
        Fri, 21 Jun 2019 17:32:10 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 25/30] crypto: 3des - move verification out of exported routine
Date:   Sat, 22 Jun 2019 02:31:07 +0200
Message-Id: <20190622003112.31033-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 5c610d4ef9fc..48292a2ce66d 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -358,6 +358,10 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
+	err = des3_ede_verify_key(tfm, key, keylen);
+	if (unlikely(err))
+		return err;
+
 	/* Generate encryption context using generic implementation. */
 	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
 	if (err < 0)
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c94a303da4dd..34921f8004cc 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -851,10 +851,6 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 {
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
-		return err;
-
 	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	des_ekey(expkey, key);
@@ -867,8 +863,12 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 *expkey = dctx->expkey;
+	int err;
+
+	err = des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return __des3_ede_setkey(expkey, flags, key, keylen);
 }
-- 
2.20.1

