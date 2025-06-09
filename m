Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B92505CB;
	Mon,  9 Jun 2025 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749474922; cv=none; b=RVG3A8lOmW8MNv9Wj75X9PH876XREBtY1oTdV2UqOoHh33BPDb9jsf1kFXt+/RnRT+EbFohFXqmXBKHWLtKD7JijqZghCTITv8Tg50ypkVbb45FY0vNX3tQ9nl3QPAbFDNUoK6uDYhIU34P0fV5YDVFugRwTg7/9dLTGlnw2fkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749474922; c=relaxed/simple;
	bh=j8xoKgKfro/Bd9fgQpXYtZM22e8ov44Ze5bH5xPMj6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mj8qK2m4bfmdn2Lyui54EthvTkMn1Hw18Nc5+hLLfEwCpjznDaBQF+mtAqTZYOZzj1A1k9gTzjw0OjhRYvVGxTgSRVgX/wDq9BQE9XTQcljjBCCu7vdiI90cUMTFZdmmh0wvIsFtIuajOJL8r4esX5wWSWlrw12mcpHrsWueAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/b3DS2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/b3DS2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14013C4CEEB;
	Mon,  9 Jun 2025 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749474922;
	bh=j8xoKgKfro/Bd9fgQpXYtZM22e8ov44Ze5bH5xPMj6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g/b3DS2zkUOqSHGxHWqLozKCbyHb5B10l1tzLgMvo+Ihd1shQFeXQFIWvtZkUYLe4
	 6Hm1RQaMrYgqiyOh+mUY5CZPvq9S+ttacJScCgM1lh8PyDVoRSQNfIUqS3RKSTwtQb
	 2ccfwPj7ZdwtYs6GFWEtfVH7aDNA1wrraYBP4INV1pHmZfysVQi+9FE1bEeHUe6o4w
	 nKwVPY/87DET8ry1BO7DsXx7VACW60WUbmgCgrlcpvPpyDfiH9MW9xmycDw0SdmF1F
	 s+V3+dC9LMZDPqoOk0ryt845fIktiSs0yA0GUoDJhBV7fSxdVXoFnoCKsX0bjnZA3O
	 z4CubotZHdb3g==
Date: Mon, 9 Jun 2025 08:15:21 -0500
From: Rob Herring <robh@kernel.org>
To: Harsh Jain <h.jain@amd.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	mohan.dhanawade@amd.com, michal.simek@amd.com
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random
 Number Generator
Message-ID: <20250609131521.GA1700932-robh@kernel.org>
References: <20250609045110.1786634-1-h.jain@amd.com>
 <20250609045110.1786634-2-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609045110.1786634-2-h.jain@amd.com>

On Mon, Jun 09, 2025 at 10:21:05AM +0530, Harsh Jain wrote:
> From: Mounika Botcha <mounika.botcha@amd.com>
> 
> Add TRNG node compatible string and reg properities.
> 
> Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> new file mode 100644
> index 000000000000..b6424eeb5966
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/xlnx,versal-rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx Versal True Random Number Generator Hardware Accelerator
> +
> +maintainers:
> +  - Harsh Jain <h.jain@amd.com>
> +  - Mounika Botcha <mounika.botcha@amd.com>
> +
> +description:
> +  The Versal True Random Number Generator consists of Ring Oscillators as
> +  entropy source and a deterministic CTR_DRBG random bit generator (DRBG).
> +
> +properties:
> +  compatible:
> +    const: xlnx,versal-rng

I believe the prior comment was only about the node name. If the block 
is called 'trng' then you should call it that.

And please test your bindings before sending.

Rob
