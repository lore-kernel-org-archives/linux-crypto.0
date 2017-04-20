From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 9/9] MAINTAINERS: add Gilad BY as ccree maintainer
Date: Thu, 20 Apr 2017 16:13:03 +0300
Message-ID: <1492693983-8175-10-git-send-email-gilad@benyossef.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, gilad.benyossef@arm.com,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I work for Arm on maintaining the TrustZone CryptoCell driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 676c139..f21caa1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3066,6 +3066,13 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
+CCREE ARM TRUSTZONE CRYPTOCELL 700 REE DRIVER
+M:	Gilad Ben-Yossef <gilad@benyossef.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/staging/ccree/
+W:	https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
+
 CEC DRIVER
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
-- 
2.1.4
