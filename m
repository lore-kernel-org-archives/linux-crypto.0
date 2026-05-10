Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155B318027;
	Sun, 10 May 2026 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778422646; cv=none; b=YD1bro1E2zyOF8W/O5Z5tCz4KnBpvrOgq/AnvUxwS6ZDgAb5qi7R16zPERlHmNLi7TGzpdtCiJ7IPPr9xutQ8S4rwIynaemArqa9aIi+SbQSqAMuymIi2udZCbgyTFbYkUgC06dAmq9BWapmJBSm/x1vJW2d11ZBKAYUE3dZpKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778422646; c=relaxed/simple;
	bh=mQiymaK1RJGr6VXYARNs37V5k7wDzApZHtcH74prrDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvFjWi5UxlesXV1y3/iphhC+27yZokgwt/3g4yYXI5Ts4yWCECLqAhv+IVTDWVMhKOQemmySgfAfyqppHFagrIvwaWO59c2jFTTQkMjDedgRp4of9KRf9RrQ+Vr6bZkUOFkmTRoomq7G5BvGPedhwNiafrdK1VJMaXPY7/cUGJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TqnK6mCz; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TqnK6mCz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778422645; x=1809958645;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mQiymaK1RJGr6VXYARNs37V5k7wDzApZHtcH74prrDw=;
  b=TqnK6mCzNvOVSzgqS6CV6aV0OTWXaS7RXicSZI4NVLLKT+zP1l4tEdUP
   kLDPUINRQiFEmyJDPBReseXybJFIvx5hl7MBU8pPM4gJ6w2gfrmfovRhI
   CyOJLOUPjOOdt1uCTV2hYjIPA3e0bCcyVvEvMuI74IQ0JjPzYhVL4tYu3
   nipwVyuP5TXVsHg00dQHiWZvS2OxasDK5p/UTVzXmd02yl9gZ17Q1kEDT
   7LrT+CN5pIerWmTorWHb3zi09Tp6ZPvLd6HWDmcaPvsE3QXVpC9Xp9rP9
   6DYafuRSufV/CAlk4PYXksx8rpJlLXCqrNw/NtivwmYbXBArbxCzW4mgg
   g==;
X-CSE-ConnectionGUID: NKWnFVM6TS2/ozUGpmANjQ==
X-CSE-MsgGUID: 3YtVYTTcRuags0atCJf5QQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="78470688"
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="78470688"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 07:17:25 -0700
X-CSE-ConnectionGUID: iVqyD3/rTiqc1Y7DVYxNsw==
X-CSE-MsgGUID: ufmAUg76RRi0aJq674z0aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="234565018"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 May 2026 07:17:21 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wM4y6-000000002If-3gA0;
	Sun, 10 May 2026 14:17:18 +0000
Date: Sun, 10 May 2026 22:16:42 +0800
From: kernel test robot <lkp@intel.com>
To: w15303746062@163.com, giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, thorsten.blum@linux.dev, kees@kernel.org,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: Re: [PATCH] crypto: qat - fix Use-After-Free in
 adf_ctl_ioctl_dev_start()
Message-ID: <202605102206.HtfQ4iA9-lkp@intel.com>
References: <20260508023542.256299-1-w15303746062@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508023542.256299-1-w15303746062@163.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v7.1-rc2 next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/w15303746062-163-com/crypto-qat-fix-Use-After-Free-in-adf_ctl_ioctl_dev_start/20260510-110441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260508023542.256299-1-w15303746062%40163.com
patch subject: [PATCH] crypto: qat - fix Use-After-Free in adf_ctl_ioctl_dev_start()
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20260510/202605102206.HtfQ4iA9-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260510/202605102206.HtfQ4iA9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605102206.HtfQ4iA9-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function 'adf_ctl_ioctl_dev_stop':
>> drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:286:13: error: 'accel_dev' undeclared (first use in this function); did you mean 'adf_accel_dev'?
     286 |         if (accel_dev)
         |             ^~~~~~~~~
         |             adf_accel_dev
   drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:286:13: note: each undeclared identifier is reported only once for each function it appears in


vim +286 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c

   255	
   256	static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
   257					  unsigned long arg)
   258	{
   259		int ret;
   260		struct adf_user_cfg_ctl_data *ctl_data;
   261	
   262		ctl_data = adf_ctl_alloc_resources(arg);
   263		if (IS_ERR(ctl_data))
   264			return PTR_ERR(ctl_data);
   265	
   266		if (adf_devmgr_verify_id(ctl_data->device_id)) {
   267			pr_err("QAT: Device %d not found\n", ctl_data->device_id);
   268			ret = -ENODEV;
   269			goto out;
   270		}
   271	
   272		ret = adf_ctl_is_device_in_use(ctl_data->device_id);
   273		if (ret)
   274			goto out;
   275	
   276		if (ctl_data->device_id == ADF_CFG_ALL_DEVICES)
   277			pr_info("QAT: Stopping all acceleration devices.\n");
   278		else
   279			pr_info("QAT: Stopping acceleration device qat_dev%d.\n",
   280				ctl_data->device_id);
   281	
   282		adf_ctl_stop_devices(ctl_data->device_id);
   283	
   284	out:
   285		/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
 > 286		if (accel_dev)
   287			adf_dev_put(accel_dev);
   288	
   289		kfree(ctl_data);
   290		return ret;
   291	}
   292	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
