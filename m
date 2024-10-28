Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847F71DD87D;
	Mon, 28 Oct 2024 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126117; cv=none; b=tjlYtZ1qYIFjmH14A8VZeh6Afl7AmyAjwSpn9gjlqE/8MU5uJzjAtAOZVBCGyqoHZmNu3D/+HaDrgGEGavX32qrkt0bI9KAYQeA/9Ew+ecOWHWziaVvgMwGPCfD1WRlOSEIHmyKfVRewSOn90jsXHladAmo+p3SuGrEjKRm2/RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126117; c=relaxed/simple;
	bh=sURJvKknHSgjTV+4lsbwxGEcIobcXzLf+Y5XDBTzmAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X03OQjFZ6kvCSHC7mJDuh/jP4sey8a2haeZ0ixsMiF8nx29J/4dCM/fo37VmabbJJstf3aBREouRdcySwIhQU9uDvKcaMAlLQacd5g0E4JwZHnPkQUXEmA3trVPcDzeOwRr+jKMSUHHe41kv18ZwWGj5Q7ooU+9w9ssIYio8MC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmfzCuF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmfzCuF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48F7C4CEC3;
	Mon, 28 Oct 2024 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730126117;
	bh=sURJvKknHSgjTV+4lsbwxGEcIobcXzLf+Y5XDBTzmAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bmfzCuF5/wJDXD530OXqnm3m6xoZv6gru82OZAGmdxFz3pPFg1Qndpns4xDdTbli7
	 aZSMnOqPMLeWB9GmtE8l/RtdRch1JLAX+hn2Do9N70l5QkPsdYg9Cqcf/M3xSluy+r
	 lVzKt9dpdDM1aqZlDrm2TulhuyI8+ypcJzV2C5S6NK2x0qtrQ6NsfGSiwg6BtaqRC/
	 1JsYUK2ZabFQSGsGKoWUHWOMZKTQSVLiwhQglBeGGLbJh6sAB6u5EtC7nelP8LP2u5
	 SsVPmKeCwvk4G+YWQNm8ZGgKYWJoMROzp5LN1N04J8t++tUkow7ciMnbh77Bp0KNcr
	 kE8z0zCRnXUNg==
Date: Mon, 28 Oct 2024 09:35:15 -0500
From: Rob Herring <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Subject: Re: [PATCH v5 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel
 EIP-93 crypto engine
Message-ID: <20241028143515.GA792452-robh@kernel.org>
References: <20241028124206.24321-1-ansuelsmth@gmail.com>
 <20241028124206.24321-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028124206.24321-2-ansuelsmth@gmail.com>

On Mon, Oct 28, 2024 at 01:41:42PM +0100, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> 
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
> 
> All the compatible that currently doesn't have any user are left there
> commented for reference.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v5:
> - Comment out compatible with no current user
> Changes v4:
> - Out of RFC
> Changes v3:
> - Add SoC compatible with generic one
> Changes v2:
> - Change to better compatible
> - Add description for EIP93 models
> 
>  .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> new file mode 100644
> index 000000000000..188240b74110
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Inside Secure SafeXcel EIP-93 cryptographic engine
> +
> +maintainers:
> +  - Christian Marangi <ansuelsmth@gmail.com>
> +
> +description: |
> +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> +  integrated in varios devices with very different and generic name from
> +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> +  developed by Inside Secure and given to license to vendors.
> +
> +  The IP block is sold with different model based on what feature are
> +  needed and are identified with the final letter. Each letter correspond
> +  to a specific set of feature and multiple letter reflect the sum of the
> +  feature set.
> +
> +  EIP-93 models:
> +    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
> +    - EIP-93ie: i + SHA224/256, AES-192/256
> +    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
> +    - EIP-93ies: i + e + s
> +    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - const: airoha,crypto-eip93

Still doesn't look SoC specific...

> +          - const: inside-secure,safexcel-eip93ies
> +      # Compatible that doesn't have any current user.
> +      # - items:
> +      #     - const: SoC specific compatible
> +      #     - enum:
> +      #         - inside-secure,safexcel-eip93i
> +      #         - inside-secure,safexcel-eip93ie
> +      #         - inside-secure,safexcel-eip93is
> +      #         - inside-secure,safexcel-eip93iw

I should have looked at the driver before commenting before, but since 
you are using these compatibles, you should go with my other suggestion 
or these will be listed as undocumented.

Rob
