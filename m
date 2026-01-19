Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C89296BD5;
	Mon, 19 Jan 2026 20:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854739; cv=none; b=WUYaVGUOZjGmsGUTaI5GzkosHgZN50N8Gi+jyjtytr8Sp7dI6gf9/bzm1mLVanr+OtYLHngwA1W8I79JmmBEvNP+ii2t/JZP2AK+YD+yNXXL99iexZzEd2n+E/viGSP4m3/MPZfsve/QSxx6ULmG3bczyLRGZZHzUZlzfVG0RAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854739; c=relaxed/simple;
	bh=9G3X5L4dQDNcCE4GzJviRia/VpS773SPyclyUMXM4MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t64Kl9aZ8F+n8MIt9yhIgXmexcWcdI9FQxICZy6vg5uJYhBAIHT5Jl4XFWLO99p3vX9DVYgX0bI9IiYb4ovtKSLo6TE3IsdaII+ooNPuNPDAX6EaSK/CuUXkazoHAKcy0eUkd978okK9LwLKsdBIvHAyOrXrsfSMx/Sa6VaIYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InLN80mr; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InLN80mr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768854739; x=1800390739;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9G3X5L4dQDNcCE4GzJviRia/VpS773SPyclyUMXM4MM=;
  b=InLN80mrzAlb+64u9m2tIgEQoTx6cwzB7f5EhcQRVHTediOazDpOsG7E
   AZ+0ou41wKlw5K5uqqLL916wtbMPEiGyYTzKfC8bYFzdLgTkQOnHHWWFN
   oDSyL6dseVYvjeghc0+O6ZltjIeWjSJfsV4DeZ/AS5MA23G6DIM3n7BYh
   wa/gO2eF4vWkabauIkCV54gHEVQkh2D2p9s23fM5TTO9x1y+bD5QlkfB0
   rqcCKdfTw0YCi1isgGqwujHolkVwQ2gIzNzXkQInd11h+EdJvpI1vwDu9
   m4wK6tPoaR4wf7AKujbEElDvnfDfz9tN4K9QRNM1rhbM0OMREsX9c28LU
   A==;
X-CSE-ConnectionGUID: DSJrmqW6SoOx+wlme/A77A==
X-CSE-MsgGUID: N3+WqZiaSAKK61eFwmfYzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="70039948"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="70039948"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 12:32:18 -0800
X-CSE-ConnectionGUID: vu3zgAhNRXO37stiCH/kcw==
X-CSE-MsgGUID: TpkMSGVFQ7qPH8nEsk/OpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="237215450"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Jan 2026 12:32:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhvv3-00000000OHd-00ic;
	Mon, 19 Jan 2026 20:32:13 +0000
Date: Tue, 20 Jan 2026 04:31:28 +0800
From: kernel test robot <lkp@intel.com>
To: Holger Dengler <dengler@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	David Laight <david.laight.linux@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <202601200403.mo4FMAVa-lkp@intel.com>
References: <20260119121210.2662-2-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119121210.2662-2-dengler@linux.ibm.com>

Hi Holger,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 47753e09a15d9fd7cdf114550510f4f2af9333ec]

url:    https://github.com/intel-lab-lkp/linux/commits/Holger-Dengler/lib-crypto-tests-Add-KUnit-tests-for-AES/20260119-201615
base:   47753e09a15d9fd7cdf114550510f4f2af9333ec
patch link:    https://lore.kernel.org/r/20260119121210.2662-2-dengler%40linux.ibm.com
patch subject: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
config: xtensa-randconfig-r133-20260120 (https://download.01.org/0day-ci/archive/20260120/202601200403.mo4FMAVa-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601200403.mo4FMAVa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601200403.mo4FMAVa-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   lib/crypto/tests/aes_kunit.c: note: in included file (through arch/xtensa/include/asm/atomic.h, include/linux/atomic.h, include/linux/jump_label.h, ...):
   arch/xtensa/include/asm/processor.h:105:2: sparse: sparse: Unsupported xtensa ABI
   arch/xtensa/include/asm/processor.h:135:2: sparse: sparse: Unsupported Xtensa ABI
   lib/crypto/tests/aes_kunit.c:149:1: sparse: sparse: bad integer constant expression
   lib/crypto/tests/aes_kunit.c:149:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
   lib/crypto/tests/aes_kunit.c:150:1: sparse: sparse: bad integer constant expression
   lib/crypto/tests/aes_kunit.c:150:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
   lib/crypto/tests/aes_kunit.c:150:1: sparse: sparse: bad integer constant expression
   lib/crypto/tests/aes_kunit.c:150:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
>> lib/crypto/tests/aes_kunit.c:35:26: sparse: sparse: incompatible types in conditional expression (incompatible argument 1 (different base types)):
   lib/crypto/tests/aes_kunit.c:35:26: sparse:    void ( * )( ... )
   lib/crypto/tests/aes_kunit.c:35:26: sparse:    void ( * )( ... )
>> lib/crypto/tests/aes_kunit.c:35:26: sparse: sparse: incompatible types in conditional expression (incompatible argument 1 (different base types)):
   lib/crypto/tests/aes_kunit.c:35:26: sparse:    void ( * )( ... )
   lib/crypto/tests/aes_kunit.c:35:26: sparse:    void ( * )( ... )

vim +35 lib/crypto/tests/aes_kunit.c

    28	
    29	static __always_inline u64 time_aes_op(bool encrypt, struct aes_key *aes_key,
    30					       u8 *out, const u8 *in)
    31	{
    32		void (*aes_op)(const struct aes_key *key, u8 *out, const u8 *in);
    33		u64 t;
    34	
  > 35		aes_op = encrypt ? &aes_encrypt : &aes_decrypt;
    36	
    37		preempt_disable();
    38		t = ktime_get_ns();
    39		aes_op(aes_key, out, in);
    40		t = ktime_get_ns() - t;
    41		preempt_enable();
    42	
    43		return t;
    44	}
    45	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
