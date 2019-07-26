Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43216C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B5D22CE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6fDdG8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfGZNqj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:46:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35043 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388396AbfGZNqX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:46:23 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so53311447edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 06:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tNOuvm1U7rjJYTQqqmSPb+y7j9vdX9oul5uO5z40swI=;
        b=i6fDdG8d7h4qam7ozRVzHSTE/ii1gajl7UdWbStAsdyS29jXrVyDn+JAUUU2qeuxBm
         KLy0qcGv5T8zqM68Yf6veA9dvFYEqoDOGW9l4vJ058ML6qKUStrFohRYeK3ygQnSYzh/
         oKDeZ1imFIt8on1donC//i70w1sdyAVlbcnKZZ0pdl+b5mfh2NAzL2RpummB5YDxCZXU
         gF6NlMgKkpAo4OwHVqARdgCToIjMhIz1n4eO5R4NX8HvFF6IgOpkByrlkbL1ZtbB0Ubs
         5d5zmTvDreqyPZop+6g3FjZ398tioMwhLWjDlApOv9rTIip8Br3KDK+TS5neThR+HE9v
         HCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tNOuvm1U7rjJYTQqqmSPb+y7j9vdX9oul5uO5z40swI=;
        b=Nf69jeom645TdIOLVlUZZkV8L9jNjn25CXO892OGM02qNed6ww4Lx2Eg+IxuZnRfSv
         VgawDmr3bRzzqifO055w1HnE7Aso000gOIqElXuD7bbzb2EnkfPOPVfI51PqISWccmhs
         Mz1gmM1wjiFk1RpzdgSzWRMy+O7+CixMPdoiRzhtPul4v6GN5cVmpjQMrrqkklt62NB6
         RX5jHDVsEaJavoLvPTT0QSdQ4Im1fJM+2+8vN4S8jsvZ/9J1gbzPxOFKxaOdLF4FIuPI
         dcTpcddbHpU0MmW066ylOIhFrc+cFZSmvip6CUKFzNu0lSDT4C8ju7FCdseoc8sTsTWI
         /pKg==
X-Gm-Message-State: APjAAAWyY1KjhK/G8gF1wPSRFtWRJmqmUV3O/p3+FCzpCcwlu4Qg3O19
        oRstBpiEzMho1DVc7dYvxS1/CAl6
X-Google-Smtp-Source: APXvYqyJ8dYbgYq4VSp9LV0MmKpLR35s+6pz9P0FYQcGnisvYKMJb/rXf8y4f+EZwKtHogklgKvL+w==
X-Received: by 2002:a50:9107:: with SMTP id e7mr83267429eda.280.1564148781787;
        Fri, 26 Jul 2019 06:46:21 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 34sm14061423eds.5.2019.07.26.06.46.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 06:46:21 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 1/3] Kconfig: inside-secure - make driver selectable for non-Marvell hardware
Date:   Fri, 26 Jul 2019 14:43:23 +0200
Message-Id: <1564145005-26731-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While being a generic EIP97/EIP197 driver, the driver was only selectable
for Marvell Armada hardware. This fix makes the driver selectable for any
Device Tree supporting kernel configuration, allowing it to be used for
other compatible hardware by just adding the correct device tree entry.

It also allows the driver to be selected for PCI(E) supporting kernel con-
figurations, to be able to use it with PCIE based FPGA development boards
for pre-silicon driver development by both Inside Secure and its IP custo-
mers.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 67af688..0d9f67d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -716,8 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF
-	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
+	depends on OF || PCI || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
@@ -729,10 +728,11 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	help
-	  This driver interfaces with the SafeXcel EIP-197 cryptographic engine
-	  designed by Inside Secure. Select this if you want to use CBC/ECB
-	  chain mode, AES cipher mode and SHA1/SHA224/SHA256/SHA512 hash
-	  algorithms.
+	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
+	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
+	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
+	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
+	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.
 
 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
-- 
1.8.3.1

