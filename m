Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738C0C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4824E20659
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cX0wvVg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfJJSXz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:23:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41271 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfJJSXz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:23:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id q9so9059212wrm.8;
        Thu, 10 Oct 2019 11:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GGIlOspffn6DYc5D1hGtXBrmMg1/47bL/Jvx1qS0/LI=;
        b=cX0wvVg7iddLcMKnmeNRuL8Dv2aRALY6WoGD5F+qjh8+HTZFWLpl0fDQGK3dq1Dkss
         KfXeEpEDxaQ6ejOCnGfn2f99Tlk6an1DUO0uGHlVlFPGhuDWPjVhWx1AUl/REZ9pk6PZ
         m5QpmnRPWHjfJ1wpb0O/TExYvO+Si8DdqSrANARi/Bi/oKRE9ziFxfr7CZ6MNLyePxi3
         YXAuxDhgcp6hr2xxBe6K6ZCwcFmHBjO4PhfBUoLnlksYS8bZSnmcUVypeFxfKXYKacf0
         TSRUI+O/UOsEWR8K5pvD8L+1PlYF2IqnLrW5B8MHXp1W93f0N56ozfQkqjPfLs4jccW/
         ld0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGIlOspffn6DYc5D1hGtXBrmMg1/47bL/Jvx1qS0/LI=;
        b=hNNeUTu3KRgsmlOukecnyg+Ss6gbvDb/gA4TlfLwATzzX5yWiVE4NrOGaxpF2wBXQG
         cZh8aXe/fidjilQr2kZ7E4Kq0v2sXcGZo6l83TNF8ngwB5t6Q/9jrgVhh33OAWkXhH+8
         s33uBXpVlajG3rbE/mcx9745SVQPXmNAqtvjTukd3XTPkixs7lp+1VQ1HXmvcqDdtwUq
         UUC13qzotUnyV6ebkYxRSOYe6zVMnsvYWTRFEjRRn3v1DbNRc0M2FlgXGpQQFYK2OCld
         PC32Nv+JIjHGw8oWxYyyj6/K9W10O4axC5a2Gr3amtgYvS7Pg09ZfE870LcSTBVX2hPk
         G8Ww==
X-Gm-Message-State: APjAAAWh08K7RU5E6Tch11ssdiZFZsU1PgSgM4jOxis+V5EeAOySpf04
        6WwNyeRwmWMAnslnf8K6gA8=
X-Google-Smtp-Source: APXvYqztZtmuRZwSa+qPLALhGbYA1g6wtJ74NxHoTswi30NlV4r2umdq7d9e9GDubqv4VNRW0OoUkQ==
X-Received: by 2002:a5d:65c1:: with SMTP id e1mr8292879wrw.364.1570731832362;
        Thu, 10 Oct 2019 11:23:52 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:23:51 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 01/11] crypto: Add allwinner subdirectory
Date:   Thu, 10 Oct 2019 20:23:18 +0200
Message-Id: <20191010182328.15826-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since a second Allwinner crypto driver will be added, it is better to
create a dedicated subdirectory.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 MAINTAINERS                      | 6 ++++++
 drivers/crypto/Kconfig           | 2 ++
 drivers/crypto/Makefile          | 1 +
 drivers/crypto/allwinner/Kconfig | 6 ++++++
 4 files changed, 15 insertions(+)
 create mode 100644 drivers/crypto/allwinner/Kconfig

diff --git a/MAINTAINERS b/MAINTAINERS
index c717b08934f6..ded0cb868b66 100644
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

