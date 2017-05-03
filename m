From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Wed, 3 May 2017 17:36:38 +0100
Message-ID: <7986721e-3a2b-23fb-61d7-7032f0d65533@arm.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-2-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdECQgn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 12:36:43 -0400
In-Reply-To: <20170424075407.19730-2-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/04/17 08:54, Antoine Tenart wrote:
> The Inside Secure Safexcel cryptographic engine is found on some Marvell
> SoCs (7k/8k). Document the bindings used by its driver.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  .../bindings/crypto/inside-secure-safexcel.txt     | 27 ++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> new file mode 100644
> index 000000000000..ff56b9384fcc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> @@ -0,0 +1,27 @@
> +Inside Secure SafeXcel cryptographic engine
> +
> +Required properties:
> +- compatible: Should be "inside-secure,safexcel-eip197".
> +- reg: Base physical address of the engine and length of memory mapped region.
> +- interrupts: Interrupt numbers for the rings and engine.
> +- interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
> +
> +Optional properties:
> +- clocks: Reference to the crypto engine clock.
> +
> +Example:
> +
> +	crypto: crypto@800000 {
> +		compatible = "inside-secure,safexcel-eip197";
> +		reg = <0x800000 0x200000>;
> +		interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,

I'm puzzled. How can the interrupt can be both level *and* edge? That
doesn't make any sense.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
