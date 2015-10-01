From: Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [STLinux Kernel] [PATCH v2 6/7] ARM: STi: STiH407: Enable the 2
 HW Random Number Generators for STiH4{07, 10}
Date: Thu, 1 Oct 2015 12:57:27 +0200
Message-ID: <560D1197.2000606@st.com>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <1442497557-9271-7-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <kernel@stlinux.com>
To: Lee Jones <lee.jones@linaro.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<peter@korsgaard.com>, <festevam@gmail.com>,
	<kieranbingham@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442497557-9271-7-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Lee, Herbert,

On 09/17/2015 03:45 PM, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih407-family.dtsi | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
> index 838b812..9452b42 100644
> --- a/arch/arm/boot/dts/stih407-family.dtsi
> +++ b/arch/arm/boot/dts/stih407-family.dtsi
> @@ -565,5 +565,19 @@
>   						  <&phy_port2 PHY_TYPE_USB3>;
>   			};
>   		};
> +
> +		rng10: rng@08a89000 {
> +			compatible      = "st,rng";
> +			reg		= <0x08a89000 0x1000>;
> +			clocks          = <&clk_sysin>;
> +			status		= "okay";
> +		};
> +
> +		rng11: rng@08a8a000 {
> +			compatible      = "st,rng";
> +			reg		= <0x08a8a000 0x1000>;
> +			clocks          = <&clk_sysin>;
> +			status		= "okay";
> +		};
>   	};
>   };

Patch applied to STi tree (sti-dt-for-v4.4).

Thanks,
Maxime
