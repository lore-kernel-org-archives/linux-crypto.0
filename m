Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72624C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 22:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKYWc7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 17:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKYWco (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 17:32:44 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349C7C73
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 14:32:28 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bp15so8724311lfb.13
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 14:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9YYmRZVJgzfGm6zhi8e8dQ108OodfeWK82tKofypW4=;
        b=ZPANDLmidQxTsvRuye5/avhi9Dei/86V6fEvTHiZB9Vyj8pws5tmqhYP56TXgL9OHj
         3mJhbydG2E7XMUMmjcf7NunQ7SEvbBUAUz2yUmQQnfPlXWv9ZvP/CxU++LCTF1v2UoJj
         TAI6b6ZPTPxQoQ2zNydJlW6/dn3RX2JcHdaVBpjub7ZlLzEssJn1vK6HpKft8r8OLzrv
         a8dIMOS/YJ80BXZ+FgrDwpxXBaPz+j9CabuqfFD1K+9vpUyQC3zpuUVPOSnbBPI/sgIB
         oFzLfOfchyjpTYfQLA/0k0Ak6oyEJnzZIJ0RjlnuEKpjhFD5LhEDhcD+REPb0XlKdcrF
         M57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9YYmRZVJgzfGm6zhi8e8dQ108OodfeWK82tKofypW4=;
        b=y51R9nmCCWRthtq/+8jwXsnO+GCVstfy/gvF0mjpKPaG+oUlw/+XuuVt68Gjz2Jn5I
         phvuLG4ce5NVW2UoWcM61S0SCVre55EtnplCR7YLNIZn/MWTt1a6NZeC+9muY39RdBLZ
         FMsWnjklhzvFjzZL/rvLBtYG8ERXGWFXmv7wrLbtjMWnohwoS0ZpRhi10y/3kyDp6e9Q
         zBt+d961bClj6JhTnQKSh8Pw88Ec0yabIzqftNpo4lq+4tEZJwrUYPYOR7+zHO6YzBTW
         k7sbg6eg8pCbjwYbj1fKgJKqHFVsyxw66pqo4gGcAziVJNzB74VGLfsmsoWzvr93o/SH
         lwVw==
X-Gm-Message-State: ANoB5pnOHbrytaqxHWHNZvzshfLwzZl9cMFwLqehl72o3BODGDZZLyTU
        6PnqYBIjfzTVUisSjCvUA46tJZWHTGP/lw==
X-Google-Smtp-Source: AA0mqf6TZyjQQuJEGwxxiugsFTdIJ3uTfEwj+iSGqHJdRDX9ecxPL9tkbxd/Que93VRxJ6+m7jsl3w==
X-Received: by 2002:ac2:46ca:0:b0:49e:da1e:fe with SMTP id p10-20020ac246ca000000b0049eda1e00femr13426965lfo.141.1669415546121;
        Fri, 25 Nov 2022 14:32:26 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id f7-20020a05651201c700b004b4e9580b1asm676582lfp.66.2022.11.25.14.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:32:25 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 2/4] crypto: stm32 - enable drivers to be used on Ux500
Date:   Fri, 25 Nov 2022 23:32:15 +0100
Message-Id: <20221125223217.2409659-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125223217.2409659-1-linus.walleij@linaro.org>
References: <20221125223217.2409659-1-linus.walleij@linaro.org>
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

