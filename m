Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCB4C352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 950632133F
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="owxqV1/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfJASlx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:41:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56134 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfJASlv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:41:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so4474849wma.5;
        Tue, 01 Oct 2019 11:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r8xpuMhi21iVWONxJYeHpdefSztrX4ydrJ/PhCWl0DE=;
        b=owxqV1/0ykA4HmzaUn70Wgdw5WXMv+V9vcknKjJi+JeUc7lT7Z740VTNnxZBq9XyKc
         MKq2ZCQhZFErC8TDKCJMMcmLOz+vr3zdcWL4TnzCPtFybpg0wbDlBSGY3UdN5H2zRjnD
         6ewHXATaeIs87g7SV6QCMrel+7KeJE6r2IKQsLh4KcmkrN3ppQzYD2svnasZ4wlibJgf
         j8YCPsmf7rOSpiG3O7/7qlLBe/YHp4JBcwGREqt1BiAdViFyqOSgheWSvgi+B4pbtLt8
         Rb4NHjW4H2Ac//4TNpZAdfbXPSGgbWNqB3nXIwhknQ81r58c7KAd6H63dHylsYe+YDHg
         K2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r8xpuMhi21iVWONxJYeHpdefSztrX4ydrJ/PhCWl0DE=;
        b=T0DoFqlGqeVgpfuz08pSyYYiiWHuCW0GFZJ3ApwJ3QrSGoVjrRHgU8ofAQX5B63HrD
         UYPkRKSvB+X/BpETvqs6PzwrS8cdo9EfgyzwIfl7o64fIa8DBOq5nz8CV1oMg9yVsi3I
         5q+6IHy0x8J0pm+ycjh/Y/ls306xhnrlWAdQO2mKTNKQ+ZCN+aKsdTYHCb5JkL5QpncB
         vVXxuKIXYm0z8WLQhD6M9HTLikbePRCFGyS6Ctcj87Xl5p73I6IRnHc/OkvWfhbqZ32D
         jivL2AG8uqkLWi6F2E/axOiQAjQsxi8vMUTC4lfhyqHyCbnq5sKEDz0AhU667n/K+Iz/
         dymA==
X-Gm-Message-State: APjAAAVG/QrzwLAQHs/J8HwgEwVic2kFVxumaS+gr7i5wL4CjQDoZNhE
        YYizCf0rg9cCJ4ZUG7yr+fI=
X-Google-Smtp-Source: APXvYqywxyc9UUlGYOPnrBYHs3aZoIRbuKn1osBpPjhuIiV/Diqwnaal9RDjo7CgPu1+SBj2cvqUUw==
X-Received: by 2002:a05:600c:2049:: with SMTP id p9mr4889336wmg.30.1569955308715;
        Tue, 01 Oct 2019 11:41:48 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:47 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 01/11] crypto: Add allwinner subdirectory
Date:   Tue,  1 Oct 2019 20:41:31 +0200
Message-Id: <20191001184141.27956-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
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
index 3b3766cccd90..db4fd4124ce8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -688,6 +688,12 @@ L:	linux-crypto@vger.kernel.org
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
index 571de87935e5..a1d0c69fb837 100644
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

