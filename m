Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FADC2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7DA61962
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhFYN3z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFYN3v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 09:29:51 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4EAC061574
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 06:27:30 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:1476:ce84:e216:add8])
        by laurent.telenet-ops.be with bizsmtp
        id MRTT250052B1U9901RTTh3; Fri, 25 Jun 2021 15:27:28 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lwlri-003Ts3-KN; Fri, 25 Jun 2021 15:27:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lwlri-004tGY-2x; Fri, 25 Jun 2021 15:27:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] crypto: CRYPTO_DEV_SL3516 should depend on ARCH_GEMINI
Date:   Fri, 25 Jun 2021 15:27:24 +0200
Message-Id: <20210625132724.1165706-2-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625132724.1165706-1-geert@linux-m68k.org>
References: <20210625132724.1165706-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The Storlink SL3516 crypto engine is only present on Storlink
Semiconductor/Storm Semiconductor/Cortina Systems Gemini SoCs.
Hence add a dependency on ARCH_GEMINI, to prevent asking the user about
this driver when configuring a kernel without Gemini support.

While at it, group the dependencies.

Fixes: 46c5338db7bd45b2 ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8796ddf37cb5bfde..51690e73153ad443 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -268,13 +268,13 @@ config CRYPTO_DEV_NIAGARA2
 
 config CRYPTO_DEV_SL3516
 	tristate "Storlink SL3516 crypto offloader"
-	depends on HAS_IOMEM
+	depends on ARCH_GEMINI || COMPILE_TEST
+	depends on HAS_IOMEM && PM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select HW_RANDOM
-	depends on PM
 	help
 	  This option allows you to have support for SL3516 crypto offloader.
 
-- 
2.25.1

