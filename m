Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4821CF96;
	Sat, 26 Oct 2024 07:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926142; cv=none; b=FR+0+4s+aHUA5C/GSEqttZZkg248kA7Pjgl/1bJ2SF9qMxjYQOcU7T+5cIHkcORqs/ybNH8gwdg4hbgwEJ9Qwi6ZNl+eiKksZs5YULtnwc7qT28pCXKZ+tiD88EL9dw9xlHKaC6k91OeE0JqzNk/Oh6/ZYJB55Njrbp84k5sKLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926142; c=relaxed/simple;
	bh=G4YlyMtaUZ52d9zJvR7KIiupa3FC1G6PAMLBKOV5xss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hy8e+w1dD9OSoUWdz/ATElwoDf2SqvPMfirSJiKYr4vP5a7QscKEAjx78wRIMAJwdilpUh7U4f1KH2uo6iajMcDTEEczfIITqf1BuwdKnNUMezLhIf3Cf3tG5ISIeN8o3th5BoTTRVXXHjajj7EIQDHYyOfrN/oP9lkRt4lpIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=joHN7ZRM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="joHN7ZRM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ioBiCpiY+/J8mnmC2qNgaLmgx7CP3zOYlEGf35DRQqo=; b=joHN7ZRMxmgn/0rZkqxksBiVtO
	IjvupL6gyQg4Q+T/iqMlwrXaHA8sq428Hxv2prgLqGRxiQl80/sgof8AEQ0+ZTxLW+UE0R2B+0q3c
	cs2IfM2OdZ5fwbPpoHTDGRkF4GR5zTZnPwMUHruMHTFCJXxgRHFm6TLvlSTY8yvR78Efid6Q9DoDh
	atg5e0qA1r5JARFB38VC2XJ/rhka5gvUgjz8kBo2BilnjVkkP+uZRVPMVpOE4ahmshPCrZjUIkivM
	OwgbYo/YTE5d6mEgtDhLeh4ORtfFqfmTq9hSzgyyDX1iahbPq2YORWV6dHiS8QGBtwKY4/6w+0zob
	hVX00ieQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ao1-00CFzl-1r;
	Sat, 26 Oct 2024 15:01:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 15:01:49 +0800
Date: Sat, 26 Oct 2024 15:01:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>, upstream@airoha.com
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: add support for Airoha EN7581
 TRNG
Message-ID: <ZxyT3ex5Ck_SBaYW@gondor.apana.org.au>
References: <20241017124456.32584-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017124456.32584-1-ansuelsmth@gmail.com>

On Thu, Oct 17, 2024 at 02:44:37PM +0200, Christian Marangi wrote:
> Add support for Airoha EN7581 True Random Number generator.
> 
> This module can generate up to 4bytes of raw data at times and support
> self health test at startup. The module gets noise for randomness from
> various source from ADC, AP, dedicated clocks and other devices attached
> to the SoC producing true random numbers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> Changes v2:
> - Add Reviewed-by tag
> 
>  .../bindings/rng/airoha,en7581-trng.yaml      | 38 +++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
