Return-Path: <SRS0=Xb3v=UI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F26C468BD
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A12820673
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l13Au7VE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfFILzZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Jun 2019 07:55:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39884 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbfFILzU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jun 2019 07:55:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so3713986wrt.6
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jun 2019 04:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KCbpo8tnaYKrv2j1lDPpryYW7uZhax3jjlheYdiONDU=;
        b=l13Au7VE/9s2L57Uo7UyE8FQaKgLUT2TfiWqxhNmzbgKwXQfWEpCs6n0ba9v1DlS1q
         DtFoFzNTPtIItR/afepMSGay/bb0GmDrj0SiV8igULkWvOZeXz1hGqNgyD5C+jdDCyA3
         mWVbjv2vTe+v+BLkixm7pUWbIMw3GNkl8MavjDeCZIgH7oqBvS0BfTBHYzpwDggDuHUc
         4CTxbPAPecPHQwWhH0Bv/Hh04B3Qr5criSWn5NFG4zmpKebjCfyfb4fRIQnRr9mRdmgV
         Jcho3ZQsikt0rCsu4Z7FYaQnaJIi9cYdJGcbWu3QUuXHC+RHWs8nNN/9MPNV04/yuQ4N
         wo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCbpo8tnaYKrv2j1lDPpryYW7uZhax3jjlheYdiONDU=;
        b=epCYy0WuAtRamz4mBhmzl4f2COpg2TBfH7XJXLf8Spd1jEjKmXusF/4Q/XBVMP0oPa
         9icri56763CN7+yjrMFdx799JXMdhdaMIXN8VWzK1KnizDrHGsQykMTA9R0gBMstoflK
         mxIyZlNA7bOkvMG81DzJ/ayxeIk5m+BsvxVmKFZJFtVI33/7fcnvscDJK9CJrXyTqIGY
         tDaa/sIaJnP2mEEUdyfN8g5mkQxnuKfpi1infG69ztoMY/2cs5C8JEOAeMKbbWB0YXxa
         wXtrR5LBh4F8SY70L+lxh7aIvaDCSqXUuAxJrAErZ7QyNhclUA6vsqIRujh0M1PUWZN1
         db+w==
X-Gm-Message-State: APjAAAWhzeOtyyTcIq/jpxmUHTBkynEnyV1/OObmhA668/5QmGdzFgNf
        sWyFQVPNlXiHsnkDbm/dv4OOdu54H6Ltew==
X-Google-Smtp-Source: APXvYqxMa+jToW0JqQs7bZbai7LF7BCuD/Hvh0Kawj0E1yoyWoAUiYZIy+nClGKntbA3vClJe3hnWQ==
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr30740019wrq.251.1560081318756;
        Sun, 09 Jun 2019 04:55:18 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:5129:23cd:5870:89d4])
        by smtp.gmail.com with ESMTPSA id r5sm14954317wrg.10.2019.06.09.04.55.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 04:55:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 5/7] crypto: arc4 - remove cipher implementation
Date:   Sun,  9 Jun 2019 13:55:07 +0200
Message-Id: <20190609115509.26260-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
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
 crypto/arc4.c | 36 ++------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 7f80623aa66a..3cdfd12110ea 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -27,11 +27,6 @@ static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
 	return arc4_set_key(&tfm->base, in_key, key_len);
 }
 
-static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	crypto_arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
-}
-
 static int ecb_arc4_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -50,23 +45,6 @@ static int ecb_arc4_crypt(struct skcipher_request *req)
 	return err;
 }
 
-static struct crypto_alg arc4_cipher = {
-	.cra_name		=	"arc4",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypto_arc4_ctx),
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
@@ -82,21 +60,11 @@ static struct skcipher_alg arc4_skcipher = {
 
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
 
@@ -106,4 +74,4 @@ module_exit(arc4_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
-MODULE_ALIAS_CRYPTO("arc4");
+MODULE_ALIAS_CRYPTO("ecb(arc4)");
-- 
2.20.1

