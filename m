Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB81EA7E6
	for <linux-crypto@vger.kernel.org>; Sat, 10 May 2025 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746891813; cv=none; b=uJrWp6/THpQdNznWJatkgG01GR+pdtC/6kyYaWzW9qQEDtFE8mWlMA/ZIuxafR3rcsDk5HFLp7g5ksHpgIoL4EXdY+DVnEFRIwrQaFuRNFLm8yRqbS+xLzoBWiObPtlsp3OI3sGMNuJmdD9s6FN5cglgOGLiyrQcoGalPq/nUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746891813; c=relaxed/simple;
	bh=75pnexBZNTe6ZbM5UY7Nv8mUeOOj5+n3QivN8HzKwBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgalfWUorshKO0hgIVk1sVUkASDMStHTwQRaXvjNr7OeGzACcAHN+YLbZU9aRfkn0sbyNn2M10oI29l9EIf2YkVoUf6uWL8YsOoctlLwkEnex7BYcZ0s4yYYZzoRlLE8/LOkVc3mSGb67zIMvxEc0fdxRqxLKvbcfKkMlVNECtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iQ44N7Id; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQ44N7Id"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746891810; x=1778427810;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=75pnexBZNTe6ZbM5UY7Nv8mUeOOj5+n3QivN8HzKwBI=;
  b=iQ44N7IdulAdaiufEeAXc6N1EgG/kptHUZOC2C3BujCbbN8p2JG5196d
   WUjh/1bNNb9wy0vBPHF82GZAV8A0w3MTLu7y3PI4Ya4JKqleKoWGXYYXS
   6kqdUHksuyQdQUAZzKyY4EW0Tt8kO76Ngjn2dleHtYkebuCT35sFZJHSM
   18LpTlmsIHcIcgEv1u0aOCa7UIiyMaMN9hatweYmxXQTabk2TlCWW9brm
   zcNLafUeuThNpsUpAQb36bGDlGtgakXjKbe+VSnIw+ihc+CX+vDUaFWVt
   3hVYoQcW5GZqXjS4ZoqZCWNPGINWfayKCsnTgJ7ckMSATdFyQUNWcIKfG
   A==;
X-CSE-ConnectionGUID: uAAdiJc4TBuFkxpwcuhDyg==
X-CSE-MsgGUID: 4Y8v+8ntQY2gasdNqj9vtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11429"; a="48870375"
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="48870375"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 08:43:30 -0700
X-CSE-ConnectionGUID: AAPKDbWyTEOpc3ApOTnKCg==
X-CSE-MsgGUID: +6vFq9isSK6PxSKvZeRq8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,278,1739865600"; 
   d="scan'208";a="142009116"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 10 May 2025 08:43:29 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uDmMI-000DBH-1F;
	Sat, 10 May 2025 15:43:26 +0000
Date: Sat, 10 May 2025 23:42:59 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 6/6] crypto: hmac - Add ahash support
Message-ID: <202505102347.IvvpwcPQ-lkp@intel.com>
References: <f67cc874594fd2cc873667530c83e239ae09db81.1746448291.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f67cc874594fd2cc873667530c83e239ae09db81.1746448291.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250509]
[cannot apply to herbert-crypto-2.6/master linus/master v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Handle-partial-blocks-in-API/20250505-203411
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/f67cc874594fd2cc873667530c83e239ae09db81.1746448291.git.herbert%40gondor.apana.org.au
patch subject: [PATCH 6/6] crypto: hmac - Add ahash support
config: mips-eyeq6_defconfig (https://download.01.org/0day-ci/archive/20250510/202505102347.IvvpwcPQ-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250510/202505102347.IvvpwcPQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505102347.IvvpwcPQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> crypto/hmac.c:231:12: warning: stack frame size (1152) exceeds limit (1024) in 'hmac_setkey_ahash' [-Wframe-larger-than]
     231 | static int hmac_setkey_ahash(struct crypto_ahash *parent,
         |            ^
   1 warning generated.


vim +/hmac_setkey_ahash +231 crypto/hmac.c

   230	
 > 231	static int hmac_setkey_ahash(struct crypto_ahash *parent,
   232				     const u8 *inkey, unsigned int keylen)
   233	{
   234		struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(parent);
   235		struct crypto_ahash *fb = crypto_ahash_fb(tctx->hash);
   236		int ds = crypto_ahash_digestsize(parent);
   237		int bs = crypto_ahash_blocksize(parent);
   238		int ss = crypto_ahash_statesize(parent);
   239		HASH_REQUEST_ON_STACK(req, fb);
   240		u8 *opad = &tctx->pads[ss];
   241		u8 *ipad = &tctx->pads[0];
   242		int err, i;
   243	
   244		if (fips_enabled && (keylen < 112 / 8))
   245			return -EINVAL;
   246	
   247		ahash_request_set_callback(req, 0, NULL, NULL);
   248	
   249		if (keylen > bs) {
   250			ahash_request_set_virt(req, inkey, ipad, keylen);
   251			err = crypto_ahash_digest(req);
   252			if (err)
   253				goto out_zero_req;
   254	
   255			keylen = ds;
   256		} else
   257			memcpy(ipad, inkey, keylen);
   258	
   259		memset(ipad + keylen, 0, bs - keylen);
   260		memcpy(opad, ipad, bs);
   261	
   262		for (i = 0; i < bs; i++) {
   263			ipad[i] ^= HMAC_IPAD_VALUE;
   264			opad[i] ^= HMAC_OPAD_VALUE;
   265		}
   266	
   267		ahash_request_set_virt(req, ipad, NULL, bs);
   268		err = crypto_ahash_init(req) ?:
   269		      crypto_ahash_update(req) ?:
   270		      crypto_ahash_export(req, ipad);
   271	
   272		ahash_request_set_virt(req, opad, NULL, bs);
   273		err = err ?:
   274		      crypto_ahash_init(req) ?:
   275		      crypto_ahash_update(req) ?:
   276		      crypto_ahash_export(req, opad);
   277	
   278	out_zero_req:
   279		HASH_REQUEST_ZERO(req);
   280		return err;
   281	}
   282	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
