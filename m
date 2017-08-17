From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 6/6] crypto: jz4780-rng: Enable PRNG support in CI20 defconfig
Date: Thu, 17 Aug 2017 23:55:20 +0530
Message-ID: <20170817182520.20102-7-prasannatsmkumar@gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38082 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdHQS0e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:26:34 -0400
Received: by mail-pg0-f67.google.com with SMTP id 123so11058502pga.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2017 11:26:34 -0700 (PDT)
In-Reply-To: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable PRNG driver support in MIPS Creator CI20 default config.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 arch/mips/configs/ci20_defconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
index b42cfa7..9f48f2c 100644
--- a/arch/mips/configs/ci20_defconfig
+++ b/arch/mips/configs/ci20_defconfig
@@ -88,6 +88,11 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=5
 CONFIG_SERIAL_8250_INGENIC=y
 CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
+CONFIG_CRYPTO_USER=y
+CONFIG_CRYPTO_USER_API=y
+CONFIG_CRYPTO_USER_API_RNG=y
+CONFIG_CRYPTO_HW=y
+CONFIG_CRYPTO_DEV_JZ4780_RNG=y
 CONFIG_I2C=y
 CONFIG_I2C_JZ4780=y
 CONFIG_GPIO_SYSFS=y
-- 
2.10.0
