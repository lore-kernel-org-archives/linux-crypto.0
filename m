Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A45EC48BE7
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42DD20657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MYRAFNet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfFVTev (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37423 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFVTev (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so9609732wme.2
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQLA1Z6u9tD3If/MHOVikbtefg1FLPAfk8jJsqm/d/c=;
        b=MYRAFNetilQRuZslBml8aKhDISEudeoPejyATZfvssgTxaDE/R1CKYQt6EVyk0b4jg
         Rh6Xxk8espv5gC83N6yobsZ2u3+e/bPXfbY4vgjDK6pbyepwv3NufLqIqo1DpVtGjxG5
         LuZVwxF3ZFCsWDOBrAVGL9pKcj+k2Dit3xkITDL9AeB+qiv8h4pS+X9eQNtOpTs5EI9p
         PuB5hVD755KqNcIbZfbHTAr4G78BS/qFDiQrPDx9xZ6mTRJ3paRktbKbAk8DLDCdexzk
         02XLXUhiUXeu/M51zGgMPXL1ofFPl2LQqy7JrkCSDoO3I9fldGnGLo+jgeOjn4qLPMEa
         jt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQLA1Z6u9tD3If/MHOVikbtefg1FLPAfk8jJsqm/d/c=;
        b=pbZlTIcqXQF4OEDdZtJ7whRWfzA06YxQEXEvbeqszo6sfFBVHOupAoo8iLPaMRHZu/
         LcoSoO6bJMDG0A99mSVNQklktkFk87T9Xswux1T4AQWQYq2kE/4y1a3DfiFrJYZjGCaj
         U8VRRcZp1gEkU/aWVCHWxFXqMFTWzZdexL3PyV2DfI9jeAJ5CwIJ5r/SLeanQ9DvSigy
         tSou3CpdOrry+u0Ifsu4wUqpJtRK2MsZa7ky2+Mr2OgbtL5hAV87vksP9kInvQok5tCV
         498s3SdN+U1sX9YNU/sUYrvXnRf5BOqwPYYVcYaZmyPVCKWw8Ycma4O4/HtL1YmYfY1T
         pqzA==
X-Gm-Message-State: APjAAAV2r0v2GZU4wVyz4IxcdSJS8Nwjq/jlSI9FBLjBYLuqb//0GIz6
        C8xYszOh7K9Lgdg7ji5+GaMcdWeoHFq/3KBB
X-Google-Smtp-Source: APXvYqxnobQMcJ/eR87Lco38fWkmNHterSKYBfPKaGpcNfdA/IeBwF1Dw3JZE+csmsoUZmzddoHWTA==
X-Received: by 2002:a1c:80c1:: with SMTP id b184mr8037126wmd.24.1561232088802;
        Sat, 22 Jun 2019 12:34:48 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 08/26] crypto: cesa/aes - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:09 +0200
Message-Id: <20190622193427.20336-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

