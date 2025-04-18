Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA4F2F43
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 21:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745013442; cv=none; b=gvBGXMQ0VpVQXUGWUEceyIJ4FNuTc8VPk2pV53KNO9cRXccy64BzAgdNZK1mNbY5FA+k/6DyA7fCFYvl+JhNbKxIav1xNFj9wo0VCKTUrBHgQPs8W5T/5AzFpgXHTkayhnOqDOAICf54zo1ZcZslWupU87KKqHOmdGXKvDgilQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745013442; c=relaxed/simple;
	bh=2R4ZmVCnOt8kxZaSNFoXnQXndqGMb3OdZfJZhlE0OCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaFw36rntsmJ+V7Me20r6uyM7rKfmb2pnuNdzg5+YMo1A4cV2hkTjcU46zpVSGLkrEFRmndj7iCbcTqmn1Jqw0ar5pQkNW6NbEfCMgc9q5s5GTeMtQbI5WMqBJCDTp2FGoB3TOh9lEoj7Ycj/tRbSu6pGKT1dmKUCHpVAgYZBzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8JivlS5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8JivlS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745013440; x=1776549440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2R4ZmVCnOt8kxZaSNFoXnQXndqGMb3OdZfJZhlE0OCY=;
  b=Z8JivlS5OYDu83gFuOiLIin1EY71tvT+psKlhYAFUdPF+hxjoC0gtie4
   A7pvUomrRWzNFHL8pJqBQyC/f3PL6s92/adI4TtmZHi6ew5kwiee6Da+J
   l6CulkjR5ZmWyAaB8dlTvFz70o+sIwvkmKAUwLoSu5dJ0y/Rffe3Sj1Tg
   ofhG5ogOUu2TFn/VrfvhFtWBWI6nVqlAMsBVboHkMKYkDC6TGTStAOVx8
   8huSzZueksbPzgFuhAFkvsJCN+MFQdHiQ6aBiC/wi3I9PjumiVHc+GgDk
   6h6ydIy8pBkU78VGMQRfqVlSwu17R6PVrYIf9VUWNY7CLEm2sDen16ZIV
   A==;
X-CSE-ConnectionGUID: IsBkzIfVQ4K0/pdQunauyQ==
X-CSE-MsgGUID: fKw9pruXS6+cCdRcyHWBYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46354043"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46354043"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:57:20 -0700
X-CSE-ConnectionGUID: eJ7t1lTBRVS5TShp3na7AQ==
X-CSE-MsgGUID: 2mirhWPZQmO70NBaasRkwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="136386917"
Received: from lkp-server01.sh.intel.com (HELO 61e10e65ea0f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 18 Apr 2025 14:57:18 -0700
Received: from kbuild by 61e10e65ea0f with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u5thz-0003N3-36;
	Fri, 18 Apr 2025 21:57:15 +0000
Date: Sat, 19 Apr 2025 05:56:52 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [v2 PATCH 27/67] crypto: x86/sha256 - Use API partial block
 handling
Message-ID: <202504190545.4Wh9NtX2-lkp@intel.com>
References: <90dc6c4603dbd8fa7ec67baa17471b441ae0ddb8.1744945025.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90dc6c4603dbd8fa7ec67baa17471b441ae0ddb8.1744945025.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on da4cb617bc7d827946cbb368034940b379a1de90]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-shash-Handle-partial-blocks-in-API/20250418-110435
base:   da4cb617bc7d827946cbb368034940b379a1de90
patch link:    https://lore.kernel.org/r/90dc6c4603dbd8fa7ec67baa17471b441ae0ddb8.1744945025.git.herbert%40gondor.apana.org.au
patch subject: [v2 PATCH 27/67] crypto: x86/sha256 - Use API partial block handling
config: x86_64-buildonly-randconfig-001-20250419 (https://download.01.org/0day-ci/archive/20250419/202504190545.4Wh9NtX2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250419/202504190545.4Wh9NtX2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504190545.4Wh9NtX2-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/crypto/sha256_ssse3_glue.c: In function '_sha256_update':
>> arch/x86/crypto/sha256_ssse3_glue.c:63:9: error: implicit declaration of function 'kernel_fpu_begin' [-Werror=implicit-function-declaration]
      63 |         kernel_fpu_begin();
         |         ^~~~~~~~~~~~~~~~
>> arch/x86/crypto/sha256_ssse3_glue.c:65:9: error: implicit declaration of function 'kernel_fpu_end' [-Werror=implicit-function-declaration]
      65 |         kernel_fpu_end();
         |         ^~~~~~~~~~~~~~
   arch/x86/crypto/sha256_ssse3_glue.c: In function 'avx_usable':
>> arch/x86/crypto/sha256_ssse3_glue.c:204:14: error: implicit declaration of function 'cpu_has_xfeatures'; did you mean 'cpu_have_feature'? [-Werror=implicit-function-declaration]
     204 |         if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
         |              ^~~~~~~~~~~~~~~~~
         |              cpu_have_feature
   cc1: some warnings being treated as errors


vim +/kernel_fpu_begin +63 arch/x86/crypto/sha256_ssse3_glue.c

1c43c0f1f84aa5 Roxana Nicolescu 2023-09-15   50  
eb7d6ba882f1c5 Hans de Goede    2019-09-01   51  static int _sha256_update(struct shash_desc *desc, const u8 *data,
3b713d1a6994a0 Herbert Xu       2025-04-18   52  			  unsigned int len,
3b713d1a6994a0 Herbert Xu       2025-04-18   53  			  crypto_sha256_block_fn *sha256_xform)
8275d1aa642295 Tim Chen         2013-03-26   54  {
3b713d1a6994a0 Herbert Xu       2025-04-18   55  	int remain;
8275d1aa642295 Tim Chen         2013-03-26   56  
41419a28901083 Kees Cook        2020-01-14   57  	/*
3b713d1a6994a0 Herbert Xu       2025-04-18   58  	 * Make sure struct crypto_sha256_state begins directly with the SHA256
41419a28901083 Kees Cook        2020-01-14   59  	 * 256-bit internal state, as this is what the asm functions expect.
41419a28901083 Kees Cook        2020-01-14   60  	 */
3b713d1a6994a0 Herbert Xu       2025-04-18   61  	BUILD_BUG_ON(offsetof(struct crypto_sha256_state, state) != 0);
8275d1aa642295 Tim Chen         2013-03-26   62  
8275d1aa642295 Tim Chen         2013-03-26  @63  	kernel_fpu_begin();
3b713d1a6994a0 Herbert Xu       2025-04-18   64  	remain = sha256_base_do_update_blocks(desc, data, len, sha256_xform);
8275d1aa642295 Tim Chen         2013-03-26  @65  	kernel_fpu_end();
8275d1aa642295 Tim Chen         2013-03-26   66  
3b713d1a6994a0 Herbert Xu       2025-04-18   67  	return remain;
8275d1aa642295 Tim Chen         2013-03-26   68  }
8275d1aa642295 Tim Chen         2013-03-26   69  
5dda42fc89f26f tim              2015-09-16   70  static int sha256_finup(struct shash_desc *desc, const u8 *data,
3b713d1a6994a0 Herbert Xu       2025-04-18   71  	      unsigned int len, u8 *out, crypto_sha256_block_fn *sha256_xform)
8275d1aa642295 Tim Chen         2013-03-26   72  {
8275d1aa642295 Tim Chen         2013-03-26   73  	kernel_fpu_begin();
3b713d1a6994a0 Herbert Xu       2025-04-18   74  	sha256_base_do_finup(desc, data, len, sha256_xform);
8275d1aa642295 Tim Chen         2013-03-26   75  	kernel_fpu_end();
8275d1aa642295 Tim Chen         2013-03-26   76  
1631030ae63aef Ard Biesheuvel   2015-04-09   77  	return sha256_base_finish(desc, out);
a710f761fc9ae5 Jussi Kivilinna  2013-05-21   78  }
a710f761fc9ae5 Jussi Kivilinna  2013-05-21   79  
5dda42fc89f26f tim              2015-09-16   80  static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
5dda42fc89f26f tim              2015-09-16   81  			 unsigned int len)
5dda42fc89f26f tim              2015-09-16   82  {
eb7d6ba882f1c5 Hans de Goede    2019-09-01   83  	return _sha256_update(desc, data, len, sha256_transform_ssse3);
5dda42fc89f26f tim              2015-09-16   84  }
5dda42fc89f26f tim              2015-09-16   85  
5dda42fc89f26f tim              2015-09-16   86  static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
5dda42fc89f26f tim              2015-09-16   87  	      unsigned int len, u8 *out)
5dda42fc89f26f tim              2015-09-16   88  {
5dda42fc89f26f tim              2015-09-16   89  	return sha256_finup(desc, data, len, out, sha256_transform_ssse3);
5dda42fc89f26f tim              2015-09-16   90  }
5dda42fc89f26f tim              2015-09-16   91  
fdcac2ddc75975 Eric Biggers     2023-10-09   92  static int sha256_ssse3_digest(struct shash_desc *desc, const u8 *data,
fdcac2ddc75975 Eric Biggers     2023-10-09   93  	      unsigned int len, u8 *out)
fdcac2ddc75975 Eric Biggers     2023-10-09   94  {
fdcac2ddc75975 Eric Biggers     2023-10-09   95  	return sha256_base_init(desc) ?:
fdcac2ddc75975 Eric Biggers     2023-10-09   96  	       sha256_ssse3_finup(desc, data, len, out);
fdcac2ddc75975 Eric Biggers     2023-10-09   97  }
fdcac2ddc75975 Eric Biggers     2023-10-09   98  
5dda42fc89f26f tim              2015-09-16   99  static struct shash_alg sha256_ssse3_algs[] = { {
8275d1aa642295 Tim Chen         2013-03-26  100  	.digestsize	=	SHA256_DIGEST_SIZE,
1631030ae63aef Ard Biesheuvel   2015-04-09  101  	.init		=	sha256_base_init,
8275d1aa642295 Tim Chen         2013-03-26  102  	.update		=	sha256_ssse3_update,
1631030ae63aef Ard Biesheuvel   2015-04-09  103  	.finup		=	sha256_ssse3_finup,
fdcac2ddc75975 Eric Biggers     2023-10-09  104  	.digest		=	sha256_ssse3_digest,
3b713d1a6994a0 Herbert Xu       2025-04-18  105  	.descsize	=	sizeof(struct crypto_sha256_state),
8275d1aa642295 Tim Chen         2013-03-26  106  	.base		=	{
8275d1aa642295 Tim Chen         2013-03-26  107  		.cra_name	=	"sha256",
8275d1aa642295 Tim Chen         2013-03-26  108  		.cra_driver_name =	"sha256-ssse3",
8275d1aa642295 Tim Chen         2013-03-26  109  		.cra_priority	=	150,
3b713d1a6994a0 Herbert Xu       2025-04-18  110  		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
3b713d1a6994a0 Herbert Xu       2025-04-18  111  					CRYPTO_AHASH_ALG_FINUP_MAX,
8275d1aa642295 Tim Chen         2013-03-26  112  		.cra_blocksize	=	SHA256_BLOCK_SIZE,
8275d1aa642295 Tim Chen         2013-03-26  113  		.cra_module	=	THIS_MODULE,
8275d1aa642295 Tim Chen         2013-03-26  114  	}
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  115  }, {
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  116  	.digestsize	=	SHA224_DIGEST_SIZE,
1631030ae63aef Ard Biesheuvel   2015-04-09  117  	.init		=	sha224_base_init,
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  118  	.update		=	sha256_ssse3_update,
1631030ae63aef Ard Biesheuvel   2015-04-09  119  	.finup		=	sha256_ssse3_finup,
3b713d1a6994a0 Herbert Xu       2025-04-18  120  	.descsize	=	sizeof(struct crypto_sha256_state),
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  121  	.base		=	{
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  122  		.cra_name	=	"sha224",
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  123  		.cra_driver_name =	"sha224-ssse3",
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  124  		.cra_priority	=	150,
3b713d1a6994a0 Herbert Xu       2025-04-18  125  		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
3b713d1a6994a0 Herbert Xu       2025-04-18  126  					CRYPTO_AHASH_ALG_FINUP_MAX,
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  127  		.cra_blocksize	=	SHA224_BLOCK_SIZE,
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  128  		.cra_module	=	THIS_MODULE,
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  129  	}
a710f761fc9ae5 Jussi Kivilinna  2013-05-21  130  } };
8275d1aa642295 Tim Chen         2013-03-26  131  
5dda42fc89f26f tim              2015-09-16  132  static int register_sha256_ssse3(void)
5dda42fc89f26f tim              2015-09-16  133  {
5dda42fc89f26f tim              2015-09-16  134  	if (boot_cpu_has(X86_FEATURE_SSSE3))
5dda42fc89f26f tim              2015-09-16  135  		return crypto_register_shashes(sha256_ssse3_algs,
5dda42fc89f26f tim              2015-09-16  136  				ARRAY_SIZE(sha256_ssse3_algs));
5dda42fc89f26f tim              2015-09-16  137  	return 0;
5dda42fc89f26f tim              2015-09-16  138  }
5dda42fc89f26f tim              2015-09-16  139  
5dda42fc89f26f tim              2015-09-16  140  static void unregister_sha256_ssse3(void)
5dda42fc89f26f tim              2015-09-16  141  {
5dda42fc89f26f tim              2015-09-16  142  	if (boot_cpu_has(X86_FEATURE_SSSE3))
5dda42fc89f26f tim              2015-09-16  143  		crypto_unregister_shashes(sha256_ssse3_algs,
5dda42fc89f26f tim              2015-09-16  144  				ARRAY_SIZE(sha256_ssse3_algs));
5dda42fc89f26f tim              2015-09-16  145  }
5dda42fc89f26f tim              2015-09-16  146  
3b713d1a6994a0 Herbert Xu       2025-04-18  147  asmlinkage void sha256_transform_avx(struct crypto_sha256_state *state,
41419a28901083 Kees Cook        2020-01-14  148  				     const u8 *data, int blocks);
5dda42fc89f26f tim              2015-09-16  149  
5dda42fc89f26f tim              2015-09-16  150  static int sha256_avx_update(struct shash_desc *desc, const u8 *data,
5dda42fc89f26f tim              2015-09-16  151  			 unsigned int len)
5dda42fc89f26f tim              2015-09-16  152  {
eb7d6ba882f1c5 Hans de Goede    2019-09-01  153  	return _sha256_update(desc, data, len, sha256_transform_avx);
5dda42fc89f26f tim              2015-09-16  154  }
5dda42fc89f26f tim              2015-09-16  155  
5dda42fc89f26f tim              2015-09-16  156  static int sha256_avx_finup(struct shash_desc *desc, const u8 *data,
5dda42fc89f26f tim              2015-09-16  157  		      unsigned int len, u8 *out)
5dda42fc89f26f tim              2015-09-16  158  {
5dda42fc89f26f tim              2015-09-16  159  	return sha256_finup(desc, data, len, out, sha256_transform_avx);
5dda42fc89f26f tim              2015-09-16  160  }
5dda42fc89f26f tim              2015-09-16  161  
fdcac2ddc75975 Eric Biggers     2023-10-09  162  static int sha256_avx_digest(struct shash_desc *desc, const u8 *data,
fdcac2ddc75975 Eric Biggers     2023-10-09  163  		      unsigned int len, u8 *out)
fdcac2ddc75975 Eric Biggers     2023-10-09  164  {
fdcac2ddc75975 Eric Biggers     2023-10-09  165  	return sha256_base_init(desc) ?:
fdcac2ddc75975 Eric Biggers     2023-10-09  166  	       sha256_avx_finup(desc, data, len, out);
fdcac2ddc75975 Eric Biggers     2023-10-09  167  }
fdcac2ddc75975 Eric Biggers     2023-10-09  168  
5dda42fc89f26f tim              2015-09-16  169  static struct shash_alg sha256_avx_algs[] = { {
5dda42fc89f26f tim              2015-09-16  170  	.digestsize	=	SHA256_DIGEST_SIZE,
5dda42fc89f26f tim              2015-09-16  171  	.init		=	sha256_base_init,
5dda42fc89f26f tim              2015-09-16  172  	.update		=	sha256_avx_update,
5dda42fc89f26f tim              2015-09-16  173  	.finup		=	sha256_avx_finup,
fdcac2ddc75975 Eric Biggers     2023-10-09  174  	.digest		=	sha256_avx_digest,
3b713d1a6994a0 Herbert Xu       2025-04-18  175  	.descsize	=	sizeof(struct crypto_sha256_state),
5dda42fc89f26f tim              2015-09-16  176  	.base		=	{
5dda42fc89f26f tim              2015-09-16  177  		.cra_name	=	"sha256",
5dda42fc89f26f tim              2015-09-16  178  		.cra_driver_name =	"sha256-avx",
5dda42fc89f26f tim              2015-09-16  179  		.cra_priority	=	160,
3b713d1a6994a0 Herbert Xu       2025-04-18  180  		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
3b713d1a6994a0 Herbert Xu       2025-04-18  181  					CRYPTO_AHASH_ALG_FINUP_MAX,
5dda42fc89f26f tim              2015-09-16  182  		.cra_blocksize	=	SHA256_BLOCK_SIZE,
5dda42fc89f26f tim              2015-09-16  183  		.cra_module	=	THIS_MODULE,
5dda42fc89f26f tim              2015-09-16  184  	}
5dda42fc89f26f tim              2015-09-16  185  }, {
5dda42fc89f26f tim              2015-09-16  186  	.digestsize	=	SHA224_DIGEST_SIZE,
5dda42fc89f26f tim              2015-09-16  187  	.init		=	sha224_base_init,
5dda42fc89f26f tim              2015-09-16  188  	.update		=	sha256_avx_update,
5dda42fc89f26f tim              2015-09-16  189  	.finup		=	sha256_avx_finup,
3b713d1a6994a0 Herbert Xu       2025-04-18  190  	.descsize	=	sizeof(struct crypto_sha256_state),
5dda42fc89f26f tim              2015-09-16  191  	.base		=	{
5dda42fc89f26f tim              2015-09-16  192  		.cra_name	=	"sha224",
5dda42fc89f26f tim              2015-09-16  193  		.cra_driver_name =	"sha224-avx",
5dda42fc89f26f tim              2015-09-16  194  		.cra_priority	=	160,
3b713d1a6994a0 Herbert Xu       2025-04-18  195  		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
3b713d1a6994a0 Herbert Xu       2025-04-18  196  					CRYPTO_AHASH_ALG_FINUP_MAX,
5dda42fc89f26f tim              2015-09-16  197  		.cra_blocksize	=	SHA224_BLOCK_SIZE,
5dda42fc89f26f tim              2015-09-16  198  		.cra_module	=	THIS_MODULE,
5dda42fc89f26f tim              2015-09-16  199  	}
5dda42fc89f26f tim              2015-09-16  200  } };
5dda42fc89f26f tim              2015-09-16  201  
5dda42fc89f26f tim              2015-09-16  202  static bool avx_usable(void)
8275d1aa642295 Tim Chen         2013-03-26  203  {
d91cab78133d33 Dave Hansen      2015-09-02 @204  	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
da154e82af4d0c Borislav Petkov  2016-04-04  205  		if (boot_cpu_has(X86_FEATURE_AVX))
8275d1aa642295 Tim Chen         2013-03-26  206  			pr_info("AVX detected but unusable.\n");
8275d1aa642295 Tim Chen         2013-03-26  207  		return false;
8275d1aa642295 Tim Chen         2013-03-26  208  	}
8275d1aa642295 Tim Chen         2013-03-26  209  
8275d1aa642295 Tim Chen         2013-03-26  210  	return true;
8275d1aa642295 Tim Chen         2013-03-26  211  }
8275d1aa642295 Tim Chen         2013-03-26  212  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
