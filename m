Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6810640D59E;
	Thu, 18 Jun 2026 04:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781755921; cv=none; b=DIv9ekvP1bdKO/AQwk4LBGfECRCqrqCA+aplFNS2YEPEAk7/z0DB5ISP1WAA7jFjmUFfijYUt/BYMKqs4K3uFxn8SfznaUzUb/ECicZ4dfPhJBxG7rXTVI6wIZnx7tjoKviX86+5yUcKKg4ssGi/Kt1tdmdRtjdTh/TGkQMGON4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781755921; c=relaxed/simple;
	bh=blXrhGPt5pKGzuMniFrpZHyHa+xg/CSxw2d5LV+j/uM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmHgDs8ZyD9AnxEY1sopYx/DMVbjNilo6AkWE0Y6Es9yfJ1IE9Jz3ZMIvEEJaMNtGNE4q/OFx4An/P7RXBjiP9Aaa8EP+MLJDHFDhLPCTKOzQxMR+DT/EEwVkmTXM5JHephYHgXtM0YIfLcvy8cEbSags1zXo0V9P01VOB5sRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XD5QFL1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XD5QFL1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AB01F000E9;
	Thu, 18 Jun 2026 04:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781755919;
	bh=vcqfM7qi5CWnj5UgyGu1a+vIMvZVBh4Xn4YdVQYidaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XD5QFL1SIF5+CtXJE7AE4D1+5KcjZ4a0pfbCjfnuG6Rg6SzEz2daL6h3LoJxfm7eF
	 MlnB8BwPRy8AzAgflFazhvL0cAigH2YFVGB/28GRs8wi7o38YQ0/S818XZaM+3ZBQj
	 MyNhZD0G22hKjuYsfOexJYvzMxwU8ezBHGf0O0dQ2FC/3uHkmV/gzMcxjzs8qp1e7a
	 eNv1r2fYX9Zs9ZDRt2FYqs+8oYlE1jbyjnu1bpBCiCwh5d23VRh6vKivHrCl9xDfja
	 sFpmFCnrZ44cI4VrgSE5yimNagMJxjeTYmjC6ROAXj19aiftnjLvVB21l7FblIbwX9
	 oDCtuGt6nRZXw==
Message-ID: <a523755d-a256-4fe8-97af-6e2f26358221@kernel.org>
Date: Thu, 18 Jun 2026 06:11:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] dt-bindings: rng: timeriomem_rng: add reg-io-width
 and mask properties
To: Jad Keskes <inasj268@gmail.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Alexander Clouter <alex@digriz.org.uk>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260617114436.1909659-1-inasj268@gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260617114436.1909659-1-inasj268@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/06/2026 13:44, Jad Keskes wrote:
> Add optional reg-io-width (1, 2, or 4 bytes) and mask properties to the
> binding.  reg-io-width selects the bus access size,  mask is ANDed with
> the raw register value to allow only the entropy-bearing bits through.
> 
> Update the example to show a typical 1-byte configuration.
> Update SPDX to dual license to match kernel convention.

And did you Cc all of the copyright holders?

> Drop the misleading '32-bit aligned' constraint from the reg
> description since alignment now depends on the configured width.
> 
> Signed-off-by: Jad Keskes <inasj268@gmail.com>
> ---
>  .../bindings/rng/timeriomem_rng.yaml          | 48 +++++++++++++++----
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml b/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
> index 4754174e9849..740bc52bf474 100644
> --- a/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/timeriomem_rng.yaml
> @@ -1,10 +1,16 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

Don't mix multiple changes into one commit.


>  %YAML 1.2
>  ---
>  $id: http://devicetree.org/schemas/rng/timeriomem_rng.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: TimerIO Random Number Generator
> +title: Timer IOMEM Hardware Random Number Generator
> +
> +description: |
> +  This binding covers platforms that have a single IO memory address which

Do not describe the binding. Describe the hardware.

> +  provides periodic random data.  The driver reads from the address at a

Do not describe drivers. Describe the hardware.

> +  fixed interval, returning a configurable-width value masked to the desired
> +  bits.
>  
>  maintainers:
>    - Krzysztof Kozlowski <krzk@kernel.org>
> @@ -13,9 +19,17 @@ properties:
>    compatible:
>      const: timeriomem_rng
>  
> +  reg:
> +    maxItems: 1
> +    description:
> +      Base address to sample from.  Must be aligned to the configured access
> +      width (1, 2, or 4 bytes) and at least that wide.
> +
>    period:
>      $ref: /schemas/types.yaml#/definitions/uint32
> -    description: wait time in microseconds to use between samples
> +    description:
> +      Interval in microseconds between reads.  New random data is expected to
> +      be available at this rate.
>  
>    quality:
>      $ref: /schemas/types.yaml#/definitions/uint32
> @@ -26,16 +40,26 @@ properties:
>        instead.  Note that the default quality is usually zero which disables
>        using this rng to automatically fill the kernel's entropy pool.
>  
> -  reg:
> -    maxItems: 1
> +  reg-io-width:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 4
> +    enum: [1, 2, 4]
>      description:
> -      Base address to sample from. Currently 'reg' must be at least four bytes
> -      wide and 32-bit aligned.
> +      Access width in bytes.  Determines whether the read is performed as
> +      an 8-bit, 16-bit, or 32-bit bus access.
> +
> +  mask:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 0xFFFFFFFF
> +    description:
> +      Mask applied to the value read from the register.  Bits set to 0 in
> +      the mask are cleared in the output data.  Default (no mask) passes
> +      all bits through.
>  
>  required:
>    - compatible
> -  - period
>    - reg
> +  - period
>  
>  additionalProperties: false
>  
> @@ -46,3 +70,11 @@ examples:
>          reg = <0x44 0x04>;
>          period = <1000000>;
>      };
> +
> +    rng@64 {
> +        compatible = "timeriomem_rng";
> +        reg = <0x64 0x01>;
> +        period = <50000>;
> +        reg-io-width = <1>;
> +        mask = <0xFF>;
> +    };

Grow existing example. Or why can't it grow?


Best regards,
Krzysztof
