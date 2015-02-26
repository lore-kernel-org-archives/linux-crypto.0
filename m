From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Thu, 26 Feb 2015 14:49:57 +0100
Message-ID: <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Harmattan system on Nokia N9 and N950 devices uses omap crypto support.
Bootloader on those devices is known that it enables HW crypto support.
This patch just include omap36xx.dtsi directly, so aes and sham is enab=
led.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/boot/dts/omap3-n950-n9.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/o=
map3-n950-n9.dtsi
index c41db94..800b379 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  */
=20
-#include "omap36xx-hs.dtsi"
+#include "omap36xx.dtsi"
=20
 / {
 	cpus {
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
