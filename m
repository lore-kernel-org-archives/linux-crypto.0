Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1E1EB5CB
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744300599; cv=none; b=hSMGTPEzPC0bpnv8GDox1l9/ByzjvcdtnDkgMvOyeydjaAp4UPj0fgMONG09UtxBs1q2FmkVto1hYPWfkikqJ6SwiwxXi2dHSedCNPDQI/TfP8kTpMEM7+xKy5e4TlQt36rKzYdHeYbBgmpu/CQKTzWkORmBX9rVI5rwtiwgCdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744300599; c=relaxed/simple;
	bh=kQXYAVIwetUyVwvHQAZ8MBfV2JpMeqQiDyjEkLidttY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wz2PKKpfbkXny/lOWNtAQOuZqPmn+EqHrjtv5y72PPH8wDpYPRlY3FTMNCAIzGAO51zp4J318gnda3viAu3q0KV6o7GWpaN1+7pu4rXoSHm89F09HKhsSIJKgOWIwWD8KkrbM8HyDa7b2nOF1jzoVFce97F6iBaPS47O7FLsyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anm+iImp; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anm+iImp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744300596; x=1775836596;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kQXYAVIwetUyVwvHQAZ8MBfV2JpMeqQiDyjEkLidttY=;
  b=anm+iImpKq7xk/5wnOYCQtoqmOQnj1pTyPBt81H8QDJqNPjdNX9RSUkl
   +pyeyHx2Gn5RD7jdfGqdz7nPbE++LAliFg9pi4S8ZK8BOrVFwk6KnOJIF
   18GECcG/FhI0n3k1LcQ/dKli+B9FhuKPO1hLkx+UBr/BGpsvr4rFbHKQD
   T4q3SfIn3WGXt6OUVbOlmGktXcClXmPVK64df61LEu+2FFmAlJ0vgWi/D
   zsCV85ovBsXXt+98sslHlbTwU+kmjRn1J0/FtpM5FiCAW94PWnnxTrx17
   oASdI+TumTE74e3bB61Ibtto1kdwnouXYMPYNWw3q29crZawrokJQN8WX
   Q==;
X-CSE-ConnectionGUID: 6Q7rm39MSMiY34+AH8LOwQ==
X-CSE-MsgGUID: GX0XdfEwRwS5rQmRBGqXrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56010831"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56010831"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:56:36 -0700
X-CSE-ConnectionGUID: cYuTcStpSoexM0h44TRRmg==
X-CSE-MsgGUID: GXm97F4OR8+Hd6GdEbBnOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="133671636"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Apr 2025 08:56:31 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u2uGT-000AFT-27;
	Thu, 10 Apr 2025 15:56:29 +0000
Date: Thu, 10 Apr 2025 23:55:59 +0800
From: kernel test robot <lkp@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Olivia Mackall <olivia@selenic.com>,
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
Message-ID: <202504102028.H0evWtkl-lkp@intel.com>
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
config: arm-randconfig-001-20250410 (https://download.01.org/0day-ci/archive/20250410/202504102028.H0evWtkl-lkp@intel.com/config)
compiler: clang version 19.1.1 (https://github.com/llvm/llvm-project d401987fe349a87c53fe25829215b080b70c0c1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250410/202504102028.H0evWtkl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504102028.H0evWtkl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/char/hw_random/npcm-rng.c:57:54: error: expected ';' at end of declaration
      57 |         struct device *dev = (struct device *)priv->rng.priv
         |                                                             ^
         |                                                             ;
   1 error generated.


vim +57 drivers/char/hw_random/npcm-rng.c

    53	
    54	static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
    55	{
    56		struct npcm_rng *priv = to_npcm_rng(rng);
  > 57		struct device *dev = (struct device *)priv->rng.priv
    58		int retval = 0;
    59		int ready;
    60	
    61		pm_runtime_get_sync(dev);
    62	
    63		while (max) {
    64			if (wait) {
    65				if (readb_poll_timeout(priv->base + NPCM_RNGCS_REG,
    66						       ready,
    67						       ready & NPCM_RNG_DATA_VALID,
    68						       NPCM_RNG_POLL_USEC,
    69						       NPCM_RNG_TIMEOUT_USEC))
    70					break;
    71			} else {
    72				if ((readb(priv->base + NPCM_RNGCS_REG) &
    73				    NPCM_RNG_DATA_VALID) == 0)
    74					break;
    75			}
    76	
    77			*(u8 *)buf = readb(priv->base + NPCM_RNGD_REG);
    78			retval++;
    79			buf++;
    80			max--;
    81		}
    82	
    83		pm_runtime_mark_last_busy(dev);
    84		pm_runtime_put_sync_autosuspend(dev);
    85	
    86		return retval || !wait ? retval : -EIO;
    87	}
    88	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
