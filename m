Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1895F16D4C9
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718961177; cv=none; b=SqZGx5gTMZBuqtNTXYRs3zDPsZ9Is0u5lH9Pa7QCk80RC/QL/w9kO343TZVh9gOS8V/VNeotk4He+2wmXNMZqDpC9c22fcUomWMJDC3B9QoL8xYCWcPnjh/cv+Ox3cpjNL5sGfC+lUkOqDd6EgpmlIn7e+tkLvx1KtTldPLH0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718961177; c=relaxed/simple;
	bh=X1yqTZpc+YxmN3y1eggCSxrmsj4Vb2Fhxpq7DnAN7cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5ZC0cn2Ow223Q6SXoLM1LJEr8C77b6vW05XsywNfX0ze9BLdLgsbXR3pPjfLUb4C3+n+LoP5WTk4t3DxRqCpw9vPfBGGX+6fJjjoqLPTFCDvFClxvaJs+bJT1rdmbHNEFZhyL7ZURnYUU71gZJbES90uzhJdQlcjwHvEhQwmNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=cAUoZfSn; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="cAUoZfSn"
X-Envelope-To: daniel@makrotopia.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1718961171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HoU+w5hbf95oI+65NF7m7axx7dLHxuPKJDtqnUpn1Y4=;
	b=cAUoZfSnDjSevbeJKZhULk5jqgXfbwffQyhxmKz2AGwKmw8Owmhnbge9dU3PvjSRj8z3Vr
	KCiWaEjz7D1mRt2SgPcTjqKWZrqRwg/5O4OxdZVmk5Wjb0zssWviaTs4YUemA/XHxNVrL8
	NULITiv0p/F8S/YV0Qtn4vTu7FnfpM//2+3pz9E+XojIDEj5DwIqKZjVMiwqS9ZtjY31Fp
	au0iPLd6lJ1htHHbHQGc88M7x27ugivW9tRNS/sFXjqGsa7qeflmVX/jtzoDROqar2raio
	AOfPJ4gPbIcCeJU3ogTjag7Zh2+friJmFGBaoJS9T1P7N0+Sg8UTTRw0+MpofA==
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
Cc: Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: RNG: Add Rockchip RNG bindings
Date: Fri, 21 Jun 2024 11:12:35 +0200
Message-ID: <68762122.lzCB0yxN2V@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <10f621d0711c80137afd93f62a03b1b10009715c.1718921174.git.daniel@makrotopia.org>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <10f621d0711c80137afd93f62a03b1b10009715c.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3910405.qtKquTYnKW";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart3910405.qtKquTYnKW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Date: Fri, 21 Jun 2024 11:12:35 +0200
Message-ID: <68762122.lzCB0yxN2V@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

Hi,

https://lore.kernel.org/all/89b16ec5-f9a5-f836-f51a-8325448e4775@linaro.org/ 
also mentions some remarks about the subject, so if I interpreted those 
remarks correctly, it should be:

dt-bindings: rng: rockchip: Add rk3568 TRNG

On Friday, 21 June 2024 03:25:01 CEST Daniel Golle wrote:
> From: Aurelien Jarno <aurelien@aurel32.net>
> 
> Add the RNG bindings for the RK3568 SoC from Rockchip
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../bindings/rng/rockchip,rk3568-rng.yaml     | 60 +++++++++++++++++++
>  MAINTAINERS                                   |  6 ++
>  2 files changed, 66 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml new file
> mode 100644
> index 000000000000..d45f03683fbe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip TRNG
> +
> +description: True Random Number Generator on Rokchip RK3568 SoC

I *think* that the TRNG for rk3588 is different, so shouldn't the title be:

Rockchip TRNG for rk356x SoCs

Cheers,
  Diederik

PS: Heiko's name is without `memcpy_fromio` ;-P
--nextPart3910405.qtKquTYnKW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZnVEAwAKCRDXblvOeH7b
bvYLAQD5phdvtSaGx5MmYC50JLDUbw5C48bFzb/suRy7BfZaNgD/TyjMUTJNnFPk
fy6xGLowx9j4pjU1c+McDZwWhadqpAM=
=qx6y
-----END PGP SIGNATURE-----

--nextPart3910405.qtKquTYnKW--



