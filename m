Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD77CA9EB9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3266B2086D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQu7jlUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404470AbfJWUFW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51665 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbfJWUFV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id q70so282451wme.1;
        Wed, 23 Oct 2019 13:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VpdEp2zf81VBM+LhkWglZ2eMDIpA3da8iXPWPqvvAdE=;
        b=iQu7jlUIO+uRonAxUB1Yx/zCvI7R9gqlIv6hs5hMa10GoZ9yMocX6c8lzjgiiROvGC
         5IgEt+kBt6COaVuTTZTGS/F4QmaItAyvKlgheV1AGOe1K0uS7j7wPdMIKk1bRxbm2kdP
         jLbpQ0ksy4rlQTR6QtsKKR/s9X09TZL+1JY4+Kz/nuZgA/Qlsbdlrqsu21/WVXGwSmvM
         45M+z+SV3g2kYXAL69simQkHrA+ZpIbn6bZDcFbzPGtDBO4AprqSQKJ3Y2+GpQHhgQni
         B5QPBz93lpzs25cyEmZ6LVuUTUrT65vJll93p1oXZB7Hasuvcqqv3fQHFiQ5nayK+Icn
         h2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VpdEp2zf81VBM+LhkWglZ2eMDIpA3da8iXPWPqvvAdE=;
        b=VZ8su123BBtgHh6gYJ2aodVC4COcIGF2zV+LuKh3Q2fcqFcedVl9ow32M9/JiU0fwP
         tBav2xIwXo8a2wfZ8mtHThjH1hsIBBnleULsjiNmo7ddCRS67p9IMyA0UXqiNWdV/cT/
         memSnN7CtL4LwfhKRScXr4UFKksQeUyzkQcGYGe9SIZEe1GoE4tW4CbMmIdYeGbx8AF5
         m++5Wx4KL2xdddV8qrXBjLtn54PwBOZ28CviqSySX23VtGSBPym5mx8WpTYgmut0k/Rk
         gu/vghH3nd8dmc6ZE35CQDv9R9DBQljq+qjqL0BRi42cRMyaXLypGQlnVlZdXcPaTVt2
         obrw==
X-Gm-Message-State: APjAAAV9Btr3/ks8tsPrqQ99p8uyXBmEEUFj0gdxtyNBX/WgpMW+qt1Q
        /B08YMx+vlYRLwnt54FyNLc=
X-Google-Smtp-Source: APXvYqxxeKv8ZV8kF3ro0l6Hkz0Ty5HtJhHnoM3Ces69iywJZZQaO+/q3FvG/DVd/Ct8Lc2VMML6wQ==
X-Received: by 2002:a1c:9dd3:: with SMTP id g202mr1532122wme.43.1571861119604;
        Wed, 23 Oct 2019 13:05:19 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:19 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 01/11] crypto: Add allwinner subdirectory
Date:   Wed, 23 Oct 2019 22:05:03 +0200
Message-Id: <20191023200513.22630-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
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

