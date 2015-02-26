From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 00/10] omap3 crypto fixes
Date: Thu, 26 Feb 2015 14:49:50 +0100
Message-ID: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch series fix crypto support for omap3 devices which use DT.

It enables AES and SHAM on N9/N950 and SHAM on N900. AES is still disab=
led for N900.

Pali Roh=C3=A1r (10):
  ARM: OMAP2+: Return correct error values from device and hwmod
  ARM: OMAP3: Fix crypto support for HS devices
  crypto: omap-sham: Add support for omap3 devices
  crypto: omap-sham: Check for return value from pm_runtime_get_sync
  ARM: dts: omap3 hs: Remove timer12
  ARM: dts: omap3: Add missing dmas for crypto
  ARM: dts: n9/n950: Enable omap crypto support
  ARM: dts: n900: Enable omap sham and include directly omap34xx.dtsi
  ARM: dts: omap3-tao3530: Include directly omap34xx.dtsi
  ARM: dts: Remove files omap34xx-hs.dtsi and omap36xx-hs.dtsi

 arch/arm/boot/dts/omap3-n900.dts           |   16 +++++-
 arch/arm/boot/dts/omap3-n950-n9.dtsi       |    2 +-
 arch/arm/boot/dts/omap3-tao3530.dtsi       |   11 +++-
 arch/arm/boot/dts/omap3.dtsi               |    4 ++
 arch/arm/boot/dts/omap34xx-hs.dtsi         |   16 ------
 arch/arm/boot/dts/omap36xx-hs.dtsi         |   16 ------
 arch/arm/mach-omap2/omap_device.c          |   30 ++++++-----
 arch/arm/mach-omap2/omap_hwmod.c           |   10 ++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   79 ++++++++++++++++++++=
+++-----
 drivers/crypto/omap-sham.c                 |   13 ++++-
 10 files changed, 131 insertions(+), 66 deletions(-)
 delete mode 100644 arch/arm/boot/dts/omap34xx-hs.dtsi
 delete mode 100644 arch/arm/boot/dts/omap36xx-hs.dtsi

--=20
1.7.9.5
