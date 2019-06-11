Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57515C31E46
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A3C20872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bOMcCobR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407948AbfFKXJw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44382 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407947AbfFKXJw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id b17so14781806wrq.11
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fbFfAJKsga0PzbfD0B7XAZEFIq7kpWzA1cLLaRgcgAY=;
        b=bOMcCobRUQbk/QWR7eKt7dvcIO0/PB+C9MITBHROZlDjRAiTT8Bjqy/Bjq2LgiSVgt
         0aXXFQ/4ztEH4TNl9zvaHP5v8QAwk06nExUBzQBEFgAIHrFrav+jY+9iP1dFGMhanL8i
         vSWbPhzdmHjTRZknabgxbs5fQ8V5AIjvziK31DYU0GeQ7vO1DomiSd/eDWpSjPoVwO/d
         /dYeL/KU71bfm60u1owCxpUgVvxp4KJe9CKSCZ4+nOWgkWMiCInPvHlYJcVcXlDUvXrz
         mEcfH5MJURvp3RYnxSfOBTentrrM22AC1DVf6TjyQB5p2O2oh2SBfLFlJXfJPStCgS/n
         rUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbFfAJKsga0PzbfD0B7XAZEFIq7kpWzA1cLLaRgcgAY=;
        b=EIYcc0qsH7qmR+BkzrS+bACLGvrS9jQ2mMtIMbda05V8tJ7uDWugGjEG3Ay5Qnyn1D
         hB4KPKauC9iDfVZsRZaWb77oHl72FAHFP+OALxmNv3QodadIruA4yNU6QChOHH6N3TiB
         r/1LY8u8FKL0OCJsoBi5AW2gS4jfhKK8aQ60whLJ5GELOL9mOx00qEtoXrYB/K8D1noM
         2uuLttR69I+gVtU7+LGTYLHUXZN0gNvxfAvDLa+tnFV+abEl0N5txDyiU/uDPilgI9b7
         v5NfTdV42aZECR0RhYVe7cBRgr2PnHdrrpPfezmzL3phVhveD1t0glWIkBKFbcQQtc7U
         /E8w==
X-Gm-Message-State: APjAAAXhCcbWnnvqC0aJ8yWLPxPJKfbl+EPZO5w8QgDu3qqiKvLpFae/
        lSxWG5y5ZN6jJRdY9PmksDk/QpvQDHak1ik5
X-Google-Smtp-Source: APXvYqx2rU3S2gqmVNjNoYKBr7y2S77LwQYfTWid0wDD2wkahZA3k43znmmvL18hEIeqdlApXr1DsA==
X-Received: by 2002:a5d:618d:: with SMTP id j13mr29159735wru.195.1560294590135;
        Tue, 11 Jun 2019 16:09:50 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 5/7] crypto: arc4 - remove cipher implementation
Date:   Wed, 12 Jun 2019 01:09:36 +0200
Message-Id: <20190611230938.19265-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are no remaining users of the cipher implementation, and there
are no meaningful ways in which the arc4 cipher can be combined with
templates other than ECB (and the way we do provide that combination
is highly dubious to begin with).

So let's drop the arc4 cipher altogether, and only keep the ecb(arc4)
skcipher, which is used in various places in the kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/arc4.c | 56 ++++----------------
 1 file changed, 9 insertions(+), 47 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 6974dba1b7b9..35a44e84158e 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -13,26 +13,15 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-			unsigned int key_len)
+static int crypto_arc4_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			      unsigned int key_len)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return arc4_setkey(ctx, in_key, key_len);
 }
 
-static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
-				 unsigned int key_len)
-{
-	return arc4_set_key(&tfm->base, in_key, key_len);
-}
-
-static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
-}
-
-static int ecb_arc4_crypt(struct skcipher_request *req)
+static int crypto_arc4_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -50,23 +39,6 @@ static int ecb_arc4_crypt(struct skcipher_request *req)
 	return err;
 }
 
-static struct crypto_alg arc4_cipher = {
-	.cra_name		=	"arc4",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct arc4_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
-			.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
-			.cia_setkey		=	arc4_set_key,
-			.cia_encrypt		=	arc4_crypt_one,
-			.cia_decrypt		=	arc4_crypt_one,
-		},
-	},
-};
-
 static struct skcipher_alg arc4_skcipher = {
 	.base.cra_name		=	"ecb(arc4)",
 	.base.cra_priority	=	100,
@@ -75,28 +47,18 @@ static struct skcipher_alg arc4_skcipher = {
 	.base.cra_module	=	THIS_MODULE,
 	.min_keysize		=	ARC4_MIN_KEY_SIZE,
 	.max_keysize		=	ARC4_MAX_KEY_SIZE,
-	.setkey			=	arc4_set_key_skcipher,
-	.encrypt		=	ecb_arc4_crypt,
-	.decrypt		=	ecb_arc4_crypt,
+	.setkey			=	crypto_arc4_setkey,
+	.encrypt		=	crypto_arc4_crypt,
+	.decrypt		=	crypto_arc4_crypt,
 };
 
 static int __init arc4_init(void)
 {
-	int err;
-
-	err = crypto_register_alg(&arc4_cipher);
-	if (err)
-		return err;
-
-	err = crypto_register_skcipher(&arc4_skcipher);
-	if (err)
-		crypto_unregister_alg(&arc4_cipher);
-	return err;
+	return crypto_register_skcipher(&arc4_skcipher);
 }
 
 static void __exit arc4_exit(void)
 {
-	crypto_unregister_alg(&arc4_cipher);
 	crypto_unregister_skcipher(&arc4_skcipher);
 }
 
@@ -106,4 +68,4 @@ module_exit(arc4_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
-MODULE_ALIAS_CRYPTO("arc4");
+MODULE_ALIAS_CRYPTO("ecb(arc4)");
-- 
2.20.1

