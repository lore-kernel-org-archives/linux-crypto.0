Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1738BEF;
	Wed, 26 Jun 2024 01:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719365829; cv=none; b=Yjbrq3BAibyde5Mk7V+6j2co5HG2uaPpmpzXs6L4AgEH+DILwMSkDDHTwgW91ykNtbSRTin7XsA8ZD3JrV84ul0kjzsTlTsZIBQr0KeDKiUooIOa3UsxtJL5Yba/uIdflcWksjzhplLLnP+WD7vM4EopNi0/vBBPsqgAP1wa6i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719365829; c=relaxed/simple;
	bh=UqdW06E/TDRU5MPimH2J4QaG6NambNN4GbZEP+VRidg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ONZtT/mCCL7U4u7x5tYeuRAa/q3reSrKURlyJpNQIcqMcjDGkkI1HGfwl6Yr2aiGQHK9BSpp5+gV3abJSxBLCi9a+HY/FLONYl1xEvngopNc5dvlvZnF83S6J6FIVkYJ14RTzqd0axjCgAqiC5JIhRiit1nLBNWDktattt+ECMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sMHaL-000000005af-1M7h;
	Wed, 26 Jun 2024 01:36:33 +0000
Date: Wed, 26 Jun 2024 02:36:29 +0100
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
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Tony Luck <tony.luck@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <cover.1719365405.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Rockchip SoCs used to have a random number generator as part of their
crypto device, and support for it has to be added to the corresponding
driver.

However newer Rockchip SoCs like the RK3568 have an independent True
Random Number Generator device. This patchset adds a driver for it and
enable it in the device tree.

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
 arch/arm64/boot/dts/rockchip/rk356x.dtsi      |   9 +
 drivers/char/hw_random/Kconfig                |  14 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/rockchip-rng.c         | 222 ++++++++++++++++++
 6 files changed, 314 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
 create mode 100644 drivers/char/hw_random/rockchip-rng.c

-- 
2.45.2
