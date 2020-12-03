Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9FBC4361A
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 23:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7640223E8
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 23:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgLCXVH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:21:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgLCXVH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Dec 2020 18:21:07 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Keerthy <j-keerthy@ti.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-i2c - select CONFIG_BITREVERSE
Date:   Fri,  4 Dec 2020 00:20:04 +0100
Message-Id: <20201203232022.1485386-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The bitreverse helper is almost always built into the kernel,
but in a rare randconfig build it is possible to hit a case
in which it is a loadable module while the atmel-i2c driver
is built-in:

arm-linux-gnueabi-ld: drivers/crypto/atmel-i2c.o: in function `atmel_i2c_checksum':
atmel-i2c.c:(.text+0xa0): undefined reference to `byte_rev_table'

Add one more 'select' statement to prevent this.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6a02ab13835c..67a17644ce17 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -550,6 +550,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_ATMEL_I2C
 	tristate
+	select BITREVERSE
 
 config CRYPTO_DEV_ATMEL_ECC
 	tristate "Support for Microchip / Atmel ECC hw accelerator"
-- 
2.27.0

