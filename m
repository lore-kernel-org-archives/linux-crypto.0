From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH 12/12] ARM: imx_v6_v7_defconfig: Select CAAM
Date: Wed, 29 Jul 2015 20:58:29 -0700
Message-ID: <1438228709-27650-13-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:6064
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbbG3D6l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2015 23:58:41 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Select CAAM for i.MX6 devices.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index b47863d..7569b39 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -354,8 +354,7 @@ CONFIG_PROVE_LOCKING=y
 # CONFIG_FTRACE is not set
 # CONFIG_ARM_UNWIND is not set
 CONFIG_SECURITYFS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
-# CONFIG_CRYPTO_HW is not set
+CONFIG_CRYPTO_DEV_FSL_CAAM=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC_T10DIF=y
 CONFIG_CRC7=m
-- 
2.1.4
