From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 10/10] ARM: dts: Remove files omap34xx-hs.dtsi and omap36xx-hs.dtsi
Date: Thu, 26 Feb 2015 14:50:00 +0100
Message-ID: <1424958600-18881-11-git-send-email-pali.rohar@gmail.com>
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

These files are not used by any DTS file anymore.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/boot/dts/omap34xx-hs.dtsi |   12 ------------
 arch/arm/boot/dts/omap36xx-hs.dtsi |   12 ------------
 2 files changed, 24 deletions(-)
 delete mode 100644 arch/arm/boot/dts/omap34xx-hs.dtsi
 delete mode 100644 arch/arm/boot/dts/omap36xx-hs.dtsi

diff --git a/arch/arm/boot/dts/omap34xx-hs.dtsi b/arch/arm/boot/dts/oma=
p34xx-hs.dtsi
deleted file mode 100644
index d4be302..0000000
--- a/arch/arm/boot/dts/omap34xx-hs.dtsi
+++ /dev/null
@@ -1,12 +0,0 @@
-/* Disabled modules for secure omaps */
-
-#include "omap34xx.dtsi"
-
-/* Secure omaps have some devices inaccessible depending on the firmwa=
re */
-&aes {
-	status =3D "disabled";
-};
-
-&sham {
-	status =3D "disabled";
-};
diff --git a/arch/arm/boot/dts/omap36xx-hs.dtsi b/arch/arm/boot/dts/oma=
p36xx-hs.dtsi
deleted file mode 100644
index e93ff8d..0000000
--- a/arch/arm/boot/dts/omap36xx-hs.dtsi
+++ /dev/null
@@ -1,12 +0,0 @@
-/* Disabled modules for secure omaps */
-
-#include "omap36xx.dtsi"
-
-/* Secure omaps have some devices inaccessible depending on the firmwa=
re */
-&aes {
-	status =3D "disabled";
-};
-
-&sham {
-	status =3D "disabled";
-};
--=20
1.7.9.5
