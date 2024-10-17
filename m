Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288081CACF7;
	Thu, 17 Oct 2024 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153440; cv=none; b=YYzLwPUBGebXunzpfbTJUqAT0dn1haWpVvY+0JV+08z+pThLe2bnqUJZX+4CU2R5Al1Ieq0XdKDlCO5MEj3If9HjXC4lA0IICL4g++FTX8o2+Id18ikjp2QqGVvQiIaB7e7elMnJ0Tg9KAofGcR6ThmV1uAeenMqkt5Gel7SQ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153440; c=relaxed/simple;
	bh=XxftJ6oXiIU+iaP5bZcCAfnmm8FL2K3XipgdpZMiRoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxxhyeJPFILUBoCyYyS1Lesmpq5ychRxJVL4IjxF1eVKmigsQFxqRmzCgzz9EaujF+2zOkH6MomafJWhAlKeoFUngh99O6LxHd852HmHOuEw/Ha5rGMhz1QSQe71aGr5yp71FJ5hLjMLJ6vvfhrGsqEQytqkZPiJAlShVpWL9kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nt+RPTHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nt+RPTHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939ABC4CEC5;
	Thu, 17 Oct 2024 08:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729153438;
	bh=XxftJ6oXiIU+iaP5bZcCAfnmm8FL2K3XipgdpZMiRoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nt+RPTHyHLSlO6M9XPChgoE0D4TxM75Hb17lucuM7RgMTy23r21+9tA1qryCPxdQc
	 nn+Ec5aQ5rTe+MBoBwXEV7nIZ/17yCVBb4ZZJpWWGKWOTiTfC8eKJXmn7v9YNDtszB
	 oHs4K4LDe6gQNHnTP/Omw3GOyvzoNh9YExmskz3wUbQZwCc5CRMGVjgsL4OjVPw16l
	 Gu9luRuJ7fK89Zv/xC44DKStEeT6moFt0WkYwVY3dYZQX98EuzFGWTqSBAysIcANbJ
	 nBCBT7DOKyXSZm85nBZm1ctXKG8D0p4iYTd5VExcHKEsLSdxmIK6UtN87HuiAHemZ5
	 CtksBvd2pXFdQ==
Date: Thu, 17 Oct 2024 10:23:54 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Antoine Tenart <atenart@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Richard van Schagen <vschagen@icloud.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <dg346xguo5cjx6yotnrdpjyp7n7wwpwnrjvybrrbocekhltpmg@s2j734wd2rnf>
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
 <20241017004335.27471-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241017004335.27471-2-ansuelsmth@gmail.com>

On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
 +
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

You write it is licensed to vendors, so are you sure these could be
used alone, without vendor customizations/hookups etc? I think you
should have a dedicated, SoC-specific compatible in the front. I am not
sure if this was discussed already, though.
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

Looks like not matching unit address.

Best regards,
Krzysztof

