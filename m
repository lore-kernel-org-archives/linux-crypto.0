Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014F1C7013;
	Thu, 12 Jun 2025 07:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713668; cv=none; b=lHY90bMXKOSN2bYupwi6n+fH//O1+eqLlYpuxsqGkdfkTp0rnLqwEaUMysdnR7HvHBws+wecoNhCokGGMqWoIKDrIJfSpgeh5HtJefnkEufGalToDt/fbkPDNFyR6HF2xRoyB26dEueG02MKI8KUsI+f9zu4OTcx2vgOL/qO05w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713668; c=relaxed/simple;
	bh=5tUhyhCzLi7X2fjwezCeRgGy4c5FGMVY8jjpVGZDy1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaiNRwimZ8ovHPl0EuI52yHyXwUb32joe52xCPW1xbRdBPZbG6awlOX+nq+cb799vUd8CHZm4rscBQIYovuhZlkMu+le9550XEZUg04tDHaX/csZyS26Q3i8RPtp18loPcPFzt3uPXlwf6yu/6N5b25r6PSw8O2pce5pJthXzFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMRKpDL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMRKpDL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA23C4CEEA;
	Thu, 12 Jun 2025 07:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749713667;
	bh=5tUhyhCzLi7X2fjwezCeRgGy4c5FGMVY8jjpVGZDy1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FMRKpDL9xlzOV+NXaRbfM3FimpTlF3nmvGTw5+Z+CTvbgLuTlVkMAHQfigpZn3Op6
	 +US/3edDLTIpz8dKqMS88V/Bjota/q8RgKOhNR/etsOU0I/v2jUvKr4YpUSJZtSWxm
	 bSqK2552dfvydKPmGDc8o1YcSA8PuH9zJiz/vp9MyJlVsDA2qfwgbHPXbwxj5eOER5
	 BqqGlMmvPAAzv+3JvQTzrZ08dSOHAEyUWGWWk8kgPngHinTpowY1HUZ7kk1NYJESlY
	 FW4aIBGSBtar4Y6/KQr0uVX04HpTIxyMDaT6pCCHgFi5dDImqtfK/3bLulV1JH0XPU
	 +pcRO7H7ikPRg==
Date: Thu, 12 Jun 2025 09:34:25 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Ryan.Wanner@microchip.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, olivia@selenic.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] dt-bindings: crypto: add sama7d65 in Atmel TDES
Message-ID: <20250612-vigilant-chestnut-mamba-400bb2@kuoka>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
 <1fa63c0ff667c61c924f1571d9c2f03cd1fcf7b2.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1fa63c0ff667c61c924f1571d9c2f03cd1fcf7b2.1749666053.git.Ryan.Wanner@microchip.com>

On Wed, Jun 11, 2025 at 12:47:27PM GMT, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC Atmel TDES.
> 
> The SAMA7D65 SoC has the same capability as the SAM9x75 SoC.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml    | 4 +++-

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

