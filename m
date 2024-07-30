Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E097B18B464;
	Tue, 30 Jul 2024 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355707; cv=none; b=mJn7yAT9sA0Xa49m/Enp7B+78BjLoH6xrSowvcDDxHuPLluvPeTZ34aRWeQh0w7YEW4pY7nGp7gMcsCYt8IKbto133Jc4deyKczLKFaOd/ihdGGFKYOwr7mcXR9bIHPEDuxiYKDNGD6MM7UD8sSQaGe3vmNutV3ALDZ29yNSK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355707; c=relaxed/simple;
	bh=LebSPG0FLq3FIUloAQtPYXALNDCpTPoH4E1GJ/xLx10=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UdAhcWtWgeT3X5xTjw4LT2Z8BI/G3LM+0QznQ2L+N6fw30uhprQ4f189fiI6N4LhujiJ2Ymg2lc/3M+Zo/fRFPJxq9ZRt1zrQEC2Rk5zGGAahCG/4P21Ei5Gt0eziLknHIwL94VnDDw6cUX9UN2ATrC8Ti4lQuSTmQRdQKirrZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98)
	(envelope-from <daniel@makrotopia.org>)
	id 1sYpOS-000000002LS-1H0P;
	Tue, 30 Jul 2024 16:08:08 +0000
Date: Tue, 30 Jul 2024 17:08:04 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <cover.1722355365.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Rockchip SoCs used to have a random number generator as part of their
crypto device.

However newer Rockchip SoCs like the RK3568 have an independent True
Random Number Generator device. This patchset adds a driver for it and
enables it in the device tree for RK3568.

It turns out the HW RNG returns very low quality on RK3566, so while
it is theoretically also present on that SoC, only enable it on RK3568
for now on which the quality expectations are met.

Tested on FriendlyARM NanoPi R5C.

v8 -> v9:
 * Patch 1: revert to v7

 * Patch 2: revert to v7, use 922 as quality

 * Patch 3: drop new properties, but enable only in rk3568.dtsi

v7 -> v8:
 * Patch 1: document new properties
   - introduce 'rockchip,sample-count'
   - require to specify 'quality' (0~1024)

 * Patch 2:
   - read sample-count and quality from DT

 * Patch 3:
   - disable hwrng in rk356x.dtsi, enable only in rk3568.dtsi
   - set sample-count 1000 and quality 900 (87.9%) as before

v6 -> v7:
 * Patch 1: unchanged

 * Patch 2: bring back rk_rng_write_ctl()
   - bring back rk_rng_write_ctl() with improved comment to describe
     the hardware.

 * Patch 3: unchaned

v5 -> v6:
 * Patch 1: unchanged

 * Patch 2: get rid of #ifdef
   - use if (IS_ENABLED(...)) { ... }instead of #ifdef inside functions
   - use __maybe_unused for functions previously enclosed by #ifdef'ery

 * Patch 3: unchanged

v4 -> v5:
 * Patch 1: always use RK3568 name
   - use full RK3568 name in patch description
   - add RK3568 to title in binding

 * Patch 2: full name and cosmetics
   - also always mention RK3568 as there may be other RNG in other
     (future) Rockchip SoCs
   - remove debug output on successful probe
   - use MODULE_AUTHOR several times instead of single comma-separated

 * Patch 3: unchanged

v3 -> v4:
 * Patch 1: minor corrections
   - fix Rokchip -> Rockchip typo
   - change commit title as requested

 * Patch 2: improved error handling and resource management
   - Always use writel() instead of writel_relaxed()
   - Use pm_runtime_resume_and_get
   - Correctly return error code in rk_rng_read()
   - Make use of devm_reset_control_array_get_exclusive
   - Use devm_pm_runtime_enable and there by get rid of rk_rng_remove()

 * Patch 3:
   - Move node to conform with ordering by address

v2 -> v3: patch adopted by Daniel Golle
 * Patch 1: address comments of Krzysztof Kozlowski, add MAINTAINERS
   - improved description
   - meaningful clock-names
   - add entry in MAINTAINERS files

 * Patch 2: numerous code-style improvements
   - drop misleading rk_rng_write_ctl(), simplify I/O writes
   - drop unused TRNG_RNG_DOUT_[1-7] macros
   - handle error handling for pm_runtime_get_sync()
   - use memcpy_fromio() instead of open coding for-loop
   - some minor white-spaces fixes

 * Patch 3:
   - use clock-names as defined in dt-bindings

v1 -> v2:
 * Patch 1: fix issues reported by Rob Herring and Krzysztof Kozlowski:
   - Rename rockchip-rng.yaml into rockchip,rk3568-rng.yaml
   - Fix binding title and description
   - Fix compatible property
   - Rename clocks and add the corresponding descriptions
   - Drop reset-names
   - Add a bus definition with #address-cells and #size-cells to the
     example.

 * Patch 2: fix issue reported by kernel test robot <lkp@intel.com>
   - Do not read the random registers as big endian, looking at the
     RK3568 TRM this is actually not needed. This fixes a sparse
     warning.

 * Patch 3: unchanged


Aurelien Jarno (3):
  dt-bindings: rng: Add Rockchip RK3568 TRNG
  hwrng: add hwrng driver for Rockchip RK3568 SoC
  arm64: dts: rockchip: add DT entry for RNG to RK356x

 .../bindings/rng/rockchip,rk3568-rng.yaml     |  61 +++++
 MAINTAINERS                                   |   7 +
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      |   4 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi      |  10 +
 drivers/char/hw_random/Kconfig                |  14 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/rockchip-rng.c         | 227 ++++++++++++++++++
 7 files changed, 324 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
 create mode 100644 drivers/char/hw_random/rockchip-rng.c

-- 
2.45.2
