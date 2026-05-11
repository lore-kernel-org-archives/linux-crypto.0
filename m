Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF200377003;
	Mon, 11 May 2026 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778502182; cv=none; b=jMgod9te6/Z6SJkZ2R+CynUqO+RIbapsryl5aiDcerspslVy4z7Liz8E6QQXWAfAOECp4gQ5SHb+HsAfZ2sSQ6WKsTWTwIMlyob5TSV2quNmAMkwbh2/K/htLHzFjJ32azLdp9c9aIA5teyidIvo8QIs3XAAxCjrVKGaLyW4AuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778502182; c=relaxed/simple;
	bh=P+ENBJPOk9zcHL20zVJrjU7DVRp3gZ5frQbrs7usO0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrdoQM8P1fcnGdy/yJl/naSjaqp8TF5J5jx0XJGgFHrWTqkrcLSQNeHhgtw4V3XTqQnucdnD3Ej4W+dKTScD4ghX0UJmATsQ2BSIoM1ygy9dSEFoXC0DRIv3KICzFN4/Nt7d3BcbeBPEsBqRbxDKxCjRa4yvMRaBJwrs1qj4Y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=byad/+kG; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="byad/+kG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778502181; x=1810038181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P+ENBJPOk9zcHL20zVJrjU7DVRp3gZ5frQbrs7usO0c=;
  b=byad/+kGtMkmCENr88nkUqT57vFUghmNMgsdmQv7dP3xooZIDGQacRmP
   tQvUC2cHAIuRFLc8U7tlzupL2fdjd3Xv0VLoByF6OhddGKvb0iMO4NTmw
   D1xsnTPqWojCL3oTW7G736LAAwW+dtaCtGvVuoUFlBHGPUvfFPhK2g3fL
   PMLO/7RZsNVvWfrF/Owe3PUy8PSaR4BkJKoqwtBhnyUCHgl4Gceu5Pu9T
   IC2Pg1WviQ5IXoTSBhIkRP0rO0+oJITZnchz91ueGyNE4ksuR2TAMNiQ2
   n09r1ePcVNPNH5wtmYUGIZOjVQ7+xmYezNawDaWqFR9T7t68r7LuYyNTZ
   g==;
X-CSE-ConnectionGUID: oPzN8qgGQAq5vVL5AVNEew==
X-CSE-MsgGUID: cjouo7D2SFqJaMsyLtXIdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="79370477"
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="79370477"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 05:23:00 -0700
X-CSE-ConnectionGUID: nqQPeyu6QXuD0+Xno0Pz3w==
X-CSE-MsgGUID: s40PKmb0Rb6zbksyyeuBBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="236466454"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 11 May 2026 05:22:57 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMPew-000000000XR-2r3L;
	Mon, 11 May 2026 12:22:54 +0000
Date: Mon, 11 May 2026 20:22:28 +0800
From: kernel test robot <lkp@intel.com>
To: w15303746062@163.com, giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	thorsten.blum@linux.dev, kees@kernel.org, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: Re: [PATCH] crypto: qat - fix Use-After-Free in
 adf_ctl_ioctl_dev_start()
Message-ID: <202605112040.jcfTlYZH-lkp@intel.com>
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
[also build test ERROR on herbert-crypto-2.6/master linus/master v7.1-rc3 next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/w15303746062-163-com/crypto-qat-fix-Use-After-Free-in-adf_ctl_ioctl_dev_start/20260510-110441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260508023542.256299-1-w15303746062%40163.com
patch subject: [PATCH] crypto: qat - fix Use-After-Free in adf_ctl_ioctl_dev_start()
config: loongarch-randconfig-001-20260510 (https://download.01.org/0day-ci/archive/20260511/202605112040.jcfTlYZH-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260511/202605112040.jcfTlYZH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605112040.jcfTlYZH-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:286:6: error: use of undeclared identifier 'accel_dev'
     286 |         if (accel_dev)
         |             ^~~~~~~~~
   drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:287:15: error: use of undeclared identifier 'accel_dev'
     287 |                 adf_dev_put(accel_dev);
         |                             ^~~~~~~~~
   2 errors generated.


vim +/accel_dev +286 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c

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
