Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E116E88C
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718962786; cv=none; b=SSKWmL0ZzrqnzBwfcMtREr9JbCx22KRZ4x9Em1houZDXgEgDCt0AMcYDR/tCzmeMOAkFUlLx6zbWFTOMFFvLCpdGLsA4ZHa8NGF+vikdmmCshLBfDvgRHdmr8cuB/XRY9KOCrBbyxsJ0GaX3noWyOufnDSDw7LyCl1hGyJPI8Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718962786; c=relaxed/simple;
	bh=FP38xlj8/r8bCZ8KQj6fPg81YiPJc6xm4wu0CROHhr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGVFgStkqTApg2lNXMsNkkQABiaIoiMAqyiSLmcpkXAv4uUqj3nrMQUmPgI2F3YLWnctoIIPZroOiHTzHkOnt+A/vI6MDHJtqC8mOZ8PuV7oi6E7HY0rqkxpb6XW/16IvFGr1W7wMqkQMiZLTtjyOguPSkcHayv3cqSZ0IsAofQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=M84UPz6W; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="M84UPz6W"
X-Envelope-To: daniel@makrotopia.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1718962782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F17P9pKVySbI9fXVe++iTydSN358yg4hkbFcPDVCy1k=;
	b=M84UPz6Wu0UdD81k8U0RjQXVLLhTxopBIriQfgTZL6bUK8n+gKUKsIz9KB3vMEXQl+M2Za
	rJr+tk+CHZgryOqLzkPQ6Wm7Q9RLm5AIe+kAQ0F83m07A92nTXF9I/29ZAeUS3A1vHtlox
	j9hh0Gk5ktVgr7nBn8WtgCkLbV2ijJpxO8eWNI5qG1OQqZBGaNqjAE6zqFULsW4si3fq8M
	uCyvJZ9qxNTY44KhmNkkkoqC28BzPkcpnNOVti5Zh6P3CUthzdrwae5xUczj5iQ7u7dZKB
	DclCF+2Tlwjxx+yJfXcbIIPxO4veiO6g+KSMZcjrTez/E57huvpw93GcQ/BjHg==
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: olivia@selenic.com
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: robh@kernel.org
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: heiko@sntech.de
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: linux.amoon@gmail.com
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: ardb@kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: daniel@makrotopia.org
X-Envelope-To: didi.debian@cknow.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Heikomemcpy_fromio Stuebner <heiko@sntech.de>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Dragan Simic <dsimic@manjaro.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>,
 Diederik de Haas <didi.debian@cknow.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: RNG: Add Rockchip RNG bindings
Date: Fri, 21 Jun 2024 11:39:38 +0200
Message-ID: <11022668.754mm22UMy@bagend>
Organization: Connecting Knowledge
In-Reply-To: <68762122.lzCB0yxN2V@bagend>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <10f621d0711c80137afd93f62a03b1b10009715c.1718921174.git.daniel@makrotopia.org>
 <68762122.lzCB0yxN2V@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart33708828.OdkiG2bhLU";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart33708828.OdkiG2bhLU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Fri, 21 Jun 2024 11:39:38 +0200
Message-ID: <11022668.754mm22UMy@bagend>
Organization: Connecting Knowledge
In-Reply-To: <68762122.lzCB0yxN2V@bagend>
MIME-Version: 1.0

On Friday, 21 June 2024 11:12:35 CEST Diederik de Haas wrote:
> > +title: Rockchip TRNG
> > +
> > +description: True Random Number Generator on Rokchip RK3568 SoC
> 
> I *think* that the TRNG for rk3588 is different, so shouldn't the title be:
> 
> Rockchip TRNG for rk356x SoCs

And I just noticed `Rokchip` in the description, so that's missing a `c`.
--nextPart33708828.OdkiG2bhLU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZnVKWgAKCRDXblvOeH7b
bo/WAQDnYl+LPfUhcypL7EAoGbH3FOzB3zav+r4xz8nCx6VAlAEA2EROli/zO/gU
Gzgahi+rLvQnzlFGOyM3qgeOw2xCXgA=
=BEBo
-----END PGP SIGNATURE-----

--nextPart33708828.OdkiG2bhLU--



