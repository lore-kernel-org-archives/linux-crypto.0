Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB07A41;
	Fri, 16 Jan 2026 00:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523189; cv=none; b=aFDiLklezCU1GAN09PF7/i9za2vgY7cX5kuGo8YSTaAIh/Zos+RqJF3h39R5p/K/eTS+zGhx+WyxEKYqQnDx1H9grAm3+XlVNT+aeDBBo5DEnVwUsYPNA8BQzORebPQqKP0kSF+IQhQquFiTbhysNixLhnjwx+QP/YS75x4r7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523189; c=relaxed/simple;
	bh=YbWZSNBq8yxIaNI4r+vfvwTWe4SVmWkoH5Q+Z8HUnqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu8NbAGCte2r/1/ehPgGDty9uw1abws2AczPplTQpAlCOE2NHgMRo0hWD9kVfNmxlwD+Tw45KcM3cRSz7SWNUIRx5u89I6H2krq0a64o70j3Zotttn/ztd+K6rHPffHeeR6b38fEKBzip0cKDayQ32BZkVd+crUwH0I0ZbZAdgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VcydsAkJ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VcydsAkJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768523188; x=1800059188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YbWZSNBq8yxIaNI4r+vfvwTWe4SVmWkoH5Q+Z8HUnqY=;
  b=VcydsAkJM5w5PemWTC+uw2+/QTsVfqF+PbYmUuoFPTqMQ2gCvzZPqvrs
   /WkvVmXD49MEmDOKCXbpQ9lstTEOMt1N/JXouluQi3M97Py6bnn2iuVw1
   xHLUERnht/x2jR/URhAsC+dNXrvywXBAuG30mPJ0MJiznDoX0R0HW09jm
   2yMb70/tMpPpccv+1pleoM4hX4XoHr3HfvwPdIFYEFaTnsjsv1xJ6npEl
   kq0Nenw5cZs8qDxdFWBfos736aLLTQN3Yg+4ZeqjRIsChrV+8CLufdXDV
   zeNxO51zqCHIG8FDyOTP5IsnXsNG7qa3i7MdxIk8s3C/QAgpOXFQIR0Y0
   w==;
X-CSE-ConnectionGUID: MBOtPr3kS9yl//ftsOMvlw==
X-CSE-MsgGUID: cjXfT4LnSOGc5513Hc6sJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="87254844"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="87254844"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 16:26:27 -0800
X-CSE-ConnectionGUID: mX2zdz9tSlGiSMw1Q5fvCQ==
X-CSE-MsgGUID: p/jf6VUySmKqJumn6G5zDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="210128037"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 15 Jan 2026 16:26:24 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgXfR-00000000K9A-2vML;
	Fri, 16 Jan 2026 00:26:21 +0000
Date: Fri, 16 Jan 2026 08:25:57 +0800
From: kernel test robot <lkp@intel.com>
To: Holger Dengler <dengler@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <202601160822.yLaBf86R-lkp@intel.com>
References: <20260115183831.72010-2-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115183831.72010-2-dengler@linux.ibm.com>

Hi Holger,

kernel test robot noticed the following build errors:

[auto build test ERROR on 47753e09a15d9fd7cdf114550510f4f2af9333ec]

url:    https://github.com/intel-lab-lkp/linux/commits/Holger-Dengler/lib-crypto-tests-Add-KUnit-tests-for-AES/20260116-030041
base:   47753e09a15d9fd7cdf114550510f4f2af9333ec
patch link:    https://lore.kernel.org/r/20260115183831.72010-2-dengler%40linux.ibm.com
patch subject: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
config: hexagon-randconfig-002-20260116 (https://download.01.org/0day-ci/archive/20260116/202601160822.yLaBf86R-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160822.yLaBf86R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160822.yLaBf86R-lkp@intel.com/

All errors (new ones prefixed by >>):

>> lib/crypto/tests/aes_kunit.c:73:24: error: use of undeclared identifier 'SZ_1M'
      73 |                              (t_enc ?: 1) * SZ_1M));
         |                                             ^
>> lib/crypto/tests/aes_kunit.c:73:24: error: use of undeclared identifier 'SZ_1M'
   lib/crypto/tests/aes_kunit.c:80:24: error: use of undeclared identifier 'SZ_1M'
      80 |                              (t_dec ?: 1) * SZ_1M));
         |                                             ^
   lib/crypto/tests/aes_kunit.c:80:24: error: use of undeclared identifier 'SZ_1M'
   4 errors generated.


vim +/SZ_1M +73 lib/crypto/tests/aes_kunit.c

    27	
    28	static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
    29	{
    30		const size_t num_iters = 10000000;
    31		u8 out[AES_BLOCK_SIZE];
    32		struct aes_key aes_key;
    33		u64 t_enc, t_dec;
    34		int rc;
    35	
    36		if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
    37			kunit_skip(test, "not enabled");
    38	
    39		rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
    40		KUNIT_ASSERT_EQ(test, 0, rc);
    41	
    42		/* warm-up enc */
    43		for (size_t i = 0; i < 1000; i++)
    44			aes_encrypt(&aes_key, out, tv->plain);
    45	
    46		preempt_disable();
    47		t_enc = ktime_get_ns();
    48	
    49		for (size_t i = 0; i < num_iters; i++)
    50			aes_encrypt(&aes_key, out, tv->plain);
    51	
    52		t_enc = ktime_get_ns() - t_enc;
    53		preempt_enable();
    54	
    55		/* warm-up dec */
    56		for (size_t i = 0; i < 1000; i++)
    57			aes_decrypt(&aes_key, out, tv->cipher);
    58	
    59		preempt_disable();
    60		t_dec = ktime_get_ns();
    61	
    62		for (size_t i = 0; i < num_iters; i++)
    63			aes_decrypt(&aes_key, out, tv->cipher);
    64	
    65		t_dec = ktime_get_ns() - t_dec;
    66		preempt_enable();
    67	
    68		kunit_info(test, "enc (iter. %zu, duration %lluns)",
    69			   num_iters, t_enc);
    70		kunit_info(test, "enc (len=%zu): %llu MB/s",
    71			   (size_t)AES_BLOCK_SIZE,
    72			   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
  > 73				     (t_enc ?: 1) * SZ_1M));
    74	
    75		kunit_info(test, "dec (iter. %zu, duration %lluns)",
    76			   num_iters, t_dec);
    77		kunit_info(test, "dec (len=%zu): %llu MB/s",
    78			   (size_t)AES_BLOCK_SIZE,
    79			   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
    80				     (t_dec ?: 1) * SZ_1M));
    81	}
    82	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
