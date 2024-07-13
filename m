Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB58101D5;
	Sat, 13 Jul 2024 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720857126; cv=none; b=ilguLSU0xxxbgGjRhEuL+FpkK+Mget2D5G7BgMxV8P4Hdf4zyzVmVBI+lSJ9Weiel0+q3uYYa3Euy+9EuNLzDHWYFybxe1BrS92l3xyeke0BIXnypeW80hm1K7GY0MxuKypj7w+7pMYrL8c7gJGVazdc5f1JkVp1fGby/kNCXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720857126; c=relaxed/simple;
	bh=Eueq+6J+8pin3umzJrmjFs0ReEXfG2QuCgfeH9rPLyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhVtQ7IOcNzYWd53JwE8Ch+2g4LYbv0+wOINCqbiByhgWgIKJg1+nrC9Id3s+EDg2NpGxYH/5lOHC32xr0vl5+9lB2jJjkEJatSaZLXdfoTsvh2a/bT/CX0CSWeI+wKKstIuwy7QPiEZ2xvpWD0Pwr/kcYUAQEKGHgzeNWTNUUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sSXXm-000000006ly-3V0z;
	Sat, 13 Jul 2024 07:51:46 +0000
Date: Sat, 13 Jul 2024 08:51:39 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Chen-Yu Tsai <wens@kernel.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <ZpIyCwnFVbML3hnV@makrotopia.org>
References: <cover.1720830725.git.daniel@makrotopia.org>
 <CAGb2v64ajgK_4G_ANFgwxQToEzDjuBgbmozb7CLxJyNDo-MkCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGb2v64ajgK_4G_ANFgwxQToEzDjuBgbmozb7CLxJyNDo-MkCw@mail.gmail.com>

Hi Chen-Yu,

thank you for reviewing and testing.

On Sat, Jul 13, 2024 at 02:48:39PM +0800, Chen-Yu Tsai wrote:
> Hi,
> 
> On Sat, Jul 13, 2024 at 8:38 AM Daniel Golle <daniel@makrotopia.org> wrote:
> >
> > Rockchip SoCs used to have a random number generator as part of their
> > crypto device.
> >
> > However newer Rockchip SoCs like the RK3568 have an independent True
> > Random Number Generator device. This patchset adds a driver for it and
> > enables it in the device tree.
> >
> 
> Have you tested any of the later iterations? For me it stopped working
> at v3. After v3 (including v3), all it spits out is zeros.

I've not examined the actual values it returns, I will do so in future
iterations.

Alsom, I misread the original rk_rng_write_ctl() function, I will bring
it back and also improve the comment describing it.

> 
> > v5 -> v6:
> >  * Patch 1: unchanged
> >
> >  * Patch 2: get rid of #ifdef
> >    - use if (IS_ENABLED(...)) { ... }instead of #ifdef inside functions
> >    - use __maybe_unused for functions previously enclosed by #ifdef'ery
> >
> >  * Patch 3: unchanged
> >
> > v4 -> v5:
> >  * Patch 1: always use RK3568 name
> >    - use full RK3568 name in patch description
> >    - add RK3568 to title in binding
> >
> >  * Patch 2: full name and cosmetics
> >    - also always mention RK3568 as there may be other RNG in other
> >      (future) Rockchip SoCs
> >    - remove debug output on successful probe
> >    - use MODULE_AUTHOR several times instead of single comma-separated
> >
> >  * Patch 3: unchanged
> >
> > v3 -> v4:
> >  * Patch 1: minor corrections
> >    - fix Rokchip -> Rockchip typo
> >    - change commit title as requested
> >
> >  * Patch 2: improved error handling and resource management
> >    - Always use writel() instead of writel_relaxed()
> >    - Use pm_runtime_resume_and_get
> >    - Correctly return error code in rk_rng_read()
> >    - Make use of devm_reset_control_array_get_exclusive
> >    - Use devm_pm_runtime_enable and there by get rid of rk_rng_remove()
> >
> >  * Patch 3:
> >    - Move node to conform with ordering by address
> >
> > v2 -> v3: patch adopted by Daniel Golle
> >  * Patch 1: address comments of Krzysztof Kozlowski, add MAINTAINERS
> >    - improved description
> >    - meaningful clock-names
> >    - add entry in MAINTAINERS files
> >
> >  * Patch 2: numerous code-style improvements
> >    - drop misleading rk_rng_write_ctl(), simplify I/O writes
> 
> This is probably the culprit. The RNG and RST control registers have
> enable bits in their top 16 bits. Without those set together with the
> actual bit values, the writes to the registers have no effect.
> 
> Please check all your writel calls against the TRM and add appropriate
> bitmasks for the upper 16 bits.

The upper 16 bits are apparently used as hardware mask when writing the
lower 16 bits...

I will send v7 after testing.


> 
> 
> ChenYu
> 
> >    - drop unused TRNG_RNG_DOUT_[1-7] macros
> >    - handle error handling for pm_runtime_get_sync()
> >    - use memcpy_fromio() instead of open coding for-loop
> >    - some minor white-spaces fixes
> >
> >  * Patch 3:
> >    - use clock-names as defined in dt-bindings
> >
> > v1 -> v2:
> >  * Patch 1: fix issues reported by Rob Herring and Krzysztof Kozlowski:
> >    - Rename rockchip-rng.yaml into rockchip,rk3568-rng.yaml
> >    - Fix binding title and description
> >    - Fix compatible property
> >    - Rename clocks and add the corresponding descriptions
> >    - Drop reset-names
> >    - Add a bus definition with #address-cells and #size-cells to the
> >      example.
> >
> >  * Patch 2: fix issue reported by kernel test robot <lkp@intel.com>
> >    - Do not read the random registers as big endian, looking at the
> >      RK3568 TRM this is actually not needed. This fixes a sparse
> >      warning.
> >
> >  * Patch 3: unchanged
> >
> > Aurelien Jarno (3):
> >   dt-bindings: rng: Add Rockchip RK3568 TRNG
> >   hwrng: add hwrng driver for Rockchip RK3568 SoC
> >   arm64: dts: rockchip: add DT entry for RNG to RK356x
> >
> >  .../bindings/rng/rockchip,rk3568-rng.yaml     |  61 +++++
> >  MAINTAINERS                                   |   7 +
> >  arch/arm64/boot/dts/rockchip/rk356x.dtsi      |   9 +
> >  drivers/char/hw_random/Kconfig                |  14 ++
> >  drivers/char/hw_random/Makefile               |   1 +
> >  drivers/char/hw_random/rockchip-rng.c         | 220 ++++++++++++++++++
> >  6 files changed, 312 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> >  create mode 100644 drivers/char/hw_random/rockchip-rng.c
> >
> > --
> > 2.45.2
> >
