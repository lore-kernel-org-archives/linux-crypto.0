From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 05/10] ARM: dts: omap3 hs: Remove timer12
Date: Thu, 26 Feb 2015 14:49:55 +0100
Message-ID: <1424958600-18881-6-git-send-email-pali.rohar@gmail.com>
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

Device timer12 is automatically disabled on all HS devices via DTS prop=
erty
"ti,timer-secure" in file omap3.dtsi so it can be safely removed. We do=
 not
need to disable it on another place.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/boot/dts/omap34xx-hs.dtsi |    4 ----
 arch/arm/boot/dts/omap36xx-hs.dtsi |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/omap34xx-hs.dtsi b/arch/arm/boot/dts/oma=
p34xx-hs.dtsi
index 1ff6264..d4be302 100644
--- a/arch/arm/boot/dts/omap34xx-hs.dtsi
+++ b/arch/arm/boot/dts/omap34xx-hs.dtsi
@@ -10,7 +10,3 @@
 &sham {
 	status =3D "disabled";
 };
-
-&timer12 {
-	status =3D "disabled";
-};
diff --git a/arch/arm/boot/dts/omap36xx-hs.dtsi b/arch/arm/boot/dts/oma=
p36xx-hs.dtsi
index 2c7febb..e93ff8d 100644
--- a/arch/arm/boot/dts/omap36xx-hs.dtsi
+++ b/arch/arm/boot/dts/omap36xx-hs.dtsi
@@ -10,7 +10,3 @@
 &sham {
 	status =3D "disabled";
 };
-
-&timer12 {
-	status =3D "disabled";
-};
--=20
1.7.9.5
