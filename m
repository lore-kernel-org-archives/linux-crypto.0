Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC640C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874DA21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bgemgjj/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfGBTmY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:24 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36632 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGBTmX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:23 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so18199590ljj.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2vu90pozuzPI+4NwppRxnbZtYKOaoe2IbHpzwdsfy4U=;
        b=bgemgjj/Z8o864DCjP3XY81G24w7BW3XOxgNRvKtwcYqQd7DeqA2OMuDc3wF+cKdTE
         JXIfYaSod1nr8sPXEwlPeNlScTEZY4zke+aPMAvfbv3sUHr6C1L5IAfnfNN2bRljgMcy
         7/U03X/wtFjl4cYcvZKe+zM0yF3Fblk+4HW5O95SIHyLtEGhySx9p3LZbGtFzRobdo1K
         UCM+jiy75eUH2HD24zs3Ke/l5xa3O2CzvLVZS5RVRfiLI7s6JZQdHpyDpuKXUTqopjPt
         l00bKwcOd8eWaJq98njJ/tvGRt8fvh90uS09AKKo8xKovvwZEAD4biWmoTkC1+EyXc02
         JWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2vu90pozuzPI+4NwppRxnbZtYKOaoe2IbHpzwdsfy4U=;
        b=kLyz6Ov6/4bt9bztxBmm9LJ3C2ej0IWSiMApbXZX3pqRjjMmbfDkbSRzZxf7RN6jGX
         kOkz9XK9Tedy8ZbL0OW+IizmGZMdE6nnIz1jL1nLCnY5A2S6FJidfLD60Nerh9J4MXSI
         E3ukDWhsbAvaSYuHiBhEGrQuvkwODVVIAWbIB3VBs/kEErRBflbqwrTctpoxPftpZI/W
         AoxklhE9xKnGviUnf7t8C+V+pAxl06W2eb1idkNgpKbftJ5KKVbOeOrb+3kyO33/94aV
         DIA7d/eLiNvgLpd8wmkAqCcAGpgVxBoEsvYpiUOBkcLhyL1dBHJT9wyPKUruiAQbeblY
         FmiQ==
X-Gm-Message-State: APjAAAXkWkco6mdsWiViLaTVXOCZ4PSMpeg23qtBhj/h+jYEXcWDMm/m
        9jOpVn/JwRLaZG34IKWqwmMwpBoZRWlvRQdU
X-Google-Smtp-Source: APXvYqxipfVP+v2VIG8rV5HnP4+ZvqSN9H/2kFRmP/OB+mg50/w90o12zpXva2T4NsyVWwjiIrLM3g==
X-Received: by 2002:a2e:50e:: with SMTP id 14mr18798392ljf.5.1562096541399;
        Tue, 02 Jul 2019 12:42:21 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:20 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 08/32] crypto: cesa/aes - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:26 +0200
Message-Id: <20190702194150.10405-9-ard.biesheuvel@linaro.org>
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
 drivers/crypto/Kconfig          | 2 +-
 drivers/crypto/marvell/cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3fca5f7e38f0..fdccadc94819 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -213,7 +213,7 @@ config CRYPTO_CRC32_S390
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "Marvell's Cryptographic Engine driver"
 	depends on PLAT_ORION || ARCH_MVEBU
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 2fd936b19c6d..debe7d9f00ae 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -257,7 +257,7 @@ static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	int ret;
 	int i;
 
-	ret = crypto_aes_expand_key(&ctx->aes, key, len);
+	ret = aes_expandkey(&ctx->aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.17.1

