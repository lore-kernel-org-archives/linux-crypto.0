Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70032C3251;
	Mon,  2 Jun 2025 05:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748843917; cv=none; b=mEbVBZAv2nJAREahibkgpVRE5/1Kg++Xmr8iTlFULxCc+dDTq7VvxbSqiqKW+2hdjlaqAxkAt8Y7/qKhJ5oeyNahAzqM9l1Uoyon0mH3SrSasCJssrMhkgNZcqp7OKDh02rLZ0fq7aVyTd4lKzPZGqR9RhJI8eEMJgHv+DIUnDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748843917; c=relaxed/simple;
	bh=fx8+5minStLn1u8EkNx/PHeeOZA27TBadJ5A5OaVa3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4di9EPJ+YezEXx/uR0sB9zkzGwJpQUTNbCoplt9ju/H0oHFeyFDkGXCdn6JwEigfllJ3EyAEdoEwXq4kgSWedhk7jm7IQZGfC6LQoXBl3IASsxaxOu2pNhJ90uFDCGfodTaY9FNTCN8F7+ai42InbhlIvelBqdv76gQ1IGFYTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojTto1Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojTto1Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E37C4CEEB;
	Mon,  2 Jun 2025 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748843916;
	bh=fx8+5minStLn1u8EkNx/PHeeOZA27TBadJ5A5OaVa3g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ojTto1LsXJNGjgoPKpqrjXEBDWJ12fGs5n62ASiGLOZ34GjQkC+wrPjx3bNf64YYs
	 B3DoJHi5c2H46b8uDY+JkiQy3ls9mGbVMsbtKy6q16l22Q9MfBJLWaXAZ2KKp2BPli
	 J/WT9pfIS658Hefl3TeGZHoHmRu7993+SitUsw2ICKwQZqsiXVIfPx+Djz65fD7Tr7
	 wiSaq9OOC2/xbkTI0D6KvDJ6l2ecy5InPPq+353hZdD3IVyLcSuQoOotAhaw4g0qCD
	 jaTLfEfnjYuXT+c35JNocf45HW30iyf/LJJir/sUa/I9xSICd1Wz3b8qZCclO0ev6d
	 6HW6WYTqwUSrQ==
Message-ID: <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
Date: Mon, 2 Jun 2025 07:58:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
 manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
 Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/06/2025 07:32, Pavitrakumar Managutte wrote:
> Add DT bindings related to the SPAcc driver for Documentation.
> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> Engine is a crypto IP designed by Synopsys.
> 
> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Where was this Ack given? It's not on the lists, it's not public, so it
cannot be after your SoB.

> ---
>  .../bindings/crypto/snps,dwc-spacc.yaml       | 77 +++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> new file mode 100644
> index 000000000000..2780b3db2182
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> @@ -0,0 +1,77 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto Engine
> +
> +maintainers:
> +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> +
> +description: |
> +  This binding describes the Synopsys DWC Security Protocol Accelerator (SPAcc),

Don't say that binding describes a binding.  Describe here hardware.

> +  which is a hardware IP designed to accelerate cryptographic operations, such
> +  as encryption, decryption, and hashing.
> +
> +  The SPAcc supports virtualization where a single physical SPAcc can be
> +  accessed as multiple virtual SPAcc instances, each with its own register set.
> +  These virtual instances can be assigned different priorities.
> +
> +  In this configuration, the SPAcc IP is instantiated within the Synopsys
> +  NSIMOSCI virtual SoC platform, a SystemC simulation environment used for
> +  software development and testing. The device is accessed as a memory-mapped
> +  peripheral and generates interrupts to the ARC interrupt controller.
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: snps,nsimosci-hs-spacc
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  snps,vspacc-id:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      Virtual SPAcc instance identifier.
> +      The SPAcc hardware supports multiple virtual instances (determined by
> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to identify
> +      which virtual instance this node represents.

No, IDs are not accepted.

> +    minimum: 0
> +    maximum: 7
> +
> +  snps,spacc-internal-counter:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      Hardware counter that generates an interrupt based on a count value.
> +      This counter starts ticking when there is a completed job sitting on
> +      the status fifo to be serviced. This makes sure that no jobs are
> +      starved of processing.

Not a DT property.

> +    minimum: 0x19000
> +    maximum: 0xFFFFF
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +

Drop blank line.

> +    crypto@40000000 {
> +        compatible = "snps,nsimosci-hs-spacc";
> +        reg = <0x40000000 0x3FFFF>;

Lowercase hex only.



Best regards,
Krzysztof
