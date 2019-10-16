Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A4BFA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5878621A49
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbvFwY7y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392894AbfJPPB5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41486 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392725AbfJPPB4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id p4so12589294wrm.8;
        Wed, 16 Oct 2019 08:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e457YyDFVfE5IUj3AWYMM47UgnP78lQnD30EkuZGvV4=;
        b=IbvFwY7y30vzZmQNQZIdNwtpOJW3l/IQEoam6v99L4QEnCH773bL58VkU8OkkT8W+t
         fbTZvpkR8YBT+PlV374xiKueR6wTf99r8NJPMF+vx+jizVYbSRcXaFywAxq70iVM0gX/
         +7OQD6wxYq72vzAiykXQ4gULTs+vzG6TN/NLwwQ3ZUVv4y+YdQ2HUjpVS2kF2NxTTpD5
         BQ3sFQAKhDACFjUnBgP7t0WCQHfwDnanmEAEzd5OmTms90ICnMwBoHoJUGdZSbBGiJXY
         si97Fj9Sm2Puh+Wy5hp92JVLGsEu8j6R74lVyWpbEDRS+UzTzZ8p5pKPQWgmyg8LaEpQ
         jJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e457YyDFVfE5IUj3AWYMM47UgnP78lQnD30EkuZGvV4=;
        b=gQgAHSlNry0NvvXNTShn1PpSOvG3HdfV+zqCTgaNW5FNdrw0vMxm4Ti198fxZMJvoC
         W/t2ji/5UrbkauhqpjIfv2WU7AzSIf4jt43gvMeDo16ZrgQfXYmhoCgAOP9Y6KmYRo34
         Cw40ogQpQqZo0Qqw+4d4grJptoAytW8WqpE9XsVDuef7xTwaMKLy37JrtNA58BJ8MexX
         vWTknIhZGwoewPHKSToSLd08x9dDk1I2SY8XDkfuijI4JoqFB6kSHtAFBhDEtDwwBFiv
         y8QC8aa8Maz+llAtH3eib75ox8t+FWEGRACW44XUIrRsFQ5guDX/zxOygfT3cTDZcW6o
         k8NQ==
X-Gm-Message-State: APjAAAUXfoYzYqmt5N9pGrFcK1IO2Ob14vAefPvl6gMOfwm/j6IoHmSX
        T8GxJP9VxRvgvkc4N4d+Miw=
X-Google-Smtp-Source: APXvYqyoh/WOojasasugeXydDJgc+8u1z2I8bcvkAOZUBZ1n6Lp44HwStUcdBzPDTzjZHU0Vyq6V+A==
X-Received: by 2002:adf:e8c6:: with SMTP id k6mr3139239wrn.78.1571238113369;
        Wed, 16 Oct 2019 08:01:53 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:52 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 11/11] crypto: sun4i-ss: Move to Allwinner directory
Date:   Wed, 16 Oct 2019 17:01:31 +0200
Message-Id: <20191016150131.15430-12-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since we have a dedicated Allwinner directory for crypto driver, move
the sun4i-ss driver in it.

Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 MAINTAINERS                                   |  6 -----
 drivers/crypto/Kconfig                        | 26 ------------------
 drivers/crypto/Makefile                       |  1 -
 drivers/crypto/allwinner/Kconfig              | 27 +++++++++++++++++++
 drivers/crypto/allwinner/Makefile             |  1 +
 .../{sunxi-ss => allwinner/sun4i-ss}/Makefile |  0
 .../sun4i-ss}/sun4i-ss-cipher.c               |  0
 .../sun4i-ss}/sun4i-ss-core.c                 |  0
 .../sun4i-ss}/sun4i-ss-hash.c                 |  0
 .../sun4i-ss}/sun4i-ss-prng.c                 |  0
 .../sun4i-ss}/sun4i-ss.h                      |  0
 11 files changed, 28 insertions(+), 33 deletions(-)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/Makefile (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-cipher.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-core.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-hash.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-prng.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9153c02e1f63..2120c74f476a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -684,12 +684,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/opp/sun50i-nvmem-cpufreq.txt
 F:	drivers/cpufreq/sun50i-cpufreq-nvmem.c
 
-ALLWINNER SECURITY SYSTEM
-M:	Corentin Labbe <clabbe.montjoie@gmail.com>
-L:	linux-crypto@vger.kernel.org
-S:	Maintained
-F:	drivers/crypto/sunxi-ss/
-
 ALLWINNER CRYPTO DRIVERS
 M:	Corentin Labbe <clabbe.montjoie@gmail.com>
 L:	linux-crypto@vger.kernel.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 610bb52d77d6..9f08ed72eae8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -659,32 +659,6 @@ config CRYPTO_DEV_IMGTEC_HASH
 	  hardware hash accelerator. Supporting MD5/SHA1/SHA224/SHA256
 	  hashing algorithms.
 
-config CRYPTO_DEV_SUN4I_SS
-	tristate "Support for Allwinner Security System cryptographic accelerator"
-	depends on ARCH_SUNXI && !64BIT
-	depends on PM
-	select CRYPTO_MD5
-	select CRYPTO_SHA1
-	select CRYPTO_AES
-	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
-	help
-	  Some Allwinner SoC have a crypto accelerator named
-	  Security System. Select this if you want to use it.
-	  The Security System handle AES/DES/3DES ciphers in CBC mode
-	  and SHA1 and MD5 hash algorithms.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called sun4i-ss.
-
-config CRYPTO_DEV_SUN4I_SS_PRNG
-	bool "Support for Allwinner Security System PRNG"
-	depends on CRYPTO_DEV_SUN4I_SS
-	select CRYPTO_RNG
-	help
-	  Select this option if you want to provide kernel-side support for
-	  the Pseudo-Random Number Generator found in the Security System.
-
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 90d60eff5ecc..79e2da4a51e4 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -40,7 +40,6 @@ obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_ARCH_STM32) += stm32/
-obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index a3e5781fa95e..9c445973ca08 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -5,6 +5,33 @@ config CRYPTO_DEV_ALLWINNER
 	help
 	  Say Y here to get to see options for Allwinner hardware crypto devices
 
+config CRYPTO_DEV_SUN4I_SS
+	tristate "Support for Allwinner Security System cryptographic accelerator"
+	depends on ARCH_SUNXI && !64BIT
+	depends on PM
+	depends on CRYPTO_DEV_ALLWINNER
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_AES
+	select CRYPTO_LIB_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  Some Allwinner SoC have a crypto accelerator named
+	  Security System. Select this if you want to use it.
+	  The Security System handle AES/DES/3DES ciphers in CBC mode
+	  and SHA1 and MD5 hash algorithms.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sun4i-ss.
+
+config CRYPTO_DEV_SUN4I_SS_PRNG
+	bool "Support for Allwinner Security System PRNG"
+	depends on CRYPTO_DEV_SUN4I_SS
+	select CRYPTO_RNG
+	help
+	  Select this option if you want to provide kernel-side support for
+	  the Pseudo-Random Number Generator found in the Security System.
+
 config CRYPTO_DEV_SUN8I_CE
 	tristate "Support for Allwinner Crypto Engine cryptographic offloader"
 	select CRYPTO_BLKCIPHER
diff --git a/drivers/crypto/allwinner/Makefile b/drivers/crypto/allwinner/Makefile
index 11f02db9ee06..fdb720c5bcc7 100644
--- a/drivers/crypto/allwinner/Makefile
+++ b/drivers/crypto/allwinner/Makefile
@@ -1 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sun4i-ss/
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_CE) += sun8i-ce/
diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/allwinner/sun4i-ss/Makefile
similarity index 100%
rename from drivers/crypto/sunxi-ss/Makefile
rename to drivers/crypto/allwinner/sun4i-ss/Makefile
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
similarity index 100%
rename from drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
rename to drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
similarity index 100%
rename from drivers/crypto/sunxi-ss/sun4i-ss-core.c
rename to drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
similarity index 100%
rename from drivers/crypto/sunxi-ss/sun4i-ss-hash.c
rename to drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
similarity index 100%
rename from drivers/crypto/sunxi-ss/sun4i-ss-prng.c
rename to drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
similarity index 100%
rename from drivers/crypto/sunxi-ss/sun4i-ss.h
rename to drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
-- 
2.21.0

