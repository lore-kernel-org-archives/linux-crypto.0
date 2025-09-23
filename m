Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3E18E20;
	Tue, 23 Sep 2025 14:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637785; cv=none; b=j2OP82Uebl1wHyZ8L6NIRHId6cUggPuY4+yzj8CHZVn74V9d7651pH7qJQ8GTNTTa2+l4wpiy5sL5puBQIKrgFprmq9LjtlupMZFPyVhZpz6yR9X7gSMyvcbokgQmcV93JvsgfHafPZw0kil3HHj6Ar5Dcqb1nBrlSFSCZlZ2sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637785; c=relaxed/simple;
	bh=8VR91M07ZYegzZ2sv14LTHAk0HCZvQIK1wKP89nGMd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5lbEeFOhKh+t9Qk8iGKiLsHoMAzomvkFDVsKni4JgwzlCJKDxINH0asOq6+lUJKSYYIyEYBPpnz1Up/Q8tef3IR/8v3kO1WEHmcfDi98nMU7WSYBR/rkRjiI0VG7LmqetDfmzczsge2xL7N1Et9t97rGfHS+5Rp7wJwNPqzyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+XY4Lhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+XY4Lhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B966C4CEF5;
	Tue, 23 Sep 2025 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758637784;
	bh=8VR91M07ZYegzZ2sv14LTHAk0HCZvQIK1wKP89nGMd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N+XY4LhcSTqHUVZos/FJ4QYeoJ/SIoyuCWtGtfXJgStwns6Fm2QWs1iaYMDM3BRYU
	 DgXVw6S3v7EfFMuf0PAWPz//RRhL8Nsk/8plcNiIIzxlFEhlEnLJMjLb/9xtzFP82A
	 npEfAfuVboxqB+hX7wxqaFSpO4nZ76XM4yOADGR7pnNcjdcGPOh/AWTWlWz4TgD7uG
	 5xVyKPUz2WZd647Cu6n81nATrPshBGOM1m4/amJFrAmboLpVLu+MkgRDh1DvB0d5tg
	 CYjgql2nB+FxE8qjP+iBHnWKf41l6XvzrdaUIk6HoCRzczAShbGz9Ih46mIpY4+nOG
	 Oab0QuMq5S8bw==
Date: Tue, 23 Sep 2025 09:29:43 -0500
From: Rob Herring <robh@kernel.org>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT
 schema
Message-ID: <20250923142943.GA3134901-robh@kernel.org>
References: <20250923103900.136621-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923103900.136621-1-dev@kael-k.io>

On Tue, Sep 23, 2025 at 12:38:22PM +0200, Kael D'Alcamo wrote:
> Convert the Devicetree binding documentation for:
> * SUNW,n2-rng
> * SUNW,vf-rng
> * SUNW,kt-rng
> * ORCL,m4-rng
> * ORCL,m7-rng
> from plain text to YAML.

While I welcome any conversions, I wouldn't put Sparc stuff high on 
priority list as we're not going to run the validation tools on them 
and we can't change anything in their DTs if we did. My priority is the 
remaining warnings on arm64 and then active arm32 platforms (e.g. 
aspeed). We're down to <700 unique warnings on arm64 (from ~10000). 

There's builds with warnings of Linus' and next trees here:

https://gitlab.com/robherring/linux-dt/-/jobs

And some scripts to fetch the warnings here:

https://gitlab.com/robherring/ci-jobs

> 
> Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> ---
>  .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
>  .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++++++

SUNW,n2-rng.yaml for the filename.

>  2 files changed, 61 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
> deleted file mode 100644
> index b0b211194c71..000000000000
> --- a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -HWRNG support for the n2_rng driver
> -
> -Required properties:
> -- reg		: base address to sample from
> -- compatible	: should contain one of the following
> -	RNG versions:
> -	- 'SUNW,n2-rng' for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
> -	- 'SUNW,vf-rng' for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
> -	- 'SUNW,kt-rng' for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4), (UltraSPARC KT/Niagara 3 - development names)
> -	more recent systems (after Oracle acquisition of SUN)
> -	- 'ORCL,m4-rng' for SPARC T5/M5
> -	- 'ORCL,m7-rng' for SPARC T7/M7
> -
> -Examples:
> -/* linux LDOM on SPARC T5-2 */
> -Node 0xf029a4f4
> -	.node:  f029a4f4
> -	rng-#units:  00000002
> -	compatible: 'ORCL,m4-rng'
> -	reg:  0000000e
> -	name: 'random-number-generator'
> -
> -/* solaris on SPARC M7-8 */
> -Node 0xf028c08c
> -	rng-#units:  00000003
> -	compatible: 'ORCL,m7-rng'
> -	reg:  0000000e
> -	name:  'random-number-generator'
> -
> -PS: see as well prtconfs.git by DaveM
> diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> new file mode 100644
> index 000000000000..fea6be544784
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/sparc_sun_oracle_rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: HWRNG support for the n2_rng driver

SUN UltraSPARC HWRNG

> +
> +maintainers:
> +  - David S. Miller <davem@davemloft.net>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - SUNW,n2-rng  # for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
> +      - SUNW,vf-rng  # for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
> +      # for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4),
> +      #  (UltraSPARC KT/Niagara 3 - development names)
> +      #  more recent systems (after Oracle acquisition of SUN)
> +      - SUNW,kt-rng
> +      - ORCL,m4-rng  # for SPARC T5/M5
> +      - ORCL,m7-rng  # for SPARC T7/M7
> +
> +  reg:
> +    maxItems: 1
> +
> +  "rng-#units":
> +    description: Number of RNG units
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1

This will need an exception in vendor-prefixes.yaml to fix the warning. 
Looking at some of the Sparc DTs briefly, there's a few more ways '#' 
shows up.

I suppose this:

"^[a-zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$": true

needs to be:

"^[a-zA-Z0-9#_][a-zA-Z0-9#+\\-._@]{0,63}$": true 

(I think the '@' should be dropped here.)

> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +# PS: see as well prtconfs.git by DaveM
> +examples:
> +  - |
> +    bus {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        rng@e {
> +            compatible = "ORCL,m4-rng";
> +            reg = <0xe>;
> +            rng-#units = <2>;
> +        };
> +    };
> +  - |
> +    bus {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        rng@e {
> +            compatible = "ORCL,m7-rng";
> +            reg = <0xe>;
> +            rng-#units = <3>;
> +        };
> +    };

I think one example is enough.

Rob
