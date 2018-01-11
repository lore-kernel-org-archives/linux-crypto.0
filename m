From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 7/7] MAINTAINERS: update ccree entry
Date: Thu, 11 Jan 2018 09:17:14 +0000
Message-ID: <1515662239-1714-8-git-send-email-gilad@benyossef.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
