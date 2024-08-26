Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629CA17B51C;
	Mon, 26 Aug 2024 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724680353; cv=none; b=KCSOx9VMWOW2pJCtChqoQWdawQK7cN8gWY4GpGRtbfWfcHO8Gvz1jDNZBt12MMnODvPs6fzOq+dvNVd2njLp4XGtESTafwTm3+NpIjhqw+AjvpVptytv/CPG/glTc0z+rhRxAGwM1/172AEiOFoL2E6nBDCQsM1Eqf8OUKWC7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724680353; c=relaxed/simple;
	bh=Ih2aZy7VK+1vLk929aZ2HrdxEuygnHrgNQUcO7Z4NJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWHgVDh/Mt9b1hO9ouYiTszrXBU4Rp8zcAMT7Dmd8izfcgEG+NMyl6mDdHe1UXFR1L6y+7HZpTnSL9VLaM+vmAkt5tQXeli2HcgMbwByy/sP3N5MfF8RZr8Rm94B6irLiP1+ctOv0prlwtmcBGaDzHll6zuHoQs2YyCMp33Fwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnF1digA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnF1digA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35F3C52FC0;
	Mon, 26 Aug 2024 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724680350;
	bh=Ih2aZy7VK+1vLk929aZ2HrdxEuygnHrgNQUcO7Z4NJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mnF1digAxnCngL9LOjd3YG47mqco03wSu3Rda6ewvhEB2kBiqA7Wl1xSO2TxDQsAa
	 VhHRaztUJAEQYSdkscisW7+ABuMKMe3KlePokEddD1+HCrdkQ0xXmGdzFEr3Y93SeO
	 rJXi1IVbXVPhVW2qN3k97HVHkK5+5HaHV5+Pii+qPP6VmNbdVgtfkColVlwSzG4DJ7
	 BRmRWYFn16OkyvgiOeImC6L0d5vE3Dib/aoCkQiEUa5HkG1EhKezEws1IoRne5i5Ow
	 8NtxXRB2G34ErFIp8GsyvAqLo3Fk9hTFahRD9d5zvPb/UAXFM2uaY8Y8ZYhby/yCRz
	 aeyrcVStCpj/A==
Date: Mon, 26 Aug 2024 08:52:28 -0500
From: Rob Herring <robh@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	khilman@baylibre.com, jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
Subject: Re: [PATCH v9 18/23] dt-bindings: crypto: meson: support new SoC's
Message-ID: <20240826135228.GA61588-robh@kernel.org>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
 <20240820145623.3500864-19-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820145623.3500864-19-avromanov@salutedevices.com>

On Tue, Aug 20, 2024 at 05:56:18PM +0300, Alexey Romanov wrote:
> Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.
> 
> 1. Add new compatibles:
>   - amlogic,g12a-crypto
>   - amlogic,axg-crypto
>   - amlogic,a1-crypto
>   - amlogic,s4-crypto (uses a1-crypto as fallback)
> 
> Difference between this compatibles:
>  * Different registers offset and the number of setup descriptors.
>  * GXL doesn't support hashing like the others.
>  * G12A/B and A1/S4 crypto HW don't support 192 AES key.
>  * GXL, G12A/B and AXG require a reverse IV key before processing.
> 
> 2. Add power-domains in schema, which is required only for A1.
> This is specific vendor design: in old SoC's power domain for
> crypto HW was not configurable, but in A1-series it is configurable.

You added this in the previous patch. So I withdraw my Reviewed-by.

> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   | 21 +++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> index 7300328de1d5..106a9d1fed69 100644
> --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> @@ -11,8 +11,16 @@ maintainers:
>  
>  properties:
>    compatible:
> -    items:
> -      - const: amlogic,gxl-crypto
> +    oneOf:
> +      - items:
> +          - enum:
> +              - amlogic,s4-crypto
> +          - const: amlogic,a1-crypto
> +      - enum:
> +          - amlogic,gxl-crypto
> +          - amlogic,axg-crypto
> +          - amlogic,g12a-crypto
> +          - amlogic,a1-crypto
>  
>    reg:
>      maxItems: 1
> @@ -33,6 +41,15 @@ required:
>    - interrupts
>    - clocks
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          const: amlogic,a1-crypto
> +    then:
> +      required:
> +        - power-domains
> +
>  additionalProperties: false
>  
>  examples:
> -- 
> 2.34.1
> 
