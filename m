From: Neil Armstrong <narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] ARM64: dts: meson-gx: add clock CLKID_RNG0 to
 hwrng node
Date: Tue, 21 Feb 2017 13:20:44 -0800
Message-ID: <a80f9487-b385-b886-5a4c-e8f5da506b7f@baylibre.com>
References: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
 <8bf052e3-de8f-dbdf-be76-369a7bb1ed15@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jerome Brunet <jbrunet-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-amlogic-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Michael Turquette <mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8bf052e3-de8f-dbdf-be76-369a7bb1ed15-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 02/21/2017 12:18 PM, Heiner Kallweit wrote:
> Add clock CLKID_RNG0 to HW randon number generator node and
> extend the DT binding documentation accordingly.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> v2:
> - splitted first version of patch into two
> - add DT binding documentation

Hi Heiner,

Can you move the dt-bindings to a separate patch ?

> - mention that clock is optional
> - replace spaces with tabs in DT binding example
> ---
>  Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt | 8 ++++++--
>  arch/arm64/boot/dts/amlogic/meson-gx.dtsi                   | 2 +-
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi                 | 5 +++++
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
> index 202f2d09..4c012a04 100644
> --- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
> @@ -5,10 +5,14 @@ Required properties:
>  
>  - compatible : should be "amlogic,meson-rng"
>  - reg : Specifies base physical address and size of the registers.
> +- clocks : Optional core clock
> +- clock-names: Name of core clock, must be "core"

Please put these in a separate "Optional Properties" :

Optional Properties:
- clocks : phandle to the following named clocks
- clock-names: Name of core clock, must be "core"

>  
>  Example:
>  
>  rng {
> -        compatible = "amlogic,meson-rng";
> -        reg = <0x0 0xc8834000 0x0 0x4>;
> +	compatible = "amlogic,meson-rng";
> +	reg = <0x0 0xc8834000 0x0 0x4>;
> +	clocks = <&clkc CLKID_RNG0>;
> +	clock-names = "core";
>  };
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> index 5d995f77..620495a4 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> @@ -380,7 +380,7 @@
>  			#size-cells = <2>;
>  			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
>  
> -			rng {
> +			hwrng: rng {
>  				compatible = "amlogic,meson-rng";
>  				reg = <0x0 0x0 0x0 0x4>;
>  			};
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> index 04b3324b..a375cb21 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> @@ -524,3 +524,8 @@
>  &vpu {
>  	compatible = "amlogic,meson-gxbb-vpu", "amlogic,meson-gx-vpu";
>  };
> +
> +&hwrng {
> +	clocks = <&clkc CLKID_RNG0>;
> +	clock-names = "core";
> +};
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
