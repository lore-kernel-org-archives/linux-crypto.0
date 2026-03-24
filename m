Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0542A39478D;
	Tue, 24 Mar 2026 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774382055; cv=none; b=SVZO0tUtnEM9JQu/QE9Gu6324WZ0HiJt+x6BtBpnxZiGmY3kFq9jl+CNh+cB1mVO0EBA6PjUloVMz67DzoA9kHGWGl5YqY0rfeMKbH6WB63FwNsbBKkYTEEMfS2erQSsHGeZUx3t+M0MraieL2+glgnsHz0TNRBCa9Tagkvvnpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774382055; c=relaxed/simple;
	bh=UkMGwqq22iwoXvq8WTHO2sEi1l7YHym5mkOuSu27Ctw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYfIXepnVWLbThxrbN/cwSLy8OIp74SNUo5fCwWmBFll3kUEJca2297q1L7U0D1FZ2EaSXPi1+UJgKc96AMgbC8csXQIp2IJEIezQSBs3L0k2c35xdWry8lSq4iS7tYFWbQQUEN03GJ3Nruk2ojncO0hpiNoL7L84C5mI7w9eGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUhFdOaR; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUhFdOaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774382054; x=1805918054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UkMGwqq22iwoXvq8WTHO2sEi1l7YHym5mkOuSu27Ctw=;
  b=MUhFdOaR6u7sdh8atAvXECJKgEzLaFGsZscEkI63Sp9kemXs0P5Sgh3C
   WGfEya5CZUh9+TmJKEHr/tCta5QUvXE9bgKKwBknJPPEj2kplOZJCM55j
   je+ze/3rTDoq0/eDWMOp8661/5Uehx08gT1zictdvhBBX7/udRbODtODL
   AheKg3dPujOrLPgFIPkTgh3rH1oB/uWdllCOplAq7UklcHPWAClulTqRL
   gG1ywe23ldwghHVIct6Pgwx/67g3a9x+uprcHizPp1zCNzNgF7jCHC3+C
   UuXo6k3rQE8nI8pYzLYwDpwxqjzKhRHXAe0BA4BEIvKgeoOrKmIJjM8i4
   g==;
X-CSE-ConnectionGUID: zoOPZMp6QqWmJ0kvLyP62g==
X-CSE-MsgGUID: Rg6NgN5vSPWesmIdAJSEMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75381624"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75381624"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 12:54:09 -0700
X-CSE-ConnectionGUID: xHKOCFOHQn6/6LoPjrqBGA==
X-CSE-MsgGUID: Sfj9w7JSTAS9x8PTYS+lPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="248027229"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 24 Mar 2026 12:54:07 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w57pE-000000005N3-38Le;
	Tue, 24 Mar 2026 19:54:04 +0000
Date: Wed, 25 Mar 2026 03:53:51 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2] crypto: cryptomgr - Select algorithm types only when
 CRYPTO_SELFTESTS
Message-ID: <202603250302.MimbBMTL-lkp@intel.com>
References: <20260324050123.9494-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324050123.9494-1-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build errors:

[auto build test ERROR on f9bbd547cfb98b1c5e535aab9b0671a2ff22453a]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/crypto-cryptomgr-Select-algorithm-types-only-when-CRYPTO_SELFTESTS/20260324-131705
base:   f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
patch link:    https://lore.kernel.org/r/20260324050123.9494-1-ebiggers%40kernel.org
patch subject: [PATCH v2] crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS
config: sparc-randconfig-002-20260325 (https://download.01.org/0day-ci/archive/20260325/202603250302.MimbBMTL-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260325/202603250302.MimbBMTL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603250302.MimbBMTL-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc-linux-ld: drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.o: in function `sun8i_ce_unregister_algs':
>> sun8i-ce-core.c:(.text+0x19c): undefined reference to `crypto_unregister_rng'
   sparc-linux-ld: drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.o: in function `sun8i_ce_register_algs':
>> sun8i-ce-core.c:(.text+0x654): undefined reference to `crypto_register_rng'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
