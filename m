Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804F2A927;
	Sat,  5 Jul 2025 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751695308; cv=none; b=smNoVHss34NH5Ji5eyKgU162YKLP6qnG5RkP+CceHbkdiwp9jzfMi4N5W2iwC5uAKHLggLQd2LxztW/MLyy8M17OhRZ3pSiI5MEwmhP45/I9FpZTyKDK52SfZ2nYOzj8bbanfM2D4ksGJt5RblNpdU5BXYUTniChV0FGkogS56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751695308; c=relaxed/simple;
	bh=mXBlarxcOHoAVSL3KlFj7ecUcr1aQVy9IEIhWKHJqWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2yRzMrMLDL+IUQ4PfMsEy/23lfe8bM7Y/Sua60FHHQ9C5W7aipQltnTq1AQFTvPX8sS9OW0Y2d1GjunA60lzHKr/hzazrmKoTgTVJ5bMKcOLAxBIG5kIDHo5zh02tKDz47F199BvbDujL/H73FCKWq+Oz/Lh3psHAwCs6f5XaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUb118py; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUb118py"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751695306; x=1783231306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mXBlarxcOHoAVSL3KlFj7ecUcr1aQVy9IEIhWKHJqWo=;
  b=eUb118pyDGTL7IkFyoov/heeiebjFrGrJYeCAeSaKcTl2i0u9t7b8piq
   f2Bj0nu6jz/J2545FWhMfHYETn7KrG9japJTwRmzy9inD1UUGqtphbKrx
   hAH/IFrHVg9ry6xbZ5DY/En6kFi0EHMXUzeBj/nqsctCTJv/2oBkypsti
   mxLBZ7vu3djKbJxYIhJxAPH+jBXVX4nqrp8sfOX79dFagEcSXOnDjt/mG
   vzwGapxDKWZTQZrEYru/zhsgXyNNwQpwL6Qoz+J9JfJdo4Rb8hcJ9XTS8
   xDWtXgTlk0RoA4AhLEzaFPdarujarAI24DK38gJa5lfLHg71u2n0lRIjD
   w==;
X-CSE-ConnectionGUID: xKhsrGbUTkSk11oOUKUsNA==
X-CSE-MsgGUID: 45l4oH1KSLSYPlgJPmUHvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="65061964"
X-IronPort-AV: E=Sophos;i="6.16,289,1744095600"; 
   d="scan'208";a="65061964"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 23:01:31 -0700
X-CSE-ConnectionGUID: NXB8hpnrQ6yeMZX6sGE8Nw==
X-CSE-MsgGUID: hKgW5LbiQKuieAcNg6LaSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,289,1744095600"; 
   d="scan'208";a="160445533"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 04 Jul 2025 23:01:26 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXvxj-0004KR-0A;
	Sat, 05 Jul 2025 06:01:23 +0000
Date: Sat, 5 Jul 2025 14:00:27 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v10 02/25] crypto: iaa - New architecture for IAA device
 WQ comp/decomp usage & core mapping.
Message-ID: <202507051352.IIeHABGF-lkp@intel.com>
References: <20250704042323.10318-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704042323.10318-3-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master akpm-mm/mm-everything linus/master v6.16-rc4 next-20250704]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-iaa-Reorganize-the-iaa_crypto-driver-code/20250704-122613
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250704042323.10318-3-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v10 02/25] crypto: iaa - New architecture for IAA device WQ comp/decomp usage & core mapping.
config: x86_64-randconfig-123-20250704 (https://download.01.org/0day-ci/archive/20250705/202507051352.IIeHABGF-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250705/202507051352.IIeHABGF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507051352.IIeHABGF-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/intel/iaa/iaa_crypto_main.c:94:1: sparse: sparse: symbol 'first_wq_found_lock' was not declared. Should it be static?

vim +/first_wq_found_lock +94 drivers/crypto/intel/iaa/iaa_crypto_main.c

    77	
    78	/*
    79	 * First wq probed, to use until @iaa_crypto_enabled is 1:
    80	 *
    81	 * The first wq probed will be entered in the per-CPU comp/decomp wq tables
    82	 * until the IAA compression modes are registered. This is done to facilitate
    83	 * the compress/decompress calls from the crypto testmgr resulting from
    84	 * calling crypto_register_acomp().
    85	 *
    86	 * With the new dynamic package-level rebalancing of WQs being
    87	 * discovered asynchronously and concurrently with tests
    88	 * triggered from device registration, this is needed to
    89	 * determine when it is safe for the rebalancing of decomp/comp
    90	 * WQs to de-allocate the per-package WQs and re-allocate them
    91	 * based on the latest number of IAA devices and WQs.
    92	 */
    93	static struct idxd_wq *first_wq_found;
  > 94	DEFINE_MUTEX(first_wq_found_lock);
    95	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
