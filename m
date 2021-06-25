Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE180C2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86FFA6197B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhFYN3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhFYN3v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 09:29:51 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D07CC061766
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 06:27:30 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:1476:ce84:e216:add8])
        by laurent.telenet-ops.be with bizsmtp
        id MRTT250012B1U9901RTTh0; Fri, 25 Jun 2021 15:27:28 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lwlri-003Ts2-H9; Fri, 25 Jun 2021 15:27:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lwlri-004tGU-1e; Fri, 25 Jun 2021 15:27:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] crypto: Typo s/Stormlink/Storlink/
Date:   Fri, 25 Jun 2021 15:27:23 +0200
Message-Id: <20210625132724.1165706-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

According to Documentation/devicetree/bindings/arm/gemini.txt, the
company was originally named "Storlink Semiconductor", and later renamed
to "Storm Semiconductor".

Fixes: 46c5338db7bd45b2 ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/crypto/Kconfig                   | 2 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c | 2 +-
 drivers/crypto/gemini/sl3516-ce-core.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ebcec460c045734f..8796ddf37cb5bfde 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -267,7 +267,7 @@ config CRYPTO_DEV_NIAGARA2
 	  checksumming, and raw copies.
 
 config CRYPTO_DEV_SL3516
-	tristate "Stormlink SL3516 crypto offloader"
+	tristate "Storlink SL3516 crypto offloader"
 	depends on HAS_IOMEM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index b41c2f5fc495a856..c1c2b1d866639149 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * sl3516-ce-cipher.c - hardware cryptographic offloader for Stormlink SL3516 SoC
+ * sl3516-ce-cipher.c - hardware cryptographic offloader for Storlink SL3516 SoC
  *
  * Copyright (C) 2021 Corentin LABBE <clabbe@baylibre.com>
  *
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index da6cd529a6c01ff4..b7524b649068e980 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * sl3516-ce-core.c - hardware cryptographic offloader for Stormlink SL3516 SoC
+ * sl3516-ce-core.c - hardware cryptographic offloader for Storlink SL3516 SoC
  *
  * Copyright (C) 2021 Corentin Labbe <clabbe@baylibre.com>
  *
-- 
2.25.1

