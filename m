Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70396313E16;
	Tue, 23 Sep 2025 10:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624992; cv=none; b=sl/KsgzRLH3+n2+ZWV61jxdnRsMxIZs5VMmtSDZs5FPUm1WViiYQqEFoB1GP/ERv7C2g3YwjKri0TrAAb7dhjlRFosuj5jCxXZHDWgZgRebIu8jwJoVCkR0KaK7AVcZ+hMmDVL1TDTM7kRB7pCmOm582SGXmI0E/uxNUFSVEX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624992; c=relaxed/simple;
	bh=rZpX1cqpB/ZIey8M6xVk2BFhszygIMBGOCqDy8inSU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQQxSQ/vOgzKIJoqxlMBJhuyiHhKljwK7yBt0CBIO7Rs4STCRZ3NgcrXzsm50GGH9/I1eHklXV2Ie+jiKbg4qgfsQCp2XJJwnRWfhiRoit5vRy49Ea65dXqLEVkc4WjKAwFGqhicLlkBjWUugdtZR6RvH1oPExPHtQCQuyB7QbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gmhrueqC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gmhrueqC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758624990; x=1790160990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rZpX1cqpB/ZIey8M6xVk2BFhszygIMBGOCqDy8inSU8=;
  b=gmhrueqC4N+YxeSUXbXjKTCdBTwlOIGAaPpZyZ4XifrpKAYCrz0nfb2N
   lSGjLlaPOXSx8UQinPbb9keJa7EpFzHfkx+GwgxzDXPgIYSm9Fuwe3/i1
   3kGRqZW/D6eiQQWbRfzTVBQdi9JAl4YkSaXybHrGo4ylwbH3afvBNc/mr
   Xfbvb0xY85LCHGJUDDuMII/0ytv4rWl2J8B3hMBD4/TnLCuHvokX+b82o
   CIxtCnSTn5Auno/y8EN9GTlUsMCjo+c1zmfqxwHievcXwfggGNkQAdPzj
   cR7vy/wrfE8jDp/qFvOP8tvNtSuv8Svq2UQjt6N2RH3GtPvfOb/RJZYPR
   A==;
X-CSE-ConnectionGUID: AOVrKvbTTj2cnWL/UjJrBg==
X-CSE-MsgGUID: 52I4GKV4SUeKT5u8SgDDpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60118418"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="60118418"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 03:56:29 -0700
X-CSE-ConnectionGUID: d4pNVhNKRqqTzpQ3WvrWqA==
X-CSE-MsgGUID: dHmrTC5PRU+gRttYCgYMHw==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 23 Sep 2025 03:56:25 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v10h5-00032H-2B;
	Tue, 23 Sep 2025 10:56:23 +0000
Date: Tue, 23 Sep 2025 18:56:21 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Victoria Milhoan (b42089)" <vicki.milhoan@freescale.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Dan Douglass <dan.douglass@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Guangshuo Li <lgs201920130244@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam: Add check for kcalloc() in test_len()
Message-ID: <202509231807.ZFBBKMM4-lkp@intel.com>
References: <20250922155322.1825714-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922155322.1825714-1-lgs201920130244@gmail.com>

Hi Guangshuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.17-rc7 next-20250922]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/crypto-caam-Add-check-for-kcalloc-in-test_len/20250922-235723
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250922155322.1825714-1-lgs201920130244%40gmail.com
patch subject: [PATCH v2] crypto: caam: Add check for kcalloc() in test_len()
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20250923/202509231807.ZFBBKMM4-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509231807.ZFBBKMM4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509231807.ZFBBKMM4-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/caam/caamrng.c: In function 'test_len':
>> drivers/crypto/caam/caamrng.c:186:24: error: 'return' with a value, in function returning void [-Wreturn-mismatch]
     186 |                 return -ENOMEM;
         |                        ^
   drivers/crypto/caam/caamrng.c:176:20: note: declared here
     176 | static inline void test_len(struct hwrng *rng, size_t len, bool wait)
         |                    ^~~~~~~~


vim +/return +186 drivers/crypto/caam/caamrng.c

   174	
   175	#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_TEST
   176	static inline void test_len(struct hwrng *rng, size_t len, bool wait)
   177	{
   178		u8 *buf;
   179		int read_len;
   180		struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
   181		struct device *dev = ctx->ctrldev;
   182	
   183		buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
   184	
   185		if (!buf) {
 > 186			return -ENOMEM;
   187		}
   188		while (len > 0) {
   189			read_len = rng->read(rng, buf, len, wait);
   190	
   191			if (read_len < 0 || (read_len == 0 && wait)) {
   192				dev_err(dev, "RNG Read FAILED received %d bytes\n",
   193					read_len);
   194				kfree(buf);
   195				return;
   196			}
   197	
   198			print_hex_dump_debug("random bytes@: ",
   199				DUMP_PREFIX_ADDRESS, 16, 4,
   200				buf, read_len, 1);
   201	
   202			len = len - read_len;
   203		}
   204	
   205		kfree(buf);
   206	}
   207	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
