Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE3326E6F9;
	Mon, 19 Jan 2026 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840862; cv=none; b=mALFtr0eCZE3NaAphIyekc3VUUlN6F8i2H6bqS3PyKbwtKQeBlcplRbYJMxmmJ8l6tTW3RQikvpvJFU6SfGBMx8jMzIsBWLtvXBu5csjFhV5rLrWmklDl6HZHyo6L2+PalB05/nQZU62ojQDBOTWqX1zEepeI/UG1UyQVI4PkME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840862; c=relaxed/simple;
	bh=gLTASZSO6F0d0fNNC68C0I6+gNqb9dwQHiOxD1xPiIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0JVNCABV2BgJpJ2qyrUZlHVg290vhScid5PUpOb75HFbgvhH5rM9XpPQmxLDlLJv6Tmn+pa3ettn5uwI84NlRUZfI75RZnGNa/WLmKN9lVoBcDcqGlcYA5azpawVGmendJHfIQjOQqpx8iWSeIbJgd6iWR6E3JXkIIFr7Cnxy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VlVBXBTj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VlVBXBTj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768840860; x=1800376860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gLTASZSO6F0d0fNNC68C0I6+gNqb9dwQHiOxD1xPiIE=;
  b=VlVBXBTjFa4KIH2WOD0MgENtZx3T1oL27xLJ1nUeWKvuolSoqiqssszL
   h2yCpfBZ0qNnItx4+HJXIJzUz7Kdu6LkqHQ3dXgOpzOWeW3Hu7ZhAyLLz
   CAHPTcVDWOioQPncH/cEwlexORGKsMvGNj/FWRIQhkyDF5XOPepEQGlqD
   A6fzqFRJ/CgcCQqcjgB9dT4eHYKq+x759hM8ixEijRujI/9U+DZ1K/LcL
   vcVgBo+Yhucdi0w4AzUwg+VtsDfsqLvMUD2UVvnWopI7RJCZIg8H3sLSX
   xm0xgUMHLuW5I5heVM+aUjq0lCNUuWMqohuqBW2xtW1mTH1YjnqKGfYM5
   w==;
X-CSE-ConnectionGUID: uVPWrWzlTV+xiEZOTt93nQ==
X-CSE-MsgGUID: KuLckc6nQVeGcQBdYm4krg==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81424929"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="81424929"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 08:41:00 -0800
X-CSE-ConnectionGUID: CjQz0uYgR1KuaIlJsW502g==
X-CSE-MsgGUID: VTKXT+oTQxCGqcmDve1opA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="210407414"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 19 Jan 2026 08:40:57 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhsJC-00000000O3h-3Za7;
	Mon, 19 Jan 2026 16:40:54 +0000
Date: Tue, 20 Jan 2026 00:39:59 +0800
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
Message-ID: <202601200047.d0uwB8zw-lkp@intel.com>
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260120/202601200047.d0uwB8zw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601200047.d0uwB8zw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601200047.d0uwB8zw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/kunit/assert.h:13,
                    from include/kunit/test.h:12,
                    from lib/crypto/tests/aes_kunit.c:2:
   lib/crypto/tests/aes_kunit.c: In function 'benchmark_aes':
>> lib/crypto/tests/aes_kunit.c:77:45: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
      77 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                                             ^
   include/linux/printk.h:484:33: note: in definition of macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/kunit/test.h:661:17: note: in expansion of macro 'printk'
     661 |                 printk(lvl fmt, ##__VA_ARGS__);                         \
         |                 ^~~~~~
   include/kunit/test.h:667:9: note: in expansion of macro 'kunit_log'
     667 |         kunit_log(lvl, test, KUNIT_SUBTEST_INDENT "# %s: " fmt,         \
         |         ^~~~~~~~~
   include/kunit/test.h:680:9: note: in expansion of macro 'kunit_printk'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:76:9: note: in expansion of macro 'kunit_info'
      76 |         kunit_info(test, "enc (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
         |         ^~~~~~~~~~
>> lib/crypto/tests/aes_kunit.c:77:45: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
      77 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                                             ^
   include/kunit/test.h:663:36: note: in definition of macro 'kunit_log'
     663 |                                  ##__VA_ARGS__);                        \
         |                                    ^~~~~~~~~~~
   include/kunit/test.h:680:9: note: in expansion of macro 'kunit_printk'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:76:9: note: in expansion of macro 'kunit_info'
      76 |         kunit_info(test, "enc (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
         |         ^~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:80:45: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
      80 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                                             ^
   include/linux/printk.h:484:33: note: in definition of macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/kunit/test.h:661:17: note: in expansion of macro 'printk'
     661 |                 printk(lvl fmt, ##__VA_ARGS__);                         \
         |                 ^~~~~~
   include/kunit/test.h:667:9: note: in expansion of macro 'kunit_log'
     667 |         kunit_log(lvl, test, KUNIT_SUBTEST_INDENT "# %s: " fmt,         \
         |         ^~~~~~~~~
   include/kunit/test.h:680:9: note: in expansion of macro 'kunit_printk'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:79:9: note: in expansion of macro 'kunit_info'
      79 |         kunit_info(test, "dec (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
         |         ^~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:80:45: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
      80 |                    div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
         |                                             ^
   include/kunit/test.h:663:36: note: in definition of macro 'kunit_log'
     663 |                                  ##__VA_ARGS__);                        \
         |                                    ^~~~~~~~~~~
   include/kunit/test.h:680:9: note: in expansion of macro 'kunit_printk'
     680 |         kunit_printk(KERN_INFO, test, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   lib/crypto/tests/aes_kunit.c:79:9: note: in expansion of macro 'kunit_info'
      79 |         kunit_info(test, "dec (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
         |         ^~~~~~~~~~


vim +77 lib/crypto/tests/aes_kunit.c

   > 2	#include <kunit/test.h>
     3	#include <linux/preempt.h>
     4	#include "aes-testvecs.h"
     5	
     6	static void test_aes(struct kunit *test, const struct aes_testvector *tv,
     7			     bool enc)
     8	{
     9		struct aes_key aes_key;
    10		u8 out[AES_BLOCK_SIZE];
    11		const u8 *input, *expect;
    12		int rc;
    13	
    14		rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
    15		KUNIT_ASSERT_EQ(test, 0, rc);
    16	
    17		if (enc) {
    18			input = tv->plain;
    19			expect = tv->cipher;
    20			aes_encrypt(&aes_key, out, input);
    21		} else {
    22			input = tv->cipher;
    23			expect = tv->plain;
    24			aes_decrypt(&aes_key, out, input);
    25		}
    26		KUNIT_ASSERT_MEMEQ(test, out, expect, sizeof(out));
    27	}
    28	
    29	static __always_inline u64 time_aes_op(bool encrypt, struct aes_key *aes_key,
    30					       u8 *out, const u8 *in)
    31	{
    32		void (*aes_op)(const struct aes_key *key, u8 *out, const u8 *in);
    33		u64 t;
    34	
    35		aes_op = encrypt ? &aes_encrypt : &aes_decrypt;
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
