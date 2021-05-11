Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FA1C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19430613CD
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhEKNao (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 09:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNan (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 09:30:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6579BC061574
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:37 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m11so12205570lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yoz2GWLVoP/LmN8U8yqLyJhrZcQ/cFUl8VArRwTIYzs=;
        b=U0mCBlAvEGT030WD7J5uzq/oKj8uV+C8GhSf/oJ6RwvJzPt588HE0g+nids5SDQzoE
         S+XavvYkHcCRy4Jnd9toYhETpAbuCiS6PE5KMHYhe4rUfFXURr4p5TKajWmqZ2cEskgV
         nL/OeJL7LK4IDaQ+11xviByB5+GZnn6iQ4rqAVveL6oViHod1XfxJo68IP62/co4+Mf5
         ev49FCL2xQeWRwl17WMHIiGOjk3Ir9WCaQRM8IL03pTR6ANGxNn0ILc42CzK+GyFF3Hf
         3BioGL36IQJjJo38Hvt7sd8VcLbVHFZEgdaGZh0+SmciRrR1q3A2cmuP7u+tpygTZ45J
         u/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yoz2GWLVoP/LmN8U8yqLyJhrZcQ/cFUl8VArRwTIYzs=;
        b=EBZsJaiiZM419093y2DnphjDQBeuDkDrZRQpnuPfD3Bu3KixkedXEPuIfbkhCO6pDH
         xl8zOOrTCjDffw/F0fkGQr3bJlZzKDVygMAR8VVKe8zrOnJodsrODaEkBJHW98Y3UI20
         lMBm9s50OUg0anEP2Bj2IktxoOLjAqmN4fKeAHuULwbqOyFccUXEUR9BrTMVTaeFID15
         3m4TIjJyI6Sz4ahoH4mbLnjysPMtNsk9hyHKMzlBHRl3EMFhx2iW9vXXbGIgKFIwX2+t
         E2QVClycYSEFvSbmE8MVxTFw2sMGJp93P8aP897TOiNCgPtIqB9sVkzuHI7KFmnS9ieF
         GbiQ==
X-Gm-Message-State: AOAM530uW0EqTHL/veJDYTy3rqJgvpMjeUahmVdVt++i2NJ0vKOnVPvh
        s0MCUDLdbVMkDxV9uA2QP9SLOg==
X-Google-Smtp-Source: ABdhPJykr1In1BcO7q93EKLY6PvMotH1K0CewY1k7kOI81hmCjQR9oudiIRz12jtmsCRVzLR0VhDLw==
X-Received: by 2002:a19:7604:: with SMTP id c4mr19610763lff.627.1620739775855;
        Tue, 11 May 2021 06:29:35 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m4sm3699740ljc.20.2021.05.11.06.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:29:35 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Deepak Saxena <dsaxena@plexity.net>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/5] hw_random: ixp4xx: enable compile-testing
Date:   Tue, 11 May 2021 15:29:24 +0200
Message-Id: <20210511132928.814697-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver is almost portable already, it just needs to
include the new header for the cpu definition.

Cc: Deepak Saxena <dsaxena@plexity.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The idea is to apply this through the ARM SoC tree along
with other IXP4xx refactorings.
Please tell me if you prefer another solution.
---
 drivers/char/hw_random/Kconfig      | 2 +-
 drivers/char/hw_random/ixp4xx-rng.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1fe006f3f12f..f033a11cc90d 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -152,7 +152,7 @@ config HW_RANDOM_VIA
 
 config HW_RANDOM_IXP4XX
 	tristate "Intel IXP4xx NPU HW Pseudo-Random Number Generator support"
-	depends on ARCH_IXP4XX
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Pseudo-Random
diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index beec1627db3c..34781028caec 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -21,10 +21,9 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/hw_random.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 #include <asm/io.h>
-#include <mach/hardware.h>
-
 
 static int ixp4xx_rng_data_read(struct hwrng *rng, u32 *buffer)
 {
-- 
2.30.2

