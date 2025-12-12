Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895E2D7DE6;
	Fri, 12 Dec 2025 05:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765517012; cv=none; b=iU/iebskgvtuJAWEybf97yT1eKjd4yegOORh5p9XsECKwL821YuIWbUGgi395h17XUgzQx+zZSw6GL/WXL0EW5QkdakS2quyKQx+YDdYwNNATh3AzqZomUKEkXbCJ/04u7COsQ42RYUYbhpH8AHImP7LLjSCJQ0DL6YArGm8syU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765517012; c=relaxed/simple;
	bh=m74I6Bvib2CIovtwKp7KyYPQ9tJgDXGU5el4QgpfVco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REDJ12sRi1e2hG8V9bp+LLKvCGfjWEnOrAB5PjNkRKQFCqdANJOm6h7diY8UIw/1z4q2fQI57NdeaSzwh6f+LkHRz93gG1vaTQw6EJ6ZpWc73ZkAU+ZuaVdNfMc9u8B7827zlkUJdahvIzAPzuN7jwRGwq46JIkORVZSdJQsJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mU5XSJ1x; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mU5XSJ1x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765517011; x=1797053011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m74I6Bvib2CIovtwKp7KyYPQ9tJgDXGU5el4QgpfVco=;
  b=mU5XSJ1xnVU5LPd/DmCpAD+xJQ0nEUgcMCqCuZPXKLv6LszT+7xWwMTN
   M0qNBTX5PjJb0l3yFgXiQO0trwLkmoOq838cIy05f8KaD3g+10VXCFY1K
   kOtA6bQs2Ct8I5qbFrf5SZ09D3ghJ39uVVcY9hM7gkDJZuSKh/zfmvoqR
   XkMYmKQxkwm5hlYTXmaPODF2Hy/dUCt4bxDobQxkNaNSVi5NrUv2+cjAO
   acneUvHZiT4OqEqg6aNpD//a1VwuusFrMUxU4hz0AxTPHEL+0YQfTBYwX
   rwIhkuUNcNVT4q7MzVkXcBLM13IyelUNPxIn2MFq8cClkFve7Q5ASxT2d
   w==;
X-CSE-ConnectionGUID: YNYN2P1PQKinVA1/KRM9NQ==
X-CSE-MsgGUID: Fi34Je51S3WzsvGL8e0Cnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="78615697"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="78615697"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 21:23:28 -0800
X-CSE-ConnectionGUID: KrxP/FzGQtaHRq6HfwPmjg==
X-CSE-MsgGUID: CGNRnWs7T9Oq6dLLnt89bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="234390040"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 11 Dec 2025 21:23:26 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTvch-000000005aH-1QJD;
	Fri, 12 Dec 2025 05:23:23 +0000
Date: Fri, 12 Dec 2025 13:22:27 +0800
From: kernel test robot <lkp@intel.com>
To: Haotian Zhang <vulab@iscas.ac.cn>, ansuelsmth@gmail.com,
	olivia@selenic.com, herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Haotian Zhang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] hwrng: airoha: Fix wait_for_completion_timeout return
 value check
Message-ID: <202512121309.biSQJ5fC-lkp@intel.com>
References: <20251208080836.1010-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208080836.1010-1-vulab@iscas.ac.cn>

Hi Haotian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.18 next-20251212]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Haotian-Zhang/hwrng-airoha-Fix-wait_for_completion_timeout-return-value-check/20251208-161314
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20251208080836.1010-1-vulab%40iscas.ac.cn
patch subject: [PATCH] hwrng: airoha: Fix wait_for_completion_timeout return value check
config: arm-randconfig-r072-20251210 (https://download.01.org/0day-ci/archive/20251212/202512121309.biSQJ5fC-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512121309.biSQJ5fC-lkp@intel.com/

New smatch warnings:
drivers/char/hw_random/airoha-trng.c:108 airoha_trng_init() warn: unsigned 'ret' is never less than zero.

Old smatch warnings:
drivers/char/hw_random/airoha-trng.c:117 airoha_trng_init() warn: unsigned 'ret' is never less than zero.

vim +/ret +108 drivers/char/hw_random/airoha-trng.c

e53ca8efcc5ec1 Christian Marangi 2024-10-17   75  
e53ca8efcc5ec1 Christian Marangi 2024-10-17   76  static int airoha_trng_init(struct hwrng *rng)
e53ca8efcc5ec1 Christian Marangi 2024-10-17   77  {
e53ca8efcc5ec1 Christian Marangi 2024-10-17   78  	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
cd62dba83f93a0 Haotian Zhang     2025-12-08   79  	unsigned long ret;
e53ca8efcc5ec1 Christian Marangi 2024-10-17   80  	u32 val;
e53ca8efcc5ec1 Christian Marangi 2024-10-17   81  
e53ca8efcc5ec1 Christian Marangi 2024-10-17   82  	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   83  	val |= RNG_EN;
e53ca8efcc5ec1 Christian Marangi 2024-10-17   84  	writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   85  
e53ca8efcc5ec1 Christian Marangi 2024-10-17   86  	/* Set out of SW Reset */
e53ca8efcc5ec1 Christian Marangi 2024-10-17   87  	airoha_trng_irq_unmask(trng);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   88  	writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   89  
e53ca8efcc5ec1 Christian Marangi 2024-10-17   90  	ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
cd62dba83f93a0 Haotian Zhang     2025-12-08   91  	if (ret == 0) {
e53ca8efcc5ec1 Christian Marangi 2024-10-17   92  		dev_err(trng->dev, "Timeout waiting for Health Check\n");
e53ca8efcc5ec1 Christian Marangi 2024-10-17   93  		airoha_trng_irq_mask(trng);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   94  		return -ENODEV;
e53ca8efcc5ec1 Christian Marangi 2024-10-17   95  	}
e53ca8efcc5ec1 Christian Marangi 2024-10-17   96  
e53ca8efcc5ec1 Christian Marangi 2024-10-17   97  	/* Check if Health Test Failed */
e53ca8efcc5ec1 Christian Marangi 2024-10-17   98  	val = readl(trng->base + TRNG_HEALTH_TEST_STATUS);
e53ca8efcc5ec1 Christian Marangi 2024-10-17   99  	if (val & (RST_STARTUP_AP_TEST_FAIL | RST_STARTUP_RC_TEST_FAIL)) {
e53ca8efcc5ec1 Christian Marangi 2024-10-17  100  		dev_err(trng->dev, "Health Check fail: %s test fail\n",
e53ca8efcc5ec1 Christian Marangi 2024-10-17  101  			val & RST_STARTUP_AP_TEST_FAIL ? "AP" : "RC");
e53ca8efcc5ec1 Christian Marangi 2024-10-17  102  		return -ENODEV;
e53ca8efcc5ec1 Christian Marangi 2024-10-17  103  	}
e53ca8efcc5ec1 Christian Marangi 2024-10-17  104  
e53ca8efcc5ec1 Christian Marangi 2024-10-17  105  	/* Check if IP is ready */
e53ca8efcc5ec1 Christian Marangi 2024-10-17  106  	ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
e53ca8efcc5ec1 Christian Marangi 2024-10-17  107  				 val & SAMPLE_RDY, 10, 1000);
e53ca8efcc5ec1 Christian Marangi 2024-10-17 @108  	if (ret < 0) {
e53ca8efcc5ec1 Christian Marangi 2024-10-17  109  		dev_err(trng->dev, "Timeout waiting for IP ready");
e53ca8efcc5ec1 Christian Marangi 2024-10-17  110  		return -ENODEV;
e53ca8efcc5ec1 Christian Marangi 2024-10-17  111  	}
e53ca8efcc5ec1 Christian Marangi 2024-10-17  112  
e53ca8efcc5ec1 Christian Marangi 2024-10-17  113  	/* CNT_TRANS must be 0x80 for IP to be considered ready */
e53ca8efcc5ec1 Christian Marangi 2024-10-17  114  	ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
e53ca8efcc5ec1 Christian Marangi 2024-10-17  115  				 FIELD_GET(CNT_TRANS, val) == TRNG_CNT_TRANS_VALID,
e53ca8efcc5ec1 Christian Marangi 2024-10-17  116  				 10, 1000);
e53ca8efcc5ec1 Christian Marangi 2024-10-17  117  	if (ret < 0) {
e53ca8efcc5ec1 Christian Marangi 2024-10-17  118  		dev_err(trng->dev, "Timeout waiting for IP ready");
e53ca8efcc5ec1 Christian Marangi 2024-10-17  119  		return -ENODEV;
e53ca8efcc5ec1 Christian Marangi 2024-10-17  120  	}
e53ca8efcc5ec1 Christian Marangi 2024-10-17  121  
e53ca8efcc5ec1 Christian Marangi 2024-10-17  122  	return 0;
e53ca8efcc5ec1 Christian Marangi 2024-10-17  123  }
e53ca8efcc5ec1 Christian Marangi 2024-10-17  124  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
