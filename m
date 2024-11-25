Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C218A922;
	Mon, 25 Nov 2024 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732540686; cv=none; b=b+Ogm9Thk2SRR29OxRnoEj1D1zNuVuew4DdW0NLN72NU3d5WkiGXcuBjHvHKhhiwTa8RoV6QK5twlpq9jJxmrD28vp1PxA4SMG3/tzRARNr3nrBhSQ1ZhlDUqlZYB+q7dg4TIa5CpjAzcZ9flfmzpbVMvaFAXq7j5ATesYMGz1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732540686; c=relaxed/simple;
	bh=90GdErDfqH3TbSI8xoxeF3mLsBpbfOPnjyRbEkwAr8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFnPDel4sf/IE0ClfC6wN52IRXdrorR4QgOhgp2gwG7lpPX6GfpBGvc5UmBU1M/sNUK4orLvjcFz3GkgtPT8n+8Ijc2yzlvuBBgPC1yQJSucHT/v1Mu1yBRVxOAbRGDQBRz4yHtB1U1UgzeEqmWrMNcLadTCkI2VZMQWAZhbxHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M3JQE0o0; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M3JQE0o0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732540685; x=1764076685;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=90GdErDfqH3TbSI8xoxeF3mLsBpbfOPnjyRbEkwAr8I=;
  b=M3JQE0o010b0uL5uFgoEa2sCDXScG8IiKTbVmKmpcxusWMq8DGjjX0wK
   iZKzykWmPZ1UHEfU2CUY5syic47LDe+x3zUVWgeklscXMF7OfHZmYkqpG
   XPcYTnMoUQ2u2TCG6PtqBeDBRoXSqP1B+rLOKt4wIPwftZlRH+HDaKsXz
   /QQ3DZDNedZkL6NXjsLVJGXg7u/e4gZUlddWOKgYL8Aa9WRCq1R3QyDUz
   v399e4ld3CwNO+AUCe8gS2pH8A3LTav8QRNLVixrZAflTQdi2SrowILzO
   T1NX1XVHZKVPIKAiCRXT9WdGhkyR5TJ8aD1gHy+bPcfKB34rbNuFssMpO
   g==;
X-CSE-ConnectionGUID: OjgxB8pQRZWI3YaLrW1jWA==
X-CSE-MsgGUID: y0u1KQpLRN+gXthM66YtyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43145213"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="43145213"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:18:04 -0800
X-CSE-ConnectionGUID: Qv+DsYSFQWqk/plthBEMMQ==
X-CSE-MsgGUID: wsOnNtBsT8m5Z3MeEKLcwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91161329"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 25 Nov 2024 05:18:02 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFYyV-0006QD-1E;
	Mon, 25 Nov 2024 13:17:59 +0000
Date: Mon, 25 Nov 2024 21:17:12 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH 1/2] padata: add pd get/put refcnt helper
Message-ID: <202411252108.XGoGQSTI-lkp@intel.com>
References: <20241123080509.2573987-2-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123080509.2573987-2-chenridong@huaweicloud.com>

Hi Chen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.12 next-20241125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/padata-add-pd-get-put-refcnt-helper/20241125-111043
base:   linus/master
patch link:    https://lore.kernel.org/r/20241123080509.2573987-2-chenridong%40huaweicloud.com
patch subject: [PATCH 1/2] padata: add pd get/put refcnt helper
config: x86_64-randconfig-161-20241125 (https://download.01.org/0day-ci/archive/20241125/202411252108.XGoGQSTI-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241125/202411252108.XGoGQSTI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411252108.XGoGQSTI-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/padata.c:1134:24: warning: variable 'pd' set but not used [-Wunused-but-set-variable]
    1134 |         struct parallel_data *pd;
         |                               ^
   1 warning generated.


vim +/pd +1134 kernel/padata.c

bbefa1dd6a6d53 Herbert Xu   2019-11-26  1126  
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1127  /**
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1128   * padata_free_shell - free a padata shell
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1129   *
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1130   * @ps: padata shell to free
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1131   */
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1132  void padata_free_shell(struct padata_shell *ps)
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1133  {
7ddc21e317b360 WangJinchao  2023-10-16 @1134  	struct parallel_data *pd;
7ddc21e317b360 WangJinchao  2023-10-16  1135  
07b24c7c08bdc2 Eric Biggers 2020-02-25  1136  	if (!ps)
07b24c7c08bdc2 Eric Biggers 2020-02-25  1137  		return;
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1138  
07b24c7c08bdc2 Eric Biggers 2020-02-25  1139  	mutex_lock(&ps->pinst->lock);
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1140  	list_del(&ps->list);
7ddc21e317b360 WangJinchao  2023-10-16  1141  	pd = rcu_dereference_protected(ps->pd, 1);
31df8a12c672a5 Chen Ridong  2024-11-23  1142  	padata_put_pd(ps->pd);
07b24c7c08bdc2 Eric Biggers 2020-02-25  1143  	mutex_unlock(&ps->pinst->lock);
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1144  
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1145  	kfree(ps);
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1146  }
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1147  EXPORT_SYMBOL(padata_free_shell);
bbefa1dd6a6d53 Herbert Xu   2019-11-26  1148  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
