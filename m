Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7752DA32;
	Sun,  4 May 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746379064; cv=none; b=jRSF86voA/RtW/pMl+QStVyXKSb0D09OCD9JYRWR6FYmGRsFoC9VvkhaMSpo8w0JzW9ngmfyxOENgTpi0Yb+tJogjvRxZMifXD529lIFokyfVxvLO4HS9Bd6QEfQNZpruIfvMRHRrQC1L3QYuJKcmwcd6kooqujkKcaV4cyaGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746379064; c=relaxed/simple;
	bh=sgZPr4WYxTx1WRbDhzcd65kmX61osl9mq2JXEYcEsog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZoROkx4qbL8sQnDaI9h3hEPVMx0diwHfA00CaRbIulDU2xxoJTZzGUx+3xyfrc3oA/q/QmvDYN8oSS0rv4beD14fbKqBh8O5V7ANB43XQT+GhwYhp0LcjBgws2ITFLtu63vi02uXLri6gXPY954PzhJSsDpgZ74ulcSZR2l7X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzF3+2p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzF3+2p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46160C4CEE7;
	Sun,  4 May 2025 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746379063;
	bh=sgZPr4WYxTx1WRbDhzcd65kmX61osl9mq2JXEYcEsog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dzF3+2p3eM3+omSGCAO7tZReKg6vjRCGswmnoxWGXTC/q5W2lcEluacgfpdd5iRMH
	 OewZZbLQN5+QEWBcF8J8/cD3KWnPuwEWucdvKt16OxN6UCSUbdiVa8yA54KcAwBVlq
	 xdI0HGV5zQlkIX9OZ1F1/g/WECT0Yi8MHbvNNhDR7lLIALFmC329HbRUL+ycHmLMd5
	 +e6ONxUb4zt4nW7VZpGEzKXj89ID8X59HKsLGEera0PjD1GPbxtYJirBJaXeeVLdst
	 zMJ6XwdetaI6PhIsBbI0qac0GVouwurbVohTf5XCwsXtqQzDFX8uUjwrfZ5jADp9No
	 tnUVmHYWeIavA==
Date: Sun, 4 May 2025 19:17:41 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Kamlesh Gurudasani <kamlesh@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Praneeth Bajjuri <praneeth@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Message-ID: <20250504-tangible-courageous-robin-3e31d1@kuoka>
References: <20250502121253.456974-2-t-pratham@ti.com>
 <20250502121253.456974-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250502121253.456974-3-t-pratham@ti.com>

On Fri, May 02, 2025 at 05:21:16PM GMT, T Pratham wrote:
> Add DT binding for Texas Instruments DTHE V2 crypto accelerator.
> 
> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
> only found in it.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,dthev2.yaml | 55 +++++++++++++++++++

Filename: nothing improved.

>  MAINTAINERS                                   |  6 ++
>  2 files changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
> new file mode 100644
> index 000000000000..68ed9923eebb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/ti,dthev2.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: K3 SoC DTHE V2 crypto module
> +
> +maintainers:
> +  - T Pratham <t-pratham@ti.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,am62l-dthev2
> +
> +  reg:
> +    maxItems: 1
> +
> +  dmas:
> +    items:
> +      - description: AES Engine RX DMA Channel
> +      - description: AES Engine TX DMA Channel
> +      - description: SHA Engine TX DMA Channel
> +
> +  dma-names:
> +    items:
> +      - const: rx
> +      - const: tx1
> +      - const: tx2
> +
> +required:
> +  - compatible
> +  - reg
> +  - dmas
> +  - dma-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    cbass_main {

soc or whatever is reasonable, but follow DTS coding style.

I already asked to match coding style, although about wrapping :/

> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        crypto@40800000 {
> +          compatible = "ti,am62l-dthev2";
> +          reg = <0x00 0x40800000 0x00 0x10000>;
> +
> +          dmas = <&main_bcdma 0 0 0x4700 0>,
> +                <&main_bcdma 0 0 0xc701 0>,
> +                <&main_bcdma 0 0 0xc700 0>;

Looks misaligned, again, see DTS coding style

> +          dma-names = "rx", "tx1", "tx2";
> +        };

Best regards,
Krzysztof

