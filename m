Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D42DC352A1
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Dec 2022 09:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiLCJPg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Dec 2022 04:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiLCJPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Dec 2022 04:15:30 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F365AE06
        for <linux-crypto@vger.kernel.org>; Sat,  3 Dec 2022 01:15:29 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f21so10072352lfm.9
        for <linux-crypto@vger.kernel.org>; Sat, 03 Dec 2022 01:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOw2QtS+uRqhb6p7Xl9O8o0oPEzroNF87b+CczjtJzI=;
        b=FIwJMprbu/qe113DhSEBg3xCx4pB7IadzqJ3mrrbUnHgsc4fJBcml4OH4k/yrH4Nhq
         hOO95KEQrCeVYvN0RhyNbYvaCtrjQFku5XURLhX5v/l2JNY1RsB826mM3opzxM2PzeGO
         X6ocVd1Img9Yp74kRpbXE4e5kULfYEagAiS0Kk8dKLqgUvFdxEHXBvH2xbT35Ylrjddr
         ojl5LjbODcBWueaGX/ctBifHiKm5FEAUq+59IkHNvNY7/dwxT4qt/1MS5tialmj0BNGn
         8mHe1zfB85yJMZNpHGvFeEeFiEI5X8eH74427eK1/f2jMJ+HiRKzoA/Mj5Ax8G5yPH93
         WMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOw2QtS+uRqhb6p7Xl9O8o0oPEzroNF87b+CczjtJzI=;
        b=BOsiMHeG7nsbYLDuFqmm8I0NFSMikcemw/sTxBiImvT8U8Zzb+/F6ikLKnnftFu6lY
         JZQORls5HHqaOM+/kGfMoS527hr/MroQYT7SbdH0+p7DZGm8l6e1TBvL0D6NJozOzU08
         e3e7WT+n5zc+rZpIylly629cfOGLFIrVinu9SitByJJmnDUQL5XQB6pH83IYlOjCyepA
         snwIajoBbmu+ySiwwwKAOLl++Wor7kIjMNROIwugNZawVR0BmQhj7RCjURu/W0B2sTVQ
         TaKUwgCrInOXyoZOUPmSQT0JB3XOOcww41q277rd4kF6Ywbg1CzAbfvye4viUc4Gntwb
         NEkQ==
X-Gm-Message-State: ANoB5pm+KaNIys31H6oXsUDdpmHqD5qKzS+XHnevCaBh2YN5E2l1UqOI
        kp931Tqg3QmVb91uJiPocgF4OQY2BMoI9U5m
X-Google-Smtp-Source: AA0mqf5VhsSnNjFQpFmufzWbYaatmLKVWHQWCs0Ru9O7iwT7XQz9Z4ucl443dHNBgbvZ9qDxaLTZ8Q==
X-Received: by 2002:a05:6512:3762:b0:4ac:5faa:654d with SMTP id z2-20020a056512376200b004ac5faa654dmr23057117lft.684.1670058927994;
        Sat, 03 Dec 2022 01:15:27 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id v4-20020a2ea604000000b0026dce0a5ca9sm800132ljp.70.2022.12.03.01.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 01:15:27 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 2/4] crypto: stm32 - enable drivers to be used on Ux500
Date:   Sat,  3 Dec 2022 10:15:16 +0100
Message-Id: <20221203091518.3235950-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203091518.3235950-1-linus.walleij@linaro.org>
References: <20221203091518.3235950-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Ux500 cryp and hash drivers are older versions of the
hardware managed by the stm32 driver.

Instead of trying to improve the Ux500 cryp and hash drivers,
start to switch over to the modern and more well-maintained
STM32 drivers.

Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- No changes.
ChangeLog v1->v2:
- Collect Lionel's ACK.
---
 drivers/crypto/Makefile      | 2 +-
 drivers/crypto/stm32/Kconfig | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 116de173a66c..fa8bf1be1a8c 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
-obj-$(CONFIG_ARCH_STM32) += stm32/
+obj-y += stm32/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 4a4c3284ae1f..4fc581e9e595 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -10,7 +10,7 @@ config CRYPTO_DEV_STM32_CRC
 
 config CRYPTO_DEV_STM32_HASH
 	tristate "Support for STM32 hash accelerators"
-	depends on ARCH_STM32
+	depends on ARCH_STM32 || ARCH_U8500
 	depends on HAS_DMA
 	select CRYPTO_HASH
 	select CRYPTO_MD5
@@ -23,7 +23,7 @@ config CRYPTO_DEV_STM32_HASH
 
 config CRYPTO_DEV_STM32_CRYP
 	tristate "Support for STM32 cryp accelerators"
-	depends on ARCH_STM32
+	depends on ARCH_STM32 || ARCH_U8500
 	select CRYPTO_HASH
 	select CRYPTO_ENGINE
 	select CRYPTO_LIB_DES
-- 
2.38.1

