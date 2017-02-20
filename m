From: Jerome Brunet <jbrunet@baylibre.com>
Subject: Re: [PATCH 1/2] hwrng: meson: expose RNG0 clock via DT
Date: Mon, 20 Feb 2017 11:07:23 +0100
Message-ID: <1487585243.3734.3.camel@baylibre.com>
References: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
         <a02b078d-9171-cf66-d5d8-84259f9f9a88@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38407 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdBTKH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 05:07:26 -0500
Received: by mail-wm0-f52.google.com with SMTP id r141so48292197wmg.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2017 02:07:26 -0800 (PST)
In-Reply-To: <a02b078d-9171-cf66-d5d8-84259f9f9a88@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2017-02-19 at 21:33 +0100, Heiner Kallweit wrote:
> Expose the RNG0 clock via DT.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gx.dtsi   | 2 +-
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 5 +++++
>  include/dt-bindings/clock/gxbb-clkc.h       | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> index 5d995f77..620495a4 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
> @@ -380,7 +380,7 @@
>  			#size-cells = <2>;
>  			ranges = <0x0 0x0 0x0 0xc8834000 0x0
> 0x2000>;
>  
> -			rng {
> +			hwrng: rng {
>  				compatible = "amlogic,meson-rng";
>  				reg = <0x0 0x0 0x0 0x4>;
>  			};
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> index 04b3324b..a375cb21 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> @@ -524,3 +524,8 @@
>  &vpu {
>  	compatible = "amlogic,meson-gxbb-vpu", "amlogic,meson-gx-
> vpu";
>  };
> +
> +&hwrng {
> +	clocks = <&clkc CLKID_RNG0>;
> +	clock-names = "core";
> +};
> diff --git a/include/dt-bindings/clock/gxbb-clkc.h b/include/dt-
> bindings/clock/gxbb-clkc.h
> index 692846c7..473676b1 100644
> --- a/include/dt-bindings/clock/gxbb-clkc.h
> +++ b/include/dt-bindings/clock/gxbb-clkc.h
> @@ -15,6 +15,7 @@
>  #define CLKID_SPI		34
>  #define CLKID_I2C		22
>  #define CLKID_SAR_ADC		23
> +#define CLKID_RNG0		25

Shouldn't you comment out the corresponding "define" in
drivers/clk/meson/gxbb.h ?

I don't know if it is rule, but we usually "expose" the clock (moving
the define from drivers/clk/meson/gxbb.h to include/dt-
bindings/clock/gxbb-clkc.h) in a dedicated patch, with the subject
starting with "clk: gxbb: expose foobar clock". It helps the
maintainers of the subsystem to give their ack.

For this to happen, please remember the patch should be sent to them as
well. Here you are missing the clock and dt guys:
* Stephen Boyd <sboyd@codeaurora.org>
* Michael Turquette <mturquette@baylibre.com>
* linux-clk@vger.kernel.org
* devicetree@vger.kernel.org

scripts/get_maintainer.pl can help you finding all people your patch
should be sent to.

The remaining part of this patch involves DT, so the subject should
start with "ARM64: dts: meson-gx:"
You also need to add devicetree@vger.kernel.org in CC.

Apart from these minor remarks, the patchset looks good to me.
Thx !

>  #define CLKID_ETH		36
>  #define CLKID_USB0		50
>  #define CLKID_USB1		51
