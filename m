Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B7F2C2AA2
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758005485; cv=none; b=dEOTsi8otSDM5NwDAVJnL33iyW8pQY9GGKhMlhAjNbJmVHSkTjKijdNGyXfQ5ioYLCxq+jPJtBMoVZQ8wkfsrzzFEjKM81uwaamAF4kRdSNcZln2YtYrQVkh9MDK8RIroPNEAyJKxnZQAvoSNbv1Oeo9C9R8C1W2mvK8JkcIAhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758005485; c=relaxed/simple;
	bh=nLDuSGzHG5C1KGnA+a8+TU+vYrkKyVbKDPzT0ivqZZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0mdfcJ+L55IWsc/L7/RUfRPnxkJM4lLjdIf/1wkHpODTVeL4uSHS9eekp4yGZhGrUQQkbQPF53mJRecTPOTGdVCIarB0eMgfCidcZOcGsG9stfRTWzNgG8uwz971dbeESC3YbVQdW3AjmBZJA7cZ98EH28Jc+PnWeWiL0oaelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTkNigLG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTkNigLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758005483; x=1789541483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nLDuSGzHG5C1KGnA+a8+TU+vYrkKyVbKDPzT0ivqZZg=;
  b=aTkNigLGqKkY+YtTc/dtv17y++rowQzhzoix5y49iFNpPK9dbpj1TkI9
   IMgq/BXglspK2RNb/G8cebrmbOJujXWG/A/S/pCtZ/oRW6oR5eZdU7WNM
   jKiU1eGB9vZrKdaRFDAYaz1vxS/0ZRxfULCg79/ETEw0iwcsSKUWHS+CS
   t/9zbWVL/XCPGhxEAFqo8v+eB/KIYeQNDId80vu6jaouGkv/yHTKu7BV/
   QXMfMIft1bSRMLcs0gcGKp5jiamR+awR5igKsjZv5jhl1TDWROfQpLnV1
   mTu5rQpZLwrjY+/OABH7dKGskcGS0vcELLjBYHHbj1Vc1FK9/j+K7qtAe
   g==;
X-CSE-ConnectionGUID: E3qgCuEsRXaKW621DWTtjQ==
X-CSE-MsgGUID: w0M1pUhXQn2MJbW+oWpRtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="47848436"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="47848436"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 23:51:23 -0700
X-CSE-ConnectionGUID: n7NQzLRvQD+P+DWXnpMzWQ==
X-CSE-MsgGUID: lj2pg1j/Qie2b1nl1LsI2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174464358"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 15 Sep 2025 23:51:21 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyPX5-00002B-16;
	Tue, 16 Sep 2025 06:51:19 +0000
Date: Tue, 16 Sep 2025 14:50:50 +0800
From: kernel test robot <lkp@intel.com>
To: Rodolfo Giometti <giometti@enneenne.com>, linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [V1 1/4] crypto ecdh.h: set key memory region as const
Message-ID: <202509161457.uTdEUas6-lkp@intel.com>
References: <20250915084039.2848952-2-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915084039.2848952-2-giometti@enneenne.com>

Hi Rodolfo,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250915]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rodolfo-Giometti/crypto-ecdh-h-set-key-memory-region-as-const/20250915-164558
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250915084039.2848952-2-giometti%40enneenne.com
patch subject: [V1 1/4] crypto ecdh.h: set key memory region as const
config: riscv-randconfig-001-20250916 (https://download.01.org/0day-ci/archive/20250916/202509161457.uTdEUas6-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 65ad21d730d25789454d18e811f8ff5db79cb5d4)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250916/202509161457.uTdEUas6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509161457.uTdEUas6-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:1430:23: error: passing 'const char *' to parameter of type 'char *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
    1430 |         if (hpre_key_is_zero(params.key, params.key_size)) {
         |                              ^~~~~~~~~~
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:1369:36: note: passing argument to parameter 'key' here
    1369 | static bool hpre_key_is_zero(char *key, unsigned short key_sz)
         |                                    ^
   1 error generated.


vim +1430 drivers/crypto/hisilicon/hpre/hpre_crypto.c

1e609f5fb73b6b1 Hui Tang   2021-05-29  1399  
05e7b906aa7c869 Meng Yu    2021-03-04  1400  static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
05e7b906aa7c869 Meng Yu    2021-03-04  1401  				unsigned int len)
05e7b906aa7c869 Meng Yu    2021-03-04  1402  {
05e7b906aa7c869 Meng Yu    2021-03-04  1403  	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
b0ab0797f7ab74b Weili Qian 2023-07-07  1404  	unsigned int sz, sz_shift, curve_sz;
b94c910afda050a Hui Tang   2021-05-12  1405  	struct device *dev = ctx->dev;
1e609f5fb73b6b1 Hui Tang   2021-05-29  1406  	char key[HPRE_ECC_MAX_KSZ];
05e7b906aa7c869 Meng Yu    2021-03-04  1407  	struct ecdh params;
05e7b906aa7c869 Meng Yu    2021-03-04  1408  	int ret;
05e7b906aa7c869 Meng Yu    2021-03-04  1409  
05e7b906aa7c869 Meng Yu    2021-03-04  1410  	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
05e7b906aa7c869 Meng Yu    2021-03-04  1411  		dev_err(dev, "failed to decode ecdh key!\n");
05e7b906aa7c869 Meng Yu    2021-03-04  1412  		return -EINVAL;
05e7b906aa7c869 Meng Yu    2021-03-04  1413  	}
05e7b906aa7c869 Meng Yu    2021-03-04  1414  
1e609f5fb73b6b1 Hui Tang   2021-05-29  1415  	/* Use stdrng to generate private key */
1e609f5fb73b6b1 Hui Tang   2021-05-29  1416  	if (!params.key || !params.key_size) {
1e609f5fb73b6b1 Hui Tang   2021-05-29  1417  		params.key = key;
b0ab0797f7ab74b Weili Qian 2023-07-07  1418  		curve_sz = hpre_ecdh_get_curvesz(ctx->curve_id);
b0ab0797f7ab74b Weili Qian 2023-07-07  1419  		if (!curve_sz) {
b0ab0797f7ab74b Weili Qian 2023-07-07  1420  			dev_err(dev, "Invalid curve size!\n");
b0ab0797f7ab74b Weili Qian 2023-07-07  1421  			return -EINVAL;
b0ab0797f7ab74b Weili Qian 2023-07-07  1422  		}
b0ab0797f7ab74b Weili Qian 2023-07-07  1423  
b0ab0797f7ab74b Weili Qian 2023-07-07  1424  		params.key_size = curve_sz - 1;
1e609f5fb73b6b1 Hui Tang   2021-05-29  1425  		ret = ecdh_gen_privkey(ctx, &params);
1e609f5fb73b6b1 Hui Tang   2021-05-29  1426  		if (ret)
1e609f5fb73b6b1 Hui Tang   2021-05-29  1427  			return ret;
1e609f5fb73b6b1 Hui Tang   2021-05-29  1428  	}
1e609f5fb73b6b1 Hui Tang   2021-05-29  1429  
05e7b906aa7c869 Meng Yu    2021-03-04 @1430  	if (hpre_key_is_zero(params.key, params.key_size)) {
05e7b906aa7c869 Meng Yu    2021-03-04  1431  		dev_err(dev, "Invalid hpre key!\n");
05e7b906aa7c869 Meng Yu    2021-03-04  1432  		return -EINVAL;
05e7b906aa7c869 Meng Yu    2021-03-04  1433  	}
05e7b906aa7c869 Meng Yu    2021-03-04  1434  
05e7b906aa7c869 Meng Yu    2021-03-04  1435  	hpre_ecc_clear_ctx(ctx, false, true);
05e7b906aa7c869 Meng Yu    2021-03-04  1436  
05e7b906aa7c869 Meng Yu    2021-03-04  1437  	ret = hpre_ecdh_set_param(ctx, &params);
05e7b906aa7c869 Meng Yu    2021-03-04  1438  	if (ret < 0) {
05e7b906aa7c869 Meng Yu    2021-03-04  1439  		dev_err(dev, "failed to set hpre param, ret = %d!\n", ret);
05e7b906aa7c869 Meng Yu    2021-03-04  1440  		return ret;
05e7b906aa7c869 Meng Yu    2021-03-04  1441  	}
05e7b906aa7c869 Meng Yu    2021-03-04  1442  
05e7b906aa7c869 Meng Yu    2021-03-04  1443  	sz = ctx->key_sz;
05e7b906aa7c869 Meng Yu    2021-03-04  1444  	sz_shift = (sz << 1) + sz - params.key_size;
05e7b906aa7c869 Meng Yu    2021-03-04  1445  	memcpy(ctx->ecdh.p + sz_shift, params.key, params.key_size);
05e7b906aa7c869 Meng Yu    2021-03-04  1446  
05e7b906aa7c869 Meng Yu    2021-03-04  1447  	return 0;
05e7b906aa7c869 Meng Yu    2021-03-04  1448  }
05e7b906aa7c869 Meng Yu    2021-03-04  1449  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
