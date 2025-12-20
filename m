Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A909213AF2;
	Sat, 20 Dec 2025 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766244947; cv=none; b=dR/WOnVGBFePSjXp8MnN63j4u0qwyape4qtRLCzgMFJIq576CpGYMPV56MBq824l+OVODNiPt0L/a93GNVtnS+hDAaTXYNLnSZcOYHYuekYmYJqnLM2QUCAIREFzX4xZli5iyZqDiB2a1SPbRFwG7O8UeACQbGdLs9KS9cpsTUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766244947; c=relaxed/simple;
	bh=BV5nTbXeR1w7Bkj4hUzXcjjiqqHjudO0UFkY8C86vAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEXsiyRu/+SrbcCsSC+SoxwJ5Vhw8pMC32+Fv3e13xWYeaIbD7Xt4KFDVZjOYEOA16ORc9lvdE0sYTQoNY+sW22JSCBt0U0zSU/MMyP6c8CWO0t9skMXYJTff1ClXk6WsHpL1IqIrlb6CgSYkxZRDJO7IILSiJUbRVZxqoWwo98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5hE3YwC; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5hE3YwC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766244946; x=1797780946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BV5nTbXeR1w7Bkj4hUzXcjjiqqHjudO0UFkY8C86vAU=;
  b=d5hE3YwCqnQdvHOtYC6LKbVgOpvsiuU7/S8AzfsCkJ0R2vRYSEiXpYR6
   Zwdm7uEOjipiV0Ng1IfGzgKAiZidsGL0IHtVhemLQ1Bqn2xjXSCn9us3o
   /2zBZVBczdXzTP9J5m03YH2I+La62sBqy3XlWaxudx+Pa8l+m4I0rmH2N
   MLHUFRnBAU7nqGyyj1cFY/08vEq/XerVUb7j25R8k1z9DGtuFYMoPuXfS
   iqeGMD0bQyxiK57fN/rW6wc7DBVoaKfl3c9zb4YbmJojkLC0mA2APtsz7
   7wQOMr/i36QdI8NqFVO4xEayhRDPCrFt1tnCi0P3lszJambaAELoDvLaL
   Q==;
X-CSE-ConnectionGUID: ZYMP7s7vTbCJdwxhhLUTCg==
X-CSE-MsgGUID: jYJJ1OeyRdS3f2QHA2bDFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="79296948"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="79296948"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 07:35:45 -0800
X-CSE-ConnectionGUID: ilPmho4uRZW2zwnAMfaiug==
X-CSE-MsgGUID: 5GawnLD3TA6oIkgyqO1Yow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="236534715"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 20 Dec 2025 07:35:42 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWyzc-000000004ga-39a2;
	Sat, 20 Dec 2025 15:35:40 +0000
Date: Sat, 20 Dec 2025 16:34:46 +0100
From: kernel test robot <lkp@intel.com>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: Re: [PATCH 2/3] lib/crypto: Initial implementation of Ascon-Hash256
Message-ID: <202512201605.QLcE0Qu7-lkp@intel.com>
References: <20251215-ascon_hash256-v1-2-24ae735e571e@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-ascon_hash256-v1-2-24ae735e571e@kriptograf.id>

Hi Rusydi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 92de2d349e02c2dd96d8d1b7016cc78cf80fc085]

url:    https://github.com/intel-lab-lkp/linux/commits/Rusydi-H-Makarim/lib-crypto-Add-KUnit-test-vectors-for-Ascon-Hash256/20251215-215114
base:   92de2d349e02c2dd96d8d1b7016cc78cf80fc085
patch link:    https://lore.kernel.org/r/20251215-ascon_hash256-v1-2-24ae735e571e%40kriptograf.id
patch subject: [PATCH 2/3] lib/crypto: Initial implementation of Ascon-Hash256
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20251220/202512201605.QLcE0Qu7-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512201605.QLcE0Qu7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512201605.QLcE0Qu7-lkp@intel.com/

All errors (new ones prefixed by >>):

>> lib/crypto/hash_info.c:35:10: error: 'HASH_ALGO_ASCON_HASH256' undeclared here (not in a function); did you mean 'HASH_ALGO_SHA3_256'?
      35 |         [HASH_ALGO_ASCON_HASH256] = "ascon-hash256",
         |          ^~~~~~~~~~~~~~~~~~~~~~~
         |          HASH_ALGO_SHA3_256
>> lib/crypto/hash_info.c:35:10: error: array index in initializer not of integer type
   lib/crypto/hash_info.c:35:10: note: (near initialization for 'hash_algo_name')
   lib/crypto/hash_info.c:35:37: warning: excess elements in array initializer
      35 |         [HASH_ALGO_ASCON_HASH256] = "ascon-hash256",
         |                                     ^~~~~~~~~~~~~~~
   lib/crypto/hash_info.c:35:37: note: (near initialization for 'hash_algo_name')
   lib/crypto/hash_info.c:63:10: error: array index in initializer not of integer type
      63 |         [HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,
         |          ^~~~~~~~~~~~~~~~~~~~~~~
   lib/crypto/hash_info.c:63:10: note: (near initialization for 'hash_digest_size')
>> lib/crypto/hash_info.c:63:37: error: 'ASCON_HASH256_DIGEST_SIZE' undeclared here (not in a function); did you mean 'SHA256_DIGEST_SIZE'?
      63 |         [HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~
         |                                     SHA256_DIGEST_SIZE
   lib/crypto/hash_info.c:63:37: warning: excess elements in array initializer
   lib/crypto/hash_info.c:63:37: note: (near initialization for 'hash_digest_size')


vim +35 lib/crypto/hash_info.c

    10	
    11	const char *const hash_algo_name[HASH_ALGO__LAST] = {
    12		[HASH_ALGO_MD4]		= "md4",
    13		[HASH_ALGO_MD5]		= "md5",
    14		[HASH_ALGO_SHA1]	= "sha1",
    15		[HASH_ALGO_RIPE_MD_160]	= "rmd160",
    16		[HASH_ALGO_SHA256]	= "sha256",
    17		[HASH_ALGO_SHA384]	= "sha384",
    18		[HASH_ALGO_SHA512]	= "sha512",
    19		[HASH_ALGO_SHA224]	= "sha224",
    20		[HASH_ALGO_RIPE_MD_128]	= "rmd128",
    21		[HASH_ALGO_RIPE_MD_256]	= "rmd256",
    22		[HASH_ALGO_RIPE_MD_320]	= "rmd320",
    23		[HASH_ALGO_WP_256]	= "wp256",
    24		[HASH_ALGO_WP_384]	= "wp384",
    25		[HASH_ALGO_WP_512]	= "wp512",
    26		[HASH_ALGO_TGR_128]	= "tgr128",
    27		[HASH_ALGO_TGR_160]	= "tgr160",
    28		[HASH_ALGO_TGR_192]	= "tgr192",
    29		[HASH_ALGO_SM3_256]	= "sm3",
    30		[HASH_ALGO_STREEBOG_256] = "streebog256",
    31		[HASH_ALGO_STREEBOG_512] = "streebog512",
    32		[HASH_ALGO_SHA3_256]    = "sha3-256",
    33		[HASH_ALGO_SHA3_384]    = "sha3-384",
    34		[HASH_ALGO_SHA3_512]    = "sha3-512",
  > 35		[HASH_ALGO_ASCON_HASH256] = "ascon-hash256",
    36	};
    37	EXPORT_SYMBOL_GPL(hash_algo_name);
    38	
    39	const int hash_digest_size[HASH_ALGO__LAST] = {
    40		[HASH_ALGO_MD4]		= MD5_DIGEST_SIZE,
    41		[HASH_ALGO_MD5]		= MD5_DIGEST_SIZE,
    42		[HASH_ALGO_SHA1]	= SHA1_DIGEST_SIZE,
    43		[HASH_ALGO_RIPE_MD_160]	= RMD160_DIGEST_SIZE,
    44		[HASH_ALGO_SHA256]	= SHA256_DIGEST_SIZE,
    45		[HASH_ALGO_SHA384]	= SHA384_DIGEST_SIZE,
    46		[HASH_ALGO_SHA512]	= SHA512_DIGEST_SIZE,
    47		[HASH_ALGO_SHA224]	= SHA224_DIGEST_SIZE,
    48		[HASH_ALGO_RIPE_MD_128]	= RMD128_DIGEST_SIZE,
    49		[HASH_ALGO_RIPE_MD_256]	= RMD256_DIGEST_SIZE,
    50		[HASH_ALGO_RIPE_MD_320]	= RMD320_DIGEST_SIZE,
    51		[HASH_ALGO_WP_256]	= WP256_DIGEST_SIZE,
    52		[HASH_ALGO_WP_384]	= WP384_DIGEST_SIZE,
    53		[HASH_ALGO_WP_512]	= WP512_DIGEST_SIZE,
    54		[HASH_ALGO_TGR_128]	= TGR128_DIGEST_SIZE,
    55		[HASH_ALGO_TGR_160]	= TGR160_DIGEST_SIZE,
    56		[HASH_ALGO_TGR_192]	= TGR192_DIGEST_SIZE,
    57		[HASH_ALGO_SM3_256]	= SM3256_DIGEST_SIZE,
    58		[HASH_ALGO_STREEBOG_256] = STREEBOG256_DIGEST_SIZE,
    59		[HASH_ALGO_STREEBOG_512] = STREEBOG512_DIGEST_SIZE,
    60		[HASH_ALGO_SHA3_256]    = SHA3_256_DIGEST_SIZE,
    61		[HASH_ALGO_SHA3_384]    = SHA3_384_DIGEST_SIZE,
    62		[HASH_ALGO_SHA3_512]    = SHA3_512_DIGEST_SIZE,
  > 63		[HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
