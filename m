Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970C12F43;
	Sun, 23 Jun 2024 03:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719113568; cv=none; b=W2FMJ8W7QFwR/2ePzI4QwdB96dAyMH2GL2IdMJ2XU8THeHfhhM6MZt+I5l0t5mDQ8w6QtiEZh06VwU+SMMo3GqlHd84PmPny9X3vMGySGz8oqBHVfzCjFm82eXfmIgGC6jrnqV2R9YeX3m13FWZ4i7HB4pio9KIBCmTmla0/cHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719113568; c=relaxed/simple;
	bh=IbORJeV6xQMVmBw1RRg2a8llpbUGUSsalEAjqHxSPfE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iVC2GUmptJz8l1Ysa98U3lwCIdNUBYvR16uZvUwuDkDewdgkJ5Z8ZOe0zwnfRg+gvEs7fh25CxavlDZbZihQFjJDuOT3x4fDRNLXcMWztx1nRYJbnTPtWoW5GNGmpehB6AtTxcnB5bzuK4/aSbt8PUVwC/G2gFlWnf4p47ljY4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sLDxi-000000006bG-0Ffy;
	Sun, 23 Jun 2024 03:32:18 +0000
Date: Sun, 23 Jun 2024 04:32:12 +0100
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
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>, Martin Kaiser <martin@kaiser.cx>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <cover.1719106472.git.daniel@makrotopia.org>
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
  dt-bindings: rng: Add Rockchip RNG bindings
  hwrng: add Rockchip SoC hwrng driver
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
