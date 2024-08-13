Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033519B3ED;
	Tue, 13 Aug 2024 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723558640; cv=none; b=Y7vDNG39dl2REg2nsn4FF4GFUlReUG5SQ5pkYqb0T6MHRBLMJdFJstA17snPYLElrvV92evVL0xCjMukQmluttDr7KOKS/kFgmRFHMjupG7RI5IWeFmFYWczY5fVvKPuXlYHJwmFXo3220tvaPv0aK9LkeVKKXXxIcD9B+G8qRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723558640; c=relaxed/simple;
	bh=Ts02BaX1uJBucVrRoYv/f607u6/Qe7CljCeo1TcnB1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lMkvM7TD2BxS/S0VDQJOx7YHSanKqObg3NRSucjbLVeF+F5goCOfOKTxWvvzFSbm+H0ALKSgnThAosbDovl/MHzazrh0NyOqkG/PcnNGXtopVLRrmhvBNDyIaZHMpQye2DbfvUGI9zU6rmo8+bCLN9ggCkqqbGmVnp+oc9Cfyzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akETTczI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akETTczI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41956C4AF09;
	Tue, 13 Aug 2024 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723558640;
	bh=Ts02BaX1uJBucVrRoYv/f607u6/Qe7CljCeo1TcnB1o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=akETTczIweO4EVNKAeoT9iyLYwL8xm6U3nSR0TYlL8u1t7nbfvShuXn0mKX5sHs/q
	 tDaaWC+JKCqOEBDfxfOcYwh5XXTaKYi57CDnUZMtAdQpgabl35qRf+SOXs+NPhDmM5
	 jMhBP0zgiQ+tCgEmL6dpjBkbHTj4i+0QPEiE+VK6p/WHxQXM+52typMPLkC7SaXd6g
	 adQJ51OTLGEAZ7W5Q7nOOemnh+UT0WpJGSDtozbLJoTFKoB4Nv6TGJThKpax/mBmWH
	 tCHbu5wNLeyqrUpadE9f4aLX3dxt7UQzk7Y7gpXEDCnjWYl8gvlmUQ2WKfcsfJTDB7
	 jGpf1mtYCp54Q==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2f1a7faa4d5so48321241fa.3;
        Tue, 13 Aug 2024 07:17:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtfE03HX6gsyGA03Q7ZOuTVdr0CdrZBBoAljIjPX+wEBaRaqMSpGly1GZqIMXIIWgXCFOm4Nynb5xQ9C4JH31F3RFs1If3tHU5/T9ocWQp0aHKgYIwG9seVcmoCzYKOBIhX+FPEjEF1utA7rEw4IHSXyWae5XLEHoYWucPSC/h8zBroqc8EA==
X-Gm-Message-State: AOJu0Yyd8QK2ICPAEpxN3aV1fl4KOC4TYB8fcSSLAfdRSB2maorgzMST
	vSz9pt5xkimUuMQJNfRnrYod55dOokesYvTgZzPg98VjAbQ8HXhOvsVSaOmrmmdj7jlVrjLX2aA
	byNdQMrCwvMEHcRGNLQbnUrq/fA==
X-Google-Smtp-Source: AGHT+IG4ZD1LYUmTcjNxsu4NSl0NVMrynBgp0QWu3I61S59AOffl8L/RksPbuMpvt7XgOGWntMOsVjpu4+iKl0U5l+Q=
X-Received: by 2002:a2e:be93:0:b0:2ef:2bb4:2ea1 with SMTP id
 38308e7fff4ca-2f2b712cfedmr34435731fa.4.1723558638412; Tue, 13 Aug 2024
 07:17:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1722355365.git.daniel@makrotopia.org> <d2beb15377dc8b580ca5557b1a4a6f50b74055aa.1722355365.git.daniel@makrotopia.org>
In-Reply-To: <d2beb15377dc8b580ca5557b1a4a6f50b74055aa.1722355365.git.daniel@makrotopia.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 13 Aug 2024 08:17:05 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKG+dMJjPXrWiQ8qZ7yfpdX3R22ntKRBawYZWTaW_9GWA@mail.gmail.com>
Message-ID: <CAL_JsqKG+dMJjPXrWiQ8qZ7yfpdX3R22ntKRBawYZWTaW_9GWA@mail.gmail.com>
Subject: Re: [PATCH v9 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Dragan Simic <dsimic@manjaro.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 10:11=E2=80=AFAM Daniel Golle <daniel@makrotopia.or=
g> wrote:
>
> From: Aurelien Jarno <aurelien@aurel32.net>
>
> Include the just added Rockchip RNG driver for RK356x SoCs and
> enable it on RK3568.
>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  4 ++++
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/d=
ts/rockchip/rk3568.dtsi
> index f1be76a54ceb0..2a6ca20e607fd 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> @@ -257,6 +257,10 @@ power-domain@RK3568_PD_PIPE {
>         };
>  };
>
> +&rng {
> +       status =3D "okay";
> +};
> +
>  &usb_host0_xhci {
>         phys =3D <&usb2phy0_otg>, <&combphy0 PHY_TYPE_USB3>;
>         phy-names =3D "usb2-phy", "usb3-phy";
> diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/d=
ts/rockchip/rk356x.dtsi
> index 4690be841a1cd..d160a23fd4959 100644
> --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> @@ -1113,6 +1113,16 @@ sdhci: mmc@fe310000 {
>                 status =3D "disabled";
>         };
>
> +       rng: rng@fe388000 {
> +               compatible =3D "rockchip,rk3568-rng";
> +               reg =3D <0x0 0xfe388000 0x0 0x4000>;
> +               clocks =3D <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
> +               clock-names =3D "core", "ahb";
> +               resets =3D <&cru SRST_TRNG_NS>;
> +               reset-names =3D "reset";

This adds a new warning:

rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-=
9]+'
