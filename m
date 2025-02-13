Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D82063C9;
	Thu, 13 Feb 2025 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739432820; cv=none; b=PIacdX94ees4LWPccxRug0bUiZxpN66faRuJN9+RoX72LWF+dRZMphUINtn0vodgSrsvVlkTL67SRtFmY0AAzv/thJBHfj31uRCwTsvEUCn2b6pRG/vZWloIblt1CddJcVLL+swTa2JcMNjCDuaXwhYNDHCn2Pd615yzbuZsKZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739432820; c=relaxed/simple;
	bh=m7N01gpsrS64Ul0ZF1AXLBTZ2lTKOYhMJOH5bm/b/Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njx3F3W749i4EHwD6PCD2nMEytAOoebYUllC6YWYWBEgntuhexhRj34BYqtJyKYrxMxWcRTJBaAyfnLekTpmvqimx/j3blIsJQX1zky7rLLTmC4UqeL0amTySLHM4vzLv83HnWf6S6CB4wrGmIw8SK/Wd1JTE6IDT+T2zoctWPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEvnj/Km; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEvnj/Km"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739432819; x=1770968819;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m7N01gpsrS64Ul0ZF1AXLBTZ2lTKOYhMJOH5bm/b/Gw=;
  b=jEvnj/KmTN71p2O7tzX2+RP7fPE+OPoQHi5be69Mkug3m3GqxsPXbgMW
   DUa8iJvFxrITyrz9UzwKIbmWLfCspJIVChmeymrwZs7/Tn1NodEzmgxCV
   vB+78Y7NCPy+35kgjbz3kz8NoTuFSm10WHFw9YifEvyNZeCyrpskq0Q9I
   ZaFqzxnwciHUlmExG9ydNCE26MTs40VNAErjnL8L/sHQBWF6oU/Qkdoiw
   ynuHAFGDDPNV2oRT1jA9iRpcsx2i5iw68aZDQyEynycmYabI0zJ7739RW
   0Vwk5EdhOcQ8RoZMYyKEu7H3AADgHH/Jq2j3B3b8YDPP2ROpjjIx56g0m
   g==;
X-CSE-ConnectionGUID: F5d4mfVqTTCo8n9JxIp6YQ==
X-CSE-MsgGUID: 3qqvpQWCTXKv+rJsJ6ko8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="43889586"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="43889586"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:46:58 -0800
X-CSE-ConnectionGUID: kIMk4oU5TYacoA6Out/RQA==
X-CSE-MsgGUID: unga1muWThCDLOmV4wVp6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113027361"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 12 Feb 2025 23:46:55 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiTvw-0016k1-2o;
	Thu, 13 Feb 2025 07:46:52 +0000
Date: Thu, 13 Feb 2025 15:46:00 +0800
From: kernel test robot <lkp@intel.com>
To: Akhil R <akhilrajeev@nvidia.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH v2 05/10] crypto: tegra: Transfer HASH init function to
 crypto engine
Message-ID: <202502131554.aBNVn7S9-lkp@intel.com>
References: <20250211171713.65770-6-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211171713.65770-6-akhilrajeev@nvidia.com>

Hi Akhil,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-crypto-2.6/master]
[also build test WARNING on herbert-cryptodev-2.6/master linus/master v6.14-rc2 next-20250212]
[cannot apply to tegra/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Akhil-R/crypto-tegra-Use-separate-buffer-for-setkey/20250212-012434
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
patch link:    https://lore.kernel.org/r/20250211171713.65770-6-akhilrajeev%40nvidia.com
patch subject: [PATCH v2 05/10] crypto: tegra: Transfer HASH init function to crypto engine
config: i386-buildonly-randconfig-002-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131554.aBNVn7S9-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502131554.aBNVn7S9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131554.aBNVn7S9-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/crypto/tegra/tegra-se-hash.c:8:
   In file included from include/linux/dma-mapping.h:8:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/crypto/tegra/tegra-se-hash.c:657:6: warning: unused variable 'ret' [-Wunused-variable]
     657 |         int ret;
         |             ^~~
   2 warnings generated.
--
   In file included from drivers/crypto/tegra/tegra-se-aes.c:8:
   In file included from include/linux/dma-mapping.h:8:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/crypto/tegra/tegra-se-aes.c:1788:6: warning: unused variable 'ret' [-Wunused-variable]
    1788 |         int ret;
         |             ^~~
   2 warnings generated.


vim +/ret +657 drivers/crypto/tegra/tegra-se-hash.c

0880bb3b00c855 Akhil R     2024-04-03  651  
0880bb3b00c855 Akhil R     2024-04-03  652  static int tegra_sha_digest(struct ahash_request *req)
0880bb3b00c855 Akhil R     2024-04-03  653  {
0880bb3b00c855 Akhil R     2024-04-03  654  	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
0880bb3b00c855 Akhil R     2024-04-03  655  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
0880bb3b00c855 Akhil R     2024-04-03  656  	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
15589bda468306 Chen Ridong 2024-11-11 @657  	int ret;
0880bb3b00c855 Akhil R     2024-04-03  658  
0880bb3b00c855 Akhil R     2024-04-03  659  	if (ctx->fallback)
0880bb3b00c855 Akhil R     2024-04-03  660  		return tegra_sha_fallback_digest(req);
0880bb3b00c855 Akhil R     2024-04-03  661  
0c179ef38db723 Akhil R     2025-02-11  662  	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
0880bb3b00c855 Akhil R     2024-04-03  663  
0880bb3b00c855 Akhil R     2024-04-03  664  	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
0880bb3b00c855 Akhil R     2024-04-03  665  }
0880bb3b00c855 Akhil R     2024-04-03  666  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
