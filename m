Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640B41DD555;
	Thu, 17 Oct 2024 12:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168705; cv=none; b=pd/cypmx7DcWA2yndLLuvIU10MmgPQ/H0pIvqjihPVJ6nCYIa17aeQjnW6BHQU1QEJBzTolWQILiSTimKZb76IhP2aimubo4t79CRTio4zCPYp0z+ZhhLtI6QrgIbyqkFQvrAuAU4yfw5lPqEGNiJ8HWyF5bBvY6Uh06kINVdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168705; c=relaxed/simple;
	bh=OIrbp2CVtvg4UWFxQXRqZHrfcrJEkOcp4KyDD/C3SZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uB/IaVhYcn/HeOSTc3l4M/d7fyyKt4sUaotAhZ1m+omGNQ9W42KzfgZDu3Y29OcEgcYvlNPztiUWEnZRQ70RcERUmWToxEEq6YndMnkKxnwfjbjiRAZkwZJrPBp1eYkpXxpTvee+ELJMP6tGiDgHOCI+3pgojsg8/7669LVqt+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9EYVNij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9EYVNij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B29C4CEC3;
	Thu, 17 Oct 2024 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729168705;
	bh=OIrbp2CVtvg4UWFxQXRqZHrfcrJEkOcp4KyDD/C3SZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9EYVNijAzTcR9+Q0nJWF76QGbpC+i2F8Ibd8Pe90Lok8iYwrawrW1sU7xB48VpbX
	 DusFdxUNub+eo2+w5hWdTMVqxJOMKF1L84kcSNbOJAsluJd2oBkBwYM5J7LzRmp0B/
	 eKaik9MtUzVjTAg0rc94FslYDLuYTN29+jqiAsjRR7rFjEBsUYlmk7S0GSo4ES3HRZ
	 2keZZ9VINR1rnGmQwjR2xlHfHUBoKoHqPBY8Sr4w23dsdsyn3P5rz5a+RHiSSFWpr8
	 oi3DIiTkz5PyHoFXhI8WdQb7eAXy6Zx3eS3ICgzkda0hwfX+2EPPBn8+BXg1EimbIB
	 OtBDc/5J7JCGQ==
Date: Thu, 17 Oct 2024 07:38:23 -0500
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
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <20241017123823.GA3032377-robh@kernel.org>
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
 <20241017004335.27471-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017004335.27471-2-ansuelsmth@gmail.com>

On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> 
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v2:
> - Change to better compatible
> - Add description for EIP93 models
> 
>  .../crypto/inside-secure,safexcel-eip93.yaml  | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> new file mode 100644
> index 000000000000..fc0877d93514
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> @@ -0,0 +1,61 @@
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
> +    enum:
> +      - inside-secure,safexcel-eip93i
> +      - inside-secure,safexcel-eip93ie
> +      - inside-secure,safexcel-eip93is
> +      - inside-secure,safexcel-eip93ies
> +      - inside-secure,safexcel-eip93iw
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1


No clocks? All their other IP has clocks.

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
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    crypto@1e004000 {
> +      compatible = "inside-secure,safexcel-eip93ies";
> +      reg = <0x1fb70000 0x1000>;
> +
> +      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +    };
> -- 
> 2.45.2
> 
