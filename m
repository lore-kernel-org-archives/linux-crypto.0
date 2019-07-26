Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C5FC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 18:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 149F922BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 18:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ctubbg/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfGZSTV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 14:19:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35481 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGZSTU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 14:19:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so54005823edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DYue9Ta5QZ05sip6xPS5AmvFZdGwY9ycVH6bVBUVWxo=;
        b=Ctubbg/sTubmXjKAUBG4q0hYoHE86fWYO8Yuav0AfLA3zVtNhSbFzQB3+n+9c+69zX
         IQunjDfDwUesk5Vm5X9D+HPdopLGdW79+9MD4O8GLfYk2ujIV0qeio6wKJq9CBi80ixx
         +zKlZZ8gFVrqWVfyxViifUbX6Lll+dZRypkN5jTHlY9NLwlObDnIgr29A6bSz5VzbUAv
         lFRdaNu2YHO9UIsPUBy+ACABNC0e2sZAewrBE5zkLrwIyrKN09WeMtcFv8wp57RnqXrV
         agLNpgDvYBtFXdRUKF5Gx9I+iQuhG5pRgw3y1NYN6qZVJU1fml/aVLs+dC2VJ6Tj69CH
         sVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DYue9Ta5QZ05sip6xPS5AmvFZdGwY9ycVH6bVBUVWxo=;
        b=Oa8AC/+Pcsf/VDX4GNPPa8i6Lt9XOA6uuJDmQWln/pA46s0glxK9YtKWlvKKuMfp8l
         pTLT5Plcv2oaIbIx/VG3jThxLahKg1a/C+3nMmq1PRfBqigUG2oENu5gYJbDR9f8BwK5
         8njB2op+CbxVQ5eniW0T8Y5Clt19ERb97qAJjkZshmf/6/QeMZ8zVr5KZYEYUOM11vI1
         Pohcn6c1FHHPsbN2lZfHbimkqF8dIjYXFfpWjyx7raniYtjzudkUrpGxc+5crwu+C/pB
         eSMg7nKw5h4x4JLKs9fp7Sipd9qmwtVuV0YH8iJkw856KO4aVDCjfmJW9Ug7POW+VVv2
         GiUQ==
X-Gm-Message-State: APjAAAXynwkmcH1QfgZpZOA9/S7xXYxnlnpEi8tnAyjHqgv22AtpMr4u
        QDqUnYHe6CvjZKzM4QcWh/vpimtlgiM0ipa7
X-Google-Smtp-Source: APXvYqxh7/fo0uiLU7rtrLIFjuLexDeFwW9kQLIKQt0ZNJaABFWKhUoKZtiHodI20rSoUMrZu/IGzg==
X-Received: by 2002:aa7:d781:: with SMTP id s1mr38585866edq.20.1564165159271;
        Fri, 26 Jul 2019 11:19:19 -0700 (PDT)
Received: from localhost.localdomain ([212.92.122.86])
        by smtp.gmail.com with ESMTPSA id x10sm14329152edd.73.2019.07.26.11.19.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 11:19:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: s390/aes - fix name clash after AES library refactor
Date:   Fri, 26 Jul 2019 21:19:04 +0300
Message-Id: <20190726181904.22467-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The newly introduced AES library exposes aes_encrypt/aes_decrypt
routines so rename existing occurrences of those identifiers in
the s390 driver.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/s390/crypto/aes_s390.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index d00f84add5f4..dc0f72dd6e03 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -108,7 +108,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
@@ -119,7 +119,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	cpacf_km(sctx->fc, &sctx->key, out, in, AES_BLOCK_SIZE);
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
@@ -172,8 +172,8 @@ static struct crypto_alg aes_alg = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
 			.cia_setkey		=	aes_set_key,
-			.cia_encrypt		=	aes_encrypt,
-			.cia_decrypt		=	aes_decrypt,
+			.cia_encrypt		=	crypto_aes_encrypt,
+			.cia_decrypt		=	crypto_aes_decrypt,
 		}
 	}
 };
-- 
2.17.1

