Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E7C29B78F;
	Mon, 15 Dec 2025 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765839770; cv=none; b=ifcPfswmP69R6+KWAsgnianzs5lMU7lM2UOpRbCa62j5/2A8qCw5nUBe9cXh3nNTNtgkJP7qqKzEmBAewWQMtuh2EXy+g8OxL13JtMSV+HbObwsKXKrOueqzHiyJUICeRP+3PgfhzcLPCXkomOvkNT3U7/b9MMdgavxHuZQiS28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765839770; c=relaxed/simple;
	bh=bgjdXXwKfRRV8adSprDjXvT3wxmw3oSGIdXqmChwGJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGlbYiYfYZbbakkCVsrVhRkJbp7CBiAtyJSLJyWEaMVkE7IMn/PaCcGKLom0xyxS0yy4nv4I7jua+3WZHhLV8P826IV2LhCYczYI6ExaEkrr9UiSBA2xrfUHlvkFAb0jFyEGNNRnfPop7wlEXHyeSjE3vzSMf1Eq32Tdbhm90vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A5vkWFcR; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A5vkWFcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765839769; x=1797375769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bgjdXXwKfRRV8adSprDjXvT3wxmw3oSGIdXqmChwGJo=;
  b=A5vkWFcR7h/766i6rLyDMfw4TrqcYlbcT1SKjvb2Whk7GEePb7owy3VG
   mxTUaslktBJdOTTZiM4nSmnSDFfMcmWCWmG3BKV7ykeNnT5ZXReckkVRT
   8LI16WzMyAA13zqOUtOuAdoPGfvURs+EZrY8RLk6L3nQHNjl1OWJdfUA2
   zGsHTUN9mWl7DRQiJSymF5+42j1MJ+PDxjSDFcTswkNXIg6tcBzDqorvv
   J+ptThHmLsuo1WZw8h0iJ0twiPvXJh74yNEQwRLch6VP88B6tho4zfiPY
   TIdQ/TahkrKhmPr0fGwgQAvQSFaFove54oPJm//A9aKObGR/RTguqJTxM
   Q==;
X-CSE-ConnectionGUID: C9/CkXw6RtGk1A2/lSDVEg==
X-CSE-MsgGUID: CemfnnZxQLSQFdGkkhMgvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="67636244"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="67636244"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 15:02:47 -0800
X-CSE-ConnectionGUID: TH49JKAeRRC6PJoVQJ2saw==
X-CSE-MsgGUID: L/rj+e2kTUa1FC2fkUDgWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="235255737"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 15 Dec 2025 15:02:45 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVHaU-000000000tp-2XoD;
	Mon, 15 Dec 2025 23:02:42 +0000
Date: Tue, 16 Dec 2025 07:01:26 +0800
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
Message-ID: <202512160656.DWMVkABi-lkp@intel.com>
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

[auto build test ERROR on ebiggers/libcrypto-next]
[also build test ERROR on ebiggers/libcrypto-fixes linus/master v6.19-rc1 next-20251215]
[cannot apply to herbert-cryptodev-2.6/master herbert-crypto-2.6/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rusydi-H-Makarim/lib-crypto-Initial-implementation-of-Ascon-Hash256/20251215-165442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
patch link:    https://lore.kernel.org/r/20251215-ascon_hash256-v1-2-24ae735e571e%40kriptograf.id
patch subject: [PATCH 2/3] lib/crypto: Initial implementation of Ascon-Hash256
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251216/202512160656.DWMVkABi-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160656.DWMVkABi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512160656.DWMVkABi-lkp@intel.com/

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
