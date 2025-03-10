Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BF22318;
	Mon, 10 Mar 2025 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741635059; cv=none; b=olJkwd0KWB4027kRRvJxpvPE20uiBfUSr8fwTQm5PZauZ+570fsKw8YRkwQ8Z2fT+8eModY9PdAntyjGwJva6VN/1uOUMrCdPom8xjOKAJIjKIkOY+VXFrRT/Pha6iVLgaqAp2FErZAhOTgdHPQcAhARaDfkZytpcMc8ylqfHls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741635059; c=relaxed/simple;
	bh=v4yFecT2Oniyy1NPYOTfbARYRqI9e57Xhic4hOu+GeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MJe3mDAazMICuepeUVPBmPwYKf6x3gf+JZ25GgLQ+Ku5p6WMBRUS654qCTZa0GG24v6Oo7gJfLCLdmcShiD0vrQq6dxYIs11NBGrnHtnbjtzzU2aIXdWXjsWzG5NA7xMkuMkhMzs/qPLgqfr99dBu96idckguRaZGwxUX7cp8Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEsJI4SW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEsJI4SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFEC4CEE5;
	Mon, 10 Mar 2025 19:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741635059;
	bh=v4yFecT2Oniyy1NPYOTfbARYRqI9e57Xhic4hOu+GeQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YEsJI4SW1f/4rNuYiyHSu6/QnSExJ4x+d6iQjI9VDYrZoNADxke2mnXUwP9afkihL
	 hTuuH7V0VvVUg5uJFbcLaV3P7z7RXNhKKuijQf+ljuhhIZy4j+4VTXINMoR1mxU6mu
	 9oYCm4t8FMpXLRBV22kEbpTDdhoxwjLbeq0rMzzReSuaVBXcAgYjIAZq3BHxisBfVj
	 GLFn9UmZ/rHmt/8ArwgEiV5JpYwhB5ksIkuxE1S5ZZfX7MMhJRKQW4RKzxHjSn4O1U
	 ToiRFxu1+MR8QXk+J8FtqIwrbQ6ID67F5bBBCPBS5GARlRPIQNUENI/DTESUA/ZxXY
	 2OvQqUx3x58Hw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e6167d0536so4706336a12.1;
        Mon, 10 Mar 2025 12:30:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCULAye0Az3DzysmNejb7GZX5aAaOB/uGQfiRwbgX1cMQQmgvv/T82ASvgQAEegoDraoqQq2pf5TS2CQx3Gt@vger.kernel.org, AJvYcCVoELF7pH09+41qHmwKC/aWTvIMxEc3Qtc5qcXCEWY3dxgsq1/FcD+brrhO3jJqjewjlj2IB1d/t2Dz@vger.kernel.org, AJvYcCWxf2NDBB1ZpdpMb/2K5Y7+jIaPlV/N/NfxyhA84R7E9gmGmoUxN0DYZsQ8Ig+Kc0OJ++5OkpvLVx6nh7GB@vger.kernel.org
X-Gm-Message-State: AOJu0YwH2F3DhDl1tEj+kPkwypbh8JAo/0Qd/NM3dmfc05oVnP6w8KnU
	Pn1MwTRVOXlj339ZPVfVrSgOnPpgWzhcY6wqUoMFMISGl/AhxIhnDohzsag0CL33H91u4NKVbJ6
	ktWMbpYNtqGqNaRU2p8gTiXHZwg==
X-Google-Smtp-Source: AGHT+IGxBKdAQOOWVnO3ZEjAzX0VnUi4wg5gUyfxa5EYDnUv2ipBTTlxmPR9u72RbqgdJn4WQkU1sK0SjNez+497cro=
X-Received: by 2002:a17:906:7308:b0:ac2:6582:1564 with SMTP id
 a640c23a62f3a-ac2b9e1d1d1mr100096466b.27.1741635057630; Mon, 10 Mar 2025
 12:30:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
 <5417098.31r3eYUQgx@workhorse> <20250310124956.GA3875809-robh@kernel.org>
In-Reply-To: <20250310124956.GA3875809-robh@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Mon, 10 Mar 2025 14:30:45 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJShHSMzMwiYA79OppJYKKR8qN=1soXPV_hCZiXGyVkSg@mail.gmail.com>
X-Gm-Features: AQ5f1JosXmbTct3QI9ZnK1eBDcQPU7QRj7_3mqIgKtvsQToiQl1meMSpHXHswhc
Message-ID: <CAL_JsqJShHSMzMwiYA79OppJYKKR8qN=1soXPV_hCZiXGyVkSg@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop
 unnecessary status from example
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 7:49=E2=80=AFAM Rob Herring <robh@kernel.org> wrote=
:
>
> On Fri, Mar 07, 2025 at 03:05:50PM +0100, Nicolas Frattaroli wrote:
> > On Friday, 7 March 2025 10:33:09 Central European Standard Time Krzyszt=
of
> > Kozlowski wrote:
> > > Device nodes are enabled by default, so no need for 'status =3D "okay=
"' in
> > > the DTS example.
> > >
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > >
> > > ---
> > >
> > > Changes in v2:
> > > 1. Drop unnecessary full stop in subject prefix after ':'.
> > > 2. Add Rb tag.
> > > ---
> > >  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rn=
g.yaml
> > > b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml inde=
x
> > > 757967212f55..ca71b400bcae 100644
> > > --- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> > > +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> > > @@ -53,7 +53,6 @@ examples:
> > >          interrupts =3D <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
> > >          clocks =3D <&scmi_clk SCMI_HCLK_SECURE_NS>;
> > >          resets =3D <&scmi_reset SCMI_SRST_H_TRNG_NS>;
> > > -        status =3D "okay";
> > >        };
> > >      };
> >
> > Hi,
> >
> > is there the possibility we could make dtschema as invoked by `make
> > dt_binding_check W=3D1` (or W=3D2) add a warning for examples that have=
 disabled
> > or explicitly listed status properties when not needed? Or is this some=
thing
> > better handled in, say, checkpatch.pl?
> >
> > The question arises because dumb mistakes by me like this should ideall=
y be
> > caught before they waste precious maintainer time.
> >
> > If it's best handled in dtschema, I can look into working on that so yo=
u guys
> > don't have to do even more work due to me.
>
> Trust me, I'm always looking for things to check automatically. :)
>
> I have something like that which adds a schema for examples only. I
> think there were some corner cases. I'll take a fresh look at it.

I got my check working again. i2c/i2c-demux-pinctrl.yaml is the
problematic one. Not sure what to do there.

Rob
