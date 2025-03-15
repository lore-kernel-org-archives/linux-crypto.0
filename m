Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D6317578;
	Sat, 15 Mar 2025 09:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742030198; cv=none; b=LnbV+dsp0JEia1Y0HW1uP8ct6HQSRJolyHDKk0qoe0cODcAf6/xl4VjtrKtkIrXO++ftxv99pWB72+1hiZ7l2q8LdS9VEFuT195qFrOEDSoNRAaPRJNb5A0/RSiUoFlzwgbFI8AazC1n0wcHLjJgQzm/n/FLiMyAiiJQ05sFqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742030198; c=relaxed/simple;
	bh=x0bjopHeQaoDf6tOJHipS265n33d1JhJUSNML+p7jM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp+JE69iWZTygjm8e/t+ylTARMvuAkQWeDpjQGBHuXyASDLt7kJWP2XnrleHb7A8l6cx4CyCIZB3ucsQYAAb9cbnPEuKRrmpDpzzhLh7j0ehFiV94Do1iF7Dw+g3Jy87SF1K6wy80auLenh6wQ054t+5GP/s9aYMcc9DopBHaKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SF48966b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SF48966b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+hJhGJ9OfCsgUOC8k5woQVSeucpJBmdlb3gPK7xykbU=; b=SF48966bNfMBDi1jBsj05t3bcQ
	rVhIVuqd612r1BUxwqrEwt76NCtqUYBn+GyGqVgxe9G9l362ZNiCuA5pGCoYo3oVQJz2Z6gjUvraY
	iQJkOxYxQJ9VHY45t9PXAYbC4NfJSSzlY+7weUa9gHX/hKHDGt/dvBDtbhFLTrV7tYfciqWx1aaLs
	7RoEZSF5ouIvpxNrJYkrhs+uCjtClsBmWosoODB/1td/ECRqqMUQB/HFqIigQk1wIwCXAf1Q+DHp/
	+VxZDT7dh4/ULAuA+NRe3OknlmUKD/2XDDO4EwmylWTI8kBuoFxPe7cB51MQ4OFv0BGJQ+1dh+wEy
	0OVA0iDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNcO-006o7v-36;
	Sat, 15 Mar 2025 17:15:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:15:44 +0800
Date: Sat, 15 Mar 2025 17:15:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: rockchip,rk3588-rng.: Drop unnecessary
 status from example
Message-ID: <Z9VFQOjcFxJLAlfr@gondor.apana.org.au>
References: <20250307081406.35242-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307081406.35242-1-krzysztof.kozlowski@linaro.org>

On Fri, Mar 07, 2025 at 09:14:06AM +0100, Krzysztof Kozlowski wrote:
> Device nodes are enabled by default, so no need for 'status = "okay"' in
> the DTS example.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
