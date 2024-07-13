Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC0718B09;
	Sat, 13 Jul 2024 06:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720853335; cv=none; b=LsTtmRNhGZAqNpkwspPWFpylhY22FLYAykjg+c1XhXHEK+Nwt0OxxBZTV3jq53R0NnpvXSe0Gkx/pBbHO1iwUdikpsYGWMCbwGGTo6syRHZaS0IcnvCIO1Ufqz9oXN1E4m3twN6Qw3/3cl/DzecPKipO1Qqhfcy1NUI+PVi0HOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720853335; c=relaxed/simple;
	bh=rmngPodD1hpovVDZjrY0POcxROayfR4qJFc2JSoZNHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cfQ4qv+r7bt999PpmXYr+t0iBC+Kf9CT6TN0p0BGI/OG4ThQfeF5t9CTRzVwIM+IUfqsod9qp75/Hte1meCslCJ3hv7Ptw/7jfF5QywmT9OuWxmW5TIhJdlGLvrwfS2btXGqjTPBoNECXqijxnl6nNwl4ZgoWvP7kH4K3ANP3yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzNsA6MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzNsA6MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39898C4AF15;
	Sat, 13 Jul 2024 06:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720853335;
	bh=rmngPodD1hpovVDZjrY0POcxROayfR4qJFc2JSoZNHg=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=jzNsA6MZh4gRJnAtWA224bQbcwcmRlfulT9/C5iGyz/mqns3Mkk7D1loYEBiVfVBJ
	 F7JkLxOZoK1GketP7VEYlx7GHJyYlyIbHa3lH+H/lWwCEu3dznfMsXna03EptbfAVc
	 w8LIf99uW9VNjJeqdWpelszhnIc8rPdD5lC5p4p64DR1Dd5jRo3VQNa4S3hAiUM3Xy
	 3wbULs/3/B6cXzWKlYB9xyCWyZgxmQB+mUrQlq9k7e1E505BxC/tz1d52+9K/lvIg+
	 QDorsjOJ/gpt/oE4jCp5U35Fn/jC3GK0JqdaL5HE4PL4RJ1TvhDdJkStpktuXMtVK1
	 ywpW65tEtl4TA==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2eec7e431d9so34354571fa.2;
        Fri, 12 Jul 2024 23:48:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVToCavhAuhqJIZCiaP3kLpfck+NDyh4U47aHxp5z118WvoFy3Lwi1hm64sv0ZoTddGW+Eqdt+qojW8CNafI+IVUmUb9Gn95JfYFGfKadGJk1mvx6GmayNLJSN7r8ycuRZCjKYgL1BvLBmVmBP2o+K3LVst4ewcCwknMjWJ/Xzev5qKJ15fww==
X-Gm-Message-State: AOJu0YxOBeFUrxnWJX3u3Bc27zGJFHT5cwrmf60DmwaOcEcp+sff0RpN
	bpngY1HS3Tc6DquNdQbrMRX5mZowTJEcaiDmqWhMzZD25e1aUPjZ9qeMr0JRfDpgaQNbxMkQQWO
	DtZMi44k+Y17A/a36Il0yZAHpFD8=
X-Google-Smtp-Source: AGHT+IH/4Jry0qoasCXWKjUAZkBfuqHL+VReoVc9bEqJlVdcgZjP7WNeITu1eBxpBYc6Ar9/BFXa9+EFkGyjAzlRL4w=
X-Received: by 2002:a2e:9595:0:b0:2ec:58e8:d7a6 with SMTP id
 38308e7fff4ca-2eeb30b9b78mr86285991fa.5.1720853333390; Fri, 12 Jul 2024
 23:48:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720830725.git.daniel@makrotopia.org>
In-Reply-To: <cover.1720830725.git.daniel@makrotopia.org>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Sat, 13 Jul 2024 14:48:39 +0800
X-Gmail-Original-Message-ID: <CAGb2v64ajgK_4G_ANFgwxQToEzDjuBgbmozb7CLxJyNDo-MkCw@mail.gmail.com>
Message-ID: <CAGb2v64ajgK_4G_ANFgwxQToEzDjuBgbmozb7CLxJyNDo-MkCw@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] hwrng: add hwrng support for Rockchip RK3568
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Dragan Simic <dsimic@manjaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>, Martin Kaiser <martin@kaiser.cx>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jul 13, 2024 at 8:38=E2=80=AFAM Daniel Golle <daniel@makrotopia.org=
> wrote:
>
> Rockchip SoCs used to have a random number generator as part of their
> crypto device.
>
> However newer Rockchip SoCs like the RK3568 have an independent True
> Random Number Generator device. This patchset adds a driver for it and
> enables it in the device tree.
>

Have you tested any of the later iterations? For me it stopped working
at v3. After v3 (including v3), all it spits out is zeros.

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

This is probably the culprit. The RNG and RST control registers have
enable bits in their top 16 bits. Without those set together with the
actual bit values, the writes to the registers have no effect.

Please check all your writel calls against the TRM and add appropriate
bitmasks for the upper 16 bits.


ChenYu

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
> Aurelien Jarno (3):
>   dt-bindings: rng: Add Rockchip RK3568 TRNG
>   hwrng: add hwrng driver for Rockchip RK3568 SoC
>   arm64: dts: rockchip: add DT entry for RNG to RK356x
>
>  .../bindings/rng/rockchip,rk3568-rng.yaml     |  61 +++++
>  MAINTAINERS                                   |   7 +
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi      |   9 +
>  drivers/char/hw_random/Kconfig                |  14 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/rockchip-rng.c         | 220 ++++++++++++++++++
>  6 files changed, 312 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568=
-rng.yaml
>  create mode 100644 drivers/char/hw_random/rockchip-rng.c
>
> --
> 2.45.2
>
