Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA47C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18716218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w/7AIrQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfGCIzv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:51 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40515 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGCIzv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id a9so1186727lff.7
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FsynkDGHcI3FuVlz//acB7VJ0fqaGYFF4yMXPjLoHBk=;
        b=w/7AIrQoAPbZToVg1KbfI0oplzMjqnvxvndBD6HmI2HEynp2Poxlw2nP0H6DhnH1Ov
         mf9FQCvEN8PPVtw8zqcnPsUwrA8ENd2OudqhqyvjngeKNFwogFNPgJoQSjjWhme5tvqz
         /U4Zy5uOYgMU5j8MZyFu5JMPNZlE3hgDUPBcso51xSqrW1ipC+gpDYaJpPWmD5CWiDLL
         WBuhxbWfbf9T31FR65+CPlnupg0F1sPERMjjrZ+KQHahtOZL1qiDQ4djw9gdl/bno8A3
         PiBbBibBj48M044b3fDJ4xFaYAE/WGsI988od2ngLSQNkAZTJcayMBmtWkUdjJl3aM5f
         CG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FsynkDGHcI3FuVlz//acB7VJ0fqaGYFF4yMXPjLoHBk=;
        b=rpjh3sfaP2osPHKcaNjpqjNnpTG4GsNtRc9EhhbTPZn0v1sapIm9uYzClHvhaC6PoO
         wefvmtV04ZDJc241G8Z9acLXR30SCV1G+ahGbQENswGf0M4BzsS3SPdnqKizqEMf+s/7
         evxBJ45/T+ZvnnaICF8mlNE7hUXdQO3P10FJ60NUeGxDedWsIvx/ldS3kHMol6z9bGjf
         nk+z5j5zn5h0VGzT4ZOWxrX830XYZKQZURyIlV07IEtANPwdTvD/3ZZRerCwaYgYI5XT
         5slztsbTHU8nTTxoo2fPmNxrN5VNk/DN+kIa0POCDgvBS0Njkk0SoTTNybqa8KH9V543
         9xEA==
X-Gm-Message-State: APjAAAWnfF5yI/oB58hgvDdFh8lQfZ5UShPKYK6hqv/fXBS1WU8kQ5up
        qO3w8bdfSGeuOvETSUyCFvJHbjYkE9YiMkdo
X-Google-Smtp-Source: APXvYqyOxwChA7uAkCpUfipkRkxkEKQkI+s/j4hWBADkpjPE7gnCFu4nNf5zymI7VOwUL5YelHJ1iA==
X-Received: by 2002:a19:230e:: with SMTP id j14mr16912505lfj.13.1562144149247;
        Wed, 03 Jul 2019 01:55:49 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 3/7] crypto: aegis128 - drop empty TFM init/exit routines
Date:   Wed,  3 Jul 2019 10:55:08 +0200
Message-Id: <20190703085512.13915-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
References: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TFM init/exit routines are optional, so no need to provide empty ones.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index d78f77fc5dd1..32840d5e7f65 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -403,22 +403,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis128_init_tfm(struct crypto_aead *tfm)
-{
-	return 0;
-}
-
-static void crypto_aegis128_exit_tfm(struct crypto_aead *tfm)
-{
-}
-
 static struct aead_alg crypto_aegis128_alg = {
 	.setkey = crypto_aegis128_setkey,
 	.setauthsize = crypto_aegis128_setauthsize,
 	.encrypt = crypto_aegis128_encrypt,
 	.decrypt = crypto_aegis128_decrypt,
-	.init = crypto_aegis128_init_tfm,
-	.exit = crypto_aegis128_exit_tfm,
 
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
-- 
2.17.1

