Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A032D0D0;
	Mon, 19 Jan 2026 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768843447; cv=none; b=VsrBQ2+o8gsAYUQq+tjvaPQx5WOuodVCM3nxvTRF6eD+G/dbpboPI6WhH6Rea31HkVxV52eUnkgUq6hyLed4SpZW7zFvllKVdTrznsN5wZcm/+OEzVGj7TClaqtZeypwQr6D4mhGBUzcaauHHwcH0Dg+cFuKcKkMqEgSLHhKHts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768843447; c=relaxed/simple;
	bh=1df0VpdUTwSMoI3TN6wImnMNRzM8VltjZtdx5JBLJtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGDVTEl+/24MbRHH1jEXNzeh+EImXE5g9zLDm3XO1x5eKv7w4s7O4Nm3s1ybKN26F1p2gSk7ydun6VMRaKoeA4YxRHt6HA+Qw3vbMHf7yYKngYhiTmV4iV8ugeJ/GNjgdax7EnXLhw71LaA151hKofcRKXWbHoyYvvMXDlmTzn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XdVuYRgt; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XdVuYRgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768843444; x=1800379444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1df0VpdUTwSMoI3TN6wImnMNRzM8VltjZtdx5JBLJtQ=;
  b=XdVuYRgtanm5p6bNFDDotPw5G4Qql149/H5cIJrA5lwTznzVwpnjLAyu
   5UOpiabEB498FjhOFJT0V9g3x0qzgWnSNIlRayBWK2EADZv50EqUFpqDf
   vABQ557U2cOGysspohU+WBgqBIBLYklVDx70uDfgAxBsdTcPgRPiIw6+c
   pa4qznNfCqy2sMwjYVbCuWkPjCXQgTMY68Dn7fRU0K3nK0qyc2vW/7gwN
   ntUG2GDhsvrfU986axgR5yeMMcmtwkand7rN1YwjT/LnTIw+zu9SyZ04N
   QCMr38ojCp7PmrD+JX/uI0T4p9xWxi/D5BqCRO+d/6/NpPLv1bFLFlBb+
   Q==;
X-CSE-ConnectionGUID: dILNmgsiQTqnwOse8d9xaw==
X-CSE-MsgGUID: NaMJVOMjSpiM8uEgOtdDYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="80779097"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="80779097"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 09:24:01 -0800
X-CSE-ConnectionGUID: OrgH2IfzRxKLNS4d8+nPzw==
X-CSE-MsgGUID: +KaGwzElSaWoeHEaZvj32w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="205817693"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 19 Jan 2026 09:23:59 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhsyr-00000000O6v-0LG9;
	Mon, 19 Jan 2026 17:23:57 +0000
Date: Tue, 20 Jan 2026 01:22:59 +0800
From: kernel test robot <lkp@intel.com>
To: Holger Dengler <dengler@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	David Laight <david.laight.linux@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <202601200149.4hhdN1QQ-lkp@intel.com>
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
config: arm-randconfig-003-20260119 (https://download.01.org/0day-ci/archive/20260120/202601200149.4hhdN1QQ-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601200149.4hhdN1QQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601200149.4hhdN1QQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/crypto/tests/aes_kunit.c:77:31: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
      77 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
   include/kunit/test.h:680:39: note: expanded from macro 'kunit_info'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |                                              ^~~~~~~~~~~
   include/kunit/test.h:668:21: note: expanded from macro 'kunit_printk'
     668 |                   (test)->name, ##__VA_ARGS__)
         |                                   ^~~~~~~~~~~
   include/kunit/test.h:661:21: note: expanded from macro 'kunit_log'
     661 |                 printk(lvl fmt, ##__VA_ARGS__);                         \
         |                                   ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
>> lib/crypto/tests/aes_kunit.c:77:31: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
      77 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
   include/kunit/test.h:680:39: note: expanded from macro 'kunit_info'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |                                              ^~~~~~~~~~~
   include/kunit/test.h:668:21: note: expanded from macro 'kunit_printk'
     668 |                   (test)->name, ##__VA_ARGS__)
         |                                   ^~~~~~~~~~~
   include/kunit/test.h:663:8: note: expanded from macro 'kunit_log'
     663 |                                  ##__VA_ARGS__);                        \
         |                                    ^~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:80:31: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
      80 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
   include/kunit/test.h:680:39: note: expanded from macro 'kunit_info'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |                                              ^~~~~~~~~~~
   include/kunit/test.h:668:21: note: expanded from macro 'kunit_printk'
     668 |                   (test)->name, ##__VA_ARGS__)
         |                                   ^~~~~~~~~~~
   include/kunit/test.h:661:21: note: expanded from macro 'kunit_log'
     661 |                 printk(lvl fmt, ##__VA_ARGS__);                         \
         |                                   ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:80:31: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
      80 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
   include/kunit/test.h:680:39: note: expanded from macro 'kunit_info'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |                                              ^~~~~~~~~~~
   include/kunit/test.h:668:21: note: expanded from macro 'kunit_printk'
     668 |                   (test)->name, ##__VA_ARGS__)
         |                                   ^~~~~~~~~~~
   include/kunit/test.h:663:8: note: expanded from macro 'kunit_log'
     663 |                                  ##__VA_ARGS__);                        \
         |                                    ^~~~~~~~~~~
   4 warnings generated.


vim +77 lib/crypto/tests/aes_kunit.c

    45	
    46	static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
    47	{
    48		const size_t num_iters = 100;
    49		struct aes_key aes_key;
    50		u8 out[AES_BLOCK_SIZE];
    51		u64 t, t_enc, t_dec;
    52		int rc;
    53	
    54		if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
    55			kunit_skip(test, "not enabled");
    56	
    57		rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
    58		KUNIT_ASSERT_EQ(test, 0, rc);
    59	
    60		/* warm-up */
    61		for (size_t i = 0; i < num_iters; i++) {
    62			aes_encrypt(&aes_key, out, tv->plain);
    63			aes_decrypt(&aes_key, out, tv->cipher);
    64		}
    65	
    66		t_enc = NSEC_PER_SEC;
    67		t_dec = NSEC_PER_SEC;
    68		for (size_t i = 0; i < num_iters; i++) {
    69			t = time_aes_op(true, &aes_key, out, tv->plain);
    70			t_enc = MIN_T(u64, t, t_enc);
    71	
    72			t = time_aes_op(false, &aes_key, out, tv->cipher);
    73			t_dec = MIN_T(u64, t, t_dec);
    74		}
    75	
    76		kunit_info(test, "enc (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
  > 77			   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
    78				     (t_enc ?: 1)));
    79		kunit_info(test, "dec (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
    80			   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
    81				     (t_dec ?: 1)));
    82	}
    83	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
