Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F48BC4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6D02087E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ai4h+lWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfJLStA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54826 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfJLStA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so13347338wmp.4;
        Sat, 12 Oct 2019 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sB0Ndx4jYFX7LXfHmgIgjA6IVb29KxMOBWd5xPd93L4=;
        b=ai4h+lWG11c7vxSxMfkuS4qmoLueicww398ddr4aH0fMp8TcMvDH3PEBesbwv5Air2
         VunOBxb13WA2HdtTec0UP5rjcPiOfvcanMydHu53ZJzw9v1G1UvaNmEnDWKgVbj2c6vu
         ZJBMxc2TiwXy4SOHECTCNlw+sEb13xXax56xn2Q4nWF3Kgdb8mUQdaHn7dYHGcEQ8YWD
         cHRvD6vQN+4VEk0wnXe3VZ4k+Uc4v5qZfQ1rAKlNU0irhRE32fqviPKBkshpKVjw8zoF
         N6KhXKB2Kj4HF4SRezZ+G++N++u4pDNTtySqov4hgu6PDe2L2wYUbs9cqxuNqmWeybgB
         brew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sB0Ndx4jYFX7LXfHmgIgjA6IVb29KxMOBWd5xPd93L4=;
        b=Ibb5cW0WeS7gjVmyHikKKx8gUu4j7TZUGxXdHvgYbsuInwXSGWD4eBJ0iD3DZwn8fE
         h1qvxEj5l9Tr0jv9EP6wL8igU6khSqwTvYphXQaHbUiJs/0QWG+fa/l6pYDPkH9KC7N+
         fRozqWWN6ldR9MLhc/tCu+pCNIyyFtYim+YJGJThMPJBTQmziWC5WWOCBFcThluXdlNI
         NbNTueHl5WRYhdwQEI/nGSM0I+BtDkye5ywWLwpaLkXbUEEK0/0ODYbrVdhUxFJHBIGT
         Jp7Nyna4mkxLcWMoXivmSPbxO75L6bP5caf3vKmeGU2SLpO0rblvtRw92/oYQrhEgA91
         KhPw==
X-Gm-Message-State: APjAAAVSlAFpYfbV4HLp/AxMukPPjkPtErHlAxUV3lXMBh06VsiPODpt
        1KAXor1qOw/WoKn3ZOQ6rnQ=
X-Google-Smtp-Source: APXvYqzqFg5v+H5w4CQbJP2InxUgGscus7OJ/bRqm3MXIrgpOwTSlGMbK6bRDDwV1Og++X6hwotY9A==
X-Received: by 2002:a7b:c924:: with SMTP id h4mr8384649wml.46.1570906138007;
        Sat, 12 Oct 2019 11:48:58 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:48:57 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 01/11] crypto: Add allwinner subdirectory
Date:   Sat, 12 Oct 2019 20:48:42 +0200
Message-Id: <20191012184852.28329-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
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
index 3d09efe69508..78bc109aba98 100644
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

