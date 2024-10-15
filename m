Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D6185B47;
	Tue, 15 Oct 2024 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729030662; cv=none; b=HEoOQPGXvp5epQSe8qJI1IYXXPo4NMnR3lAvPFY3Xuudn8tzy8hk/gn/8pABAsRs0J1jnn/UC842zyph1vUrnZMC1v5/ay825M6Y9AKWpp021qWiCwu2m8AGwYoNB8B+7qbbWH7p2ox6bFlOA7RqOU2M4az/x7xXGoc5xS0xM1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729030662; c=relaxed/simple;
	bh=uMYkHlMKaytHOvnhHen4sk4aMkGAAmVSj+k1YxZcbDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwmEM7BGAti2j7lw1HxMCixOTeOmMTfRvO2XPzNw7JOBwZ6HLQMjt40cwEyzxWdquwUglnyZ/G3t3LHY6D7IFcgRIuGyNW6Iwi+ZvrdQ60n+eB2ijNNAHY5w7T66ozlakfbs1hlh2j3erDp09wfFbkAn9S2TQ8opYn9P68VFFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9TNb6Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9TNb6Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924D3C4CEC6;
	Tue, 15 Oct 2024 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729030661;
	bh=uMYkHlMKaytHOvnhHen4sk4aMkGAAmVSj+k1YxZcbDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q9TNb6Y7mb2ZnDSkREuBd+zIZhQ5UlL4+nGnSv6fUlRhQQYyEjJgfHNzkHJpNNUIE
	 Awwzor3n00sSb9KTvfywA+9gBoqnwxE3tSAPVgOY2MRJr90V+PqMte0D34wMA6Dyii
	 lVNrktg9wupODvZnp/zFjluPk7+q3unGwiDzeIM1OzlJbXdrzM7uBcxa7lh+xw0z9q
	 aGCi0vyTZ0Yv4Ea3RVEHowbnGY72hkqGKDskK7orwREwNTNWDUYDXWLBnaWhcU/ZBY
	 bgpMr/hvstaNV5NQKwAyLElO/cxdzaC0Qz24kVNVlkxBjst7GvqnPA9F2GeMXxAKg1
	 rftr8OQpGU9iQ==
Date: Tue, 15 Oct 2024 17:17:40 -0500
From: Rob Herring <robh@kernel.org>
To: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>, marex@denx.de,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Message-ID: <20241015221740.GA2100600-robh@kernel.org>
References: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
 <20241015-rng-mp25-v2-v3-1-87630d73e5eb@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015-rng-mp25-v2-v3-1-87630d73e5eb@foss.st.com>

On Tue, Oct 15, 2024 at 06:48:54PM +0200, Gatien Chevallier wrote:
> Add RNG STM32MP25x platforms compatible. Update the clock
> properties management to support all versions.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
> Changes in V3:
> 	- Add constraint on clock-names for st,stm32mp25-rng compatible
> 
> Changes in V2
> 	-Fix missing min/maxItems
> 	-Removed MP25 RNG example
> 	-Renamed RNG clocks for mp25 to "core" and "bus"
> ---
>  .../devicetree/bindings/rng/st,stm32-rng.yaml      | 34 +++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> index 340d01d481d12ce8664a60db42182ddaf0d1385b..c276723d566ce4a0d6deca10c491510644d842f8 100644
> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> @@ -18,12 +18,20 @@ properties:
>      enum:
>        - st,stm32-rng
>        - st,stm32mp13-rng
> +      - st,stm32mp25-rng
>  
>    reg:
>      maxItems: 1
>  
>    clocks:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: core
> +      - const: bus
>  
>    resets:
>      maxItems: 1
> @@ -57,6 +65,30 @@ allOf:
>        properties:
>          st,rng-lock-conf: false
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - st,stm32-rng
> +              - st,stm32mp13-rng
> +    then:
> +      properties:
> +        clocks:
> +          maxItems: 1
> +        clock-names: false

It makes no sense that you allowed 1 entry, but then disallow the 
property. Either drop the 'minItems: 1' at the top level (keeping this) 
or put 'maxItems: 1' here, 

> +    else:
> +      properties:
> +        clocks:
> +          minItems: 2
> +          maxItems: 2

maxItems is already 2. Only need minItems.

> +        clock-names:
> +          items:
> +            - const: core
> +            - const: bus

You already defined the names, don't do it again. You need either 
nothing or 'minItems: 2' depending on the above.

> +      required:
> +        - clock-names
> +
>  additionalProperties: false
>  
>  examples:
> 
> -- 
> 2.25.1
> 
