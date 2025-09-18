Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6F623CF12;
	Thu, 18 Sep 2025 06:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758178345; cv=none; b=ap2eqHDZO3cWvpxBniwz1NCbocTHEEPb+hLMUQZmu4PkteqUp9+zWaLI7b3Ui4TA1dur9VFhBqQTjYZmQFG4T/4xSTgVaOEAJf13t6b0zPtbxGMTXp5nXF6q8hKaHG4qVT1yn2ZXuriTkrkIQ3mFjYAQa+2IbpnlY1xuI6ogTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758178345; c=relaxed/simple;
	bh=8guvnPhfYkC4UXz0FVHEuKdw/NOn7dkFZfu4xpqkqzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nkh61g5q1D9O7MRZSjddL3oujx/WCr5xjq+AdFnnlqYzCziMqJbJ3lu5qG0B4xi+Pg6ulQsm0P4ezXXTO+CIr3bVWPthbdClZHqWGUlmp46ZQvJnfqG+YdfuUMI/FwK9UuSxM9mm/Yz8lYySphkJOxyb594ct3gEwM6tSbil14g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R39borod; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R39borod"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758178344; x=1789714344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8guvnPhfYkC4UXz0FVHEuKdw/NOn7dkFZfu4xpqkqzY=;
  b=R39borodOMahwic45e+0K3+PKBR5umzJtDlQ3OE2l4QgSURC6eEmE1Os
   ZEAfRxbWm7wa0hzSkMoOPH2++E8gPD+nnz8iJ/qdKWSfyBhbHhhXM7YAL
   yE49HPBtaUjcYfmDkrh8qdODw+++r7LEF1sqo5SDZhlf2QKOM0kieA1ML
   chY9lNpIsgReKZMXuSC5sDMmILnXSSh8uw+76fIyqxxUJ2Oaiqn4yn+5B
   Lk9GYeeSF2GvABi+cOv5Xbb9zOotA6c0AJcFaJJ0/tLRf5DT3SImlqm6Y
   amEAwLnGmJ+8Zfjk8m04pyJCdFp5qfucLcRXAQK9HfBC53y2qiOyiF8Z2
   Q==;
X-CSE-ConnectionGUID: BQ6KcDJYTaWXuaAigxQNQQ==
X-CSE-MsgGUID: 4mWpAyWoT6W7raRFZZUhHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71925018"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71925018"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:52:23 -0700
X-CSE-ConnectionGUID: Yc9nWOABRheo1JBzKZ9rOA==
X-CSE-MsgGUID: t2vfJQZQSTmlR2nJnRGstw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 17 Sep 2025 23:52:16 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz8V3-0002ql-1m;
	Thu, 18 Sep 2025 06:52:13 +0000
Date: Thu, 18 Sep 2025 14:52:04 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <202509181410.XN0MIpCh-lkp@intel.com>
References: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-8-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
config: x86_64-randconfig-121-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181410.XN0MIpCh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181410.XN0MIpCh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181410.XN0MIpCh-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> crypto/asymmetric_keys/tests/pkcs7_kfuzz.c:15:1: sparse: sparse: symbol '__fuzz_test__test_pkcs7_parse_message' was not declared. Should it be static?
--
>> crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:15:1: sparse: sparse: symbol '__fuzz_test__test_rsa_parse_pub_key' was not declared. Should it be static?
>> crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:30:1: sparse: sparse: symbol '__fuzz_test__test_rsa_parse_priv_key' was not declared. Should it be static?

vim +/__fuzz_test__test_pkcs7_parse_message +15 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c

    14	
  > 15	FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
