From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 3/3] MAINTAINERS: add a maintainer for Microchip / Atmel ECC driver
Date: Wed, 5 Jul 2017 13:08:00 +0300
Message-ID: <1499249280-31779-4-git-send-email-tudor.ambarus@microchip.com>
References: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55120 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdGEKIQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2017 06:08:16 -0400
In-Reply-To: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A new cryptographic engine driver was added in
drivers/crypto/atmel-ecc.*.
Add myself as a maintainer for this driver.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a24eb8c..d55b983 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8464,6 +8464,12 @@ F:	drivers/dma/at_hdmac.c
 F:	drivers/dma/at_hdmac_regs.h
 F:	include/linux/platform_data/dma-atmel.h
 
+MICROCHIP / ATMEL ECC DRIVER
+M:	Tudor Ambarus <tudor.ambarus@microchip.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/atmel-ecc.*
+
 MICROCHIP / ATMEL ISC DRIVER
 M:	Songjun Wu <songjun.wu@microchip.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
