Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8FAC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52BF8208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bc8YNuhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439226AbfFLMtB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55471 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409157AbfFLMtB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so6429725wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=Bc8YNuhgRlYAqFqT5jtNDi4QTQiRYHmu4iimah+AMG+XNBcM4k/qp0UjZj6sdDr7++
         qDgYUaHtKrj+24P0Ta+7rPPz6QrRYKIg4I/0DL+NmM8+bL9KJ89p8E/Hxn0gCKlTppog
         2i4GGHcLUygzvj0xSb37E6y2gtjOiHtpQIkGO6fwUBtS8KMPWnB62lO5Q60zYmwSK+9T
         83x72iiwWV/iz/077WlhuVns9Z5y+NDBNjpVxKwVDQ30INPw3m/ATjYlvSiD6oN2LwNZ
         mC8z6DbH65y6ZcGCzPcEwvckeIfXZN/7Fv+pT1xNEt/5xNe7TGUa6TPuZ/Vq7mIFQY1i
         TOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=SAhXkaM4QR/poxvBAPPGsWpR2Y6HO4oEQRLEo4IBEiA9KX4IGtp9cgdMvVZ64eGnnj
         TFc4I+fVGTWjmgHPMjDOpW/fvMFkgb6a5PWyX0jTpzSdzpW3kgnvtohxn6GKP6DCiqA/
         JP6YVjJvyGA8IkV4B1UogJ9iXbSxdBUoWb3g/LrlgzteT4o2NYHwaG0di/kq8OUuNtnE
         6+AjudIoedvmMCXXxzQqbfOxsxX6qrsdhXKELIMctn1L38+/jpZTyjXFSvPVtQLZuwcE
         5E87M41s034LmkdAIAwtSXdOKiteDCdEMU082DVWozwHalRjxEzvYvnEpZMAEjdGHZPH
         lBbQ==
X-Gm-Message-State: APjAAAVnEmWONEqdvelDVutD9VHXUkUFJZQuo+KQUx2D5dmS4Jr73PLr
        Ksm/LMLGqV3F9cEz3toZ9pKG26iSr3JCSg==
X-Google-Smtp-Source: APXvYqyuQ/y3rlo7dhNeeyzF+rlGQTYgd8NINhRXyB8oGigKj0kFm662vv9nOY31PNY0BuohLv8KgA==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr9228056wma.34.1560343738709;
        Wed, 12 Jun 2019 05:48:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 11/20] crypto: arm/aes-neonbs - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:29 +0200
Message-Id: <20190612124838.2492-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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
2.20.1

