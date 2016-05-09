From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2 8/8] arm64: dts: ls1043a: add crypto node
Date: Mon, 9 May 2016 08:28:38 +0000
Message-ID: <AM2PR04MB067369B10B1C4A2848C265DC98700@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
 <1462462617-28153-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingkai Hu <mingkai.hu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh+dt@kernel.org>,
	Olof Johansson <olof@lixom.net>,
	Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+Shawn

On 5/5/2016 6:39 PM, Horia Geant=E3 wrote:
> LS1043A has a SEC v5.4 security engine.
> For now don't add rtic or sec_mon subnodes, since these features
> haven't been tested yet.
>=20
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>

Shawn,

IIUC, you are the de facto maintainer of arch/arm64/boot/dts/freescale
entry, thus adding you to the loop.
I'd like to get the Ack for this patch.

As stated in the cover letter: https://lkml.org/lkml/2016/5/5/340
my intent is to go with the whole patch set via cryptodev-2.6 tree.

Thanks,
Horia

> ---
>  arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |  4 +++
>  arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi    | 43 +++++++++++++=
++++++++++
>  2 files changed, 47 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts b/arch=
/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> index ce235577e90f..9b5b75a4f02a 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> @@ -49,6 +49,10 @@
> =20
>  / {
>  	model =3D "LS1043A RDB Board";
> +
> +	aliases {
> +		crypto =3D &crypto;
> +	};
>  };
> =20
>  &i2c0 {
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi b/arch/ar=
m64/boot/dts/freescale/fsl-ls1043a.dtsi
> index be72bf5b58b5..529c198494d5 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
> @@ -159,6 +159,49 @@
>  			big-endian;
>  		};
> =20
> +		crypto: crypto@1700000 {
> +			compatible =3D "fsl,sec-v5.4", "fsl,sec-v5.0",
> +				     "fsl,sec-v4.0";
> +			fsl,sec-era =3D <3>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			ranges =3D <0x0 0x00 0x1700000 0x100000>;
> +			reg =3D <0x00 0x1700000 0x0 0x100000>;
> +			interrupts =3D <0 75 0x4>;
> +
> +			sec_jr0: jr@10000 {
> +				compatible =3D "fsl,sec-v5.4-job-ring",
> +					     "fsl,sec-v5.0-job-ring",
> +					     "fsl,sec-v4.0-job-ring";
> +				reg	   =3D <0x10000 0x10000>;
> +				interrupts =3D <0 71 0x4>;
> +			};
> +
> +			sec_jr1: jr@20000 {
> +				compatible =3D "fsl,sec-v5.4-job-ring",
> +					     "fsl,sec-v5.0-job-ring",
> +					     "fsl,sec-v4.0-job-ring";
> +				reg	   =3D <0x20000 0x10000>;
> +				interrupts =3D <0 72 0x4>;
> +			};
> +
> +			sec_jr2: jr@30000 {
> +				compatible =3D "fsl,sec-v5.4-job-ring",
> +					     "fsl,sec-v5.0-job-ring",
> +					     "fsl,sec-v4.0-job-ring";
> +				reg	   =3D <0x30000 0x10000>;
> +				interrupts =3D <0 73 0x4>;
> +			};
> +
> +			sec_jr3: jr@40000 {
> +				compatible =3D "fsl,sec-v5.4-job-ring",
> +					     "fsl,sec-v5.0-job-ring",
> +					     "fsl,sec-v4.0-job-ring";
> +				reg	   =3D <0x40000 0x10000>;
> +				interrupts =3D <0 74 0x4>;
> +			};
> +		};
> +
>  		dcfg: dcfg@1ee0000 {
>  			compatible =3D "fsl,ls1043a-dcfg", "syscon";
>  			reg =3D <0x0 0x1ee0000 0x0 0x10000>;
>=20
