Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84A6211A29;
	Wed, 28 May 2025 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469132; cv=none; b=e2JsBncRGziMZ6bkCWn9rxKovuPWNgJGQxTqQdFohgAzQkuqm8m83tYn200RAOzTO4zXxdzj2vIVayt3fSvLZ4uim1AEAwWzxLs6J4YQOgkRefzwuVPSl+T/Iw3zWiyJK3oGVufgjDveDLvHGJ7W5pOtM7RJWuNGxCpMptDQBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469132; c=relaxed/simple;
	bh=4gXpD5gzsKHRkYAgF4556xWhjY838szvkedKjVZOZZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgBtMWUbgXKimbkF4y44f/Kbrchm46rVu7sCdrfh/izNQ5u1YjIHMaUh+qKjdrq0zR4ko07qF7E2T9Ef10JJTJApXLBYMifZUyaltFA3dQhAOxPSZxesvjD4vhmkymK8Dri1IY9weiastd4Jhv7rtwWCQvgJbQsxIpZK7mz/Y2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Reto9zlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Reto9zlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A33DC4CEE3;
	Wed, 28 May 2025 21:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469131;
	bh=4gXpD5gzsKHRkYAgF4556xWhjY838szvkedKjVZOZZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Reto9zlKGiybocpiqah7bOX9Od88N96vwzlIu8vXB+ZFGRtU+/eLYy7rOFlhMi8kB
	 TQMP/NMKZnIhY/FPg2vxg00XUA/NJUekkNvO0vjgOxMz+SYPRsVTaFXP7xqPHTut17
	 /+RQ4qNvDJqV8aLXAfB20aBmYMQTq+WrjxfSVlc4IGrT2BQOtpNQfSrElc21Y89zP9
	 LSeHJ4gNVCaXyF9gFtlgsT3Uo6U9mMbGSOIyLRDotymboT/Bvgm4cCh/sjLB9/MC4c
	 LxZPPDMycuk7qc7f2WAM7u6xF4ZzwrE1TgmjlEcQBSshVKoyoFZvlx1WU7pNp2Uyr4
	 gJRRFowAgpApw==
Date: Wed, 28 May 2025 16:52:09 -0500
From: Rob Herring <robh@kernel.org>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Message-ID: <20250528215209.GA862463-robh@kernel.org>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-4-john.ernberg@actia.se>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528144259.2603914-4-john.ernberg@actia.se>

On Wed, May 28, 2025 at 02:43:07PM +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.
> 
> Allow specifying them for such SoCs.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> 
> ---
> 
> v3:
>  - Fix warnings discovered by Rob Herring's bot
>  - Declare the compatibles correctly (Krzysztof Kozlowski)
> 
> v2:
>  - Adjust commit message (Frank Li)
>  - Only allow power-domains when compatible with imx8qm (Frank Li)
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 45 ++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> index 75afa441e019..a4ada0e2d97c 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> @@ -46,6 +46,7 @@ properties:
>        - items:
>            - enum:
>                - fsl,imx6ul-caam
> +              - fsl,imx8qm-caam
>                - fsl,sec-v5.0
>            - const: fsl,sec-v4.0
>        - const: fsl,sec-v4.0
> @@ -77,6 +78,9 @@ properties:
>    interrupts:
>      maxItems: 1
>  
> +  power-domains:
> +    maxItems: 1
> +
>    fsl,sec-era:
>      description: Defines the 'ERA' of the SEC device.
>      $ref: /schemas/types.yaml#/definitions/uint32
> @@ -106,7 +110,9 @@ patternProperties:
>                - const: fsl,sec-v5.0-job-ring
>                - const: fsl,sec-v4.0-job-ring
>            - items:
> -              - const: fsl,sec-v5.0-job-ring
> +              - enum:
> +                - fsl,imx8qm-job-ring
> +                - fsl,sec-v5.0-job-ring
>                - const: fsl,sec-v4.0-job-ring
>            - const: fsl,sec-v4.0-job-ring
>  
> @@ -116,6 +122,9 @@ patternProperties:
>        interrupts:
>          maxItems: 1
>  
> +      power-domains:
> +        maxItems: 1
> +
>        fsl,liodn:
>          description:
>            Specifies the LIODN to be used in conjunction with the ppid-to-liodn
> @@ -212,6 +221,40 @@ required:
>    - reg
>    - ranges
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: fsl,imx8qm-caam
> +    then:
> +      required:
> +        - power-domains
> +    else:
> +      properties:
> +        power-domains: false
> +
> +  - if:

This 'if' belongs under the '^jr@[0-9a-f]+$' subschema which will then 
remote a level here.

> +      patternProperties:
> +        '^jr@[0-9a-f]+$':
> +          type: object
> +          properties:
> +            compatible:
> +              contains:
> +                const: fsl,imx8qm-job-ring
> +    then:
> +      patternProperties:
> +        '^jr@[0-9a-f]+$':
> +          type: object
> +          required:
> +            - power-domains
> +    else:
> +      patternProperties:
> +        '^jr@[0-9a-f]+$':
> +          type: object
> +          properties:
> +            power-domains: false
> +
>  additionalProperties: false
>  
>  examples:
> -- 
> 2.49.0
