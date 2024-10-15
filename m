Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE514D8DA;
	Tue, 15 Oct 2024 06:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728974863; cv=none; b=UYIXs7SnJtd1GPjOB2v1PBO5Ul5LtUD35vuynkMZpDNMvFh5X+zuhdf7h1f3gyMbBkL75cb4v8TasAPMMzYb0+FpcMXq97HfCH+DnMEZDC8sIN8x/hWRV6jZlgi6kOdHiCM6GnWYj4nbSwHWgkVYcTXiwbc+E4U4YQiltfdp9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728974863; c=relaxed/simple;
	bh=6IAKQl0FeJyqvb+jgw9De0Ep6tMaFhgHgcVDED6/PIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uzi6ARM29UD/qy7l/wNENWuf6ntKWpn7vMmkirEBWtKtTAn9F0e2YPojbokOmDDdFBvaYaWoFlZrMmG/hmg6qWOOGvmroFSU9xvtyskSBnXlb/iHJHzvbC3O7UvjffoHK7m45X9uOA7CVsj+1D2ax4Pf/xLR1RRu5WaPhtGC8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8zbXHWW; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8zbXHWW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728974858; x=1760510858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6IAKQl0FeJyqvb+jgw9De0Ep6tMaFhgHgcVDED6/PIQ=;
  b=Y8zbXHWWxApPnc0jyW4Stv9q4c584+NHqzB00iSpqF0XREYSzuRYprJk
   OeGzuIj+HKYGNhYkE1GQlW0zhCkNV5rZj4RAh1iRs8JavEmSpNdSPCrRV
   1UKj1Qdz0IcJ11pG7HGdddmtXp5pbr1T3iIWfXbDdsfcAFEQZKEABHtFH
   gpHfQi/KMnS33wXaxSkpI0+PkKzvEPEoqp9kWRHhfEvHE8CPNFZtCkb73
   dV4shdFr0ECbtig+476ES005Wuz+D+xrVRB4IAwiw7oy4SARNp7keQj5N
   1zNjm7uWLYMGhDQlqwJQkT20XBYygNE7HIGe1lcV5pzF2moell0/MBvSC
   A==;
X-CSE-ConnectionGUID: Kl9pVw1FRv+CRZNgEW+6jQ==
X-CSE-MsgGUID: ksBp7ATcQdqhYU6omAwqYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="28539405"
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="28539405"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 23:47:37 -0700
X-CSE-ConnectionGUID: taqcyVltRrKTjJ7B5kbwzQ==
X-CSE-MsgGUID: 4ywyFyftQkSB6s+nkaBVhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="78138620"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2024 23:47:34 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t0bL9-000HiD-2f;
	Tue, 15 Oct 2024 06:47:31 +0000
Date: Tue, 15 Oct 2024 14:46:41 +0800
From: kernel test robot <lkp@intel.com>
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>, marex@denx.de
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Gatien Chevallier <gatien.chevallier@foss.st.com>
Subject: Re: [PATCH v2 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
Message-ID: <202410151421.5UhVRFdF-lkp@intel.com>
References: <20241011-rng-mp25-v2-v2-2-76fd6170280c@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011-rng-mp25-v2-v2-2-76fd6170280c@foss.st.com>

Hi Gatien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 1d227fcc72223cbdd34d0ce13541cbaab5e0d72f]

url:    https://github.com/intel-lab-lkp/linux/commits/Gatien-Chevallier/dt-bindings-rng-add-st-stm32mp25-rng-support/20241011-234913
base:   1d227fcc72223cbdd34d0ce13541cbaab5e0d72f
patch link:    https://lore.kernel.org/r/20241011-rng-mp25-v2-v2-2-76fd6170280c%40foss.st.com
patch subject: [PATCH v2 2/4] hwrng: stm32 - implement support for STM32MP25x platforms
config: nios2-randconfig-r053-20241015 (https://download.01.org/0day-ci/archive/20241015/202410151421.5UhVRFdF-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 14.1.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410151421.5UhVRFdF-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> drivers/char/hw_random/stm32-rng.c:585:6-12: inconsistent IS_ERR and PTR_ERR on line 586.

vim +585 drivers/char/hw_random/stm32-rng.c

   530	
   531	static int stm32_rng_probe(struct platform_device *ofdev)
   532	{
   533		struct device *dev = &ofdev->dev;
   534		struct device_node *np = ofdev->dev.of_node;
   535		struct stm32_rng_private *priv;
   536		struct resource *res;
   537	
   538		priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
   539		if (!priv)
   540			return -ENOMEM;
   541	
   542		priv->base = devm_platform_get_and_ioremap_resource(ofdev, 0, &res);
   543		if (IS_ERR(priv->base))
   544			return PTR_ERR(priv->base);
   545	
   546		priv->rst = devm_reset_control_get(&ofdev->dev, NULL);
   547		if (!IS_ERR(priv->rst)) {
   548			reset_control_assert(priv->rst);
   549			udelay(2);
   550			reset_control_deassert(priv->rst);
   551		}
   552	
   553		priv->ced = of_property_read_bool(np, "clock-error-detect");
   554		priv->lock_conf = of_property_read_bool(np, "st,rng-lock-conf");
   555		priv->dev = dev;
   556	
   557		priv->data = of_device_get_match_data(dev);
   558		if (!priv->data)
   559			return -ENODEV;
   560	
   561		dev_set_drvdata(dev, priv);
   562	
   563		priv->rng.name = dev_driver_string(dev);
   564		priv->rng.init = stm32_rng_init;
   565		priv->rng.read = stm32_rng_read;
   566		priv->rng.quality = 900;
   567	
   568		if (!priv->data->nb_clock || priv->data->nb_clock > 2)
   569			return -EINVAL;
   570	
   571		priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * sizeof(*priv->clk_bulk),
   572					      GFP_KERNEL);
   573		if (!priv->clk_bulk)
   574			return -ENOMEM;
   575	
   576		if (priv->data->nb_clock == 2) {
   577			struct clk *clk;
   578			struct clk *bus_clk;
   579	
   580			clk = devm_clk_get(&ofdev->dev, "core");
   581			if (IS_ERR(clk))
   582				return PTR_ERR(clk);
   583	
   584			bus_clk = devm_clk_get(&ofdev->dev, "bus");
 > 585			if (IS_ERR(clk))
 > 586				return PTR_ERR(bus_clk);
   587	
   588			priv->clk_bulk[0].clk = clk;
   589			priv->clk_bulk[0].id = "core";
   590			priv->clk_bulk[1].clk = bus_clk;
   591			priv->clk_bulk[1].id = "bus";
   592		} else {
   593			struct clk *clk;
   594	
   595			clk = devm_clk_get(&ofdev->dev, NULL);
   596			if (IS_ERR(clk))
   597				return PTR_ERR(clk);
   598	
   599			priv->clk_bulk[0].clk = clk;
   600			priv->clk_bulk[0].id = "core";
   601		}
   602	
   603		pm_runtime_set_autosuspend_delay(dev, 100);
   604		pm_runtime_use_autosuspend(dev);
   605		pm_runtime_enable(dev);
   606	
   607		return devm_hwrng_register(dev, &priv->rng);
   608	}
   609	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
