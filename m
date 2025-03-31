Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527C919D8A7;
	Mon, 31 Mar 2025 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743408034; cv=none; b=gdOKv52f007vOB7CH/x4OoqbHkHnWANZM+shgw46w9eNz/f5Gmvn3uGKiAvV5BnrbNEwk6Pm2orgcKvhvVkcjYDWX5vDfFisrMdJeunJZmvWITAy7pT7+tFYFG1jMtGSy1jlrNvtvQ7cWRgcidDZ4xm8dh3M1TAzRFday0J5nI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743408034; c=relaxed/simple;
	bh=9lhSfPox4E2eux54Gtxkrw5LjnGqrUCdXCq0YD5C+1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0j7EhoILkVs1NSs828NbHLpSgq9sFWTeo3TMRMB3GRfAEW1TokC38q1bPzHLTtNsR6V7Tzsv8MttLzfMh3s+b1mEO3yRu0X1JS9aom/hK7RYf5XVqDFCGMtuA6RQ4yYSAHIMD5bhVMXY3h+1/4ymeA1uPDkS1AFf77r0z1zrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXQM5M0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXQM5M0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB81C4CEE3;
	Mon, 31 Mar 2025 08:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743408033;
	bh=9lhSfPox4E2eux54Gtxkrw5LjnGqrUCdXCq0YD5C+1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXQM5M0t0uFbQ/BP15/z10c6ah0f32+Sul8vazqTQ0dzfih1yE6XX9jLQ/bUVmeUZ
	 pIzdPNI4MBmw8/Ak3P8ynzn73W3qTf2LdCcWd1RZoOx27jR3vaMvqIFpcNSMYBFKRz
	 dGxgvTX25wH+lRYRnWx5hx2HdKqKH2LmfAJOZUjMzRfgebUyclR3fRiFMP6ZbeVgXu
	 sKos25JUz+y9KXcjJZTaNeGsg+6TjBuTgjGUcl6Y2x8GJMEOyHDm0crWDPdF7jAIbj
	 faz+A9R3Oeizldd49VR49QnW5eGnRYvvj/vxwBYBijQXRcXjkklHhQfh+T8ITaJVlb
	 nC72FfYxEeZCg==
Date: Mon, 31 Mar 2025 10:00:30 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	William Zhang <william.zhang@broadcom.com>, Anand Gore <anand.gore@broadcom.com>, 
	Kursad Oney <kursad.oney@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Olivia Mackall <olivia@selenic.com>, Ray Jui <rjui@broadcom.com>, 
	Scott Branden <sbranden@broadcom.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/12] dt-bindings: rng: r200: Add interrupt property
Message-ID: <20250331-hulking-orthodox-moth-e7d47e@krzk-bin>
References: <20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org>
 <20250328-bcmbca-peripherals-arm-v1-2-e4e515dc9b8c@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250328-bcmbca-peripherals-arm-v1-2-e4e515dc9b8c@linaro.org>

On Fri, Mar 28, 2025 at 08:43:52AM +0100, Linus Walleij wrote:
> This IP block has an interrupt. Add it and add it to the
> example as well.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

