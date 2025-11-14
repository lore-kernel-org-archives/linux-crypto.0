Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F827D782;
	Fri, 14 Nov 2025 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763113042; cv=none; b=USI5Jrb1K7VWh81BEXiJCfMXqHxVIb0xkd5haVV5Ax87kdgEedLPQsRaOg9uinkxX1lstcRVSY3sa6STdcjcBY5JUiQ8fZL+i2i8kQsr1E9jHELpoicK6Xc8JNL4YvGkSCuMiAWRfHTbRt0wcdIJ2nL8E01PnDAQtZASBob1vxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763113042; c=relaxed/simple;
	bh=VVIqPEqnNo0EhTLfDg/0eZ9CprIn3SbGY9+ZPeN0Utc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfAOmnzhHh18uhNbu48C+jm+ER89qtWOPvqn5eka14jcvC0Tb07DfMM4OLqWfETRS8GRn7ISuRuqJ5pDZMhyt0aR5z545YCOh5xKhm0GjO98/RwqPXyZoTEeNS0rBNqQas5H++DsVeUSdFXFudzHiU1LfxnawYQLvVGrMsIRGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cy5pyOOW; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cy5pyOOW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763113040; x=1794649040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VVIqPEqnNo0EhTLfDg/0eZ9CprIn3SbGY9+ZPeN0Utc=;
  b=cy5pyOOWZEVnJZASCUI1zz6vXcjN7uUqs8UOVMJeZfx3cMqaIlxzurkP
   8YVcgyqduY81vpWdnTOwo/KbP7Z0y+aA7nfGYbdMvodO1Y+c1YYyy8gko
   Z6Psjqv04JsoZGnTxLl/sxtWiS599fsPXehE2aQujYUgsboTZxV9t5aEu
   jGF6ZA34rQ/L6u5t7a7gMMcSeCk+kdz9ehpGPrtwu07kw9cAbL0jMhbJk
   k57LO3gLn25mmZI8jZkihv7aTO3k0v0sm2Juyj6N69XleHtpIz+tfSpX6
   ZJD0cFi+PXLQxC0NCWa0cBF5EhQ0y1wFBFG5q/hNLwPShJoiR97wXx7nw
   g==;
X-CSE-ConnectionGUID: +mnZg9JaQLqnvBeMZMwxnQ==
X-CSE-MsgGUID: jpRJI2BrQtGdBMjslrOSbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65092737"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="65092737"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:37:19 -0800
X-CSE-ConnectionGUID: C3+0W0jSRQaX7Eh3jk8OUA==
X-CSE-MsgGUID: AaynQJoFQ06GVme5Xvfr7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="189001449"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 14 Nov 2025 01:37:17 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJqF0-0006Pv-1s;
	Fri, 14 Nov 2025 09:37:14 +0000
Date: Fri, 14 Nov 2025 17:36:49 +0800
From: kernel test robot <lkp@intel.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
Message-ID: <202511141721.73B0pu4H-lkp@intel.com>
References: <20251111112137.976121-4-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111112137.976121-4-t-pratham@ti.com>

Hi Pratham,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-crypto-2.6/master]
[also build test ERROR on linus/master v6.18-rc5]
[cannot apply to herbert-cryptodev-2.6/master next-20251114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/T-Pratham/crypto-ti-Add-support-for-AES-XTS-in-DTHEv2-driver/20251111-192827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
patch link:    https://lore.kernel.org/r/20251111112137.976121-4-t-pratham%40ti.com
patch subject: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2 driver
config: s390-randconfig-002-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141721.73B0pu4H-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141721.73B0pu4H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141721.73B0pu4H-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/ti/dthev2-aes.c: In function 'dthe_aead_init_tfm':
>> drivers/crypto/ti/dthev2-aes.c:573:24: error: implicit declaration of function 'crypto_alloc_sync_aead'; did you mean 'crypto_alloc_aead'? [-Werror=implicit-function-declaration]
     573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
         |                        ^~~~~~~~~~~~~~~~~~~~~~
         |                        crypto_alloc_aead
   drivers/crypto/ti/dthev2-aes.c:573:22: warning: assignment to 'struct crypto_sync_aead *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
         |                      ^
   drivers/crypto/ti/dthev2-aes.c: In function 'dthe_aead_exit_tfm':
>> drivers/crypto/ti/dthev2-aes.c:588:9: error: implicit declaration of function 'crypto_free_sync_aead'; did you mean 'crypto_free_aead'? [-Werror=implicit-function-declaration]
     588 |         crypto_free_sync_aead(ctx->aead_fb);
         |         ^~~~~~~~~~~~~~~~~~~~~
         |         crypto_free_aead
   drivers/crypto/ti/dthev2-aes.c: In function 'dthe_aead_setkey':
>> drivers/crypto/ti/dthev2-aes.c:831:9: error: implicit declaration of function 'crypto_sync_aead_clear_flags'; did you mean 'crypto_aead_clear_flags'? [-Werror=implicit-function-declaration]
     831 |         crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |         crypto_aead_clear_flags
>> drivers/crypto/ti/dthev2-aes.c:832:9: error: implicit declaration of function 'crypto_sync_aead_set_flags'; did you mean 'crypto_aead_set_flags'? [-Werror=implicit-function-declaration]
     832 |         crypto_sync_aead_set_flags(ctx->aead_fb,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |         crypto_aead_set_flags
>> drivers/crypto/ti/dthev2-aes.c:836:16: error: implicit declaration of function 'crypto_sync_aead_setkey'; did you mean 'crypto_aead_setkey'? [-Werror=implicit-function-declaration]
     836 |         return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
         |                ^~~~~~~~~~~~~~~~~~~~~~~
         |                crypto_aead_setkey
   drivers/crypto/ti/dthev2-aes.c: In function 'dthe_aead_setauthsize':
>> drivers/crypto/ti/dthev2-aes.c:846:16: error: implicit declaration of function 'crypto_sync_aead_setauthsize'; did you mean 'crypto_aead_setauthsize'? [-Werror=implicit-function-declaration]
     846 |         return crypto_sync_aead_setauthsize(ctx->aead_fb, authsize);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                crypto_aead_setauthsize
   drivers/crypto/ti/dthev2-aes.c: In function 'dthe_aead_do_fallback':
>> drivers/crypto/ti/dthev2-aes.c:854:9: error: implicit declaration of function 'SYNC_AEAD_REQUEST_ON_STACK'; did you mean 'SYNC_SKCIPHER_REQUEST_ON_STACK'? [-Werror=implicit-function-declaration]
     854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |         SYNC_SKCIPHER_REQUEST_ON_STACK
>> drivers/crypto/ti/dthev2-aes.c:854:36: error: 'subreq' undeclared (first use in this function)
     854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
         |                                    ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:854:36: note: each undeclared identifier is reported only once for each function it appears in
   drivers/crypto/ti/dthev2-aes.c:863:1: warning: control reaches end of non-void function [-Wreturn-type]
     863 | }
         | ^
   cc1: some warnings being treated as errors


vim +573 drivers/crypto/ti/dthev2-aes.c

   563	
   564	static int dthe_aead_init_tfm(struct crypto_aead *tfm)
   565	{
   566		struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
   567		struct dthe_data *dev_data = dthe_get_dev(ctx);
   568	
   569		ctx->dev_data = dev_data;
   570	
   571		const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
   572	
 > 573		ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
   574						      CRYPTO_ALG_NEED_FALLBACK);
   575		if (IS_ERR(ctx->aead_fb)) {
   576			dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
   577				alg_name);
   578			return PTR_ERR(ctx->aead_fb);
   579		}
   580	
   581		return 0;
   582	}
   583	
   584	static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
   585	{
   586		struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
   587	
 > 588		crypto_free_sync_aead(ctx->aead_fb);
   589	}
   590	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
