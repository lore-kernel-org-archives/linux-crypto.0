Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9642C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD5420896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zj/ey98w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390988AbfFKNsE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:48:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54835 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389298AbfFKNsD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:48:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so3042719wme.4
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 06:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3I0sVEcJNKK5i1GhWoBB9kBvtudu6BnBVt42aYvHhK0=;
        b=zj/ey98wPanTfXmMnGYdICoWHd5IsvcgXDDnHto4mHfrAbCkkjDmx6got6b6VFhnDX
         +lC4myTMOybE/EzrSeRwipAGupn/23Hr5qxOJqY6tyiEiSjHNOFp8DDa/tL2zB+EcEQm
         bLVByxRkOMQ0mWtrwrZmhfCWZ97qcw5QvPWHEU/hzLCYljcNFo2/gKds3m7f+LsmetSV
         XBr9nO7Sx1v239IQslLGebJ5SroZqSEaqmDhbIH55yaKAE1HtUDFVQVBuxbZn1ZvKCSE
         BfNQOM7v5stu2A2YNWLJ77DqYVnE2jKnt9dQHOB8vPJw9MItTB0PqYJW07j4mg6wCWnV
         tDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3I0sVEcJNKK5i1GhWoBB9kBvtudu6BnBVt42aYvHhK0=;
        b=YOtnv8yZy+0u/fbeZ0YCnoMr5Xk6iofTvTtURkqX7/nYPa7nl1M9Lx51OqiOJNqTo8
         0rMZHXix9X+N9FinLlW8Dbohu5y870vcDrN7Pmkqczb2n8L+aVPmRfZCU5mMNYj8Z93X
         EauptJXujpRuzF83oRe1ALgej++mbJIXwSXGAMeJGfIVU++4ymmz+58Tmxt/VpX+pei9
         pwX/L6zZ8FZy14ei62Pe9zkJ7byTPEUvoCSg3VyywPyCWLUqL5G46tFyWcCvkQDm6pTR
         lTfuk039tVRtpejJ+NMEgdSKqI4IbSk676r0cMd8wMy5GpJ3D9NQgVv1WBkUaWmQ5WHx
         iXKw==
X-Gm-Message-State: APjAAAXUNoZRJCuVlyIJTtbNaz3eh9nxy7Q4XtUAvLzjCfVzbAWS34B4
        ptB2ifOypN4UY8Mp6lEWRD+QUEFuahyQyTZL
X-Google-Smtp-Source: APXvYqx9bO2x1LEA4pgE145K6MdqTYeGqyScD8hZ3lSGlyeVXXhGa0CoUFt4QXImrMtJ8VLOfzD7tQ==
X-Received: by 2002:a1c:a783:: with SMTP id q125mr18760740wme.94.1560260880932;
        Tue, 11 Jun 2019 06:48:00 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id o126sm3964305wmo.31.2019.06.11.06.47.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 06:48:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3 5/7] crypto: arc4 - remove cipher implementation
Date:   Tue, 11 Jun 2019 15:47:48 +0200
Message-Id: <20190611134750.2974-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
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
 crypto/arc4.c | 46 ++------------------
 1 file changed, 4 insertions(+), 42 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 6974dba1b7b9..79a51e9f90ae 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -13,23 +13,12 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-			unsigned int key_len)
-{
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return arc4_setkey(ctx, in_key, key_len);
-}
-
 static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
 				 unsigned int key_len)
 {
-	return arc4_set_key(&tfm->base, in_key, key_len);
-}
+	struct arc4_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
+	return arc4_setkey(ctx, in_key, key_len);
 }
 
 static int ecb_arc4_crypt(struct skcipher_request *req)
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
@@ -82,21 +54,11 @@ static struct skcipher_alg arc4_skcipher = {
 
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

