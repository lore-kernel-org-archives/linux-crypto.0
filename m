Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30161DA618;
	Thu, 17 Oct 2024 10:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729160844; cv=none; b=Qny5jvb/Swzcm1c2XSRCXxR120Gns8pGVaBwyah1EWklcvxrjJzF097BGBQEkwMCg7LkeYbCCtsw+nhvvC3HV7CCtFxGRHtlxluzzoMEnuF0cc6y21DF4fVQ3ONRXkzHw425LjGtUS7RL3RybNjUbRFjguvH0qo2bmZ0EpgQMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729160844; c=relaxed/simple;
	bh=Wg6rF3xq4Ey0oW4iGbKDhGAMlW4BmliJZ60Z/nadhtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYZVptXbbw8ZK0HqBUn/ycd17kv8VjcDJSQ2W3pz+zu+R0EtT5rQQ7XQFMe2ILbA8K9+u2gEZS/e+N8mnZKFY/mDv6WmdTZxWf5XCZgeWOnAWJ5JR9vEz5/Jg36GCwpk6aRG5xQuD2xVvi8RQOYaqZbWKsYDgJ13l5SvfB4c6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CTzWXfEg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CTzWXfEg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729160840; x=1760696840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wg6rF3xq4Ey0oW4iGbKDhGAMlW4BmliJZ60Z/nadhtQ=;
  b=CTzWXfEgPKcUPf2WV/JmmmHXcs+22ifwwSUIKs0oUwKqzBGgZzmgbk7d
   0hgzsB/xY1c54SfvbRlFDNB2nEh6BUWlvqjIg0AW6DE/ztlFS/qmLE+e2
   imRekljlxcpuRW8LsT8U5IPqBvNPGa4KPYKqUpMAMfEunMBl0EulUXdSv
   I/AKn+Tt01W9AXcMxZTpOenClAKHVPcEpVuR6qu3Scjn8Qv1E5axtkEb/
   Rxd/YEX9qIuGw42YLomG4qXvmwUC7FVpaffWt/HNJAhKs5MPIVdR342TG
   FgZbqhSzpumsg/ZgT4q8E2I08K0nCimxZulfM/fOfL/NHd+jfx6ps9NbR
   w==;
X-CSE-ConnectionGUID: xtWNDV0VSCi5VHWx9JDi5w==
X-CSE-MsgGUID: K9+/52yqR+ulCuODLk87lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11227"; a="32569247"
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="32569247"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 03:27:19 -0700
X-CSE-ConnectionGUID: BgghfPaLSXie9thWfmyVgA==
X-CSE-MsgGUID: NGryFgCARN26/cVntol++g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="78111661"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 17 Oct 2024 03:27:16 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t1Nir-000MCZ-1N;
	Thu, 17 Oct 2024 10:27:13 +0000
Date: Thu, 17 Oct 2024 18:26:16 +0800
From: kernel test robot <lkp@intel.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
Message-ID: <202410171822.152Yno42-lkp@intel.com>
References: <20241016151845.23712-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016151845.23712-2-ansuelsmth@gmail.com>

Hi Christian,

kernel test robot noticed the following build errors:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on char-misc/char-misc-next char-misc/char-misc-linus robh/for-next herbert-cryptodev-2.6/master linus/master v6.12-rc3 next-20241016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Marangi/hwrng-add-support-for-Airoha-EN7581-TRNG/20241016-232144
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20241016151845.23712-2-ansuelsmth%40gmail.com
patch subject: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
config: arc-randconfig-001-20241017 (https://download.01.org/0day-ci/archive/20241017/202410171822.152Yno42-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241017/202410171822.152Yno42-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410171822.152Yno42-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/char/hw_random/airoha-trng.c:9:
   drivers/char/hw_random/airoha-trng.c: In function 'airoha_trng_init':
>> drivers/char/hw_random/airoha-trng.c:115:34: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]
     115 |                                  FIELD_GET(CNT_TRANS, val) == TRNG_CNT_TRANS_VALID,
         |                                  ^~~~~~~~~
   include/linux/iopoll.h:47:21: note: in definition of macro 'read_poll_timeout'
      47 |                 if (cond) \
         |                     ^~~~
   include/linux/iopoll.h:170:9: note: in expansion of macro 'readx_poll_timeout'
     170 |         readx_poll_timeout(readl, addr, val, cond, delay_us, timeout_us)
         |         ^~~~~~~~~~~~~~~~~~
   drivers/char/hw_random/airoha-trng.c:114:15: note: in expansion of macro 'readl_poll_timeout'
     114 |         ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
         |               ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/FIELD_GET +115 drivers/char/hw_random/airoha-trng.c

    75	
    76	static int airoha_trng_init(struct hwrng *rng)
    77	{
    78		struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
    79		int ret;
    80		u32 val;
    81	
    82		val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
    83		val |= RNG_EN;
    84		writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
    85	
    86		/* Set out of SW Reset */
    87		airoha_trng_irq_unmask(trng);
    88		writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);
    89	
    90		ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
    91		if (ret <= 0) {
    92			dev_err(trng->dev, "Timeout waiting for Health Check\n");
    93			airoha_trng_irq_mask(trng);
    94			return -ENODEV;
    95		}
    96	
    97		/* Check if Health Test Failed */
    98		val = readl(trng->base + TRNG_HEALTH_TEST_STATUS);
    99		if (val & (RST_STARTUP_AP_TEST_FAIL | RST_STARTUP_RC_TEST_FAIL)) {
   100			dev_err(trng->dev, "Health Check fail: %s test fail\n",
   101				val & RST_STARTUP_AP_TEST_FAIL ? "AP" : "RC");
   102			return -ENODEV;
   103		}
   104	
   105		/* Check if IP is ready */
   106		ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
   107					 val & SAMPLE_RDY, 10, 1000);
   108		if (ret < 0) {
   109			dev_err(trng->dev, "Timeout waiting for IP ready");
   110			return -ENODEV;
   111		}
   112	
   113		/* CNT_TRANS must be 0x80 for IP to be considered ready */
   114		ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
 > 115					 FIELD_GET(CNT_TRANS, val) == TRNG_CNT_TRANS_VALID,
   116					 10, 1000);
   117		if (ret < 0) {
   118			dev_err(trng->dev, "Timeout waiting for IP ready");
   119			return -ENODEV;
   120		}
   121	
   122		return 0;
   123	}
   124	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
