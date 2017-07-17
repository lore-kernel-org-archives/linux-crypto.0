From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 2/3] dt-bindings: Document STM32 CRYP bindings
Date: Mon, 17 Jul 2017 12:49:31 -0500
Message-ID: <20170717174931.b6uvhwz5yn52qvyi@rob-hp-laptop>
References: <1499939979-8623-1-git-send-email-fabien.dessenne@st.com>
 <1499939979-8623-3-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34823 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdGQRtd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 13:49:33 -0400
Content-Disposition: inline
In-Reply-To: <1499939979-8623-3-git-send-email-fabien.dessenne@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 13, 2017 at 11:59:38AM +0200, Fabien Dessenne wrote:
> Document device tree bindings for the STM32 CRYP.
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
> ---
>  .../devicetree/bindings/crypto/st,stm32-cryp.txt     | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> new file mode 100644
> index 0000000..f631c37
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
> @@ -0,0 +1,20 @@
> +* STMicroelectronics STM32 CRYP
> +
> +Required properties:
> +- compatible: Should be "st,stm32f756-cryp".
> +- reg: The address and length of the peripheral registers space
> +- clocks: The input clock of the CRYP instance
> +- interrupts: The CRYP interrupts

More than 1? How many?

> +
> +Optional properties:
> +- resets: The input reset of the CRYP instance
> +
> +Example:
> +cryp1: cryp@50060000 {
> +	compatible = "st,stm32f756-cryp";
> +	reg = <0x50060000 0x400>;
> +	interrupts = <79>;
> +	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(CRYP)>;
> +	resets = <&rcc STM32F7_AHB2_RESET(CRYP)>;
> +	status = "disabled";
> +};
> -- 
> 2.7.4
> 
