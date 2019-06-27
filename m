Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDBFC48BDA
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C6D20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gaJMvy1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfF0MDz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34778 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfF0MDz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so2280267wrl.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ioky3fpyGzGrutebcm9SiIqrDnulKn3sb2MnhR7QvI=;
        b=gaJMvy1d4pog6kqA8ImpHgejwkmq3ZUKh0j2/sL895rzLUP+msW5h2AnsZUJ5R5H6z
         KqtLkBmOnFRp/PwIv2Nhbk21QgeRtZeB2fn9mje9RANOXsjwk/f84SDiwCHyu1TDpyte
         ICZ3f2vIh6+Bxo+ch+iYToDomYOfiqsB6yry9TeJU56nZE4yTo+yR6DY/ZdH+RPyAFFC
         8wK2GwfiXlAVAyLlfEhBs7DfjweRnqq+ZgzAB/6QF8ge6/TyL+2K8XbOGswZ9velF/u2
         LWPT/8uv8EIn/PxkVMYkUahZ7lZ5b20a/U8vvIkZdpGN4daZdaobbICUvCO4/nsyvtwf
         NCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ioky3fpyGzGrutebcm9SiIqrDnulKn3sb2MnhR7QvI=;
        b=YwqWkVfFolgvtLN4HBUnCMt/qIMJ2xcfEnvPLMi7L+BJvdkf8qpd6C2ZI//CxtorSH
         Y8TK3ACJLCor65BPyGrTirQU8mxycYqA7OTdZ36PH1IYBGM6nMvyEM1bvbdVNGXPCj5r
         Uj8azUDGn2vTwQGTflcEWWGgd1AQ1+IdQdw/FduHqytpOqT/BfofQRIo1qKu9oeZWVu5
         uG5uNS72EOyQmQmPyX88PsH5ezppJS5NlX+UCDJ7zy1wuNo30HWk0jO2nouPYp1lIBog
         R7NCk+2JbvPkS1SgWjESsLp3uvIg/TYvBFhIDDSdn93cuNe8yzFwO/Mk3ikWN1jLa1Yo
         3KFQ==
X-Gm-Message-State: APjAAAWStMuLv2jZzvMs00cf6DSLqHXMOv9/6DI48jMRntd5OfwbeACe
        UCbpwwZt8wJfVtUoCcVDds9Dwel/Hia3Jg==
X-Google-Smtp-Source: APXvYqzDXc17EQgabDax6tyf7t3yds2Z0DRKE2Sc4ynz9qHgAODldlz5X1tUIBlJobveFV/bje0BEg==
X-Received: by 2002:a5d:56cb:: with SMTP id m11mr2986899wrw.255.1561637033424;
        Thu, 27 Jun 2019 05:03:53 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 25/30] crypto: 3des - move verification out of exported routine
Date:   Thu, 27 Jun 2019 14:03:09 +0200
Message-Id: <20190627120314.7197-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
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
index 5c610d4ef9fc..df1b81f06764 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -358,6 +358,10 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (unlikely(err))
+		return err;
+
 	/* Generate encryption context using generic implementation. */
 	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
 	if (err < 0)
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c94a303da4dd..ce482fb5abee 100644
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
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (unlikely(err))
+		return err;
 
 	return __des3_ede_setkey(expkey, flags, key, keylen);
 }
-- 
2.20.1

