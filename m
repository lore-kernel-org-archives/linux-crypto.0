From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 7/7] arm64: defconfig: enable the Safexcel crypto engine as a module
Date: Wed, 29 Mar 2017 14:44:32 +0200
Message-ID: <20170329124432.27457-8-antoine.tenart@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36300 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbdC2Mop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:45 -0400
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Safexcel EIP197 cryptographic engine is used on some Marvell SoCs,
such as Armada 7040 and Armada 8040. Enable this driver as a module in
the ARM64 defconfig.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index fece4d3c2095..76308fa2fa7a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -519,6 +519,7 @@ CONFIG_MEMTEST=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_ANSI_CPRNG=y
+CONFIG_CRYPTO_DEV_SAFEXCEL=m
 CONFIG_ARM64_CRYPTO=y
 CONFIG_CRYPTO_SHA1_ARM64_CE=y
 CONFIG_CRYPTO_SHA2_ARM64_CE=y
-- 
2.11.0
