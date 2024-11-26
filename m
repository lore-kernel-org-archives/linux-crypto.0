Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892281BD517;
	Tue, 26 Nov 2024 11:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732619066; cv=none; b=Hx3lACQ19a7gyOVhdYl0FROP0PbhcydzJ9o/IySl7bDKXviT9RFW4QSajceaju8k2Oh+eE5Dd9jms1HuYBpZ9MB7SzxxhnwfEJl6WtnPASHRql4lGPJxpjA7Qn8TbyExwVPXPLjZXMojgDrnoT9BtXi24YWcPQ+vAmj/miw/OG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732619066; c=relaxed/simple;
	bh=3UYSpdBhhScmFfwNokk9SRyhw7PvbAn+Go6uW15ExwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SS4exOnOOKQ1gBdvPq1TMxkGJ7L9u3GCNN0VPJmfwHVPRrS1ooy1079wfj0dBCPZmOHgRskzX2/LhsMhfmac87T+Gd6JthzCFWA5xMES/ptJ9HxDHmdzMSAe/Hnk7q04vJDkDD3nenrDyks/kW0lIsDHjElPIopJF/TC3CJn69U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cfcPKMQ0; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cfcPKMQ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732619065; x=1764155065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3UYSpdBhhScmFfwNokk9SRyhw7PvbAn+Go6uW15ExwY=;
  b=cfcPKMQ0gy2DCmpoE0vJmzyrEMt7OTaSBlWh8YteJSnjb+a2lb/+Iwa0
   sEK2D7wa+XylEVScBx8SY/3ds/QlIXdnk3bPtOFW8Ce9lxeE5bEi0REpZ
   5aTAlXjjoDDpjGpuAg13nZfIcfD/A81pJbQh9hVqOPf3oN1RwB1V5vP72
   aOnpQpOljHHa3vqM2gbBpkpYo3HeW4lVenqoDgVowOXGHbKBJqMTvLBM+
   Hy2EjAU6nkuV0vVCnnBLQASnnQ4XTmx3VQ/3g9rr3FstP6AZvHZF8KkDd
   pMk40/LwFif0gP+fwZIw54+0ZSv1XvtSJEgLvJPceGSRkDyaPrNx05y1t
   g==;
X-CSE-ConnectionGUID: JARBdAiWTniczbqY6c/ZQQ==
X-CSE-MsgGUID: 7OT8y3kmSlm639QxNFcZMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="35629881"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="35629881"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 03:04:24 -0800
X-CSE-ConnectionGUID: dpQhF7GvSayMgKDQ+Av3Xw==
X-CSE-MsgGUID: hxYvGCnPRcitHFZ1a19nuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="114841348"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 26 Nov 2024 03:04:22 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFtMh-0007EX-1P;
	Tue, 26 Nov 2024 11:04:19 +0000
Date: Tue, 26 Nov 2024 19:04:10 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH 1/2] padata: add pd get/put refcnt helper
Message-ID: <202411261818.iINyAe83-lkp@intel.com>
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
[also build test WARNING on v6.12 next-20241126]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/padata-add-pd-get-put-refcnt-helper/20241125-111043
base:   linus/master
patch link:    https://lore.kernel.org/r/20241123080509.2573987-2-chenridong%40huaweicloud.com
patch subject: [PATCH 1/2] padata: add pd get/put refcnt helper
config: x86_64-randconfig-122-20241125 (https://download.01.org/0day-ci/archive/20241126/202411261818.iINyAe83-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241126/202411261818.iINyAe83-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411261818.iINyAe83-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/padata.c:1142:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct parallel_data *pd @@     got struct parallel_data [noderef] __rcu *pd @@
   kernel/padata.c:1142:25: sparse:     expected struct parallel_data *pd
   kernel/padata.c:1142:25: sparse:     got struct parallel_data [noderef] __rcu *pd
   kernel/padata.c: note: in included file (through include/linux/swait.h, include/linux/completion.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true

vim +1142 kernel/padata.c

  1126	
  1127	/**
  1128	 * padata_free_shell - free a padata shell
  1129	 *
  1130	 * @ps: padata shell to free
  1131	 */
  1132	void padata_free_shell(struct padata_shell *ps)
  1133	{
  1134		struct parallel_data *pd;
  1135	
  1136		if (!ps)
  1137			return;
  1138	
  1139		mutex_lock(&ps->pinst->lock);
  1140		list_del(&ps->list);
  1141		pd = rcu_dereference_protected(ps->pd, 1);
> 1142		padata_put_pd(ps->pd);
  1143		mutex_unlock(&ps->pinst->lock);
  1144	
  1145		kfree(ps);
  1146	}
  1147	EXPORT_SYMBOL(padata_free_shell);
  1148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
