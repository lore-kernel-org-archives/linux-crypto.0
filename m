Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EBCC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 528A72086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxLzt3NF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfF0K2C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46507 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfF0K2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so1887287wrw.13
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQLA1Z6u9tD3If/MHOVikbtefg1FLPAfk8jJsqm/d/c=;
        b=lxLzt3NFRfs6f4epK37Ltp6P42+8nW+jSteVOJmx+PVMzF8CiB0qq1PuFWKxbSE/Gz
         FWaVyiOebaq0oEA4LaB4G04SPBXm7uaOzewDGxwEcfb5DOYkbmA76+qfjMBBThUVl10C
         4sJi0XWZECubmCmdvalGxqbAGptUz21vuN6EUEzPrvTsndZrvkSDbMwriQnirl2C5G12
         U6ZnRSmLg9Ai8o4r4NW6vilB9Qs0JckXVQwq1Iv2XNrjo6i+wF8vLV4R8S+EFVA8AmFe
         5Wam4ah9cVv0haFjoR6rlLgeB4uJPhSbZ7JGhj4sBvLAOI08ZnGFrniADZMgFuttDpan
         jpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQLA1Z6u9tD3If/MHOVikbtefg1FLPAfk8jJsqm/d/c=;
        b=JFb/JtTmAx3EHuYSjJIM/OUmhOo1tadJETOL5eLX1c/x6gEUixMuJY0jjDxyuBWudJ
         7QvbqjWtfb0z3g9y6IpyD7uE/k4yo8iEJw4n8iAVdRPlepd/rnWJFe10Ul+1OBZpFBRJ
         SOYvv++xwqdB5CLHnDqxa3AJHYJvCcW95ZZ1sW7mMJBzkIMSaIKhBntFmCLEtUIjRHns
         7sgiVoa3ADKad6neaw43guMF03Ebv8gnlP85BiHT9b5Yh/CvoJlDxac2rXEcE30GrM/C
         I0hgDgQqAA/NhhGU6uG1FKHsPCMGgFzg+IT+D+JLkP0DL8y1Dwgr3QmeH1ZqumTe6jE0
         s3zw==
X-Gm-Message-State: APjAAAW7hvoXpC/v31t2GjxH7FfLde/0L4W1dcvBXGi6GbWZKLT66a8X
        pnAjIimkEG7Uw3qwiFgbdbmWs+e4Hbc=
X-Google-Smtp-Source: APXvYqzcQ+2+MlAKRgSvGiVFYcm7wejcGMHFZl+ZL1OaZNLEs5cHlqrAEy4GW0DWinhxsSyWU+y4xg==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr2798134wrw.75.1561631279558;
        Thu, 27 Jun 2019 03:27:59 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 08/32] crypto: cesa/aes - switch to library version of key expansion routine
Date:   Thu, 27 Jun 2019 12:26:23 +0200
Message-Id: <20190627102647.2992-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

