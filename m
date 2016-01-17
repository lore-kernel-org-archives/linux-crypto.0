From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH 4/4] hw_random: brcm63xx-rng: document device tree bindings
Date: Sun, 17 Jan 2016 10:03:57 +0100
Message-ID: <1453021437-12531-4-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	f.fainelli@gmail.com, jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34586 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbcAQJDf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2016 04:03:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Documents device tree bindings for random number generator present on B=
roadcom
BCM6368 SoC.

Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
---
 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt | 17 ++++++++++=
+++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.=
txt

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm6368.txt b/D=
ocumentation/devicetree/bindings/rng/brcm,bcm6368.txt
new file mode 100644
index 0000000..4b5ac60
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
@@ -0,0 +1,17 @@
+BCM6368 Random number generator
+
+Required properties:
+
+- compatible : should be "brcm,bcm6368-rng"
+- reg : Specifies base physical address and size of the registers
+- clocks : phandle to clock-controller plus clock-specifier pair
+- clock-names : "ipsec" as a clock name
+
+Example:
+	random: rng@10004180 {
+		compatible =3D "brcm,bcm6368-rng";
+		reg =3D <0x10004180 0x14>;
+
+		clocks =3D <&periph_clk 18>;
+		clock-names =3D "ipsec";
+	};
--=20
1.9.1
