Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C017545;
	Mon, 10 Jun 2024 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718058741; cv=none; b=NTtP+QpcrscqjDvoR5klC/CvA0UPYX9oDR+eI9HMD5sYdHSCna9FuTnc74DRDuf4S7m/PH3ioYxsI6C/xNyaBsv7Jh4W7RvroaDzw/kOfgv7MbNFcHb835vDoidignV4mviNDgJqGaKYqPYRl8vBgOo/I/l4xBih3CabKQo8DJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718058741; c=relaxed/simple;
	bh=Wt7Pzfxyq20AcjEBu7nZDSRzfK6ptsm4tLFP5cYJIwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fovH/P5Yw9B3tQYVFcIO/wf5KXlP5l29e828YErnNoamD0j+o3enXMAl0G6k1Mp/8RF3v5ebWZ67Ry6Bp5tkI1qGzWtQvJxCcpb6ORJsxzeSpv5NQmUQ23epwRx1BaXL+cis5B6OenwlV0fifWzgWfvJBu9XAh2dzDu1RAlSiwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED7MjdO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED7MjdO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02078C2BBFC;
	Mon, 10 Jun 2024 22:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718058741;
	bh=Wt7Pzfxyq20AcjEBu7nZDSRzfK6ptsm4tLFP5cYJIwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ED7MjdO6mPoaUcOm0MdqhRVSsw69DhTqKOcRTILKsXVHrEkXBEWQ+U4yGFo2svjS4
	 sNAvyU5s9tLXo9MkPr0L7WtTTR+45vq1K+AYi+mpR5I/TwIvJtjOZkz4sVi+xXSi0g
	 rHsIR10ApGF8g06ltOZQXetW9h7x37Q+V98PH71MNd/OsRuzVoLyxywJiYxZ0iOhfo
	 DTO84t5m7HhoAUkVUwWFnMkG53JwpbCWaFQ0Pjous7qt5aHx9K/gOdY8tF8n1GbA4P
	 L/4rUodyejQaRE6u8Mo1AVEKyWMf5QnMnvbbsk/7gj4wNdjuWIo4MW8yaRkIxKh8Rr
	 I8QSfzzS+OlPg==
Date: Mon, 10 Jun 2024 16:32:19 -0600
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
Subject: Re: [PATCH v8 19/23] dt-bindings: crypto: meson: support new SoC's
Message-ID: <20240610223219.GA3175091-robh@kernel.org>
References: <20240607141242.2616580-1-avromanov@salutedevices.com>
 <20240607141242.2616580-20-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607141242.2616580-20-avromanov@salutedevices.com>

On Fri, Jun 07, 2024 at 05:12:38PM +0300, Alexey Romanov wrote:
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

You added it in the prior patch, was that supposed to be done here? Kind 
of strange for h/w to optionally have a power-domain... It either has 
one or it doesn't. OTOH, making required is an ABI break.

> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   | 21 +++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> index aff6f3234dc9..a8344de71b4a 100644
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
> @@ -37,6 +45,15 @@ required:
>    - clocks
>    - clock-names
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
