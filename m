Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273F1FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3E5021848
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u2Li+8fG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392186AbfJPPBi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54984 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392187AbfJPPBh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so3287039wmp.4;
        Wed, 16 Oct 2019 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VpdEp2zf81VBM+LhkWglZ2eMDIpA3da8iXPWPqvvAdE=;
        b=u2Li+8fGwbUzcPJxxvOBpyqCzMizq522pSUKcGfpCAvPVCu/xb71Ztqe3MF8EHlkzi
         C6Nw5hH7TGPzEgamiHkcD457loJHQ/duxoyhzL2Tga3I9niCXRQ+7pmFUmyaoCrBKprY
         Q3u5EO2sgi8Td29J42iRStmS4OZEPWXiu/nl1tenbyXtxClgcjV/UfVPH8mNCXPEJdd4
         jVQPJEl9tYPrcqzlpTEunFumnh90l7idaVo18Zec/sot0tX+APqKD8MRLeE44/yu3aZx
         7qxdFrqKnLMRh58jYl16fYI8zyCeEEyW1e1YJrHdrZnZGG8lrJp3HCs3toFJYdTGKHmI
         3LxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VpdEp2zf81VBM+LhkWglZ2eMDIpA3da8iXPWPqvvAdE=;
        b=YMCQTtDdBk1xmj7Ff8RoN3U5TTifeZEKRG3J1D8UbQ1e9ldHEvbG1VDtB0FBpR1O2c
         TsTaKJJKeL917D6Drt5RF6NnAcjHtr6IsLtYkm7z0O2myrHfAAY3qnpc1FCR0x+LYTjt
         VSH2NGp7N7pNOa7JV2QfOsnVgf9IfjdwZtDQ9KtS+MOUK01w/6PkrI3GOFi3qKoA4QWN
         H/twLk+eemyUBr+LGi9i6NFd7cWX/GjyLYV3ix6qh/EUXHSaGQ4tU6h/w4ZFrTRRNV/I
         zwzHP2i/dt/pbrkodYPq1wiHk7y2RpwfihnVYmTF14gnNRWskq0Bfd+2OAzalu8KR9QZ
         gc0g==
X-Gm-Message-State: APjAAAW2FRFgL+LeRF7Exl4nUpI0dToZQFaM9asubKiYbQZ+YUjH2va/
        r//UtwO1J/W1nk/EsRFITWFP1drP
X-Google-Smtp-Source: APXvYqyZvGmYe2ePerNhQGEy2ZE8TMHhSrtbEr+lxIT94scGpIIN6fF6fq+EUVbBPdZWbs/d/PHvUg==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr3583046wmf.37.1571238096285;
        Wed, 16 Oct 2019 08:01:36 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:35 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 01/11] crypto: Add allwinner subdirectory
Date:   Wed, 16 Oct 2019 17:01:21 +0200
Message-Id: <20191016150131.15430-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since a second Allwinner crypto driver will be added, it is better to
create a dedicated subdirectory.

Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 MAINTAINERS                      | 6 ++++++
 drivers/crypto/Kconfig           | 2 ++
 drivers/crypto/Makefile          | 1 +
 drivers/crypto/allwinner/Kconfig | 6 ++++++
 4 files changed, 15 insertions(+)
 create mode 100644 drivers/crypto/allwinner/Kconfig

diff --git a/MAINTAINERS b/MAINTAINERS
index c7b48525822a..9153c02e1f63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -690,6 +690,12 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/sunxi-ss/
 
+ALLWINNER CRYPTO DRIVERS
+M:	Corentin Labbe <clabbe.montjoie@gmail.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/allwinner/
+
 ALLWINNER VPU DRIVER
 M:	Maxime Ripard <mripard@kernel.org>
 M:	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3e51bae191ec..610bb52d77d6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -11,6 +11,8 @@ menuconfig CRYPTO_HW
 
 if CRYPTO_HW
 
+source "drivers/crypto/allwinner/Kconfig"
+
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
 	depends on X86 && !UML
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index afc4753b5d28..90d60eff5ecc 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CRYPTO_DEV_ALLWINNER) += allwinner/
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
new file mode 100644
index 000000000000..0c8a99f7959d
--- /dev/null
+++ b/drivers/crypto/allwinner/Kconfig
@@ -0,0 +1,6 @@
+config CRYPTO_DEV_ALLWINNER
+	bool "Support for Allwinner cryptographic offloader"
+	depends on ARCH_SUNXI || COMPILE_TEST
+	default y if ARCH_SUNXI
+	help
+	  Say Y here to get to see options for Allwinner hardware crypto devices
-- 
2.21.0

