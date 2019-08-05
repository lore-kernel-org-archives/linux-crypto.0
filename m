Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 272B3C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E74A22054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OtKu8lUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfHERCQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39354 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so63359599wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VBCngyQGZmU8Cnfx0i/YpoNN6k5U5JO1wOluhtxvAhc=;
        b=OtKu8lUMGyewaxPEAnpt6pmXHYcZq4sAra7l7HBryG2SmyXXxK0f9DqyE5JPozNE0X
         /lmePcePlMcOusQNBFkOVcJBwG0g+cMi34XlQtU1w5NlrhYsWJPmqOyS3jX+R0sjwp3X
         PItKSGEfyeUKd3sUCiLDeA4859GS0gED1rhJHV4JGTCynVbnFxToEY/FSnIq9qah7cJ1
         zmljdPeK7aCINXecvoLgM2zg6H/ivjYoNXmCaPW5cv+0fCtiG3vWY9YiVVVZQJOq/UIT
         XivZNX2vW60zl9rkqg/CGVhQkGI4rNbsacsAQ3qEMpY8GhIMzlroKPBCnN2tnkrQXZMV
         JkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VBCngyQGZmU8Cnfx0i/YpoNN6k5U5JO1wOluhtxvAhc=;
        b=Rt/jRTu6StvFmSp597LHJJX7VBmwzQ/pxGuD+87QuMgKjDK8cw6s8FyId/Po0rZzuf
         szwgKOefE62UQWgMu61P40A1et1O0LtzA++rgs9Liqi/LsVt0csGMS1w6Yp11/yk/AzY
         QMVnrvZu5KWbyeyr54BQwRUDlOXmuf5ke8516dDFvxqsXfBmQuY4kaeNU3Dl4HIQv3jS
         fNH9fy9PdIfF8fZyXS8YlvmPfBQPtZHufIldf3HlmOizpyYPnrmxu7xFE0Sn6ZApACB8
         c61Fep0q22SRE/m6kTrxJwrqaCDSnUH9NVY68IxOYsuw56mGXLJDc1bzvR7h7KkbQom5
         0Psg==
X-Gm-Message-State: APjAAAWg5WuckSTwXksSuRDqbN0/rt3G1oLUmu24VkQTXTVW4ILqNYnI
        G46J0ktFBGKouhBW48CU1K7WvYrx4AG64A==
X-Google-Smtp-Source: APXvYqzlZxyEPDT9D2Hgv7lqkoBzIgsL9QImIlFc+BQRmiQlBktqyv+IxToZEMhdaUzl+At7JK3oNA==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr19961719wma.78.1565024534111;
        Mon, 05 Aug 2019 10:02:14 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 23/30] crypto: talitos/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:30 +0300
Message-Id: <20190805170037.31330-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/talitos.c | 34 ++++----------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c9d686a0e805..890cf52007f2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -30,7 +30,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
 #include <crypto/internal/aead.h>
@@ -939,12 +939,9 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(authenc);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(authenc, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(authenc), keys.enckey);
+	if (err)
 		goto out;
-	}
 
 	if (ctx->keylen)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
@@ -1517,32 +1514,15 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
-		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    !des_ekey(tmp, key)) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return ablkcipher_setkey(cipher, key, keylen);
+	return crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
+	       ablkcipher_setkey(cipher, key, keylen);
 }
 
 static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
-	u32 flags;
-	int err;
-
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return ablkcipher_setkey(cipher, key, keylen);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
+	       ablkcipher_setkey(cipher, key, keylen);
 }
 
 static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
-- 
2.17.1

