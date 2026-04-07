Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960522D7A1;
	Tue,  7 Apr 2026 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775591358; cv=none; b=KEBTeoEA9K//+yqJsPRPuzT2492idZM1EnvCnFYkUsWuQmZH87Xjnz+dJpc5YFju/bDK+Yg1dbR+cdCNQAowZs4afbjsOYgibccT+8AihWcq41lH6d7EdwBnYm6Wz7dmPfoUiYbN5mOwM4VdNLl337id9gNnFSA51MvDWQH4BWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775591358; c=relaxed/simple;
	bh=oqbAKOv1nEndaT+hv9Rr78xtFrIbYwevtxdkW24GrXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV9Gnsn3Gtm2bESsDtr8urgUh39sCsLuzJvz/XywUh3HOVsEdGr5/o8NvxgUv8X+I+nzIkHKFpmLfdWIRD54dn1MCONhzbvM+mK8SqIFkRMfzJgW1jNXJr5kJ477CJQeudEcCddOVWjGgGru4k/CIeJvScBW/05jtoQWTwvMaJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZgsYLfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZgsYLfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A56C19421;
	Tue,  7 Apr 2026 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775591357;
	bh=oqbAKOv1nEndaT+hv9Rr78xtFrIbYwevtxdkW24GrXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PZgsYLfbSWHhAAnoVRZ0ey6NIqq/WdNkTqdIvBKCbzE5nZObFweMSed3JIR762303
	 VkwbCcPM/iqwi2gEFaLlZpfy5oRK7z6FOZCWaVq1xcpACzRiJpTTDoJ644p3EOhAEa
	 iiFoPzNttEhHSTDoeSm8VoAL66IandokPkFuhGQgH/EPjTiCxjEVhiC8LAHmOe058a
	 UzxXFVm1vO+J5iQNOUxtJL7ofSH7mQK8j99ls6NcZBOUJv1UBWFMAB2ioW5o2Kkwib
	 qNu+0Y95IsoA0KRSTGNBJevyu/oQl7yyc8c6Nuvk9UvxOGs05rUfjGBR3zhZ2UGGxQ
	 BYgqnNS6iGdKQ==
Date: Tue, 7 Apr 2026 14:49:15 -0500
From: Rob Herring <robh@kernel.org>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 04/16] dt-bindings: crypto: eip28: Describe EIP-28 PKA
Message-ID: <20260407194915.GA3562333-robh@kernel.org>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-4-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-4-5e6ff7853994@bootlin.com>

On Fri, Mar 27, 2026 at 09:09:26PM +0100, Miquel Raynal (Schneider Electric) wrote:
> Describe the Public Key Accelerator named EIP-28 from Inside-Secure,
> part of the SafeXcel family, it is typically included in a bigger
> hardware container named EIP-150.
> 
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
> ---
>  .../crypto/inside-secure,safexcel-eip28.yaml       | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml
> new file mode 100644
> index 000000000000..96acb257450a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml
> @@ -0,0 +1,31 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip28.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Inside-Secure SafeXcel EIP-28 Public Key Accelerator
> +
> +maintainers:
> +  - Miquel Raynal <miquel.raynal@bootlin.com>
> +
> +properties:
> +  compatible:
> +    const: inside-secure,safexcel-eip28
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 3
> +
> +  clocks:
> +    minItems: 1

maxItems: 1

(only)

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +additionalProperties: false
> 
> -- 
> 2.51.1
> 
