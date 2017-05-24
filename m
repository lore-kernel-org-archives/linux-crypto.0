From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v6 2/5] arm64: marvell: dts: fix interrupts in 7k/8k crypto nodes
Date: Wed, 24 May 2017 17:13:16 +0200
Message-ID: <87zie2uw37.fsf@free-electrons.com>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
        <20170524141035.21031-3-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43501 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940429AbdEXPNT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 11:13:19 -0400
In-Reply-To: <20170524141035.21031-3-antoine.tenart@free-electrons.com>
        (Antoine Tenart's message of "Wed, 24 May 2017 16:10:32 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,
 
 On mer., mai 24 2017, Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> The cryptographic engine nodes have an interrupt which is configured as
> both edge and level, which makes no sense at all. Fix this by
> configuring it the right way (level).
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied on mvebu/fixes

Thanks,

Gregory
> ---
>  arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi | 3 +--
>  arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi  | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> index ac8df5201cd6..b4bc42ece754 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> @@ -231,8 +231,7 @@
>  			cpm_crypto: crypto@800000 {
>  				compatible = "inside-secure,safexcel-eip197";
>  				reg = <0x800000 0x200000>;
> -				interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING
> -				| IRQ_TYPE_LEVEL_HIGH)>,
> +				interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> index 7740a75a8230..6e2058847ddc 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> @@ -221,8 +221,7 @@
>  			cps_crypto: crypto@800000 {
>  				compatible = "inside-secure,safexcel-eip197";
>  				reg = <0x800000 0x200000>;
> -				interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING
> -				| IRQ_TYPE_LEVEL_HIGH)>,
> +				interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 279 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 280 IRQ_TYPE_LEVEL_HIGH>,
> -- 
> 2.9.4
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
