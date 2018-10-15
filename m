From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH v2 3/4] ARM: dts: imx6ull: Add dcp node
Date: Mon, 15 Oct 2018 13:27:38 +0000
Message-ID: <9365e24504896e58294fd8786acb3c3d4a1a264d.1539609921.git.leonard.crestez@nxp.com>
References: <cover.1539609921.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539609921.git.leonard.crestez@nxp.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The DCP block on 6ull has no major differences other than requiring
explicit clock enabling.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 arch/arm/boot/dts/imx6ull.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dts=
i
index 796ed35d4ac9..be610339e933 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -37,10 +37,20 @@
 			#address-cells =3D <1>;
 			#size-cells =3D <1>;
 			reg =3D <0x02200000 0x100000>;
 			ranges;
=20
+			dcp: dcp@2280000 {
+				compatible =3D "fsl,imx6ull-dcp", "fsl,imx28-dcp";
+				reg =3D <0x02280000 0x4000>;
+				interrupts =3D <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+				clocks =3D <&clks IMX6ULL_CLK_DCP_CLK>;
+				clock-names =3D "dcp";
+			};
+
 			iomuxc_snvs: iomuxc-snvs@2290000 {
 				compatible =3D "fsl,imx6ull-iomuxc-snvs";
 				reg =3D <0x02290000 0x4000>;
 			};
=20
--=20
2.17.1
