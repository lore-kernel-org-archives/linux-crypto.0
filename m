Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659927700E
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 10:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744279240; cv=none; b=STrQnSCQwMaxUdQgKNxqHEg/hXqEGSSE6NwBwINkFm9WCAFxaiVgSlvXLQgKL8wv4PIubrjugmethGxlOf4oXzZl0Ozh9fDQAdaC3BuA1HpeWynuJliVBvMnjrkIqFu1QNTHK3pOc8bo0LJSngKiLvUf47VKrKbrS8RILMH498E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744279240; c=relaxed/simple;
	bh=ONUHM5dAa9V9tNPfQhvJhcJq9TbPfVh38gul5GwseA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syrVjITLB8foizsaFBWP7vvB1r1AykVOltb0Gogtvhqm+s5YekUV77YmEbcxmoJHYxzpszZamFvg3PVSRaPqpX4+fztgo1uNY2RV6468x6HKfefjvnqxxHjfAPyMd0F8E3hLE/xpGMzZjbPWV8c3BfID6Jgmulzi0PvVvhJItSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfKMtL+F; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfKMtL+F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744279237; x=1775815237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ONUHM5dAa9V9tNPfQhvJhcJq9TbPfVh38gul5GwseA0=;
  b=SfKMtL+F144/ge0aDylpjwU3hJynUb3yENFl8esIg392xWpOVIfUdHZ4
   vhNKFrTuc3smeHV3Sqt0P2z7QMoz6VyFSjJm9PgPE0VZGe8dJlOKdv6b7
   29lB/ZufYTU9CDx+JQiI1pFt6z5mGoWOzti+td9z+g8yY4EM5LtTSJqU3
   YP9NzVIxMFxdXsWXeYGmeLcrd0ZmHvWuR21mvf8CLYJlLs3SJDs6xqPLN
   RW2ab7RmLcExJ4DuBnoRsscpP34TLB20VlhgYebt57bfaWqsi+3sXFA9K
   VUk4Jk8o14HvBy2QSjh8ONmrHNfRvGx/O2cY6nTOKvsQkJgRCmHEw30/K
   Q==;
X-CSE-ConnectionGUID: KAuR6KgLTSm4G03Bu4q+Jw==
X-CSE-MsgGUID: CCf86XyhQE6FUG30k3DZRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="57159397"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="57159397"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 03:00:37 -0700
X-CSE-ConnectionGUID: 05lbWpcNR3KWflc7G4CuNA==
X-CSE-MsgGUID: YLZYCk0KSbOI90zQomq2Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="133980819"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 10 Apr 2025 03:00:34 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u2ohz-0009tz-0B;
	Thu, 10 Apr 2025 10:00:31 +0000
Date: Thu, 10 Apr 2025 17:59:56 +0800
From: kernel test robot <lkp@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH 3/3] hwrng: npcm - Add a local variable for struct device
 pointer
Message-ID: <202504101705.PeW9QC3m-lkp@intel.com>
References: <20250410070623.3676647-4-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410070623.3676647-4-sakari.ailus@linux.intel.com>

Hi Sakari,

kernel test robot noticed the following build errors:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on char-misc/char-misc-next char-misc/char-misc-linus herbert-cryptodev-2.6/master linus/master v6.15-rc1 next-20250410]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sakari-Ailus/hwrng-atmel-Add-a-local-variable-for-struct-device-pointer/20250410-151223
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20250410070623.3676647-4-sakari.ailus%40linux.intel.com
patch subject: [PATCH 3/3] hwrng: npcm - Add a local variable for struct device pointer
config: csky-randconfig-001-20250410 (https://download.01.org/0day-ci/archive/20250410/202504101705.PeW9QC3m-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250410/202504101705.PeW9QC3m-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504101705.PeW9QC3m-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/char/hw_random/npcm-rng.c: In function 'npcm_rng_read':
>> drivers/char/hw_random/npcm-rng.c:58:9: error: expected ',' or ';' before 'int'
      58 |         int retval = 0;
         |         ^~~
>> drivers/char/hw_random/npcm-rng.c:78:17: error: 'retval' undeclared (first use in this function)
      78 |                 retval++;
         |                 ^~~~~~
   drivers/char/hw_random/npcm-rng.c:78:17: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/char/hw_random/npcm-rng.c:87:1: warning: control reaches end of non-void function [-Wreturn-type]
      87 | }
         | ^


vim +58 drivers/char/hw_random/npcm-rng.c

c98429297d8b25a Tomer Maimon 2019-09-12  53  
c98429297d8b25a Tomer Maimon 2019-09-12  54  static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
c98429297d8b25a Tomer Maimon 2019-09-12  55  {
c98429297d8b25a Tomer Maimon 2019-09-12  56  	struct npcm_rng *priv = to_npcm_rng(rng);
11fd03b27c8824f Sakari Ailus 2025-04-10  57  	struct device *dev = (struct device *)priv->rng.priv
c98429297d8b25a Tomer Maimon 2019-09-12 @58  	int retval = 0;
c98429297d8b25a Tomer Maimon 2019-09-12  59  	int ready;
c98429297d8b25a Tomer Maimon 2019-09-12  60  
11fd03b27c8824f Sakari Ailus 2025-04-10  61  	pm_runtime_get_sync(dev);
c98429297d8b25a Tomer Maimon 2019-09-12  62  
c2fb644638ae45c Tomer Maimon 2020-09-24  63  	while (max) {
c98429297d8b25a Tomer Maimon 2019-09-12  64  		if (wait) {
c2fb644638ae45c Tomer Maimon 2020-09-24  65  			if (readb_poll_timeout(priv->base + NPCM_RNGCS_REG,
c98429297d8b25a Tomer Maimon 2019-09-12  66  					       ready,
c98429297d8b25a Tomer Maimon 2019-09-12  67  					       ready & NPCM_RNG_DATA_VALID,
c98429297d8b25a Tomer Maimon 2019-09-12  68  					       NPCM_RNG_POLL_USEC,
c98429297d8b25a Tomer Maimon 2019-09-12  69  					       NPCM_RNG_TIMEOUT_USEC))
c98429297d8b25a Tomer Maimon 2019-09-12  70  				break;
c98429297d8b25a Tomer Maimon 2019-09-12  71  		} else {
c2fb644638ae45c Tomer Maimon 2020-09-24  72  			if ((readb(priv->base + NPCM_RNGCS_REG) &
c98429297d8b25a Tomer Maimon 2019-09-12  73  			    NPCM_RNG_DATA_VALID) == 0)
c98429297d8b25a Tomer Maimon 2019-09-12  74  				break;
c98429297d8b25a Tomer Maimon 2019-09-12  75  		}
c98429297d8b25a Tomer Maimon 2019-09-12  76  
c2fb644638ae45c Tomer Maimon 2020-09-24  77  		*(u8 *)buf = readb(priv->base + NPCM_RNGD_REG);
c2fb644638ae45c Tomer Maimon 2020-09-24 @78  		retval++;
c2fb644638ae45c Tomer Maimon 2020-09-24  79  		buf++;
c2fb644638ae45c Tomer Maimon 2020-09-24  80  		max--;
c98429297d8b25a Tomer Maimon 2019-09-12  81  	}
c98429297d8b25a Tomer Maimon 2019-09-12  82  
11fd03b27c8824f Sakari Ailus 2025-04-10  83  	pm_runtime_mark_last_busy(dev);
11fd03b27c8824f Sakari Ailus 2025-04-10  84  	pm_runtime_put_sync_autosuspend(dev);
c98429297d8b25a Tomer Maimon 2019-09-12  85  
c98429297d8b25a Tomer Maimon 2019-09-12  86  	return retval || !wait ? retval : -EIO;
c98429297d8b25a Tomer Maimon 2019-09-12 @87  }
c98429297d8b25a Tomer Maimon 2019-09-12  88  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
