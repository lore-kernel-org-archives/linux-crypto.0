Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55CC1A23BE;
	Sat, 28 Jun 2025 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751123737; cv=none; b=nEySpiQDEipQEZEAFN52hSdKY0k2HADCbZGQQdrVbU1ZeDHqPPxXIrk9eIvez1ANHeqRiH4Ba+jqfFIaTD+YIagMNJHQBpJTGpTwrVTViMJMRtlu+ORf3U1X4HwiaFoaqlFbbatuSTZaZjsZqMA8pHzlVkyiIJCcjA49jq2X4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751123737; c=relaxed/simple;
	bh=KdAezppgQ4Rh9Mn4QZ7Pfd2XJYyK3e0m9fFebe1kEkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/eomwB7jBQUHbCS93jnHcW61X5BnIoDFxeXsuvO79c0BZmHaj2R3sXrOKDeKH4JM37kuoJgF/KWg0bRJAUxR0N+dj8lETxsTJzNioK2xLqEFiXUPCCNiZ6u3uegKaI7Avn+P1jl5RxHE00E5wvTzF84nfvwE4B6krbIrHW0KJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H608KFXW; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H608KFXW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751123735; x=1782659735;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KdAezppgQ4Rh9Mn4QZ7Pfd2XJYyK3e0m9fFebe1kEkc=;
  b=H608KFXWvhfhfYzgfVnOJmZilXWcyKA6kXbezAvvsOxtrbr7IIiDQfFe
   LWF/efqb2dAUSC095lVR803ol5SItDfe3y9i0fqWnXn8AnEo7vvJMS6o/
   oTQwQIg8rHiQWT3htO44OY2L4C7d5PXbHOOLJMbu2+RHaRl1LLYNp3C8n
   +rWSh4GiAB7j5Iz831IXaV5C0gBBr87SvSKib63H/dPNYOiPj3mXFW8QA
   m9UfK9ZlcjzjuDCCpBpw5oODCjIIacfcjTsgShcmQoibN2EwN4H91eEcY
   6x1wQf2bgSIkhZdI3KPTe9Mq0sDOaqJQYerRFBGFOlhNv63O3AJe4Jlc2
   A==;
X-CSE-ConnectionGUID: J7mEWflWQj6jB+T5uQCnyg==
X-CSE-MsgGUID: NyFjwwaJTyeZQmZeNQFrJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11478"; a="64010961"
X-IronPort-AV: E=Sophos;i="6.16,273,1744095600"; 
   d="scan'208";a="64010961"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2025 08:15:34 -0700
X-CSE-ConnectionGUID: 5jv1ZLPETLOtX+oSb5jpwA==
X-CSE-MsgGUID: OVow9ORfRYefx0FCy3/rpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,273,1744095600"; 
   d="scan'208";a="157328041"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Jun 2025 08:15:32 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uVXH7-000X8I-2o;
	Sat, 28 Jun 2025 15:15:29 +0000
Date: Sat, 28 Jun 2025 23:14:41 +0800
From: kernel test robot <lkp@intel.com>
To: Jay Wang <wanjay@amazon.com>, stable@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	wanjay@amazon.com, Samuel Mendoza-Jonas <samjonas@amazon.com>,
	Elena Avila <ellavila@amazon.com>
Subject: Re: [PATCH 1/2] crypto: rng - Override drivers/char/random in FIPS
 mode
Message-ID: <202506282235.pPmU7tOj-lkp@intel.com>
References: <20250628042918.32253-2-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250628042918.32253-2-wanjay@amazon.com>

Hi Jay,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.16-rc3 next-20250627]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jay-Wang/crypto-rng-Override-drivers-char-random-in-FIPS-mode/20250628-123147
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250628042918.32253-2-wanjay%40amazon.com
patch subject: [PATCH 1/2] crypto: rng - Override drivers/char/random in FIPS mode
config: x86_64-buildonly-randconfig-001-20250628 (https://download.01.org/0day-ci/archive/20250628/202506282235.pPmU7tOj-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250628/202506282235.pPmU7tOj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506282235.pPmU7tOj-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> crypto/rng.c:272:21: error: variable 'crypto_devrandom_rng' has initializer but incomplete type
     272 | static const struct random_extrng crypto_devrandom_rng = {
         |                     ^~~~~~~~~~~~~
>> crypto/rng.c:273:10: error: 'const struct random_extrng' has no member named 'extrng_read'
     273 |         .extrng_read = crypto_devrandom_read,
         |          ^~~~~~~~~~~
>> crypto/rng.c:273:24: warning: excess elements in struct initializer
     273 |         .extrng_read = crypto_devrandom_read,
         |                        ^~~~~~~~~~~~~~~~~~~~~
   crypto/rng.c:273:24: note: (near initialization for 'crypto_devrandom_rng')
>> crypto/rng.c:274:10: error: 'const struct random_extrng' has no member named 'owner'
     274 |         .owner = THIS_MODULE,
         |          ^~~~~
   In file included from include/linux/printk.h:6,
                    from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:103,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/linux/list.h:11,
                    from include/linux/swait.h:5,
                    from include/linux/completion.h:12,
                    from include/linux/crypto.h:15,
                    from include/crypto/algapi.h:13,
                    from include/crypto/internal/rng.h:12,
                    from crypto/rng.c:11:
   include/linux/init.h:182:21: warning: excess elements in struct initializer
     182 | #define THIS_MODULE ((struct module *)0)
         |                     ^
   crypto/rng.c:274:18: note: in expansion of macro 'THIS_MODULE'
     274 |         .owner = THIS_MODULE,
         |                  ^~~~~~~~~~~
   include/linux/init.h:182:21: note: (near initialization for 'crypto_devrandom_rng')
     182 | #define THIS_MODULE ((struct module *)0)
         |                     ^
   crypto/rng.c:274:18: note: in expansion of macro 'THIS_MODULE'
     274 |         .owner = THIS_MODULE,
         |                  ^~~~~~~~~~~
   crypto/rng.c: In function 'crypto_rng_init':
>> crypto/rng.c:280:17: error: implicit declaration of function 'random_register_extrng'; did you mean 'crypto_register_rng'? [-Werror=implicit-function-declaration]
     280 |                 random_register_extrng(&crypto_devrandom_rng);
         |                 ^~~~~~~~~~~~~~~~~~~~~~
         |                 crypto_register_rng
   crypto/rng.c: In function 'crypto_rng_exit':
>> crypto/rng.c:286:9: error: implicit declaration of function 'random_unregister_extrng'; did you mean 'crypto_unregister_rng'? [-Werror=implicit-function-declaration]
     286 |         random_unregister_extrng();
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
         |         crypto_unregister_rng
   crypto/rng.c: At top level:
>> crypto/rng.c:272:35: error: storage size of 'crypto_devrandom_rng' isn't known
     272 | static const struct random_extrng crypto_devrandom_rng = {
         |                                   ^~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/crypto_devrandom_rng +272 crypto/rng.c

   271	
 > 272	static const struct random_extrng crypto_devrandom_rng = {
 > 273		.extrng_read = crypto_devrandom_read,
 > 274		.owner = THIS_MODULE,
   275	};
   276	
   277	static int __init crypto_rng_init(void)
   278	{
   279		if (fips_enabled)
 > 280			random_register_extrng(&crypto_devrandom_rng);
   281		return 0;
   282	}
   283	
   284	static void __exit crypto_rng_exit(void)
   285	{
 > 286		random_unregister_extrng();
   287	}
   288	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
