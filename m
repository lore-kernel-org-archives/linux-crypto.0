Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43C23BD01;
	Fri, 10 Oct 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760122337; cv=none; b=CkvVrizBA7O8yRiWSFNu50Xn9Wt+pd+Mj4xJbfrSpP7CjGfaPN9wEe5URtdpFQBUF6XYM+B4XkUvA4E0pjYfGfD6PiUyGPctV9NjDSw/qbpBtUNmBTGQ3pTwTSS+QbH56eXaU/dtWthyNr6RKBo8A3QrUIyIC1Ce03iluBd885Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760122337; c=relaxed/simple;
	bh=7cw4jqDvi9CcszI/Tpt1T8nehrBpthSbcfCNKRKBQ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojz2jOvA80pSQEzVhP/NToD78ZihZRRpFojyk/DsOMVyO84Z30UhDo5NBKzJPKYR/BvxAzPdg5z8kCLVUacooHbEBsfI89+i01vSF386pWXi89uDyuYzGMuHmUjT7obVlWBtRo21ZCo5nZrrCO7b1pefUry8jfSdpK/VMxrDGYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jk/jwqOq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jk/jwqOq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760122336; x=1791658336;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7cw4jqDvi9CcszI/Tpt1T8nehrBpthSbcfCNKRKBQ/o=;
  b=jk/jwqOqdm28MaNROkr700zI2vEIlT/lM5zSCB3D+i9lL2NH9WoHqrQk
   jgZfkN28/KBlZ8yx9vgkLYSJKxUl0SztKiGEBij4R+6fX9M6knvYj8o6o
   eT1FFxPPMG7qvpD5PrQ3JPM4OGp1ubsPW1DiIgS6w0Rt70FCvNZAWqXXs
   Hmp+WKHgVwjfglvBRv0fcvdq2jj6z6l9Hnu6etW2v5sSG/ZiYSdq+rL/I
   Q6wjrjOrrEbaMTuYfcBP1UyaUeQr0hAAlPRqPrhhLbszSNdCoNNsWuYJX
   CI8w/fx2hn/STh+EyrMSln+g2MytH34EuAn7xGvyKl4/gS5Sk5UZng5f6
   g==;
X-CSE-ConnectionGUID: hxGWgEe8TK+nO2VDtaNWQg==
X-CSE-MsgGUID: /syVsu/LSNqgyG4dCIDbPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62443196"
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="62443196"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 11:52:15 -0700
X-CSE-ConnectionGUID: /pobF2rZT/+U+MpeFjfwrQ==
X-CSE-MsgGUID: RcrkWcLWT9KsK32pklhu6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="181054932"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 10 Oct 2025 11:52:13 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7IDq-00034R-1w;
	Fri, 10 Oct 2025 18:52:10 +0000
Date: Sat, 11 Oct 2025 02:51:56 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Joachim Vandersmissen <git@jvdsn.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA
 algorithms
Message-ID: <202510110210.5FlCrJl7-lkp@intel.com>
References: <20251006172612.75240-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006172612.75240-1-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build errors:

[auto build test ERROR on e5f0a698b34ed76002dc5cff3804a61c80233a7a]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/lib-crypto-Add-FIPS-pre-operational-self-test-for-SHA-algorithms/20251010-085409
base:   e5f0a698b34ed76002dc5cff3804a61c80233a7a
patch link:    https://lore.kernel.org/r/20251006172612.75240-1-ebiggers%40kernel.org
patch subject: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA algorithms
config: s390-defconfig (https://download.01.org/0day-ci/archive/20251011/202510110210.5FlCrJl7-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110210.5FlCrJl7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110210.5FlCrJl7-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: fips_enabled
   >>> referenced by sha256.c
   >>>               arch/s390/purgatory/purgatory:(sha256_mod_init)
--
>> ld.lld: error: undefined symbol: hmac_sha256_usingrawkey
   >>> referenced by sha256.c
   >>>               arch/s390/purgatory/purgatory:(sha256_mod_init)
--
>> ld.lld: error: undefined symbol: panic
   >>> referenced by sha256.c
   >>>               arch/s390/purgatory/purgatory:(sha256_mod_init)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
