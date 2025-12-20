Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0730C368;
	Sat, 20 Dec 2025 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766247690; cv=none; b=r4SW0d0zSr496oyoqK0pBQz9KH0dnm8qtBwUwwakANg1yIsoVrDd4paC3Alc0TbI3vWvdXUCQVqi4DSPQO8f7ZamY/LkeQz3m8SXUbUQjnhWceHT2EnwsMXbhfB4XK3qGywVpnDK0R2cHifzgM0aQo0aQv5tLjyza5LY504tShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766247690; c=relaxed/simple;
	bh=WbBTIG/tn0WWjI8wvXgkY1BWBW0FGCU3Hx3mGTAgvew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhKB/k8kDEjz0vM9F9W/3T9ywMWTffF5G4ZGSJ2DA9KL9YuTklvg+0Isc/C/qk2mJCJjx7wamFjVBhI14nIZUnEObURLVPBNK9+noek3zPruZZCIiAh2CE6ekgNMKrlS7UJ+Etg3qaXM5dYGFWjxR6QzsgNMGn+Po0g3x21nB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VDmiYtZA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VDmiYtZA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766247689; x=1797783689;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WbBTIG/tn0WWjI8wvXgkY1BWBW0FGCU3Hx3mGTAgvew=;
  b=VDmiYtZA2oS7zaH9fse1bDqE0T5rtF2iNl+5KXYAsWllgFRDrHqugyAC
   20UncoRFuHG06lOt4czpixl8XZDwexzgR22EBUeTvXvvMHJc5cMuqpf2H
   fCVu4q3kWrnolEVtspX8LhAWo28Va5gPrCqcv5dTKIU2RUy0/0Bx5tI3s
   8qhOpOWRGK5CrBaawxXzsTccdIxPy7SVrTIBWVW7HlA0wPHaivDMqZqZF
   KsRMXb081qa2pBodSjbIW6SUZH/dfQ5TojRV6xf0e+TTBXdfhBbMR2qhA
   8OMF9Bp9YCthbSOSzH0F6+I8GeUHfmyALTo8S88GuLJekrar+FMsZQjBj
   A==;
X-CSE-ConnectionGUID: DB+zG+SwSIiwfTzOkxe87g==
X-CSE-MsgGUID: ReeKlk4HR1+OPAwp+AQxwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="67375376"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="67375376"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 08:21:27 -0800
X-CSE-ConnectionGUID: zkpZYfYzRBG4rPX5OIcOaA==
X-CSE-MsgGUID: QuNw423oS0iz13ZUjxCcMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="222604685"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 20 Dec 2025 08:21:24 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWzhq-000000004rl-2HNp;
	Sat, 20 Dec 2025 16:21:22 +0000
Date: Sun, 21 Dec 2025 00:20:24 +0800
From: kernel test robot <lkp@intel.com>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: Re: [PATCH 2/3] lib/crypto: Initial implementation of Ascon-Hash256
Message-ID: <202512210037.K5OAaoVa-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251221/202512210037.K5OAaoVa-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210037.K5OAaoVa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210037.K5OAaoVa-lkp@intel.com/

All errors (new ones prefixed by >>):

>> lib/crypto/hash_info.c:35:3: error: use of undeclared identifier 'HASH_ALGO_ASCON_HASH256'
      35 |         [HASH_ALGO_ASCON_HASH256] = "ascon-hash256",
         |          ^
>> lib/crypto/hash_info.c:63:30: error: use of undeclared identifier 'ASCON_HASH256_DIGEST_SIZE'
      63 |         [HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,
         |                                     ^
   lib/crypto/hash_info.c:63:3: error: use of undeclared identifier 'HASH_ALGO_ASCON_HASH256'
      63 |         [HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,
         |          ^
   3 errors generated.


vim +/HASH_ALGO_ASCON_HASH256 +35 lib/crypto/hash_info.c

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
