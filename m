From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 7/7] MAINTAINERS: update ccree entry
Date: Mon, 22 Jan 2018 09:27:05 +0000
Message-ID: <1516613230-4524-8-git-send-email-gilad@benyossef.com>
References: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55482 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbeAVJ2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 04:28:09 -0500
In-Reply-To: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update Arm TrustZone CryptoCell driver entry move into drivers/crypto/

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1082846..560e068 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3273,12 +3273,11 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
-CCREE ARM TRUSTZONE CRYPTOCELL 700 REE DRIVER
+CCREE ARM TRUSTZONE CRYPTOCELL REE DRIVER
 M:	Gilad Ben-Yossef <gilad@benyossef.com>
 L:	linux-crypto@vger.kernel.org
-L:	driverdev-devel@linuxdriverproject.org
 S:	Supported
-F:	drivers/staging/ccree/
+F:	drivers/crypto/ccree/
 W:	https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
 
 CEC FRAMEWORK
-- 
2.7.4
