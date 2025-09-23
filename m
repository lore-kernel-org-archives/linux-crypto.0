Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EF22AE99;
	Tue, 23 Sep 2025 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758619289; cv=none; b=r00ttOOHluwoKzg/y7+QFVEXfgjiGVZQBJxEf2gy7WpBDq6EzP+lNotliJ1PDfJbdqAH1mpIHRB3TeC5Hr6mVMIZvbgar+guc8f75lX9Eu8IygN4ZXmndKQmk9DZzvb2uQ+Jczl2Dj5qVoky//ooyvFH+SPZLgg9XDuwUP2sVAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758619289; c=relaxed/simple;
	bh=bp+sUW3/VySg0r+uo4biT0MX4DtmWftriQRRDUg+x9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvPjUlWz2i6BvRbT0yW90jSCDwGenwYKS7ZLOwfieW+QW6c84KcyvAm4aOmlx8/HOM0u48jT0KKoKQGaGtukx4mK1gsMONHDfpUSZHhAWrxFFlhUA4lTp1S0Ub3oo/YmoHSLmPrYwBLwZ0qCWLtUfuLPu/JHUTxLeUp/fq8DfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0OviZWE; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0OviZWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758619287; x=1790155287;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bp+sUW3/VySg0r+uo4biT0MX4DtmWftriQRRDUg+x9c=;
  b=a0OviZWE/Xbp0o9OBlW9eqV296Q3OaHKumIW8anuCxVNvRc4Yck1hyFl
   vA3bf8SE5k3hD6jUT2VYHPFhLszBb/RHlh0oth4DR0THSKPPTsRT/fjnG
   P+cxZHvKVh3avKThVV/UtB9wSRtGM3Nd8+YsFDwHEP4fKMzy8ngqoNsVB
   64Fy3rHms3JtQfHZAgaDNNZT4+S6z1gmyLHDXNyF0uzee5tsUoOnBCjM6
   dmYViQwcUrhPjWCtxhqmSqHbyofZDHlAqzlquRq5B7bhte2tJzmOCxWKf
   nTxXAPmGluTGxakkt/6WkoZjQzhn36L3e6j+R6/7GO7ZDG2UWMbNY68wZ
   A==;
X-CSE-ConnectionGUID: IFV+ofI8Tei0nbmiXE9pOA==
X-CSE-MsgGUID: 3Ho+KrNlTkCIRgBOlXjnHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="86328865"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="86328865"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 02:21:27 -0700
X-CSE-ConnectionGUID: iJdzp6WtTpGB8sO1xzv26w==
X-CSE-MsgGUID: wPmYcF5hRwSNsVnsnF819g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="176304124"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 23 Sep 2025 02:21:23 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0zD1-0002xh-0D;
	Tue, 23 Sep 2025 09:21:19 +0000
Date: Tue, 23 Sep 2025 17:20:58 +0800
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
Message-ID: <202509231744.SGr3Dh19-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.17-rc7 next-20250922]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/crypto-caam-Add-check-for-kcalloc-in-test_len/20250922-235723
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250922155322.1825714-1-lgs201920130244%40gmail.com
patch subject: [PATCH v2] crypto: caam: Add check for kcalloc() in test_len()
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250923/202509231744.SGr3Dh19-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project cafc064fc7a96b3979a023ddae1da2b499d6c954)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509231744.SGr3Dh19-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509231744.SGr3Dh19-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from <built-in>:3:
   In file included from include/linux/compiler_types.h:171:
   include/linux/compiler-clang.h:28:9: warning: '__SANITIZE_ADDRESS__' macro redefined [-Wmacro-redefined]
      28 | #define __SANITIZE_ADDRESS__
         |         ^
   <built-in>:371:9: note: previous definition is here
     371 | #define __SANITIZE_ADDRESS__ 1
         |         ^
>> drivers/crypto/caam/caamrng.c:186:3: warning: void function 'test_len' should not return a value [-Wreturn-mismatch]
     186 |                 return -ENOMEM;
         |                 ^      ~~~~~~~
   2 warnings generated.


vim +/test_len +186 drivers/crypto/caam/caamrng.c

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
