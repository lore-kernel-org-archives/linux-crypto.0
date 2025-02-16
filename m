Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23103149E13
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 09:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739697531; cv=none; b=ryxdQBXmZXku2rlGXHXOQlXwDHcAUk0zXeURGmivTF66SG1yCuqRVuUC8VnscJ9P4wOhGzKBTOgepPLRoigodDP+2bIR8H342aBIZfYUky5NOfFIoYZj3s60Z0mivL+YWiJxAWRIufqYGQojEqUf4Kj4bAwUAYbMEmlhzaOGzFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739697531; c=relaxed/simple;
	bh=Q/d1oWKeAa/iMoWlEbrQGHR28WIhOD7RviHiAmTg52w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f647yasKR+JSnYlC6WpoELiwEivCvAbTvRCkZkfwXn/bk7rq8xbeJrhb/tUZqLDBbdfKWXDaxVOP//iFgQw1PNGYCNcRNa3X7jl7+lnG9l0Mdj1A8+9k7wkfa/dMxF5YF3mld02y5gFUayfRDRuI8usvmqF/YOmpQ0TB6JgvOVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+L8gqV3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+L8gqV3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739697529; x=1771233529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q/d1oWKeAa/iMoWlEbrQGHR28WIhOD7RviHiAmTg52w=;
  b=C+L8gqV3VdMxHVTl4kpB7nxN9IBf3CuhWmSB/cBXuCNeVp0lfrjXUP8k
   ssJeAJuC/3/K+Kxtz+t7mZUkVIy6GcPFoO4xOnFoQYFTbxPFXPUsgwyd9
   RqKpCn8F11aYIgqKbVp2+uZI6s9t/ybYdWaIEnX+GA8NgscA8qj942erX
   7yrJ4fqJQIPplFm7rRTfsS6pem6Lm4OmvXHyVI5fcGZ1cKQAXro5Ejl6I
   O7qsHt8feqEmULWcTKLVQOTWayJtylnapTPLK4uO4G92gi0e0/ug5dqwe
   q3a8vmhYR0MdFHn8QP5WGrho5BWUjRRK45URqCX5m5FeHwZgqDEGPrjU7
   w==;
X-CSE-ConnectionGUID: Maew9t4MRvyJnJ4LunmjCg==
X-CSE-MsgGUID: kpLkz/7yRUyqa9xBhEtXUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="44049696"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="44049696"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 01:18:48 -0800
X-CSE-ConnectionGUID: wXTb1YPiQ3O5wp0zhz5zpw==
X-CSE-MsgGUID: i4GOMJ+aRDWhNUrjscXV6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="113729943"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 16 Feb 2025 01:18:46 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tjanU-001Bmt-1N;
	Sun, 16 Feb 2025 09:18:44 +0000
Date: Sun, 16 Feb 2025 17:18:01 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 07/11] crypto: testmgr - Add multibuffer hash testing
Message-ID: <202502161754.b1Fy95ZS-lkp@intel.com>
References: <bb74b3f54e24308bef2def8d25ed917d13590921.1739674648.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb74b3f54e24308bef2def8d25ed917d13590921.1739674648.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on next-20250214]
[cannot apply to herbert-crypto-2.6/master brauner-vfs/vfs.all linus/master v6.14-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Only-save-callback-and-data-in-ahash_save_req/20250216-150941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/bb74b3f54e24308bef2def8d25ed917d13590921.1739674648.git.herbert%40gondor.apana.org.au
patch subject: [v2 PATCH 07/11] crypto: testmgr - Add multibuffer hash testing
config: arc-randconfig-001-20250216 (https://download.01.org/0day-ci/archive/20250216/202502161754.b1Fy95ZS-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250216/202502161754.b1Fy95ZS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502161754.b1Fy95ZS-lkp@intel.com/

All errors (new ones prefixed by >>):

   crypto/testmgr.c: In function '__alg_test_hash':
>> crypto/testmgr.c:2072:69: error: passing argument 3 of 'test_hash_vs_generic_impl' from incompatible pointer type [-Werror=incompatible-pointer-types]
    2072 |         err = test_hash_vs_generic_impl(generic_driver, maxkeysize, reqs,
         |                                                                     ^~~~
         |                                                                     |
         |                                                                     struct ahash_request **
   crypto/testmgr.c:1952:60: note: expected 'struct ahash_request *' but argument is of type 'struct ahash_request **'
    1952 |                                      struct ahash_request *req,
         |                                      ~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors


vim +/test_hash_vs_generic_impl +2072 crypto/testmgr.c

  1993	
  1994	static int __alg_test_hash(const struct hash_testvec *vecs,
  1995				   unsigned int num_vecs, const char *driver,
  1996				   u32 type, u32 mask,
  1997				   const char *generic_driver, unsigned int maxkeysize)
  1998	{
  1999		struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS] = {};
  2000		struct crypto_ahash *atfm = NULL;
  2001		struct crypto_shash *stfm = NULL;
  2002		struct shash_desc *desc = NULL;
  2003		struct test_sglist *tsgl = NULL;
  2004		u8 *hashstate = NULL;
  2005		unsigned int statesize;
  2006		unsigned int i;
  2007		int err;
  2008	
  2009		/*
  2010		 * Always test the ahash API.  This works regardless of whether the
  2011		 * algorithm is implemented as ahash or shash.
  2012		 */
  2013	
  2014		atfm = crypto_alloc_ahash(driver, type, mask);
  2015		if (IS_ERR(atfm)) {
  2016			if (PTR_ERR(atfm) == -ENOENT)
  2017				return 0;
  2018			pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
  2019			       driver, PTR_ERR(atfm));
  2020			return PTR_ERR(atfm);
  2021		}
  2022		driver = crypto_ahash_driver_name(atfm);
  2023	
  2024		for (i = 0; i < HASH_TEST_MAX_MB_MSGS; i++) {
  2025			reqs[i] = ahash_request_alloc(atfm, GFP_KERNEL);
  2026			if (!reqs[i]) {
  2027				pr_err("alg: hash: failed to allocate request for %s\n",
  2028				       driver);
  2029				err = -ENOMEM;
  2030				goto out;
  2031			}
  2032		}
  2033	
  2034		/*
  2035		 * If available also test the shash API, to cover corner cases that may
  2036		 * be missed by testing the ahash API only.
  2037		 */
  2038		err = alloc_shash(driver, type, mask, &stfm, &desc);
  2039		if (err)
  2040			goto out;
  2041	
  2042		tsgl = kmalloc(sizeof(*tsgl), GFP_KERNEL);
  2043		if (!tsgl || init_test_sglist(tsgl) != 0) {
  2044			pr_err("alg: hash: failed to allocate test buffers for %s\n",
  2045			       driver);
  2046			kfree(tsgl);
  2047			tsgl = NULL;
  2048			err = -ENOMEM;
  2049			goto out;
  2050		}
  2051	
  2052		statesize = crypto_ahash_statesize(atfm);
  2053		if (stfm)
  2054			statesize = max(statesize, crypto_shash_statesize(stfm));
  2055		hashstate = kmalloc(statesize + TESTMGR_POISON_LEN, GFP_KERNEL);
  2056		if (!hashstate) {
  2057			pr_err("alg: hash: failed to allocate hash state buffer for %s\n",
  2058			       driver);
  2059			err = -ENOMEM;
  2060			goto out;
  2061		}
  2062	
  2063		for (i = 0; i < num_vecs; i++) {
  2064			if (fips_enabled && vecs[i].fips_skip)
  2065				continue;
  2066	
  2067			err = test_hash_vec(&vecs[i], i, reqs, desc, tsgl, hashstate);
  2068			if (err)
  2069				goto out;
  2070			cond_resched();
  2071		}
> 2072		err = test_hash_vs_generic_impl(generic_driver, maxkeysize, reqs,
  2073						desc, tsgl, hashstate);
  2074	out:
  2075		kfree(hashstate);
  2076		if (tsgl) {
  2077			destroy_test_sglist(tsgl);
  2078			kfree(tsgl);
  2079		}
  2080		kfree(desc);
  2081		crypto_free_shash(stfm);
  2082		if (reqs[0]) {
  2083			ahash_request_set_callback(reqs[0], 0, NULL, NULL);
  2084			for (i = 1; i < HASH_TEST_MAX_MB_MSGS && reqs[i]; i++)
  2085				ahash_request_chain(reqs[i], reqs[0]);
  2086			ahash_request_free(reqs[0]);
  2087		}
  2088		crypto_free_ahash(atfm);
  2089		return err;
  2090	}
  2091	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
