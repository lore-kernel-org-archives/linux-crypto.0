From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/5] dt-bindings : Document the STM32F4 CRC32 binding
Date: Tue, 30 May 2017 17:50:24 -0500
Message-ID: <20170530225024.ypguef347yqbjbsd@rob-hp-laptop>
References: <cover.1495285223.git.cosardindar@gmail.com>
 <bb672acb88667e9d27beb4d1e4fd8882f265ee47.1495285223.git.cosardindar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, fabien.dessenne@st.com
To: Cosar Dindar <cosardindar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb672acb88667e9d27beb4d1e4fd8882f265ee47.1495285223.git.cosardindar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, May 20, 2017 at 04:32:12PM +0300, Cosar Dindar wrote:
> Add device tree binding for STM32F4.
> 
> Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/st,stm32-crc.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> index 3ba92a5..7b30f1e 100644
> --- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> @@ -1,7 +1,7 @@
>  * STMicroelectronics STM32 CRC
>  
>  Required properties:
> -- compatible: Should be "st,stm32f7-crc".
> +- compatible: Can be either "st,stm32f7-crc" or "st,srm32f4-crc".

Here you say either, but the example has both.

>  - reg: The address and length of the peripheral registers space
>  - clocks: The input clock of the CRC instance
>  
> @@ -10,7 +10,7 @@ Optional properties: none
>  Example:
>  
>  crc: crc@40023000 {
> -	compatible = "st,stm32f7-crc";
> +	compatible = "st,stm32f7-crc", "st,stm32f4-crc";
>  	reg = <0x40023000 0x400>;
>  	clocks = <&rcc 0 12>;
>  };
> -- 
> 2.7.4
> 
