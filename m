From: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/3] ARM: dts: mxs: set dcp to "disabled" by default
Date: Mon, 12 Aug 2013 19:05:26 +0800
Message-ID: <20130812110523.GD25292@S2101-09.ap.freescale.net>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
 <1375968629-10091-2-git-send-email-LW@KARO-electronics.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
 Rob Herring <rob.herring@calxeda.com>, linux-crypto@vger.kernel.org,
 Tobias Rauter <tobiasrauter@gmail.com>, linux-arm-kernel@lists.infradead.org
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1375968629-10091-2-git-send-email-LW@KARO-electronics.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 08, 2013 at 03:30:27PM +0200, Lothar Wa=DFmann wrote:
> Reintroduce 'status =3D "disabled"' for the dcp node that was dropped by
> commit 519d8b1a "Added support for Freescale's DCP co-processor".

For IP blocks that do not have pins to be routed on boards, it should be
fine to have it enabled in <soc>.dtsi.

Shawn

> =

> Explicitly enable it in imx28-evk which is referenced in the commit
> message of that commit.
> =

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  arch/arm/boot/dts/imx28-evk.dts |    4 ++++
>  arch/arm/boot/dts/imx28.dtsi    |    3 ++-
>  2 files changed, 6 insertions(+), 1 deletions(-)
> =

> diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-ev=
k.dts
> index dff2279..ac790bb 100644
> --- a/arch/arm/boot/dts/imx28-evk.dts
> +++ b/arch/arm/boot/dts/imx28-evk.dts
> @@ -361,3 +361,7 @@
>  		default-brightness-level =3D <6>;
>  	};
>  };
> +
> +&dcp {
> +	status =3D "okay";
> +};
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index e459d63..ea99d09 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -794,9 +794,10 @@
>  			};
>  =

>  			dcp: dcp@80028000 {
> +				compatible =3D "fsl-dcp";
>  				reg =3D <0x80028000 0x2000>;
>  				interrupts =3D <52 53 54>;
> -				compatible =3D "fsl-dcp";
> +				status =3D "disabled";
>  			};
>  =

>  			pxp: pxp@8002a000 {
> -- =

> 1.7.2.5
> =

> =

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
