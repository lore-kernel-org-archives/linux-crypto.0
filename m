Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D8282F18;
	Fri,  3 Jul 2026 06:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783061494; cv=none; b=CIsxLN1DBuTALtHO5sfCkDJb4WSdjngtacvgInnMKJPBjj4JWJq7PwJ6sAsZsNMO0JTQ65HwuGfttqvuhKwnkDaiRga2I8+PygFY0ISC+k50NGleoAgEUi8dGjxw3KcIFhCryvo2Tl4XXQCUNf4ZB0esemf6H7HvT/jncl3j+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783061494; c=relaxed/simple;
	bh=VyBwtiwEieSiIIGma2mDQI0QVyOxWGwCHI21AN1y5wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dbnhx0tzCNcWCZxDpFUDPdVfMbKISqi/QsHdfXED/n6pgZP0xezgP+GAuh1by+5t8hFCaKdMyXBKwcjh1DI09GLFWijQTq9zJxl3kS6vhkXs0cNiL4Bvt4JJNf5lWX8CgHaaQs6TqCoQmwvTTMvhgi4TphD2FpGak0fPjdqMzi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7Na/6Vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7Na/6Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306C31F00A3F;
	Fri,  3 Jul 2026 06:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783061492;
	bh=t+IcM7mmiTmoh28YJxL6FUZ0PgcEuIvhrm5jZ5vcolI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I7Na/6Vqws4y7tOz0+uPfwk6zFUa+43bNDWH2tbbizoa29y5PZs9SnHFomLnKhROD
	 O+qVzgqRvKPWI9zfPUNsxUfeRMz1pofeqi1m22j+NNYE23dh6i0TDHYftiqYJxA7eP
	 Zk7fhrTw5mXyV1FhxhwnQ7Gd7Z4eH79h7mjSUXAGUefmBsCNJSXy8xDifl11TsbazB
	 I4NW7rlkY00wzrGNIuesentthOXEx5IseSzYN25ikyFS6k3tcKj6gzV1lBi1xsYDRn
	 V5JeiOYOxBgNkl9pEGe+u11GgEbAhQKaUDC/P4mjpf7xonhK9ZErgvXfzdM+W6eu07
	 Fas+yUSMTQVEA==
Date: Fri, 3 Jul 2026 08:51:27 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Fix legacy/new SoC strictness split
Message-ID: <20260703-nice-beetle-of-efficiency-eafad3@quoll>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com>

On Thu, Jul 02, 2026 at 01:47:11AM +0530, Kuldeep Singh wrote:
> Couple of already merged SoCs describe ICE as single clock historically
> which are recently updated with mandatory 2 clocks.
> 
> Keep only the known legacy compatibles flexible, and make strict
> validation default(of power-domains and 2 clocks) for all other Soc
> compatibles.
> 
> This ensures old DTs are valid while ensuring any new SoC (not in the
> legacy allowlist) must follow latest requirements by default.
> 
> Fixes: e27264daac7d ("dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk")

Please drop, original codeo was correct, no bug to fix.

> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 23 ++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index db895c50e2d2..4f3689a24410 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -55,14 +55,25 @@ required:
>  
>  additionalProperties: false
>  
> +# Do not extend the list.
> +# Legacy SoCs are allowed for single clock.
> +# New SoCs must provide both clocks and power domains.
>  allOf:
>    - if:
> -      properties:
> -        compatible:
> -          contains:
> -            enum:
> -              - qcom,eliza-inline-crypto-engine
> -              - qcom,milos-inline-crypto-engine
> +      not:
> +        properties:
> +          compatible:
> +            contains:
> +              enum:
> +                - qcom,kaanapali-inline-crypto-engine

Your change is not equivalent in relation to hawi. Please make it
explicit in commit msg - all devices which are fixed by this.

> +                - qcom,qcs8300-inline-crypto-engine
> +                - qcom,sa8775p-inline-crypto-engine
> +                - qcom,sc7180-inline-crypto-engine
> +                - qcom,sc7280-inline-crypto-engine
> +                - qcom,sm8450-inline-crypto-engine
> +                - qcom,sm8550-inline-crypto-engine
> +                - qcom,sm8650-inline-crypto-engine
> +                - qcom,sm8750-inline-crypto-engine

Best regards,
Krzysztof

