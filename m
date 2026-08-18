Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED7D39FCB5;
	Tue, 18 Aug 2026 07:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038941; cv=none; b=VucoZl9KPkefldJ9tKrEDPDElr88f3AE1wXhKOMoTc7IWvGscvoLjcCRkBOxeWrTiW0GLeCW+9y0yVWxw6zCEDFocc1A4ER2V6Na3ta/1KmNxfjaZ/31uhiPCTe6ytf0mUBGqZni7jnzI5HoTL4+ubOlxe7eLgZtxrDCYq/GCro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038941; c=relaxed/simple;
	bh=Jbj3xKqPibrgGY7IU9h+4vYoNQOeALoqkWlUJR7CKuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUA6wNvIbU+dzFgQzDOwcrbPgbbaARmbF/2E04X5ITLvcRyh++ChSlHNNPoyzf1ddZydA/bRc8x04FTgFrshZC4ripwvyD8oQm5kYWMYXqQNTTMdwTiZF5rX5XQT/mlwz/MFC8+HDvWHKxQkRFzWS1RaJW1JJSAuyXX+PirT0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZFYfVEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZFYfVEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A65A1F000E9;
	Tue, 18 Aug 2026 07:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038940;
	bh=LX0teEYZDicZcHJo2lDUYkFNlLlxLZ1Jm2aWE8Ry63M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PZFYfVEy+WZcBBNcSUtD9qhZrqUINBhI+JJRLWmOUm9G58VB38rnMfUQhQq+dHFI2
	 dwtSKT8kSSYEAaLEMeEFUemqRs06m77WO/uriOYiEfp8rTQzsZNJtAA77aiHystCxG
	 g2wwAd6Eo8NZv/BsrnDsOCAlnNjikWR5rhWieIDgQtE7Wb8IBFr3Esso8JJxiozlk/
	 rlMAR6OjuG6dNJ5YGARTQiU9K2iOKDbP/7ykACOza1bb8NLpsENC1G2fcgFedjKFKq
	 kwhpinqSKTFGfC5g1FegwOyeZ4dGl3a9ciGAAtF8avqqEFmXNsygPbNDy5zvCglqb4
	 YUrAl0lkMh8kw==
Date: Tue, 18 Aug 2026 09:42:15 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Dawid Olesinski <dawidro@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Diederik de Haas <diederik@cknow-tech.com>, Eric Biggers <ebiggers@kernel.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Conor Dooley <conor+dt@kernel.org>, Corentin Labbe <clabbe@baylibre.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588
 crypto engine binding
Message-ID: <20260818-gracious-sincere-limpet-affeee@quoll>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
 <20260816194112.552100-2-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260816194112.552100-2-dawidro@gmail.com>

On Sun, Aug 16, 2026 at 08:39:44PM +0100, Dawid Olesinski wrote:
> Add a YAML device tree binding for the Rockchip second-generation (V2)
> cryptographic hardware accelerator present on the RK3568 and RK3588 SoCs.
> 
> The IP block exposes AES-ECB, AES-CBC, AES-XTS block ciphers, SHA-1,
> SHA-224, SHA-256, SHA-384, SHA-512, MD5, and SM3 hash algorithms, each
> with a hardware DMA engine controlled via linked-list descriptors.
> 
> The binding covers two compatible strings:
> 
>   - rockchip,rk3568-crypto: clocks and resets are driven directly by the
>     non-secure CRU (accessible to Linux at EL1).
>   - rockchip,rk3588-crypto: clocks and resets live in SECURECRU, a
>     register bank sandboxed to TrustZone. Linux must request them through
>     the ARM SCMI firmware interface (scmi_clk / scmi_reset), as direct
>     MMIO access to SECURECRU from EL1 triggers a bus fault.
> 
> Co-developed-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
> Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B,

Nope. Not possible. Drop non-applicable tags.

> NanoPi R5S, NanoPC-T6 LTS
> ---
>  .../crypto/rockchip,rk3588-crypto.yaml        | 83 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +
>  2 files changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> new file mode 100644
> index 000000000000..32d241c19453
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml

Fallback should be used as the filename.

...

> +  clocks:
> +    items:
> +      - description: Core clock for the crypto IP internal logic
> +      - description: AXI interconnect clock interface
> +      - description: AHB interface clock
> +
> +  clock-names:
> +    items:
> +      - const: core
> +      - const: aclk
> +      - const: hclk
> +
> +  resets:
> +    minItems: 1
> +    maxItems: 3
> +
> +  reset-names:
> +    minItems: 1

Why is this flexible?

> +    items:
> +      - const: core
> +      - const: aclk
> +      - const: hclk
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names

Binding looks the same as
Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml.
Why it cannot be added there?

Aren't the clocks and resets basically the same as in that file?

Best regards,
Krzysztof

