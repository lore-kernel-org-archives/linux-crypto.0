Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722193;
	b=5eeHml4o+CVO3LgK2W0D7nNpunNbyyPt7XrgA1sb6iZ7Ve0KtX+XO0KT0AX0DI8n7r1K
	 TMrxJpDJzU85/K7PIi8K2ornjrL5so1ksg3ayj7ZwN/oxax6JpLcn6EmUD1RUmb6L1Uxy
	 mgo6sKDF6fZJs1ZCvwRUMOxJxDkGCMJy5/57Isiqh5I6dNwUW3mCURwPOwomb7ReKSzDR
	 FCo5d6MZ2sRGf13Y4Y9Pi+bRjRa+QGkY/s5NVkx84TQ6D5Q+kCdqOMAmUNEAKKsdlvh/o
	 vdlsDJnqrGWCPvO04VXn6EyxRvcZ4l6HqI9aiUFTXaTfelsJLlEb6Y8NxwoIUBYTpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YEr6X8MD9YLmwSVjAHEQJC/Iu7dikRlAmBL0OK7jay8=;
	b=MY953+0M+fxEoIOurYzihSNmw2Ruv7hiQTdUAKS/hTREt1K0ndS6k9Z0BmsqNw+WhGZS
	 BHW5w9eals9/2rQul02zturTSj81dHy5QPuskmGMVWtq9hdgY6FyQR3J1ACt7SN7raJUr
	 zBXMJADgv5kWX4aClXQj6gWvCCMX6ixUjhoHHwyHGQdvjm1wdif1flCTf+sF4C/Knk7xI
	 /JnLoawdh6zf1fHj3trRMLov9vfxU4SlYzJ7rsOZalJHNfGO9QFGynzcadFkttRyZm+Tl
	 Qg70NeDBZXuD3/jd4q9CvPhxgNSztgiYLQ5NOzecmKv7KkgoHCE/64w+C9j7stljnbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkT9U9o9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A804A606A31C;
	Thu, 26 Nov 2026 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkT9U9o9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5941F000C4;
	Thu, 26 Nov 2026 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722193;
	bh=YEr6X8MD9YLmwSVjAHEQJC/Iu7dikRlAmBL0OK7jay8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kkT9U9o96e+wx08YeEoVDAIlAePLyqVn8c0f1t57cbb5UR2f06cwHMPlGc2sgCQED
	 KmSW0dCSMpSDtBsU54h0HbP8AnLQpB0NA4CkIHvOk7naZfFBC3rPPlhkI1oQloU4Si
	 HWMy9gJm7037c8QdAwHbyIkhsmk+RZ86H5KRmQr+uuOt6eD2jnRUQGHPrGrVEf2MSD
	 blWbnrQDk9zlGk/Y/tsniYieVH3aur9TiXC0Tvo8phakVOez9UQOSzD6F951vQY8Ua
	 p1NTD+LE8ICsJN4S9e6cGimrdUF9bxgELWElFdvvA8CoYeQJxu4qnEw+ChHz4MnTtf
	 hbpV8Jk+gHFbQ==
Message-ID: <sashiko-outbox-236112@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 01/25] dt-bindings: crypto: amlogic,gxl-crypto:
 correct clk and interrupt lines
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-2-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-2-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:43:12 +0000
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
- [Low] dt-bindings: crypto: amlogic,gxl-crypto: interrupts listed
  before clocks
--

commit b4a68c4c1f0b87becd0da61f8fb2312014b9b3ee
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt lines

This commit removes the clock-names property and the unused second interrupt
line from the amlogic,gxl-crypto binding schema and updates the example clo=
ck
to CLKID_CLK81.

> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.=
yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> index 948e11ebe4eeb..fdc39797a2a9c 100644
> --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> @@ -20,20 +20,15 @@ properties:
>    interrupts:
>      items:
>        - description: Interrupt for flow 0
> -      - description: Interrupt for flow 1
> =20
>    clocks:
>      maxItems: 1
> =20
> -  clock-names:
> -    const: blkmv
> -
>  required:
>    - compatible
>    - reg
>    - interrupts
>    - clocks
> -  - clock-names
> =20
>  additionalProperties: false
> =20
> @@ -46,7 +41,6 @@ examples:
>      crypto: crypto-engine@c883e000 {
>          compatible =3D "amlogic,gxl-crypto";
>          reg =3D <0xc883e000 0x36>;
> -        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 189 =
IRQ_TYPE_EDGE_RISING>;
> -        clocks =3D <&clkc CLKID_BLKMV>;
> -        clock-names =3D "blkmv";
> +        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> +        clocks =3D <&clkc CLKID_CLK81>;
>      };

[Severity: Low]
This isn't a bug, but the example node, properties, and required lists place
interrupts before clocks instead of following the standard DT binding order
(compatible, reg, clocks, interrupts).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D1
