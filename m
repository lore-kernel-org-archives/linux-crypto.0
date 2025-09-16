Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F4242D94
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758043233; cv=none; b=KQ1VOCwMDUCs0iGgCiwwYdYCBEM89BJJLWItCIJ6oCB8BHjmmJ3CD1FxR9K/1piNKCfQAXEoU4+/KiR11P3XiBWD9YkjxigDUrk+q2WkSpJwwvuCyCJP4eM6o5ORrccPKTsWt6cNld2mfeDU+8oa6kIPmue945UThD5Q0pBG6VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758043233; c=relaxed/simple;
	bh=WB6icsQf7LMh3VE17/HhbWF8UpBxGnNLJHUUAAOym1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2j1IL6zLq1mBqsHUiq9a17XhApyR2i+nWf7jBVRwxcIIe4HU+RON22CmkUnvAIS2iFqSle0QDwe7g8ZjVdkWARzvIALASyNFRYPGDWrOswtgrWkLZyOFZf6SVRirKAiHVFMI69XUVvcHdMD+iLlVTkq7HcDuMSnnR1cD9zrMDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqIhv3Rl; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqIhv3Rl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758043231; x=1789579231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WB6icsQf7LMh3VE17/HhbWF8UpBxGnNLJHUUAAOym1o=;
  b=GqIhv3Rlc9pIn/+WT3PvMmgurII6BzINotYNb7dcMF5hVhdDv/o0HbNH
   U+bnv8rsbHziEVZrDKfHhyoUsvE765gbjWx+8n2ObSnnWj2Fb6jWVIIyV
   VIuc5ijC3vv0XLhRA3BR09jZK0RG9GtAnQfomgR3cvUUhYBWJQh46ccXq
   XhU2vwPz21SpeQfAtXPmTwrqMsMZ/Vo+9/ChA2ouweean2ZYn/knYJqL+
   QU0bTvy+GWwbfrZhIvDJ/bBtE3qAoHRYbTWldDolimgrTsCq5qj4jyKNg
   VHcZMbTn1qivdo6v56bXTgogFjHuZJWeIBVWFWImK+7wcnPbVmyXql0Zr
   Q==;
X-CSE-ConnectionGUID: uZYNbuznTeurwAGC8Zr1Pw==
X-CSE-MsgGUID: 4sCC+Pk4Q76MDKcW/Jp8mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="59378411"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="59378411"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 10:20:31 -0700
X-CSE-ConnectionGUID: dgYQ8fQcSOCUwM1u513I7w==
X-CSE-MsgGUID: 8NjD0eQtS66lpFsShuRONw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="174562665"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 16 Sep 2025 10:20:29 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyZLu-0000Yh-2P;
	Tue, 16 Sep 2025 17:20:26 +0000
Date: Wed, 17 Sep 2025 01:19:37 +0800
From: kernel test robot <lkp@intel.com>
To: Rodolfo Giometti <giometti@enneenne.com>, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [V1 1/4] crypto ecdh.h: set key memory region as const
Message-ID: <202509170134.MOV2jymf-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rodolfo-Giometti/crypto-ecdh-h-set-key-memory-region-as-const/20250915-164558
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250915084039.2848952-2-giometti%40enneenne.com
patch subject: [V1 1/4] crypto ecdh.h: set key memory region as const
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20250917/202509170134.MOV2jymf-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250917/202509170134.MOV2jymf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509170134.MOV2jymf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/hisilicon/hpre/hpre_crypto.c: In function 'hpre_ecdh_set_secret':
>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:1430:36: warning: passing argument 1 of 'hpre_key_is_zero' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    1430 |         if (hpre_key_is_zero(params.key, params.key_size)) {
         |                              ~~~~~~^~~~
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:1369:36: note: expected 'char *' but argument is of type 'const char *'
    1369 | static bool hpre_key_is_zero(char *key, unsigned short key_sz)
         |                              ~~~~~~^~~


vim +1430 drivers/crypto/hisilicon/hpre/hpre_crypto.c

1e609f5fb73b6b Hui Tang   2021-05-29  1399  
05e7b906aa7c86 Meng Yu    2021-03-04  1400  static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
05e7b906aa7c86 Meng Yu    2021-03-04  1401  				unsigned int len)
05e7b906aa7c86 Meng Yu    2021-03-04  1402  {
05e7b906aa7c86 Meng Yu    2021-03-04  1403  	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
b0ab0797f7ab74 Weili Qian 2023-07-07  1404  	unsigned int sz, sz_shift, curve_sz;
b94c910afda050 Hui Tang   2021-05-12  1405  	struct device *dev = ctx->dev;
1e609f5fb73b6b Hui Tang   2021-05-29  1406  	char key[HPRE_ECC_MAX_KSZ];
05e7b906aa7c86 Meng Yu    2021-03-04  1407  	struct ecdh params;
05e7b906aa7c86 Meng Yu    2021-03-04  1408  	int ret;
05e7b906aa7c86 Meng Yu    2021-03-04  1409  
05e7b906aa7c86 Meng Yu    2021-03-04  1410  	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
05e7b906aa7c86 Meng Yu    2021-03-04  1411  		dev_err(dev, "failed to decode ecdh key!\n");
05e7b906aa7c86 Meng Yu    2021-03-04  1412  		return -EINVAL;
05e7b906aa7c86 Meng Yu    2021-03-04  1413  	}
05e7b906aa7c86 Meng Yu    2021-03-04  1414  
1e609f5fb73b6b Hui Tang   2021-05-29  1415  	/* Use stdrng to generate private key */
1e609f5fb73b6b Hui Tang   2021-05-29  1416  	if (!params.key || !params.key_size) {
1e609f5fb73b6b Hui Tang   2021-05-29  1417  		params.key = key;
b0ab0797f7ab74 Weili Qian 2023-07-07  1418  		curve_sz = hpre_ecdh_get_curvesz(ctx->curve_id);
b0ab0797f7ab74 Weili Qian 2023-07-07  1419  		if (!curve_sz) {
b0ab0797f7ab74 Weili Qian 2023-07-07  1420  			dev_err(dev, "Invalid curve size!\n");
b0ab0797f7ab74 Weili Qian 2023-07-07  1421  			return -EINVAL;
b0ab0797f7ab74 Weili Qian 2023-07-07  1422  		}
b0ab0797f7ab74 Weili Qian 2023-07-07  1423  
b0ab0797f7ab74 Weili Qian 2023-07-07  1424  		params.key_size = curve_sz - 1;
1e609f5fb73b6b Hui Tang   2021-05-29  1425  		ret = ecdh_gen_privkey(ctx, &params);
1e609f5fb73b6b Hui Tang   2021-05-29  1426  		if (ret)
1e609f5fb73b6b Hui Tang   2021-05-29  1427  			return ret;
1e609f5fb73b6b Hui Tang   2021-05-29  1428  	}
1e609f5fb73b6b Hui Tang   2021-05-29  1429  
05e7b906aa7c86 Meng Yu    2021-03-04 @1430  	if (hpre_key_is_zero(params.key, params.key_size)) {
05e7b906aa7c86 Meng Yu    2021-03-04  1431  		dev_err(dev, "Invalid hpre key!\n");
05e7b906aa7c86 Meng Yu    2021-03-04  1432  		return -EINVAL;
05e7b906aa7c86 Meng Yu    2021-03-04  1433  	}
05e7b906aa7c86 Meng Yu    2021-03-04  1434  
05e7b906aa7c86 Meng Yu    2021-03-04  1435  	hpre_ecc_clear_ctx(ctx, false, true);
05e7b906aa7c86 Meng Yu    2021-03-04  1436  
05e7b906aa7c86 Meng Yu    2021-03-04  1437  	ret = hpre_ecdh_set_param(ctx, &params);
05e7b906aa7c86 Meng Yu    2021-03-04  1438  	if (ret < 0) {
05e7b906aa7c86 Meng Yu    2021-03-04  1439  		dev_err(dev, "failed to set hpre param, ret = %d!\n", ret);
05e7b906aa7c86 Meng Yu    2021-03-04  1440  		return ret;
05e7b906aa7c86 Meng Yu    2021-03-04  1441  	}
05e7b906aa7c86 Meng Yu    2021-03-04  1442  
05e7b906aa7c86 Meng Yu    2021-03-04  1443  	sz = ctx->key_sz;
05e7b906aa7c86 Meng Yu    2021-03-04  1444  	sz_shift = (sz << 1) + sz - params.key_size;
05e7b906aa7c86 Meng Yu    2021-03-04  1445  	memcpy(ctx->ecdh.p + sz_shift, params.key, params.key_size);
05e7b906aa7c86 Meng Yu    2021-03-04  1446  
05e7b906aa7c86 Meng Yu    2021-03-04  1447  	return 0;
05e7b906aa7c86 Meng Yu    2021-03-04  1448  }
05e7b906aa7c86 Meng Yu    2021-03-04  1449  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
