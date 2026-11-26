Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722535;
	b=2FpEe2iiV6aiDB27KnQpnu33spyNLGjMWLSeyhxKDgrmiKWVuj3NTnpekicABWpJ6LEj
	 eiSFryCIiZSXMcbIKRgmxuI3k0rKcVavXwcSa6c5W049dPjQThwEYdJMS/vqu+asETOij
	 DvtvZcd07gmLTJjfDhcJ4g9RUAWkmMHq2Il7UJbHRI/CB+7xGhKpuXr0esSJhmJzhb6Wo
	 S2caELErEZfixTKGGXbWdTVY6BdjJms363i+HHDM7+87fZNs/qxL79iF8ax5zJi32b6wU
	 ucYXhZPDB/7f8P4KIQ/mcSAQcNlqDfPHDPsrPFo1vDLBseQ0vblgM8jqsU85JhYKxQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722535;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sQFMt2XiguQ7TYuz7CbVOO5lW2+hip2/2wrcZt+W2Gw=;
	b=g+AXC13cpzz6UzLY74jp0mgMZhpgk8YPsrhgHV1BQguwP0zQ+QBn2NyfuPpV7wYZ5VFU
	 UdcCZqGC2sB1iCrq9M7ZUfsDFKnUF2PLZ8c/wLCf6Jzc4TjGZ6rxGSUAd1aPjMnRYDWe+
	 6q0JpuepZfDe+jNNpN4zcMxDkP4c3HqDfrNxejglzMKcPr0z1q/ZHFRsVxVm16I0Lsocy
	 rL2Pe6skbnH0pYhlBN+3rz+9GOeBHV34FUL1tPh2iWNk+fQMP8/f+9Ra4tjJ+SmwA0ma3
	 f/puRp0/mZ8aLYZGcXu7OAKBxCsqsISGwVLnHvuCxXe59Wpgfb9WgM0ahxdx1m+dI5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PU/w9YZ4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D47606A31C;
	Thu, 26 Nov 2026 19:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU/w9YZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDB01F000D8;
	Thu, 26 Nov 2026 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722534;
	bh=sQFMt2XiguQ7TYuz7CbVOO5lW2+hip2/2wrcZt+W2Gw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PU/w9YZ4IlnTKnDrce7jLSsO6/Vy6vIKF5YzSBtSGj6cDe9ZQaSrOfraS5D9SHjP8
	 52HZKh7yV/nPBlAhqi66DARUk79SLlN5xVOZdNljXVo2D9NlGK366LcMcX7gq4/sIi
	 ByOhqjzHDqY2XKRtfRPaUDNC+gJ/N3Pvq1fKnC7qr5szROGkBz/bBU7aZiuftpbOz9
	 WJwd/bPiioo8QVGT8Y22qOGDSPOkGFPmmKrsDMFt8/bQJKBSlIvRnTj3rPtSNOkr3p
	 uNPSDE8cDNwaX/tUPV4fwlQwVG2Mdyo5ezjoDwbxo3ecq5we5jlddELoZzTbfyDwcv
	 45Hq8P4GmeN8A==
Message-ID: <sashiko-outbox-236123@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 17/25] crypto: amlogic - Add support for A1-series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-18-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-18-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:48:53 +0000
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
- [Low] crypto: amlogic - duplicate meson_a1_pdata and redundant
  s4-crypto match entry
--

commit ce27d011d2b65868bfb43baa82ecbdb3f1fd55db
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Add support for A1-series

This commit adds platform data and device tree match entries for the
Amlogic A1 and S4 crypto hardware.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 08d89db14788a..3a6bac10bb04b 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -298,6 +298,14 @@ static const struct meson_pdata meson_axg_pdata =3D {
>  	.support_192bit_key =3D true,
>  };
> =20
> +static const struct meson_pdata meson_a1_pdata =3D {
> +	.descs_reg =3D 0x0,
> +	.status_reg =3D 0x8,
> +	.setup_desc_cnt =3D 1,
> +	.hasher_supported =3D true,
> +	.support_192bit_key =3D false,
> +};
> +
>  static const struct of_device_id meson_crypto_of_match_table[] =3D {
>  	{
>  		.compatible =3D "amlogic,gxl-crypto",
> @@ -311,6 +319,14 @@ static const struct of_device_id meson_crypto_of_mat=
ch_table[] =3D {
>  		.compatible =3D "amlogic,axg-crypto",
>  		.data =3D &meson_axg_pdata,
>  	},
> +	{
> +		.compatible =3D "amlogic,a1-crypto",
> +		.data =3D &meson_a1_pdata,
> +	},
> +	{
> +		.compatible =3D "amlogic,s4-crypto",
> +		.data =3D &meson_a1_pdata,
> +	},
>  	{},
>  };

[Severity: Low]
This isn't a bug, but meson_a1_pdata has the exact same field values as
meson_g12a_pdata defined right above it:

drivers/crypto/amlogic/amlogic-gxl-core.c:
static const struct meson_pdata meson_g12a_pdata =3D {
	.descs_reg =3D 0x0,
	.status_reg =3D 0x8,
	.setup_desc_cnt =3D 1,
	.hasher_supported =3D true,
	.support_192bit_key =3D false,
};

Also, since Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
requires "amlogic,s4-crypto" nodes to specify "amlogic,a1-crypto" as a
fallback compatible and both entries use the same platform data, is the
separate "amlogic,s4-crypto" entry in meson_crypto_of_match_table[] needed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D17
