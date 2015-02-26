From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 06/10] ARM: dts: omap3: Add missing dmas for crypto
Date: Thu, 26 Feb 2015 14:49:56 +0100
Message-ID: <1424958600-18881-7-git-send-email-pali.rohar@gmail.com>
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

This patch adds missing dma DTS definitions for omap aes and sham drive=
rs.
Without it kernel drivers do not work.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/boot/dts/omap3.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dts=
i
index 60e6d6b..6e8b58f 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -92,6 +92,8 @@
 			ti,hwmods =3D "aes";
 			reg =3D <0x480c5000 0x50>;
 			interrupts =3D <0>;
+			dmas =3D <&sdma 65 &sdma 66>;
+			dma-names =3D "tx", "rx";
 		};
=20
 		prm: prm@48306000 {
@@ -551,6 +553,8 @@
 			ti,hwmods =3D "sham";
 			reg =3D <0x480c3000 0x64>;
 			interrupts =3D <49>;
+			dmas =3D <&sdma 69>;
+			dma-names =3D "rx";
 		};
=20
 		smartreflex_core: smartreflex@480cb000 {
--=20
1.7.9.5
