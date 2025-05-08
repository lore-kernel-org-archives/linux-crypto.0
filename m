Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB23221D8F
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 22:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746741894; cv=none; b=CWgFHahvFx8kn3T2ySZzsb2W71/WhXoG9k7Enhoy5uxNc4OV+Qc7fqkrV0Q8g9DfZmJA1OhdzDy7sAr5wXymkgNMbDH99AU5V30L+2R8B58vCxetjygb4Xsq45/Soq955rxndoSfh05bTCOW1He07FVUmaxpjd/NcdDmLNnaJsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746741894; c=relaxed/simple;
	bh=hn8wZ675qgkzV7Ye31mKLeSCHbv3AKPZm/m6DSzvAZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hW1eWkb/kHGVODc6e35Jf71ToV8lbDgtGgDryTvDMOMZR0bsbRy98qZWY2i3ipjkifvbBSfHviuVRZz9F0z9PRl09tQleS0Hw6It7Q6Ri/+hv2Il9Qv41a0/oe/AXJk8xYPVnZbdSzB9TdDrfq869D4YRG1HVt+9aKlJAzCDZFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2DSx2zQ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2DSx2zQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746741893; x=1778277893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hn8wZ675qgkzV7Ye31mKLeSCHbv3AKPZm/m6DSzvAZQ=;
  b=B2DSx2zQarlsUb+TrWWC79fYd7UyUuiMFgx55z40l6aArVc6oUyNt6Vc
   NuEFDeN+F+w+0Pi2QXYGXTdfvgeN7O3CwIb3y2OZEsb+iq50z210LhewQ
   CdzG90q0Otida6PlJw8NlxmcaCCsIUctRvbStFVwFxLBJwBpx8qUs8LXF
   qQGKhFYFLjvd4iS2qdBycTxCx5wQP2ryVayc9uNq291VG6s+O5LOXB5Ln
   niC0o2dmNYevE/8F4xtRAh4qhjbf/+vTBrSx17i/Uwot2fb+17/w/AO7g
   7zoopDdPlwVvt28isZX6HkQEdBhZ4yDcMg6MeAjnfo9Ftt73pNkqk/9R0
   g==;
X-CSE-ConnectionGUID: GZsiuf+SQeWwwSbE+k3Kjg==
X-CSE-MsgGUID: uW0zafM7SNmCw3peSkOwqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58765323"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="58765323"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 15:04:52 -0700
X-CSE-ConnectionGUID: 6bjfNsRaS0uB13kdk8gHBg==
X-CSE-MsgGUID: A0d901TWQW6wpbil0R0ffA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="173599792"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 08 May 2025 15:04:51 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uD9MG-000BPx-3B;
	Thu, 08 May 2025 22:04:48 +0000
Date: Fri, 9 May 2025 06:03:51 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/6] crypto: ahash - Handle partial blocks in API
Message-ID: <202505090505.7uAKB19V-lkp@intel.com>
References: <26a6ba5a71b8848c6e79757a596ecc3838bf320e.1746448291.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26a6ba5a71b8848c6e79757a596ecc3838bf320e.1746448291.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250508]
[cannot apply to herbert-crypto-2.6/master linus/master v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Handle-partial-blocks-in-API/20250505-203411
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/26a6ba5a71b8848c6e79757a596ecc3838bf320e.1746448291.git.herbert%40gondor.apana.org.au
patch subject: [PATCH 2/6] crypto: ahash - Handle partial blocks in API
config: nios2-randconfig-r073-20250509 (https://download.01.org/0day-ci/archive/20250509/202505090505.7uAKB19V-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 13.3.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505090505.7uAKB19V-lkp@intel.com/

smatch warnings:
crypto/ahash.c:370 ahash_do_req_chain() warn: inconsistent indenting

vim +370 crypto/ahash.c

   338	
   339	static int ahash_do_req_chain(struct ahash_request *req,
   340				      int (*const *op)(struct ahash_request *req))
   341	{
   342		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
   343		int err;
   344	
   345		if (crypto_ahash_req_virt(tfm) || !ahash_request_isvirt(req))
   346			return (*op)(req);
   347	
   348		if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
   349			return -ENOSYS;
   350	
   351		{
   352			u8 state[HASH_MAX_STATESIZE];
   353	
   354			if (op == &crypto_ahash_alg(tfm)->digest) {
   355				ahash_request_set_tfm(req, crypto_ahash_fb(tfm));
   356				err = crypto_ahash_digest(req);
   357				goto out_no_state;
   358			}
   359	
   360			err = crypto_ahash_export(req, state);
   361			ahash_request_set_tfm(req, crypto_ahash_fb(tfm));
   362			err = err ?: crypto_ahash_import(req, state);
   363	
   364			if (op == &crypto_ahash_alg(tfm)->finup) {
   365				err = err ?: crypto_ahash_finup(req);
   366				goto out_no_state;
   367			}
   368	
   369			err = err ?: crypto_ahash_update(req);
 > 370				     crypto_ahash_export(req, state);
   371	
   372			ahash_request_set_tfm(req, tfm);
   373			return err ?: crypto_ahash_import(req, state);
   374	
   375	out_no_state:
   376			ahash_request_set_tfm(req, tfm);
   377			return err;
   378		}
   379	}
   380	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
