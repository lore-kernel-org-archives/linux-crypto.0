Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574D92C0F84;
	Mon, 24 Nov 2025 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764006516; cv=none; b=YbSzFuR5Nb96FeRUSy3YHwiJ6cyyaW/+jL+mf64BwUTn/xSfRG79kmpn9W6PTuAZijAq/frnJI6HtIGBSCsv88k0HJkT+HHQ8+LJeBYsSY3w9MEq/BjOwdtq/lLzW+g/iNnHnrqjx5c2qAjYBrveoBP+J66VqMBPx1OIlC1OQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764006516; c=relaxed/simple;
	bh=ZMfp9MU43gbbsHJVljv1nrWxCaYgeHGHk75SKAtcBEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6w7PsYvx0BB4zER2x1vZx3Sd20hoSm8hhoRcacfgMfzsUbuvVgjLZwbmCI1VYDdBAKL4I9hnYQ9/zlnvf3qgQ1qjH3Ci8sgnOvIzNHcgMo0bm1kkBK2hqjpPMGbUP1ZSc7BzeDsLsIcDIh/9wCj+ZzNjBjoBScJfW8NTH+a3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOHae+qG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOHae+qG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764006514; x=1795542514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZMfp9MU43gbbsHJVljv1nrWxCaYgeHGHk75SKAtcBEI=;
  b=FOHae+qGyjZak79NvA3WQNSE8rB/ipzKJ9QNVk+AIhHnf0XJzMDJRcZ6
   yrkz90ZKbAW/n3ds9AUjhVuAwo8GNs+5Llx4SebV2YADi/A1fSTfPZk6F
   t5tZTU2Hwzooa9ySvQPNIuL4D1F3WWnQHDyA9L9w1D3sBkvl3cJrrNhdJ
   xr9ogkji1TJBYo/e2exFyztnLR7r3RVFoUmB3xdGTsdwszA+9RVEZU5rQ
   8K7NxFbHpBHd36TJld6DbwwasMguX9BwnlE9eYRe3Txho62XGV+fTcaeq
   bS2aB2MBZj3KQZzQhAlPpVvU/YYtAFgnd0IfWOy2NVGs/99W8rRYuGWiu
   Q==;
X-CSE-ConnectionGUID: VRFaLfsNTv2nu8G2UHJDnQ==
X-CSE-MsgGUID: seE2lf0yQ3u9V3Xgi5ucgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66050729"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="66050729"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 09:48:33 -0800
X-CSE-ConnectionGUID: 7wgYsk0wQyGLB6sMISS2RA==
X-CSE-MsgGUID: Ce6J77WjRE2IkJQjB3NoxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="215736574"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 24 Nov 2025 09:48:30 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNafr-000000000z7-2axH;
	Mon, 24 Nov 2025 17:48:27 +0000
Date: Tue, 25 Nov 2025 01:48:24 +0800
From: kernel test robot <lkp@intel.com>
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v3 1/3] m68k: coldfire: Mark platform device resource
 arrays as const
Message-ID: <202511250103.RMNoU3xH-lkp@intel.com>
References: <20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27@yoseli.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27@yoseli.org>

Hi Jean-Michel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d]

url:    https://github.com/intel-lab-lkp/linux/commits/Jean-Michel-Hautbois/m68k-coldfire-Mark-platform-device-resource-arrays-as-const/20251124-210737
base:   ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
patch link:    https://lore.kernel.org/r/20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27%40yoseli.org
patch subject: [PATCH v3 1/3] m68k: coldfire: Mark platform device resource arrays as const
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251125/202511250103.RMNoU3xH-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511250103.RMNoU3xH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511250103.RMNoU3xH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/m68k/coldfire/device.c:141:35: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     141 |         .resource               = mcf_fec0_resources,
         |                                   ^~~~~~~~~~~~~~~~~~


vim +/const +141 arch/m68k/coldfire/device.c

b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  136  
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  137  static struct platform_device mcf_fec0 = {
bea8bcb12da09b arch/m68k/platform/coldfire/device.c Steven King       2012-06-06  138  	.name			= FEC_NAME,
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  139  	.id			= 0,
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  140  	.num_resources		= ARRAY_SIZE(mcf_fec0_resources),
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24 @141  	.resource		= mcf_fec0_resources,
f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  142  	.dev = {
f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  143  		.dma_mask		= &mcf_fec0.dev.coherent_dma_mask,
f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  144  		.coherent_dma_mask	= DMA_BIT_MASK(32),
f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  145  		.platform_data		= FEC_PDATA,
f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  146  	}
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  147  };
63a24cf8cc330e arch/m68k/coldfire/device.c          Antonio Quartulli 2024-10-29  148  #endif /* MCFFEC_BASE0 */
b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  149  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
