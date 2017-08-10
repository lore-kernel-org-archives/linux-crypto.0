From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH 10/10] arm64: defconfig: enable CAAM crypto engine on QorIQ DPAA2 SoCs
Date: Thu, 10 Aug 2017 20:42:53 +0300
Message-ID: <20170810174253.20951-11-horia.geanta@nxp.com>
References: <20170810174253.20951-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devel@driverdev.osuosl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0073.outbound.protection.outlook.com ([104.47.41.73]:46016
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753004AbdHJRoC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 13:44:02 -0400
In-Reply-To: <20170810174253.20951-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable CAAM (Cryptographic Accelerator and Assurance Module) driver
for QorIQ Data Path Acceleration Architecture (DPAA) v2.
It handles DPSECI (Data Path SEC Interface) DPAA2 objects that sit
on the Management Complex (MC) fsl-mc bus.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 6c7d147eed54..43455ad6fff5 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -561,6 +561,7 @@ CONFIG_MEMTEST=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_ANSI_CPRNG=y
+CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=y
 CONFIG_ARM64_CRYPTO=y
 CONFIG_CRYPTO_SHA1_ARM64_CE=y
 CONFIG_CRYPTO_SHA2_ARM64_CE=y
-- 
2.12.0.264.gd6db3f216544
