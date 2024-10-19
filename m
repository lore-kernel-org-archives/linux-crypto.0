Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A831DE4FE
	for <linux-crypto@vger.kernel.org>; Sat, 19 Oct 2024 11:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729336654; cv=none; b=O23DIoIh3AfCatdNImFSPK2bPCcajeXmX+9DjFc3l54SXxLRhB+Bjp7/EI8P+4e2TpwGOXzrn8ls2XjICyFF8iV0S1FpjDfrHcHCpAbZ+BPsTEULr986T8lBeZ73coaZ1Bw9yWVc0A+9I7kKQMHpGvRFCZlIqNisQncPZUsJVlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729336654; c=relaxed/simple;
	bh=Zjiq7e1fFQI6X20ENIuIYMu1sQf5Z3jfLjief1a2hqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUIacBS3mxuBS1yfnLv7RcmCBug6rwVKck1SjnHNb8xsb+M+bwznVLBX8KkXhhmsYaRQZTziIdNbyBh/l2/fE3qzXhhA2DiQKp1O9raHjAqdBXEouBX2g4ukGaCV488CePjyi+VHMa63BSseCkRN2WGGFRERa53zn3e3dVkH9ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsKQxZL2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsKQxZL2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729336652; x=1760872652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zjiq7e1fFQI6X20ENIuIYMu1sQf5Z3jfLjief1a2hqk=;
  b=nsKQxZL2ZmlfOFZfEaznKsN5u4Z42D08CCo0C2rLeUeGVGyMyKJtokay
   vKsMNHn6CeE6voNdodh8spxEW6o0sPQ7fDVxI4PWbu3PhZNq6Uc7XQxpN
   yzg/RZA0xBzi2VGG+QwiQQONT9yNqbCDyWReLjxPHNckADsX302b5HTpB
   a+UvxZd3OVwQi+H0e5xl7VBwJBNy7MsVw0VeiZR069WkBQf6UytMUGjQx
   msS5Q1GvfNsaKguD8/Zhj+i5jbGJ6uBl96HP4kJPc1jObw5xoaLmNVj1T
   ITg9oEcuz0+PNvcvQIHloKOHk6lJ/wlcZEefLj/Tkvw9BYZimaIk0IwOx
   Q==;
X-CSE-ConnectionGUID: zQ8axplxQNWsi8ENATYBgA==
X-CSE-MsgGUID: 8aKwJS6lSWiNt1BRYbyqeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11230"; a="46364195"
X-IronPort-AV: E=Sophos;i="6.11,216,1725346800"; 
   d="scan'208";a="46364195"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2024 04:17:31 -0700
X-CSE-ConnectionGUID: VewpjysSTHuDo4gn7sRuMA==
X-CSE-MsgGUID: v6rEaqerTWi0W5BAs9KmaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,216,1725346800"; 
   d="scan'208";a="109852558"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Oct 2024 04:17:30 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t27SZ-000OvZ-2Q;
	Sat, 19 Oct 2024 11:17:27 +0000
Date: Sat, 19 Oct 2024 19:16:47 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ebiggers@kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 2/2] crypto/crc32c: Provide crc32c-base alias to enable
 fuzz testing
Message-ID: <202410191558.TPVuZtME-lkp@intel.com>
References: <20241015141514.3000757-6-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015141514.3000757-6-ardb+git@google.com>

Hi Ard,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.12-rc3 next-20241018]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ard-Biesheuvel/crypto-crc32-Provide-crc32-base-alias-to-enable-fuzz-testing/20241015-221858
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241015141514.3000757-6-ardb%2Bgit%40google.com
patch subject: [PATCH 2/2] crypto/crc32c: Provide crc32c-base alias to enable fuzz testing
config: hexagon-randconfig-001-20241018 (https://download.01.org/0day-ci/archive/20241019/202410191558.TPVuZtME-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project bfe84f7085d82d06d61c632a7bad1e692fd159e4)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241019/202410191558.TPVuZtME-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410191558.TPVuZtME-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__crc32c_le_base" [crypto/crc32c_generic.ko] undefined!

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MODVERSIONS
   Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
   Selected by [y]:
   - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=y] || GCC_PLUGINS [=n]) && MODULES [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
