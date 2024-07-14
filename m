Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD5A3BB23;
	Sun, 14 Jul 2024 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720980591; cv=none; b=KkGllMG9yc2sLn4QSrQHpdBGWv9AaLFV/7mr+DkvIG2aKJu2tBkYTQ/4csa1ASu3BB3t04D3Sja9TeKw1i/OIuo0iBozBRLIAX+11zxwBmz/6MLEN/6qrgeinWZ1v+iu6Xc5WetnfSXRKe4jJYB9jTGf5CIOXIxBW9wEs2rXNnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720980591; c=relaxed/simple;
	bh=NG+9SLQB5CUb0d3jWCkQYWSiXW+fCSYfcN1EMvWBUrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCZA1sLYMLpmamuOcpuhC6CX9qucCvbI9bcGhqkRLGCM2ANf+6VYLPUnZ0Q9poeEzI98c955lo5YuqRZhc5H2aqYJdKAatA3Z4CSQ7x64nxMvvbIl2Gu4A/tyBdj9PDO+VeePObUaE+NBfn9anQU7UD88R+bBf2NXgo6PsasKkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWR3dPH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWR3dPH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EF2C4AF0A;
	Sun, 14 Jul 2024 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720980590;
	bh=NG+9SLQB5CUb0d3jWCkQYWSiXW+fCSYfcN1EMvWBUrs=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=TWR3dPH6oS3VKac35oI/mmSrQusTrgNuyW6cEQIDwl7AEqt4zW0IlfViT8keRsMgl
	 FOooC1R8aZ2B0iS0/nJyBPGVxmGuIvs4BF7uxmgcNHzguGQGy3cKEg8/3mrujc8jW6
	 g7Jg68PAA25/GUj09NortgahSMdfxQSIT7sQ2SFPXv5YObRNtsidgkoKRrTJDV7mkR
	 V9VoiTAKHzA0l7Ozaqhkryn8QrDld9l8Np7s9BlVlTYOP6qDnAJgfCym6slhQ10Bm5
	 Rnn9i9iARH4ZvKDITGIDmp2QgsuoylpjpPW56qEtRyHioylzHWGE5rgDGE+i0xQHnC
	 pfAXPU4wla6rg==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2eedeca1c79so17306101fa.3;
        Sun, 14 Jul 2024 11:09:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVNRgY33QDerwJ3D6x5azo14SyipJurIGpwlQ78PxTZ3QG9n9UYaCa8hh5eL46m2EHQbw04m7lPrQbIi1C16fTtlxP0lA7oBUHCNqJVQtnrz7BYh/VMZsA6rLqpVi6coD3yXegO7eUUPm6vsyVFqtHnS70g/buS5yOeiKdfKJI+1/eWF05LPg==
X-Gm-Message-State: AOJu0YzjoK+TVXqf1qlyAt1K4xObeNQRK5ot95rpxt5mkarJCqMMFZOP
	VxcfQDsvjf8ZNad6xilxw1RkmJAcQqHkPV9NpbVq2S35MW5tDAB3ClwNb2gGWy4UsuZZAQIh6Ns
	0dHgpNlSAJZ6NBLC+14PK7QvJaak=
X-Google-Smtp-Source: AGHT+IFFXDuC1PwJBXmFQH3s6fgDJs2b42yBRYfHa3/YS6nIv2xJQGOJLd7uR/2otp56ybbamkaqxaVyWlGuM+dGn3o=
X-Received: by 2002:a2e:b178:0:b0:2ec:5255:b4d9 with SMTP id
 38308e7fff4ca-2eeb30b88acmr130110861fa.7.1720980588944; Sun, 14 Jul 2024
 11:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org>
In-Reply-To: <cover.1720969799.git.daniel@makrotopia.org>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 15 Jul 2024 02:09:34 +0800
X-Gmail-Original-Message-ID: <CAGb2v66YespcUHnC3hdhogdutVo_wAX32+cqT3sw3UzkwKBxxQ@mail.gmail.com>
Message-ID: <CAGb2v66YespcUHnC3hdhogdutVo_wAX32+cqT3sw3UzkwKBxxQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Dragan Simic <dsimic@manjaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, 
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 14, 2024 at 11:16=E2=80=AFPM Daniel Golle <daniel@makrotopia.or=
g> wrote:
>
> Rockchip SoCs used to have a random number generator as part of their
> crypto device.
>
> However newer Rockchip SoCs like the RK3568 have an independent True
> Random Number Generator device. This patchset adds a driver for it and
> enables it in the device tree.
>
> Tested on FriendlyARM NanoPi R5C.
>
> v6 -> v7:
>  * Patch 1: unchanged
>
>  * Patch 2: bring back rk_rng_write_ctl()
>    - bring back rk_rng_write_ctl() with improved comment to describe
>      the hardware.
>
>  * Patch 3: unchaned
>
> v5 -> v6:
>  * Patch 1: unchanged
>
>  * Patch 2: get rid of #ifdef
>    - use if (IS_ENABLED(...)) { ... }instead of #ifdef inside functions
>    - use __maybe_unused for functions previously enclosed by #ifdef'ery
>
>  * Patch 3: unchanged
>
> v4 -> v5:
>  * Patch 1: always use RK3568 name
>    - use full RK3568 name in patch description
>    - add RK3568 to title in binding
>
>  * Patch 2: full name and cosmetics
>    - also always mention RK3568 as there may be other RNG in other
>      (future) Rockchip SoCs
>    - remove debug output on successful probe
>    - use MODULE_AUTHOR several times instead of single comma-separated
>
>  * Patch 3: unchanged
>
> v3 -> v4:
>  * Patch 1: minor corrections
>    - fix Rokchip -> Rockchip typo
>    - change commit title as requested
>
>  * Patch 2: improved error handling and resource management
>    - Always use writel() instead of writel_relaxed()
>    - Use pm_runtime_resume_and_get
>    - Correctly return error code in rk_rng_read()
>    - Make use of devm_reset_control_array_get_exclusive
>    - Use devm_pm_runtime_enable and there by get rid of rk_rng_remove()
>
>  * Patch 3:
>    - Move node to conform with ordering by address
>
> v2 -> v3: patch adopted by Daniel Golle
>  * Patch 1: address comments of Krzysztof Kozlowski, add MAINTAINERS
>    - improved description
>    - meaningful clock-names
>    - add entry in MAINTAINERS files
>
>  * Patch 2: numerous code-style improvements
>    - drop misleading rk_rng_write_ctl(), simplify I/O writes
>    - drop unused TRNG_RNG_DOUT_[1-7] macros
>    - handle error handling for pm_runtime_get_sync()
>    - use memcpy_fromio() instead of open coding for-loop
>    - some minor white-spaces fixes
>
>  * Patch 3:
>    - use clock-names as defined in dt-bindings
>
> v1 -> v2:
>  * Patch 1: fix issues reported by Rob Herring and Krzysztof Kozlowski:
>    - Rename rockchip-rng.yaml into rockchip,rk3568-rng.yaml
>    - Fix binding title and description
>    - Fix compatible property
>    - Rename clocks and add the corresponding descriptions
>    - Drop reset-names
>    - Add a bus definition with #address-cells and #size-cells to the
>      example.
>
>  * Patch 2: fix issue reported by kernel test robot <lkp@intel.com>
>    - Do not read the random registers as big endian, looking at the
>      RK3568 TRM this is actually not needed. This fixes a sparse
>      warning.
>
>  * Patch 3: unchanged
>
>
> Aurelien Jarno (3):
>   dt-bindings: rng: Add Rockchip RK3568 TRNG
>   hwrng: add hwrng driver for Rockchip RK3568 SoC
>   arm64: dts: rockchip: add DT entry for RNG to RK356x

Tested-by: Chen-Yu Tsai <wens@csie.org>

>  .../bindings/rng/rockchip,rk3568-rng.yaml     |  61 +++++
>  MAINTAINERS                                   |   7 +
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi      |   9 +
>  drivers/char/hw_random/Kconfig                |  14 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/rockchip-rng.c         | 227 ++++++++++++++++++
>  6 files changed, 319 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568=
-rng.yaml
>  create mode 100644 drivers/char/hw_random/rockchip-rng.c
>
> --
> 2.45.2
