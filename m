Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722252;
	b=LzzFk6lwMfxiEggRrZUv/YBBHCOytH9QrxZmnwuOmPvJn5qjlrL5iE7noIX0ECwXDsd9
	 m7aI0aICZDhwz+3G6lE/jCG6OcVH10zlRSoFIG8QtQs78iy6I9KBnCIbyMXj1+Qkvhz1p
	 RbIoS9ChFOjsMwUR8qnv2AY7Hngd2h3ebrjGqpEnkIk4dgZEhIXJvM14oW52ZvvibS5R4
	 G29GIK3d15XZpD32gRoF0SoMoD5kDovWJoEaXhDa3xnMA3cj5Y4jDpRktpboOgcjMP3i3
	 IYzknq9vmw9RtVQIuiZfuOQ09hVxNxxkXjXQr1ySWZMpekrB9RrK4I2qcvALMSzSaRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722252;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QwKK9giXi3Mifiny2Uylg0cCiIO9ScqGZxIfscA3Np8=;
	b=CTpAOxwkM9egsgO3d6HA8DpBwOZvciAPEGZxHoi0eFk+FHNoUL8gsR7OmXSQFasLzhHW
	 0T9nV1ICbuAaH/Sucl+6q68vU1fD48vdLt8XZ4YWdjLhgCv+4x4SgNFDdNgwARlEb67CC
	 Pia9w3LQhumYC/1MhrfFr5oCkzjGNLIVfI50qaWO9gVOtchOi0u307opx17R/i7qmWq+h
	 OV+MXyY+Cu+zKHzP/zZBWngvtrczhKN4uZocDe4aHWM9blPnU/mnajk98mX7h2G6reX/K
	 wU/vemwsjyc+bxk1rwsYeDNyWLdOMthNjhcQoU9srnMcndc4wPT085n4szP9XczIs+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EI8CSyo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E93606A321;
	Thu, 26 Nov 2026 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EI8CSyo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14EC1F000E0;
	Thu, 26 Nov 2026 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722251;
	bh=QwKK9giXi3Mifiny2Uylg0cCiIO9ScqGZxIfscA3Np8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EI8CSyo064WHZfPU/gT46c6fun4q/KdGJ7x3OcpnrxKTVnCvIw0XgQldJjwK2LPKG
	 C0OwQzC/nhA0ItmOKlJefI/0xXVqmKhLU4unrRXwNzP0DCFxv7jajP1A/4MTIm8Vwi
	 aik/vKruuTnbYDkJA4HdkcT/r33COESC4v0ycnqG5/RUpUpQmP1SkqV93DmWV4OJqZ
	 l0M/Jd02amOQnknyApixurN15T8oijIuzVWQx0wVPwJVDc5HgVjXYrsW/XBeGuoeCN
	 1zbT+etN6xMloHGJuos18fhnK4XvL1n2QaJ4pcbS0MLDDhJ4sQAYWhM5q1xu1KYdxp
	 8867DMfmtYHCw==
Message-ID: <sashiko-outbox-236113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 05/25] crypto: amlogic - Remove clock input
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-6-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-6-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:44:10 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: amlogic - meson_crypto_probe() drops required DT
  clock enablement
--

commit 6e2a1b06482267078b47ff3e21fbdf1bbeb5d603
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Remove clock input

This commit removes the "blkmv" clock acquisition and the busclk field
from the Amlogic GXL crypto driver.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 24ef7d5a56075..37224d75edfbf 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
[ ... ]
> @@ -267,13 +266,6 @@ static int meson_crypto_probe(struct platform_device=
 *pdev)
>  	if (IS_ERR(mc->base))
>  		return PTR_ERR(mc->base);
> =20
> -	mc->busclk =3D devm_clk_get_enabled(&pdev->dev, "blkmv");
> -	if (IS_ERR(mc->busclk)) {
> -		err =3D PTR_ERR(mc->busclk);
> -		dev_err(&pdev->dev, "Cannot get/enable core clock err=3D%d\n", err);
> -		return err;
> -	}
> -
>  	err =3D meson_allocate_chanlist(mc);
>  	if (err)
>  		return err;

[Severity: Medium]
Should meson_crypto_probe() pass NULL to devm_clk_get_enabled() instead of
dropping the clock enablement entirely?

Earlier in this series, commit "dt-bindings: crypto: amlogic,gxl-crypto:
correct clk and interrupt lines" removed clock-names because the crypto IP
is clocked by clk81 rather than blkmv, but kept the unnamed clocks
property required in the binding:

Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml {
    ...
    required:
      - compatible
      - reg
      - interrupts
      - clocks
}

Removing devm_clk_get_enabled() leaves the required DT clock unclaimed and
unenabled by the driver.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D5
