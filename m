Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D60BC43140
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13916208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VliEAdMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395361AbfIFSqH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53010 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390567AbfIFSqG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id t17so7513944wmi.2;
        Fri, 06 Sep 2019 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVVsUJ3cqxC7B0N9mD/oVG/ysz/2hMqLEdaltl6/SKo=;
        b=VliEAdMqXCZEuavCqjEh6OTr7ebBnxrMGNbDl2ershs4s/Nu3eg5EQbTh3IHq1RrYU
         6sjfvjcrb8dH+OW8JTbCr0hZ4zVdMvWooEFD5JQBPoi3B5+8FyIkdGspxnf2/Y34eaJe
         wnT6Qj4WdcFJN1CKgrGjZQBghzuxkv/M5kPlNttWstId/gDVxTWjGtCwY2Pqjyi0fro4
         1BtmmF4req7lbyPrLe/cjkdWNBaqTNUl/rTZZPIOX0vx/ssFR7CtsDgbN42TRjuKCqXH
         Msieu8Zh8UulkL+6NTZhiqPzAyauh7tIEkHGb4EeOOH2pw/3hIxzEjH823o38S/Psu4M
         jd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVVsUJ3cqxC7B0N9mD/oVG/ysz/2hMqLEdaltl6/SKo=;
        b=TZ1VCnOpOyUhT2bBEONwZGKBmiRFFShuIPNO25YTFhlEDyjwvPblsGW43AEMT85fU9
         Ffnz+KIb86lojLKLysJWd4kGOo3mUMbZf+FPPD9liS4d3I9hKE2TppCNNIZZ1FcLfj3e
         2w4b62T6OGaBm4flL+kihL7MlxTgKM6AOM1jzSYyhXDnAgl1YtoUkj+icvQWntd7DXMV
         jh3m/wIEz10r9xGnTiSjwdJBywGTDvSFutyLrKFGgkh2RfK9Ze+Dx8qJ5GgoQ6O2U38H
         mDDRgB8CKlKSQ0SDcCVK7d5MK85c1QsA9S3cH7Sj10ScR/GvFuf8YQTnU11Z9vRU3ZcI
         yNGA==
X-Gm-Message-State: APjAAAVauUCZJAXoEYIxAvCZ9pdY2/hzqQK/qISV1szYxrYFuyaO7lEl
        gSoP8PUXuZB6PNaQwTIye0E=
X-Google-Smtp-Source: APXvYqyjrzRBxxj7tYzXaXaxio1nphXp3XWOYZgyMvwziBQzHIPj2h/NUODsCwcJ/4g0/R25PDbU+Q==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr8434773wme.115.1567795564198;
        Fri, 06 Sep 2019 11:46:04 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:03 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/9] crypto: Add allwinner subdirectory
Date:   Fri,  6 Sep 2019 20:45:43 +0200
Message-Id: <20190906184551.17858-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
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
index ee4e873c0f9a..d62ddf8ff262 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -681,6 +681,12 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/sunxi-ss/
 
+ALLWINNER CRYPTO ENGINE
+M:	Corentin Labbe <clabbe.montjoie@gmail.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/allwinner/
+
 ALLWINNER VPU DRIVER
 M:	Maxime Ripard <mripard@kernel.org>
 M:	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 83271d944a96..fe90dd74797c 100644
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

