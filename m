Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49269EDE994
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbjINI25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbjINI2k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209981FF0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c3d8fb23d9so5553425ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680115; x=1695284915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3ZhNFN1dbga05t5/Fuf4qKlDoQ4ygUq3r7EAsjI++4=;
        b=r3UEkeIXz7AveqijWqEZlBh+TivD0zMqqEXgvQ6aAncRh3IBCHIUg1Q9VXV1WThOPf
         0txvY5KUN9RyXKYVQEOtVlOmowPnFTckxplQaVTZBLIZ7Iy9nXuj7FIkJtDsr+JZK3jr
         XOi1XBC3DcLxW56XQhZhlf2OGjUyLdXSwixWAZGQzXp0sPbGhkdWjemeAIAXWAWFqNtP
         i9xAL0Av1Uyt+3bQO+Og+NUu+eGUzlG4f50rsZNJPE9bLLqUdZlrB5a8ge74EORyZE5T
         hD5/VlPQqWUSZ+8T6eCZZVkxIq2+VwnUAjmKrH9lOPko/GW9IH2giq/gYj1prVzzBo+A
         aVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680115; x=1695284915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t3ZhNFN1dbga05t5/Fuf4qKlDoQ4ygUq3r7EAsjI++4=;
        b=W5N0UQczBN0z8FY51C10mjp8f6zg8SJLNi8Brb/VE/j814BdS5Mq209CtVWfpf+uYD
         0eVcbdHIUNJe04ho/w/0jVSLT51YOXjayZCkA7X1yueUt3/bkoAtYYKNaEDYST1qA8Pu
         IHnUljuFLNAkboHZ4idq19kVLw29Lli6K99x/QErOw5Q5BgsyaTGargz88mwVSGn4KSZ
         vYMk/jr1OXuhXQgm+a2PHDvjeiSg6PUHmy2PkQJo26NVzUraITzv/ggPpLpdxBNYU37r
         xZUVzWhIl5CcWJMHFc4FRAuLvaRPnIpL9JjMtvcfqH+Ds/qFj1//yi8DAXV2X0GOLp5l
         tiuQ==
X-Gm-Message-State: AOJu0YwQe9e5KpEC2wPxzTuorIOG4FGubvkv6mWXOZtcAkYsIAdlukXJ
        bGvBdXX9+NLmCQORiDlD+AfEpH4rn+4=
X-Google-Smtp-Source: AGHT+IGfAJtcqqzFgjdK6rNNdAc+6ZhGd13C9Z54XAUVSJNKKSpngOl91E2rA+O57KhB0lL5tZ/HIw==
X-Received: by 2002:a17:902:f812:b0:1c4:1538:85fc with SMTP id ix18-20020a170902f81200b001c4153885fcmr434650plb.51.1694680115267;
        Thu, 14 Sep 2023 01:28:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:34 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5/8] crypto: lskcipher - Add compatibility wrapper around ECB
Date:   Thu, 14 Sep 2023 16:28:25 +0800
Message-Id: <20230914082828.895403-6-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As an aid to the transition from cipher algorithm implementations
to lskcipher, add a temporary wrapper when creating simple lskcipher
templates by using ecb(X) instead of X if an lskcipher implementation
of X cannot be found.

This can be reverted once all cipher implementations have switched
over to lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c | 57 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 3343c6d955da..9be3c04bc62a 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -536,13 +536,19 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 	u32 mask;
 	struct lskcipher_instance *inst;
 	struct crypto_lskcipher_spawn *spawn;
+	char ecb_name[CRYPTO_MAX_ALG_NAME];
 	struct lskcipher_alg *cipher_alg;
+	const char *cipher_name;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_LSKCIPHER, &mask);
 	if (err)
 		return ERR_PTR(err);
 
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(cipher_name))
+		return ERR_CAST(cipher_name);
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return ERR_PTR(-ENOMEM);
@@ -550,9 +556,23 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 	spawn = lskcipher_instance_ctx(inst);
 	err = crypto_grab_lskcipher(spawn,
 				    lskcipher_crypto_instance(inst),
-				    crypto_attr_alg_name(tb[1]), 0, mask);
+				    cipher_name, 0, mask);
+
+	ecb_name[0] = 0;
+	if (err == -ENOENT && !!memcmp(tmpl->name, "ecb", 4)) {
+		err = -ENAMETOOLONG;
+		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		err = crypto_grab_lskcipher(spawn,
+					    lskcipher_crypto_instance(inst),
+					    ecb_name, 0, mask);
+	}
+
 	if (err)
 		goto err_free_inst;
+
 	cipher_alg = crypto_lskcipher_spawn_alg(spawn);
 
 	err = crypto_inst_setname(lskcipher_crypto_instance(inst), tmpl->name,
@@ -560,10 +580,37 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 	if (err)
 		goto err_free_inst;
 
-	/* Don't allow nesting. */
-	err = -ELOOP;
-	if ((cipher_alg->co.base.cra_flags & CRYPTO_ALG_INSTANCE))
-		goto err_free_inst;
+	if (ecb_name[0]) {
+		int len;
+
+		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4],
+			      sizeof(ecb_name));
+		if (len < 2)
+			goto err_free_inst;
+
+		if (ecb_name[len - 1] != ')')
+			goto err_free_inst;
+
+		ecb_name[len - 1] = 0;
+
+		err = -ENAMETOOLONG;
+		if (snprintf(inst->alg.co.base.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, ecb_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		if (strcmp(ecb_name, cipher_name) &&
+		    snprintf(inst->alg.co.base.cra_driver_name,
+			     CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, cipher_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+	} else {
+		/* Don't allow nesting. */
+		err = -ELOOP;
+		if ((cipher_alg->co.base.cra_flags & CRYPTO_ALG_INSTANCE))
+			goto err_free_inst;
+	}
 
 	err = -EINVAL;
 	if (cipher_alg->co.ivsize)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

