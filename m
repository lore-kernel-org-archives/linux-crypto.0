Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0DCC06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 850DB21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nWgAdFGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGBTm2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:28 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40012 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTm1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id a9so12297007lff.7
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mFytONJYgeLPEAdaeV/79gIWsnl1yOK0v5PQmjMRL3M=;
        b=nWgAdFGpodhwE7+93cpf8hVe5RVv3EzevLafUKHyHxj2qLtuO7g3rMpYF0Uc8G7EST
         xMlgMgsEIl9/8rIwSbK7RP/Ectctkb0o4dvaDxowAW+yfl5CDlp7wsUO5gVjpFYJlf36
         bQkN76++aoAlH/rYuZKwb9fGGb5Xio/JnxFethzXtBrCPKmxrKOCRovjmDdj8AV1UlD/
         9m49x0JXosLMzeaUjP+LeM2IKR8/pgOeIdy9A3lf7oKkTphUG5Z3JbH6yMxNQBBz0zfJ
         X2mFysrmK7dh/g3FZWhi9stGL3ymth+ae/D2x38j7jMy5Cp/tAu+xxqtiidLAaDjuhh0
         FJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mFytONJYgeLPEAdaeV/79gIWsnl1yOK0v5PQmjMRL3M=;
        b=sarS+xCxMhRJaTCVJuBnR0A0FQ813awpxmNS46Z01O1nL28CeBWzz3JRCs8GVS8Sha
         pG/63ppW0KykYhR0yXXgM81u5hsXtAUVSh4MMNCwtAYlwbJjybLFMtgC+PV+hY9sjE43
         2xcqnCWJBnDM1jaaaGbXpjy++of9ACkX3jqWCO6gfaaIUgGCz4lpMZ9wLYYnkLKbJ9xU
         xtHjq7lBuDTwZv2gDpIHkYvgJ1mm5t0qH7AYXkdaFE0TALKjOBhzTu1m0lbm/1W7bAps
         JGYEYkRExW9/Wxd23CJRqw+X/OcWZmMCQjVP70I1mXmOgfZuf53ae3OHt+7w4Cly7ofQ
         4O3Q==
X-Gm-Message-State: APjAAAX+7R6JffqGXiQcBjxPg2yFrHZtjXTeqc33SJ4mEzOwRxln6Ygu
        AgQz2PvlvFKya1G6ppXF7Dov6g5vL7DzSQcO
X-Google-Smtp-Source: APXvYqxIb2tjJw+V4QsaP46Bbkk15xvfCgYvVBRyCnXY5BjBigLpb84hdaJeKKQBeILxc7QiN1O4UA==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr15753843lfd.33.1562096545325;
        Tue, 02 Jul 2019 12:42:25 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:24 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 11/32] crypto: arm/aes-neonbs - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:29 +0200
Message-Id: <20190702194150.10405-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig           | 2 +-
 arch/arm/crypto/aes-neonbs-glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index a95322b59799..b24df84a1d7a 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -82,8 +82,8 @@ config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
-	select CRYPTO_AES
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 617c2c99ebfb..f43c9365b6a9 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -64,7 +64,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -123,7 +123,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
-- 
2.17.1

