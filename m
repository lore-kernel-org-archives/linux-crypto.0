Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFCBEAC6;
	Sat,  2 Nov 2024 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730553200; cv=none; b=YT3DF5tYgZdBRed/s4UmEaYdN36Qg0ovUNdGN//KiVvYjJzeWxsn7BA8Np8IAnXxs5d+l6/SYUlmypyNkm7YkRBF3KzxHNjjQ5ktq0ULAyLbVKUGJMWAQA/3yr5hK2bGfujinLfToDu6rIfk9t+SEJgtDR723kJfjUQWXWTm2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730553200; c=relaxed/simple;
	bh=fY6Y0cEvgamB3GM0ZofEW4yzoPnHMdDWFzaDOTWcK5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxeamTpQQI8HMDHN/qGVYGetf0MrzGiJiAzOS2cBUi5bYERxSRwag+F/UReOl6Iyt1vl4VujbrNgyxP3WxDMMa7gJ9gy6OiZYEr0LiEXIp/wUKsOdoYCaJdrGWoTSd4lZrXM5fC/yFlc8N6M/m2aFXInUWdJujaOAm/0kwReI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSsIJny7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSsIJny7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A50C4CEC3;
	Sat,  2 Nov 2024 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730553200;
	bh=fY6Y0cEvgamB3GM0ZofEW4yzoPnHMdDWFzaDOTWcK5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JSsIJny7Sgz9dNxWFRRe/UlE08GOdpnI7Znm/4fPHitGCANF9pYjKD18rD4bcRnl7
	 0lP9EfELn3ewbsMt7BjqN6OGq3zF1b/EHxsjtTCrhiwh9sp5qBseDKRoUedWB25zk6
	 ciYdtNSd9dAxkOu66nwkEapN0JnX/MXsL05MsqQMYNgrMXQX/28VHyqMkzxdmYO6Z3
	 NepNvLx9/lRYs74uC+ei98PfIWhUNZJb2ZN9RbkFyrc0FYLwc0ogv0+csdsozlNvcJ
	 3HQAvmDI/DeyBKdkN6aP9JaNsAGYxNtYnifefX8DvlqHiKnw68VcJRgjm+4Bm1QryX
	 jILmSSqzUO9DQ==
Date: Sat, 2 Nov 2024 14:13:16 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Markus Mayer <mmayer@broadcom.com>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Aurelien Jarno <aurelien@aurel32.net>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Golle <daniel@makrotopia.org>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Francesco Dolcini <francesco.dolcini@toradex.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
	Device Tree Mailing List <devicetree@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: add binding for BCM74110 RNG
Message-ID: <bz4r3qtdrarycfgnke54w4mxbtw52yav7bzofjx42ruibm2axx@pj5vhi7qy7pk>
References: <20241101211316.91345-1-mmayer@broadcom.com>
 <20241101211316.91345-2-mmayer@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241101211316.91345-2-mmayer@broadcom.com>

On Fri, Nov 01, 2024 at 02:13:14PM -0700, Markus Mayer wrote:
> Add a binding for the random number generator used on the BCM74110.
> 
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> ---
>  .../bindings/rng/brcm,bcm74110-rng.yaml       | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

