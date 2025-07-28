Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FA9223335;
	Mon, 28 Jul 2025 08:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753690780; cv=none; b=ZhQnai637Y+7M3QXiL7gS4uFMDop4pEdMWU4NLlAg6UsWuy+wtEQbHmmznff+67Iqfno8NGFaMAcykSZcpkRd8OCwb9gY0HGsvVPys0qjeoNwswAaCqZQz8Ka5loFRa5kZz4C40APw20NcMXCAyRuSseOmFpwEA/QZYdUeA5W+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753690780; c=relaxed/simple;
	bh=r9heF4Jx2oSf4dh7BKMtWEH3wRtjhZSOKr7RdyIDwec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWXE70sbRnMD9I3kvT4WQUWyhS5l7d2jogMQhlURhY2Vj0ScTkauM7t0eHD2d8ZB+v7kT4o0hhTGHwDS/1Y/YrM6gjgQJsftyJ9TX8sL9kpeWRqxflQ7uQkd7Yg6GGSz45TUyO/VkR4FfwTa2jkUhMoNDS3g2FruNN+pZRrpiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKZat7Wm; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKZat7Wm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753690779; x=1785226779;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r9heF4Jx2oSf4dh7BKMtWEH3wRtjhZSOKr7RdyIDwec=;
  b=MKZat7Wm9Lq/C7zsf8BV407McsLz2p8O7/BHlqwKvSymmVfsFwP4iFxZ
   13/hymVB3zAoAFZ4VyqRhMQ+yxnjZfCUFgcYUqAHj0mWvFmTeMHSlg66r
   Qo3qNs/sSnDT0PhHm1JEnj/jdCnJUbu3LcL9/ln5DPtlLnEpbb3NS8wZT
   kLA8lPf98tdjFWshzyUFQMDNJw3P5KAwIS7OObeozgBGn5b/g77LLji7W
   dGGRNHCXUdWNmG+iozn6Eoa7UEx80AGocBOOvbAsdP5kTSaIePodAT4Sm
   z4b8OhwciODoDNAJxOO1CGtaAOB8wiDJrFElOtCxj3q46nhvNB4fVNqpz
   A==;
X-CSE-ConnectionGUID: Mls3EAgBRB+3SWYIO1A/9g==
X-CSE-MsgGUID: FFVNiOR2Sey00n2nLP/XNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="55142957"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55142957"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 01:19:38 -0700
X-CSE-ConnectionGUID: e4j/OyJ1Q+m/OV7eekb6VQ==
X-CSE-MsgGUID: gR3o9gKhS6iEfbQfGj2kbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161600047"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 28 Jul 2025 01:19:35 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugJ52-0000K1-1z;
	Mon, 28 Jul 2025 08:19:32 +0000
Date: Mon, 28 Jul 2025 16:19:17 +0800
From: kernel test robot <lkp@intel.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>, clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: Re: [PATCH 3/9] crypto: sun8i-ce - remove unnecessary __maybe_unused
 annotations
Message-ID: <202507281638.lcdB5LRY-lkp@intel.com>
References: <20250728060701.1787607-4-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728060701.1787607-4-ovidiu.panait.oss@gmail.com>

Hi Ovidiu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250728]
[cannot apply to sunxi/sunxi/for-next herbert-crypto-2.6/master linus/master v6.16]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ovidiu-Panait/crypto-sun8i-ce-remove-channel-timeout-field/20250728-141133
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250728060701.1787607-4-ovidiu.panait.oss%40gmail.com
patch subject: [PATCH 3/9] crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
config: arm-randconfig-002-20250728 (https://download.01.org/0day-ci/archive/20250728/202507281638.lcdB5LRY-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1b4db78d2eaa070b3f364a2d2b2b826a5439b892)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250728/202507281638.lcdB5LRY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507281638.lcdB5LRY-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:1066:18: warning: variable 'dbgfs_stats' set but not used [-Wunused-but-set-variable]
    1066 |                 struct dentry *dbgfs_stats;
         |                                ^
   1 warning generated.


vim +/dbgfs_stats +1066 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c

  1056	
  1057		v = readl(ce->base + CE_CTR);
  1058		v >>= CE_DIE_ID_SHIFT;
  1059		v &= CE_DIE_ID_MASK;
  1060		dev_info(&pdev->dev, "CryptoEngine Die ID %x\n", v);
  1061	
  1062		pm_runtime_put_sync(ce->dev);
  1063	
  1064		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
  1065			struct dentry *dbgfs_dir;
> 1066			struct dentry *dbgfs_stats;
  1067	
  1068			/* Ignore error of debugfs */
  1069			dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
  1070			dbgfs_stats = debugfs_create_file("stats", 0444,
  1071							  dbgfs_dir, ce,
  1072							  &sun8i_ce_debugfs_fops);
  1073	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
