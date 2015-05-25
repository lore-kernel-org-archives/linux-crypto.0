From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v3 13/16] ARM: marvell/dt: add crypto node to armada-xp.dtsi
Date: Mon, 25 May 2015 17:15:42 +0200
Message-ID: <55633C9E.3090901@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com> <1432301642-11470-14-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:35880 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbbEYPPp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 11:15:45 -0400
In-Reply-To: <1432301642-11470-14-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Boris,

On 22/05/2015 15:33, Boris Brezillon wrote:
> Add crypto related nodes to armada-xp.dtsi.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

>From the point of view of the mvebu it looks OK:
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

But of course, I will wait for that the driver will be merged before
applying it, or at least that the crypto maintainers validate the
binding.

Thanks,

Gregory



> ---
>  arch/arm/boot/dts/armada-xp.dtsi | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
> index 013d63f..a12a81f 100644
> --- a/arch/arm/boot/dts/armada-xp.dtsi
> +++ b/arch/arm/boot/dts/armada-xp.dtsi
> @@ -220,6 +220,19 @@
>  				};
>  			};
>  
> +			crypto@90000 {
> +				compatible = "marvell,armada-xp-crypto";
> +				reg = <0x90000 0x10000>;
> +				reg-names = "regs";
> +				interrupts = <48>, <49>;
> +				clocks = <&gateclk 23>, <&gateclk 23>;
> +				clock-names = "cesa0", "cesa1";
> +				marvell,crypto-srams = <&crypto_sram0>,
> +						       <&crypto_sram1>;
> +				marvell,crypto-sram-size = <0x600>;
> +				status = "okay";
> +			};
> +
>  			xor@f0900 {
>  				compatible = "marvell,orion-xor";
>  				reg = <0xF0900 0x100
> @@ -240,6 +253,24 @@
>  				};
>  			};
>  		};
> +
> +		crypto_sram0: sa-sram0 {
> +			compatible = "mmio-sram";
> +			reg = <MBUS_ID(0x09, 0x09) 0 0x800>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0 MBUS_ID(0x09, 0x09) 0 0x800>;
> +			status = "okay";
> +		};
> +
> +		crypto_sram1: sa-sram1 {
> +			compatible = "mmio-sram";
> +			reg = <MBUS_ID(0x09, 0x05) 0 0x800>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0 MBUS_ID(0x09, 0x05) 0 0x800>;
> +			status = "okay";
> +		};
>  	};
>  
>  	clocks {
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
