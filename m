From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v6 3/5] arm64: marvell: dts: add dma-mask in crypto nodes for 7k/8k
Date: Tue, 13 Jun 2017 10:30:14 +0200
Message-ID: <87fuf49tnt.fsf@free-electrons.com>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
        <20170524141035.21031-4-antoine.tenart@free-electrons.com>
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
Received: from mail.free-electrons.com ([62.4.15.54]:46208 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdFMIa0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 04:30:26 -0400
In-Reply-To: <20170524141035.21031-4-antoine.tenart@free-electrons.com>
        (Antoine Tenart's message of "Wed, 24 May 2017 16:10:33 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,
 
 On mer., mai 24 2017, Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> The EIP197 cryptographic engine supports 64 bits address width but is
> limited to 40 bits on 7k/8k. Add a dma-mask property in the
> cryptographic engine nodes to reflect this.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied on mvebu/dt64

Thanks,

Gregory

> ---
>  arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi | 1 +
>  arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi  | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> index b4bc42ece754..434d8a806ffa 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
> @@ -240,6 +240,7 @@
>  				interrupt-names = "mem", "ring0", "ring1",
>  				"ring2", "ring3", "eip";
>  				clocks = <&cpm_syscon0 1 26>;
> +				dma-mask = <0xff 0xffffffff>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> index 6e2058847ddc..17ca94a5d6b4 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
> @@ -230,6 +230,7 @@
>  				interrupt-names = "mem", "ring0", "ring1",
>  						  "ring2", "ring3", "eip";
>  				clocks = <&cps_syscon0 1 26>;
> +				dma-mask = <0xff 0xffffffff>;
>  				status = "disabled";
>  			};
>  		};
> -- 
> 2.9.4
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
