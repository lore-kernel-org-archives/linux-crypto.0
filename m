Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD2D2F60A2;
	Fri, 14 Nov 2025 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763102889; cv=none; b=aOD9F9KvL20MbbpAg0Lu06LeHYppySX4KLNp9nSvrjlj8CF183+yA1lbRH8WvogKfqUf7Im1x9gH3D7xr8vAby9LzjTMEJ2uLUh6vdM/eJCzVS0riPz6h5RJSCivf4qNnvBysskbQ5ViHcL6/uJ3uUdKnwBIimGu6NGx6gisSis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763102889; c=relaxed/simple;
	bh=+qqUJbUfdNtUAp4I7SErk4lrdEOAX1LgY9PGJW2fAiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4GNVJ16MKt1NVV8lZv0puXpKRxYiamHt8tARn7c/iGsCb0J4YGNE6RACPMZSB+Ey0R5WqxAAqWKc2T2Ttn1lFrqoOUKIipAs2yXs880HtO+BedYom9L7q8PSj3JB7fUCNNS4FTMipP2sW0QcIwXqfgFMm6U0kruflLS83m2ReM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HvCqjd+W; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HvCqjd+W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763102887; x=1794638887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+qqUJbUfdNtUAp4I7SErk4lrdEOAX1LgY9PGJW2fAiE=;
  b=HvCqjd+WyIfECikccig4m/wzVQAGngEZ5PtHwBVTTK/x45v2slQx0JnZ
   ox14vY9FhyWjH1FR9FfdoQc46QZHDKYiy6c1bcuVh4e4L4I5zNqnRBfZW
   UOdK93glkg1a6vC5wCvcW5w+UBfdOkxDvRV6EmuzeQj9Um4eWOUIqUwPo
   hTFYhHpj7Ia2PZmeO8H9msy/BuJzAYGuEwfdX+MSXuWR3KkxNOlLei4VI
   2tgAHEn/mGXPP6LdM4SO6UFPl5Isu6qwu2hU56yYQDYV/CegyRhIlgCHS
   6xX9I337X8cws7ij9s+u2RyU0Hf56BeYODha1/Iad1w9Pxnf3XAtHc+Ut
   w==;
X-CSE-ConnectionGUID: wkXtkZfbSAW1RzsvN5MkfQ==
X-CSE-MsgGUID: bytQ/gn+SCma1xETVUPMWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65132793"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65132793"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:48:03 -0800
X-CSE-ConnectionGUID: UrEjQwoeT7KhCKNJzXqufw==
X-CSE-MsgGUID: GMG8FB9ITbmkemEMh8sdDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="189554985"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2025 22:47:59 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJnbB-0006Fp-1J;
	Fri, 14 Nov 2025 06:47:57 +0000
Date: Fri, 14 Nov 2025 14:47:36 +0800
From: kernel test robot <lkp@intel.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
Message-ID: <202511141245.zQcC9EcY-lkp@intel.com>
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
[cannot apply to herbert-cryptodev-2.6/master next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/T-Pratham/crypto-ti-Add-support-for-AES-XTS-in-DTHEv2-driver/20251111-192827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
patch link:    https://lore.kernel.org/r/20251111112137.976121-4-t-pratham%40ti.com
patch subject: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2 driver
config: arm-randconfig-003-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141245.zQcC9EcY-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141245.zQcC9EcY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141245.zQcC9EcY-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/ti/dthev2-aes.c:573:17: error: call to undeclared function 'crypto_alloc_sync_aead'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
         |                        ^
   drivers/crypto/ti/dthev2-aes.c:573:17: note: did you mean 'crypto_alloc_aead'?
   include/crypto/aead.h:181:21: note: 'crypto_alloc_aead' declared here
     181 | struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
         |                     ^
>> drivers/crypto/ti/dthev2-aes.c:573:15: error: incompatible integer to pointer conversion assigning to 'struct crypto_sync_aead *' from 'int' [-Wint-conversion]
     573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
         |                      ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     574 |                                               CRYPTO_ALG_NEED_FALLBACK);
         |                                               ~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/ti/dthev2-aes.c:588:2: error: call to undeclared function 'crypto_free_sync_aead'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     588 |         crypto_free_sync_aead(ctx->aead_fb);
         |         ^
   drivers/crypto/ti/dthev2-aes.c:588:2: note: did you mean 'crypto_free_aead'?
   include/crypto/aead.h:194:20: note: 'crypto_free_aead' declared here
     194 | static inline void crypto_free_aead(struct crypto_aead *tfm)
         |                    ^
>> drivers/crypto/ti/dthev2-aes.c:831:2: error: call to undeclared function 'crypto_sync_aead_clear_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     831 |         crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
         |         ^
   drivers/crypto/ti/dthev2-aes.c:831:2: note: did you mean 'crypto_aead_clear_flags'?
   include/crypto/aead.h:298:20: note: 'crypto_aead_clear_flags' declared here
     298 | static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
         |                    ^
>> drivers/crypto/ti/dthev2-aes.c:832:2: error: call to undeclared function 'crypto_sync_aead_set_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     832 |         crypto_sync_aead_set_flags(ctx->aead_fb,
         |         ^
>> drivers/crypto/ti/dthev2-aes.c:836:9: error: call to undeclared function 'crypto_sync_aead_setkey'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     836 |         return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
         |                ^
   drivers/crypto/ti/dthev2-aes.c:836:9: note: did you mean 'crypto_aead_setkey'?
   include/crypto/aead.h:319:5: note: 'crypto_aead_setkey' declared here
     319 | int crypto_aead_setkey(struct crypto_aead *tfm,
         |     ^
>> drivers/crypto/ti/dthev2-aes.c:846:9: error: call to undeclared function 'crypto_sync_aead_setauthsize'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     846 |         return crypto_sync_aead_setauthsize(ctx->aead_fb, authsize);
         |                ^
   drivers/crypto/ti/dthev2-aes.c:846:9: note: did you mean 'crypto_aead_setauthsize'?
   include/crypto/aead.h:332:5: note: 'crypto_aead_setauthsize' declared here
     332 | int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
         |     ^
>> drivers/crypto/ti/dthev2-aes.c:854:2: error: call to undeclared function 'SYNC_AEAD_REQUEST_ON_STACK'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
         |         ^
>> drivers/crypto/ti/dthev2-aes.c:854:29: error: use of undeclared identifier 'subreq'
     854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
         |                                    ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:856:28: error: use of undeclared identifier 'subreq'
     856 |         aead_request_set_callback(subreq, req->base.flags,
         |                                   ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:858:25: error: use of undeclared identifier 'subreq'
     858 |         aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req->iv);
         |                                ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:859:22: error: use of undeclared identifier 'subreq'
     859 |         aead_request_set_ad(subreq, req->assoclen);
         |                             ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:861:41: error: use of undeclared identifier 'subreq'
     861 |         return rctx->enc ? crypto_aead_encrypt(subreq) :
         |                                                ^~~~~~
   drivers/crypto/ti/dthev2-aes.c:862:23: error: use of undeclared identifier 'subreq'
     862 |                 crypto_aead_decrypt(subreq);
         |                                     ^~~~~~
   14 errors generated.


vim +/crypto_alloc_sync_aead +573 drivers/crypto/ti/dthev2-aes.c

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
