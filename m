Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A622539C;
	Fri, 20 Jun 2025 07:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750402926; cv=none; b=ABPyZkIJj3gfW2qea3GYTgJAvkEQSJRtvJkIYJqASvqewbfbapevL4CCXgyY4DU3nm3ts+QBED+8wyGKsuAylp7qCU9nHScA8JJpWoc5qg+CtLxrDcuhHCrxQ1LEmZMtr3GR/lBW1BZxXc92tJnCrIasyQ/Kp3vNgoneDT7t7ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750402926; c=relaxed/simple;
	bh=cguC+18B3LYpEpOYQWIX0LufCfRWMzRtUkx7BVhr8Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5vGlL10asCmbrAUHI+PrUg+SlMYVKAhrH3prKU4yX9FlaqnML3DopQaJfePPh7MELoWCxPZVieQAOqP6j54GhTVevWJk4TKe50LsW+O7/qGHq1vqP7wasUvQfTU22pQYWubKIwS/f4ws3wF/tnuf5nflkc3CbyczkLwjvKVljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0aSiUST; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0aSiUST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750402924; x=1781938924;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cguC+18B3LYpEpOYQWIX0LufCfRWMzRtUkx7BVhr8Vw=;
  b=M0aSiUSTddaW1KJprIl0fTXM0dIVLX/ctEtPY6STVURfY9XSrqGvNMhg
   IsSdpaIS9Frrp0XplS2qKlLqh6aMZzPQJnrhdBdkEvMVW6AEWo9NPiqIl
   X2HEvDoo42b0I+H886jEBSDsSz18LQsUXwyBdN8BHuAYmdU33YGCn3wtl
   15PZajocVuqst+mZfGCOKqIewqN8eGzxvGy5fba3jNIo1qiTJZJb1btyl
   RLj9rvE6Dw3Iv6nO9VtloPpDVr6GZShL/JhFyiCEQYJXptFAspFuaKc1A
   z/7nDFWuzP/nyleVQzWazxw79i0fIwu4z/S2Oc3Dpz4nagAd5RD2a9K13
   A==;
X-CSE-ConnectionGUID: OdiG2HpRTSu2I1QoHRJP8A==
X-CSE-MsgGUID: niq4RsVpT9y1+hB8BwK2Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52582114"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="52582114"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 00:01:42 -0700
X-CSE-ConnectionGUID: l3W9HF2kRq2LarNB3nWG4g==
X-CSE-MsgGUID: aLT0l/gnTpSJsS3dx47Oow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="155116975"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 20 Jun 2025 00:01:40 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uSVko-000LSs-1h;
	Fri, 20 Jun 2025 07:01:38 +0000
Date: Fri, 20 Jun 2025 15:01:04 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/3] lib/crc/crc32: change crc32() from macro to inline
 function and remove cast
Message-ID: <202506201401.OhkkTlo0-lkp@intel.com>
References: <20250619183414.100082-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250619183414.100082-3-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build errors:

[auto build test ERROR on ee925097a5a76eaf9c4954cdd7288a070d57a8d4]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/lib-crc-crc32-document-crc32_le-crc32_be-and-crc32c/20250620-023634
base:   ee925097a5a76eaf9c4954cdd7288a070d57a8d4
patch link:    https://lore.kernel.org/r/20250619183414.100082-3-ebiggers%40kernel.org
patch subject: [PATCH 2/3] lib/crc/crc32: change crc32() from macro to inline function and remove cast
config: x86_64-buildonly-randconfig-004-20250620 (https://download.01.org/0day-ci/archive/20250620/202506201401.OhkkTlo0-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250620/202506201401.OhkkTlo0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506201401.OhkkTlo0-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/nvmem/layouts/u-boot-env.c: In function 'u_boot_env_parse':
>> drivers/nvmem/layouts/u-boot-env.c:151:16: error: called object 'crc32' is not a function or function pointer
     151 |         calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
         |                ^~~~~
   drivers/nvmem/layouts/u-boot-env.c:99:18: note: declared here
      99 |         uint32_t crc32;
         |                  ^~~~~


vim +/crc32 +151 drivers/nvmem/layouts/u-boot-env.c

5f15811286aff4 Rafał Miłecki 2024-09-02   88  
5f15811286aff4 Rafał Miłecki 2024-09-02   89  int u_boot_env_parse(struct device *dev, struct nvmem_device *nvmem,
5f15811286aff4 Rafał Miłecki 2024-09-02   90  		     enum u_boot_env_format format)
5f15811286aff4 Rafał Miłecki 2024-09-02   91  {
5f15811286aff4 Rafał Miłecki 2024-09-02   92  	size_t crc32_data_offset;
5f15811286aff4 Rafał Miłecki 2024-09-02   93  	size_t crc32_data_len;
5f15811286aff4 Rafał Miłecki 2024-09-02   94  	size_t crc32_offset;
5f15811286aff4 Rafał Miłecki 2024-09-02   95  	__le32 *crc32_addr;
5f15811286aff4 Rafał Miłecki 2024-09-02   96  	size_t data_offset;
5f15811286aff4 Rafał Miłecki 2024-09-02   97  	size_t data_len;
5f15811286aff4 Rafał Miłecki 2024-09-02   98  	size_t dev_size;
5f15811286aff4 Rafał Miłecki 2024-09-02   99  	uint32_t crc32;
5f15811286aff4 Rafał Miłecki 2024-09-02  100  	uint32_t calc;
5f15811286aff4 Rafał Miłecki 2024-09-02  101  	uint8_t *buf;
5f15811286aff4 Rafał Miłecki 2024-09-02  102  	int bytes;
5f15811286aff4 Rafał Miłecki 2024-09-02  103  	int err;
5f15811286aff4 Rafał Miłecki 2024-09-02  104  
5f15811286aff4 Rafał Miłecki 2024-09-02  105  	dev_size = nvmem_dev_size(nvmem);
5f15811286aff4 Rafał Miłecki 2024-09-02  106  
5f15811286aff4 Rafał Miłecki 2024-09-02  107  	buf = kzalloc(dev_size, GFP_KERNEL);
5f15811286aff4 Rafał Miłecki 2024-09-02  108  	if (!buf) {
5f15811286aff4 Rafał Miłecki 2024-09-02  109  		err = -ENOMEM;
5f15811286aff4 Rafał Miłecki 2024-09-02  110  		goto err_out;
5f15811286aff4 Rafał Miłecki 2024-09-02  111  	}
5f15811286aff4 Rafał Miłecki 2024-09-02  112  
5f15811286aff4 Rafał Miłecki 2024-09-02  113  	bytes = nvmem_device_read(nvmem, 0, dev_size, buf);
5f15811286aff4 Rafał Miłecki 2024-09-02  114  	if (bytes < 0) {
5f15811286aff4 Rafał Miłecki 2024-09-02  115  		err = bytes;
5f15811286aff4 Rafał Miłecki 2024-09-02  116  		goto err_kfree;
5f15811286aff4 Rafał Miłecki 2024-09-02  117  	} else if (bytes != dev_size) {
5f15811286aff4 Rafał Miłecki 2024-09-02  118  		err = -EIO;
5f15811286aff4 Rafał Miłecki 2024-09-02  119  		goto err_kfree;
5f15811286aff4 Rafał Miłecki 2024-09-02  120  	}
5f15811286aff4 Rafał Miłecki 2024-09-02  121  
5f15811286aff4 Rafał Miłecki 2024-09-02  122  	switch (format) {
5f15811286aff4 Rafał Miłecki 2024-09-02  123  	case U_BOOT_FORMAT_SINGLE:
5f15811286aff4 Rafał Miłecki 2024-09-02  124  		crc32_offset = offsetof(struct u_boot_env_image_single, crc32);
5f15811286aff4 Rafał Miłecki 2024-09-02  125  		crc32_data_offset = offsetof(struct u_boot_env_image_single, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  126  		data_offset = offsetof(struct u_boot_env_image_single, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  127  		break;
5f15811286aff4 Rafał Miłecki 2024-09-02  128  	case U_BOOT_FORMAT_REDUNDANT:
5f15811286aff4 Rafał Miłecki 2024-09-02  129  		crc32_offset = offsetof(struct u_boot_env_image_redundant, crc32);
5f15811286aff4 Rafał Miłecki 2024-09-02  130  		crc32_data_offset = offsetof(struct u_boot_env_image_redundant, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  131  		data_offset = offsetof(struct u_boot_env_image_redundant, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  132  		break;
5f15811286aff4 Rafał Miłecki 2024-09-02  133  	case U_BOOT_FORMAT_BROADCOM:
5f15811286aff4 Rafał Miłecki 2024-09-02  134  		crc32_offset = offsetof(struct u_boot_env_image_broadcom, crc32);
5f15811286aff4 Rafał Miłecki 2024-09-02  135  		crc32_data_offset = offsetof(struct u_boot_env_image_broadcom, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  136  		data_offset = offsetof(struct u_boot_env_image_broadcom, data);
5f15811286aff4 Rafał Miłecki 2024-09-02  137  		break;
5f15811286aff4 Rafał Miłecki 2024-09-02  138  	}
5f15811286aff4 Rafał Miłecki 2024-09-02  139  
5f15811286aff4 Rafał Miłecki 2024-09-02  140  	if (dev_size < data_offset) {
5f15811286aff4 Rafał Miłecki 2024-09-02  141  		dev_err(dev, "Device too small for u-boot-env\n");
5f15811286aff4 Rafał Miłecki 2024-09-02  142  		err = -EIO;
5f15811286aff4 Rafał Miłecki 2024-09-02  143  		goto err_kfree;
5f15811286aff4 Rafał Miłecki 2024-09-02  144  	}
5f15811286aff4 Rafał Miłecki 2024-09-02  145  
5f15811286aff4 Rafał Miłecki 2024-09-02  146  	crc32_addr = (__le32 *)(buf + crc32_offset);
5f15811286aff4 Rafał Miłecki 2024-09-02  147  	crc32 = le32_to_cpu(*crc32_addr);
5f15811286aff4 Rafał Miłecki 2024-09-02  148  	crc32_data_len = dev_size - crc32_data_offset;
5f15811286aff4 Rafał Miłecki 2024-09-02  149  	data_len = dev_size - data_offset;
5f15811286aff4 Rafał Miłecki 2024-09-02  150  
5f15811286aff4 Rafał Miłecki 2024-09-02 @151  	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
5f15811286aff4 Rafał Miłecki 2024-09-02  152  	if (calc != crc32) {
5f15811286aff4 Rafał Miłecki 2024-09-02  153  		dev_err(dev, "Invalid calculated CRC32: 0x%08x (expected: 0x%08x)\n", calc, crc32);
5f15811286aff4 Rafał Miłecki 2024-09-02  154  		err = -EINVAL;
5f15811286aff4 Rafał Miłecki 2024-09-02  155  		goto err_kfree;
5f15811286aff4 Rafał Miłecki 2024-09-02  156  	}
5f15811286aff4 Rafał Miłecki 2024-09-02  157  
5f15811286aff4 Rafał Miłecki 2024-09-02  158  	buf[dev_size - 1] = '\0';
5f15811286aff4 Rafał Miłecki 2024-09-02  159  	err = u_boot_env_parse_cells(dev, nvmem, buf, data_offset, data_len);
5f15811286aff4 Rafał Miłecki 2024-09-02  160  
5f15811286aff4 Rafał Miłecki 2024-09-02  161  err_kfree:
5f15811286aff4 Rafał Miłecki 2024-09-02  162  	kfree(buf);
5f15811286aff4 Rafał Miłecki 2024-09-02  163  err_out:
5f15811286aff4 Rafał Miłecki 2024-09-02  164  	return err;
5f15811286aff4 Rafał Miłecki 2024-09-02  165  }
5f15811286aff4 Rafał Miłecki 2024-09-02  166  EXPORT_SYMBOL_GPL(u_boot_env_parse);
5f15811286aff4 Rafał Miłecki 2024-09-02  167  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
