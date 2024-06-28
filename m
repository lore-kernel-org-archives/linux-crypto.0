Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCE8770F0;
	Fri, 28 Jun 2024 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719605257; cv=none; b=P/JOOTaF8rfgFGiZz7R40Kc8kfQz7srxVG8RQ+pj5XCWvyVnfhM24mZuiW1ZU+iDICto6w2+XRFhjSPMx4os1RfNvlcqvDkrGbFAfZ4cwNVoxcnBQZCN1j84w5m4r4oPBJI4BBTb5g0ZV9o9tFGrnCAXmcOVMuovpEcQN184Hqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719605257; c=relaxed/simple;
	bh=0PjGwPWldCD0xPnSfdbjRAC8QfzgJtyroxiHeScz7FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OR0pfWrhfcgoRceqRy2eFg2zbaE8Df5CNZYVQR5k1+UJcKmnvJGSyPUr38Bj1vE68Uzu5pTEF7ogNeM4ErBNliKEbncrwhZ/qhey4+5VeCkRaLmo9zbkOyxoJrBiBppOd68M7qIi69tIoTqMFFkWq/WyMZEkl6M2Lcw/TEoEt7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNSN7tTX; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNSN7tTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719605255; x=1751141255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0PjGwPWldCD0xPnSfdbjRAC8QfzgJtyroxiHeScz7FQ=;
  b=bNSN7tTX8oJG/BRJd6Y6RoJfbnlmet0eiiD6QOjPhgEQ5t8lhi9zrpta
   26DEtV6I5jJo2Vy9YuYp9Axs3hNaXff5zeSp9xmb7KM1MDGnl0Up5y8f4
   61gxtFn4J8HqejZgX3EAQlJXUJ492UQ93h5x8+k9Yy8swoM/6rXzVILvl
   RV1U2lGLPVwgu3OYP0oDobNq1BoHfxqBY15YMZyHLSLB/cCFZEy/twH2D
   nlzvp14I2GI0HuinSIUOwzkMCHrG0Z5HSSGgmMkdKaJWR9WW8MfYwR8/3
   CFl9o1bXBe9x5QIsi6Fh4a26PY8mEhJYsZfLUhXIhjyDVDayR686XE3pA
   A==;
X-CSE-ConnectionGUID: vfSKR3j0Saia4+s+jeAXpQ==
X-CSE-MsgGUID: y8Zeq06QSdytcxknkykEXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16622499"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16622499"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 13:07:34 -0700
X-CSE-ConnectionGUID: JfGYV9VQQpSB9ks5i7ayxA==
X-CSE-MsgGUID: ryZkIDmVRNOOzPzx+J8UHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="49456002"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 28 Jun 2024 13:07:29 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sNHsU-000IIG-0l;
	Fri, 28 Jun 2024 20:07:26 +0000
Date: Sat, 29 Jun 2024 04:06:44 +0800
From: kernel test robot <lkp@intel.com>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
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
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v5 3/3] arm64: dts: rockchip: add DT entry for RNG to
 RK356x
Message-ID: <202406290305.M3hDJkwM-lkp@intel.com>
References: <2181f2207391fb8fb8ae2cfda07d38f65da05ed9.1719365406.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2181f2207391fb8fb8ae2cfda07d38f65da05ed9.1719365406.git.daniel@makrotopia.org>

Hi Daniel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus rockchip/for-next robh/for-next herbert-cryptodev-2.6/master linus/master v6.10-rc5 next-20240627]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Golle/dt-bindings-rng-Add-Rockchip-RK3568-TRNG/20240626-114623
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/2181f2207391fb8fb8ae2cfda07d38f65da05ed9.1719365406.git.daniel%40makrotopia.org
patch subject: [PATCH v5 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
config: arm64-randconfig-051-20240628 (https://download.01.org/0day-ci/archive/20240629/202406290305.M3hDJkwM-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
dtschema version: 2024.6.dev3+g650bf2d
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240629/202406290305.M3hDJkwM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406290305.M3hDJkwM-lkp@intel.com/

dtcheck warnings: (new ones prefixed by >>)
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg-arc-d.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg-arc-s.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dtb: i2c@fe5b0000: Unevaluated properties are not allowed ('pintctrl-names' was unexpected)
   	from schema $id: http://devicetree.org/schemas/i2c/i2c-rk3x.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353ps.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dtb: i2c@fe5b0000: Unevaluated properties are not allowed ('pintctrl-names' was unexpected)
   	from schema $id: http://devicetree.org/schemas/i2c/i2c-rk3x.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353vs.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg503.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi:486.10-497.6: Warning (graph_child_address): /i2c@fe5c0000/tcpc@60/connector/ports: graph node has single child node 'port@0', #address-cells/#size-cells are not necessary
>> arch/arm64/boot/dts/rockchip/rk3566-pinenote-v1.1.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-pinenote-v1.1.dtb: bluetooth: reset-gpios: False schema does not allow [[34, 20, 1]]
   	from schema $id: http://devicetree.org/schemas/net/broadcom-bluetooth.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-pinenote-v1.1.dtb: bluetooth: 'device-wake-gpios', 'host-wake-gpios' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/net/broadcom-bluetooth.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-pinenote-v1.1.dtb: usb2phy@fe8a0000: otg-port: 'port' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/rockchip,inno-usb2phy.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi:288.10-292.5: Warning (unit_address_vs_reg): /dsi@fe060000/panel@0/port@0: node has a unit name, but no reg or ranges property
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi:289.29-291.6: Warning (unit_address_vs_reg): /dsi@fe060000/panel@0/port@0/endpoint@0: node has a unit name, but no reg or ranges property
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v0.1.dtb: panel@0: 'port@0', 'reset-gpios' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/display/panel/boe,th101mb31ig002-28a.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v0.1.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v0.1.dtb: phy@fe870000: 'power-domains' is a required property
   	from schema $id: http://devicetree.org/schemas/phy/rockchip-inno-csi-dphy.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi:288.10-292.5: Warning (unit_address_vs_reg): /dsi@fe060000/panel@0/port@0: node has a unit name, but no reg or ranges property
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi:289.29-291.6: Warning (unit_address_vs_reg): /dsi@fe060000/panel@0/port@0/endpoint@0: node has a unit name, but no reg or ranges property
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v2.0.dtb: panel@0: 'port@0', 'reset-gpios' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/display/panel/boe,th101mb31ig002-28a.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v2.0.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-pinetab2-v2.0.dtb: phy@fe870000: 'power-domains' is a required property
   	from schema $id: http://devicetree.org/schemas/phy/rockchip-inno-csi-dphy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-powkiddy-rgb10max3.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-powkiddy-rgb30.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-powkiddy-rk2023.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-powkiddy-x55.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dtb: wifi@1: compatible: 'oneOf' conditional failed, one must be fixed:
   	['brcm,bcm43455-fmac'] is too short
   	'brcm,bcm43455-fmac' is not one of ['brcm,bcm4329-fmac', 'pci14e4,43dc', 'pci14e4,4464', 'pci14e4,4488', 'pci14e4,4425', 'pci14e4,4433']
   	from schema $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dtb: wifi@1: Unevaluated properties are not allowed ('compatible' was unexpected)
   	from schema $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dtb: bluetooth: reset-gpios: False schema does not allow [[103, 16, 1]]
   	from schema $id: http://devicetree.org/schemas/net/broadcom-bluetooth.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks', 'codec' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-soquartz-blade.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-soquartz-blade.dtb: phy@fe840000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dtb: phy@fe840000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-soquartz-model-a.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-soquartz-model-a.dtb: phy@fe840000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3566-box-demo.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-box-demo.dtb: bluetooth: clock-names: 'oneOf' conditional failed, one must be fixed:
   	['ext_clock'] is too short
   	'extclk' was expected
   	'txco' was expected
   	'lpo' was expected
   	from schema $id: http://devicetree.org/schemas/net/broadcom-bluetooth.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-box-demo.dtb: bluetooth: 'device-wake-gpios', 'host-wake-gpios' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/net/broadcom-bluetooth.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dtb: mmc@fe2b0000: Unevaluated properties are not allowed ('supports-sd' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mmc/rockchip-dw-mshc.yaml#
   arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dtb: mmc@fe310000: Unevaluated properties are not allowed ('supports-emmc' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mmc/snps,dwcmshc-sdhci.yaml#
>> arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dtb: sata@fc800000: Unevaluated properties are not allowed ('power-domains' was unexpected)
   	from schema $id: http://devicetree.org/schemas/ata/rockchip,dwc-ahci.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dtb: phy@fe8c0000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/rockchip,pcie3-phy.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks', 'codec' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dtb: mmc@fe310000: Unevaluated properties are not allowed ('supports-emmc' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mmc/snps,dwcmshc-sdhci.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dtb: sata@fc000000: Unevaluated properties are not allowed ('power-domains' was unexpected)
   	from schema $id: http://devicetree.org/schemas/ata/rockchip,dwc-ahci.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-mecsbc.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5c.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dtb: sata@fc800000: Unevaluated properties are not allowed ('power-domains' was unexpected)
   	from schema $id: http://devicetree.org/schemas/ata/rockchip,dwc-ahci.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dtb: phy@fe830000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dtb: phy@fe820000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-qnap-ts433.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dtb: sata@fc400000: Unevaluated properties are not allowed ('power-domains' was unexpected)
   	from schema $id: http://devicetree.org/schemas/ata/rockchip,dwc-ahci.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dtb: phy@fe830000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/phy-rockchip-naneng-combphy.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dtb: sata@fc800000: Unevaluated properties are not allowed ('power-domains' was unexpected)
   	from schema $id: http://devicetree.org/schemas/ata/rockchip,dwc-ahci.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dtb: pmic@20: regulators:DCDC_REG1: Unevaluated properties are not allowed ('regulator-init-microvolt' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dtb: pmic@20: regulators:DCDC_REG2: Unevaluated properties are not allowed ('regulator-init-microvolt' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dtb: pmic@20: regulators:DCDC_REG4: Unevaluated properties are not allowed ('regulator-init-microvolt' was unexpected)
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
--
   arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb: pmic@20: '#sound-dai-cells', 'assigned-clock-parents', 'assigned-clocks', 'clock-names', 'clocks', 'codec' do not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#
>> arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
   arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb: phy@fe8c0000: 'phy-supply' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/phy/rockchip,pcie3-phy.yaml#
--
>> arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dtb: rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[0-9]+'
   	from schema $id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
