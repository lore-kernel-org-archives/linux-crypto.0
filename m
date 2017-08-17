From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] dt-bindings: Document STM32 CRYP bindings
Date: Thu, 17 Aug 2017 16:11:04 -0500
Message-ID: <20170817211104.qiixtzbetrssp4k2@rob-hp-laptop>
References: <1502781584-18468-1-git-send-email-fabien.dessenne@st.com>
 <1502781584-18468-3-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Benjamin Gaignard <benjamin.gaignard-qxv4g6HH51o@public.gmane.org>,
        Lionel Debieve <lionel.debieve-qxv4g6HH51o@public.gmane.org>,
        Ludovic Barre <ludovic.barre-qxv4g6HH51o@public.gmane.org>
To: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502781584-18468-3-git-send-email-fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 15, 2017 at 09:19:43AM +0200, Fabien Dessenne wrote:
> Document device tree bindings for the STM32 CRYP.
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
> ---
>  .../devicetree/bindings/crypto/st,stm32-cryp.txt     | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> new file mode 100644
> index 0000000..7c6d599
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> @@ -0,0 +1,20 @@
> +* STMicroelectronics STM32 CRYP
> +
> +Required properties:
> +- compatible: Should be "st,stm32f756-cryp".
> +- reg: The address and length of the peripheral registers space
> +- clocks: The input clock of the CRYP instance
> +- interrupts: The CRYP interrupt
> +
> +Optional properties:
> +- resets: The input reset of the CRYP instance
> +
> +Example:
> +cryp1: cryp@50060000 {

crypto@..

> +	compatible = "st,stm32f756-cryp";
> +	reg = <0x50060000 0x400>;
> +	interrupts = <79>;
> +	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(CRYP)>;
> +	resets = <&rcc STM32F7_AHB2_RESET(CRYP)>;
> +	status = "disabled";

Don't show status in examples.

Otherwise,

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> +};
> -- 
> 2.7.4
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
