Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C987C149C4D;
	Mon, 14 Oct 2024 07:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728890948; cv=none; b=FGWMOzpSuk/jRjjjnN3SdIdMAhvwcEQFaJhfYCQd92T5GYUuWUFfaPO+HfM6os1Cuo3Mk8u40VISgxxafIHR0QFLVXiv6yxlQH+qDdrEPmfKmXB8FyP0z0bN0FJKPSgRhLECZURRaDoBzWjpdXwH/KgIonjmrzSCJgCqkHHKjgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728890948; c=relaxed/simple;
	bh=aveYbHuznRE0CLFdZ+yNLmHKHVrJklEvhvr//84Jf90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/71nDAWRbQ8zZZbwxubLoSWHS25BjmtPSqT5OL6FqF3iuhsjWE5TeYEoSB6ZpR/UW8GxCfltlLV/o9HGfHXAjOH0IzOWEhR22F4j0PMoLKHvQVCZfSo3XGX53HZ+isSnYfp+QBxp7OF05mIbK8QE3ixRoJ3S7jfs2VGjiLYEMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UD/1c2LK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UD/1c2LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0ADC4CEC3;
	Mon, 14 Oct 2024 07:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728890948;
	bh=aveYbHuznRE0CLFdZ+yNLmHKHVrJklEvhvr//84Jf90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UD/1c2LKksdY8WX41g8hpgrOafZHQxS2jZbkPQmSAWT8PQy832/+4yjjQF9MGhP9G
	 s6vGp6gY7hY8yJH4b6vQtHv/tJ7K6VceKLS8B0/O0EQmtYZnSNN6tNMrC89Y+ag3Ga
	 xuzpnhBhYWq/P7uDaEoVwPQ/lzxInnUVfSOz2a0bMTe3RA+kyMo7T/KT73CxV4r937
	 9vBKfPQ4mGa4FZUuaoMGv3+4kl0MyYu8tgO/ULRexs7erxyaLB9NfhuZGA1dYJpaHR
	 cQaKi73VLfIhO1sD3RC7lFKovrwRhlHXRYHP73ZyaULJmO28eDCX28hLILAXnqiArW
	 m2ydyy7inoZeA==
Date: Mon, 14 Oct 2024 09:29:03 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Lionel Debieve <lionel.debieve@foss.st.com>, marex@denx.de, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Message-ID: <v4c7vwoqfposhm3bxnidjzwb7via7flf2em45qbgjjncwfvv74@n2rsz3ujpdoc>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-1-76fd6170280c@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241011-rng-mp25-v2-v2-1-76fd6170280c@foss.st.com>

On Fri, Oct 11, 2024 at 05:41:41PM +0200, Gatien Chevallier wrote:
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
> @@ -57,6 +65,26 @@ allOf:
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
> +    else:
> +      properties:
> +        clocks:
> +          minItems: 2
> +          maxItems: 2

Missing clock-names constraint. They *always* go in sync with clocks.

Best regards,
Krzysztof

