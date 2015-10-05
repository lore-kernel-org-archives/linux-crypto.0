From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: Document the STM32 HW RNG bindings
Date: Mon, 5 Oct 2015 10:34:38 -0500
Message-ID: <CAL_JsqLt2=Cb8SDAQG7XiMNC7NV59MimYETyt87-QYHt31cnsQ@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org> <1443904519-24012-2-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linaro Patches <patches@linaro.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443904519-24012-2-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 3, 2015 at 3:35 PM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> This adds documenttaion of device tree binds for the STM32 hardware
> random number generator.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  .../devicetree/bindings/hwrng/stm32-rng.txt         | 21 +++++++++++++++++++++

Please use bindings/rng/... as I'm consolidating bindings there.

Otherwise,

Acked-by: Rob Herring <robh@kernel.org>

>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwrng/stm32-rng.txt
>
> diff --git a/Documentation/devicetree/bindings/hwrng/stm32-rng.txt b/Documentation/devicetree/bindings/hwrng/stm32-rng.txt
> new file mode 100644
> index 000000000000..47f04176f93b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwrng/stm32-rng.txt
> @@ -0,0 +1,21 @@
> +STMicroelectronics STM32 HW RNG
> +===============================
> +
> +The STM32 hardware random number generator is a simple fixed purpose IP and
> +is fully separated from other crypto functions.
> +
> +Required properties:
> +
> +- compatible : Should be "st,stm32-rng"
> +- reg : Should be register base and length as documented in the datasheet
> +- interrupts : The designated IRQ line for the RNG
> +- clocks : The clock needed to enable the RNG
> +
> +Example:
> +
> +       rng: rng@50060800 {
> +               compatible = "st,stm32-rng";
> +               reg = <0x50060800 0x400>;
> +               interrupts = <80>;
> +               clocks = <&rcc 0 38>;
> +       };
> --
> 2.4.3
>
