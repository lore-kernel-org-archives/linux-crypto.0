From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 08/10] ARM: dts: n900: Enable omap sham and include directly omap34xx.dtsi
Date: Thu, 26 Feb 2015 14:49:58 +0100
Message-ID: <1424958600-18881-9-git-send-email-pali.rohar@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch moves content of file omap34xx-hs.dtsi into omap3-n900.dts a=
nd enable
omap sham support (omap HW support for SHA + MD5). After testing both o=
map hwmod
and omap-sham.ko drivers it looks like signed Nokia X-Loader enable L3 =
firewall
for omap sham. There is no kernel crash with both official bootloader a=
nd crypto
enable bootloader. So we can safely enable sham code.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/boot/dts/omap3-n900.dts |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3=
-n900.dts
index d16aa9c..10d5305 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -9,9 +9,23 @@
=20
 /dts-v1/;
=20
-#include "omap34xx-hs.dtsi"
+#include "omap34xx.dtsi"
 #include <dt-bindings/input/input.h>
=20
+/*
+ * Default secure signed bootloader (Nokia X-Loader) does not enable L=
3 firewall
+ * for omap AES HW crypto support. When linux kernel try to access mem=
ory of AES
+ * blocks then kernel receive "Unhandled fault: external abort on non-=
linefetch"
+ * and crash. Until somebody fix omap-aes.c and omap_hwmod_3xxx_data.c=
 code (no
+ * crash anymore) omap AES support will be disabled for all Nokia N900=
 devices.
+ * There is "unofficial" version of bootloader which enables AES in L3=
 firewall
+ * but it is not widely used and to prevent kernel crash rather AES is=
 disabled.
+ * There is also no runtime detection code if AES is disabled in L3 fi=
rewall...
+ */
+&aes {
+	status =3D "disabled";
+};
+
 / {
 	model =3D "Nokia N900";
 	compatible =3D "nokia,omap3-n900", "ti,omap3430", "ti,omap3";
--=20
1.7.9.5
