Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F51EB1AC;
	Thu, 12 Jun 2025 07:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713633; cv=none; b=ucF3OYa6zisA6EdOmvtgdArx0+3+3uUrCRSoh4lGqUbUcUinyrcn4aX+bay04HdHNrdCpcWOX88Aq7XqBhCJVLWMggsK2VFYJvAmm7NnVEETaRVkcoRWLgO4h5mSvMhzBZnGi/RK3Hg2ggZrkHYb4EWi0BLCCMp4sUuzQWT5heQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713633; c=relaxed/simple;
	bh=EbHKzoPyQisbGeHdM80h8YEnwMflGlq+HV1pHMAF6V4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBYSILoFljcUaXPFOonoIdhOdIjNU4IzpYlIsHBmMTu7InclK6oLoCTRHgMIXnPBrlZjCj0f2denTD15MOAtWW/5fLPLB0ltJDQ7X6BGhzOaLdWgB9f4KG6y8PgUkNviyXBMIcGqwccs1TOT7afqPiofjcVjkeYhRoSZzZ5JS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXGKpdpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXGKpdpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE00C4CEEA;
	Thu, 12 Jun 2025 07:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749713633;
	bh=EbHKzoPyQisbGeHdM80h8YEnwMflGlq+HV1pHMAF6V4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VXGKpdpnT2hyJ+J7CIpd2//Fa60D0zBcaRMYr2eTGJLt0Nxu3ed/Zp7FWySnVvvu9
	 +bfopb8q134a/Sq10yvpF4nr7e9iGVIxpJYijDVhiPd/5qkxAU+7tGE4NNrvooQY26
	 ol5PgVzhsjhAkr6Bl1os57YFVEmYLy9+zmRP3PQq8Vlrj6PblqCD8r2g9REy/SpNJY
	 KwrN9CMvuyUdrY01iKho6DMlJ35c+Xc4ddPjSM7Wo8PonWtUmEJg9BMtc1ryownH2p
	 kSr5BUv2gJhXV/mz++pvahkc1u84ceOP5/3MspX+AGL+7UF41wbhaiWh1+hYOnCB81
	 FU4pnb3f67jvA==
Date: Thu, 12 Jun 2025 09:33:50 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Ryan.Wanner@microchip.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, olivia@selenic.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] dt-bindings: crypto: add sama7d65 in Atmel SHA
Message-ID: <20250612-translucent-space-mussel-054ce7@kuoka>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
 <a62591306df47ba006470a00e6c25d9df419a4fb.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a62591306df47ba006470a00e6c25d9df419a4fb.1749666053.git.Ryan.Wanner@microchip.com>

On Wed, Jun 11, 2025 at 12:47:26PM GMT, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC Atmel SHA.
> 
> The SAMA7D65 similar to the SAM9x75 SoC supports SHA1/224/256/384/512
> and supports HMAC for the same hashes. They both also support automatic
> padding as well as double buffering.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml     | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

