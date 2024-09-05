Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB4D1C2E;
	Thu,  5 Sep 2024 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560627; cv=none; b=GlpsuUoI7l0YTL9PpU+61qixcGjm0H1mZ1URzhC2yCefYT9b0yFirmdunas8n6V4Bmv9Z6BP6khNTd5GzsXnneVwpHsPG0LJzgS0HVy3UnMC2VLYzMFOW3fl4zMYGtOCS6kVcyLwT9YU20mKtE3kqNm5wtIJAXbGKmZSkG5BktA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560627; c=relaxed/simple;
	bh=PtjNoe5jlMKiok2si2WsANBDKQGCK5KIJtAGL+Nf4m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Py7j4uSgdBXVrge6wxjGyvQuiJD2iU5e0YnpLIrrso4xJ6I7sHpMxF2hWeyqm9LgN7iSvjP27u+YXCzq/AeqRYxqX2jjN/pwdI4PE7S8Ss4i3ErUHLwyUnTeCEI0KsOG1jCjvN/Yjtem4fzhZlRsl9dj0pD+5Ci0bW+TxCUUheE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVXZ0Dxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVXZ0Dxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC58CC4CEC3;
	Thu,  5 Sep 2024 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725560627;
	bh=PtjNoe5jlMKiok2si2WsANBDKQGCK5KIJtAGL+Nf4m4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lVXZ0Dxg2Q/WBRBiLuFPMttb6g1ZOWYI5oYc9+ArGSvLC+PHsfph1NR02ouASez1M
	 SIUvs3tTNL6IcQcjbE1b/Q3RAoMrIqz+UIGHzHC/mFIBuGNyBbUzz8hb71EdUvPpJH
	 rFaE9QiHFhAat0pEs8xHkDhoBQQPK7ixQ8qC/1Gx+6QA82uKBGudZQQ1fsIjXbgY7t
	 7k221q8HCT464QULZivP2OoABNpxqZefrQIPnu0A+0eIC9YucKPnWb9G4HorxkodbL
	 fE0N0w8aRcvEE+2ioe7moNB6CyMrBmrU1BUlKTFYF9DIQgf7rq4oDJHsXU9wvgBAF7
	 ZFnzI8LkN3W3g==
Date: Thu, 5 Sep 2024 13:23:45 -0500
From: Rob Herring <robh@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v1 1/1] dt-bindings: crypto: Document support for SPAcc
Message-ID: <20240905182345.GA2432714-robh@kernel.org>
References: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
 <20240905150910.239832-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905150910.239832-2-pavitrakumarm@vayavyalabs.com>

On Thu, Sep 05, 2024 at 08:39:10PM +0530, Pavitrakumar M wrote:
> Add DT bindings related to the SPAcc driver for Documentation.
> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> Engine is a crypto IP designed by Synopsys.

This belongs with the rest of your driver series.

> 
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>

There's 2 possibilities: Bhoomika is the author and you are just 
submitting it, or you both developed it. The former needs the git author 
fixed to be Bhoomika. The latter needs a Co-developed-by tag for 
Bhoomika.

> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> new file mode 100644
> index 000000000000..a58d1b171416
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> @@ -0,0 +1,79 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto Engine
> +
> +maintainers:
> +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> +
> +description:
> +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine is
> +  a crypto IP designed by Synopsys, that can accelerate cryptographic
> +  operations.
> +
> +properties:
> +  compatible:
> +    contains:

Drop contains. The list of compatible strings and order must be defined.

> +      enum:
> +        - snps,dwc-spacc
> +        - snps,dwc-spacc-6.0

What's the difference between these 2? The driver only had 1 compatible, 
so this should too.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    maxItems: 1

No, you must define the name. But really, just drop it because you don't 
need names with only 1 name.

> +
> +  little-endian: true

Do you really need this? You have a BE CPU this is used with?

> +
> +  vspacc-priority:

Custom properties need a vendor prefix (snps,).

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Set priority mode on the Virtual SPAcc. This is Virtual SPAcc priority
> +      weight. Its used in priority arbitration of the Virtual SPAccs.
> +    minimum: 0
> +    maximum: 15
> +    default: 0
> +
> +  vspacc-index:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: Virtual spacc index for validation and driver functioning.

We generally don't do indexes in DT. Need a better description of why 
this is needed.

> +    minimum: 0
> +    maximum: 7
> +
> +  spacc-wdtimer:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: Watchdog timer count to replace the default value in driver.
> +    minimum: 0x19000
> +    maximum: 0xFFFFF
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    spacc@40000000 {

crypto@40000000

> +        compatible = "snps,dwc-spacc";
> +        reg = <0x40000000 0x3FFFF>;
> +        interrupt-parent = <&gic>;
> +        interrupts = <0 89 4>;
> +        clocks = <&clock>;
> +        clock-names = "ref_clk";
> +        vspacc-priority = <4>;
> +        spacc-wdtimer = <0x20000>;
> +        vspacc-index = <0>;
> +        little-endian;
> +    };
> -- 
> 2.25.1
> 
