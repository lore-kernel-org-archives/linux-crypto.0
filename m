Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00A9265630;
	Wed, 17 Sep 2025 23:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758152264; cv=none; b=t+8ubhf6eQvEdZYRtgd+xd02BpvlamlSXjzy0GHHowL7Ak0JxUnSzpFcAd7wvK/SUua0gRFDas5GPFtcFULszma/irukqjsESc0q3ys1EvfCv+blxH0//QLYRSvDJZU3Kal+U/ZUCy6KvINoL8xWtJctq6DAJS4mVKaKuMN2LuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758152264; c=relaxed/simple;
	bh=Tm7LDGQYbF/5OYizYxd41PtQk/zW0KgP6XlgKNQteR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9AQtZ5ZUFfc9bsC45tTkrpAjeWifZXVJKu54chBOqs3sHOZbTmUO4OtZf826SmD7V7NjPPsa12zYav0foVHG5BsLvQgI0fcAAMWq/PFJibgkkO0kD12sFbYmy1SUVWgylNkZ3rhpJd/jSisPVV/dfoofZCzG+b95PwqkgrqRAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nu6DHH9U; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nu6DHH9U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758152261; x=1789688261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tm7LDGQYbF/5OYizYxd41PtQk/zW0KgP6XlgKNQteR0=;
  b=nu6DHH9UbBjEWEyc1mfHdH/H1FyDHdgWj/8YZCm1Qa62yvGwxiO5wIaE
   etdhv7+wBJoaS7crC3xRDQD5O2hqk0AUl412UmqGX3c5Re99H99rPnYGA
   +rSMhDZefpsaBNuW5a21mAxC129mw9TTXm9NA5GyOe9l0Ly/JkF/CkRnq
   5bhvNoXkgHPsGFyg6hWP5c7nmc94+jBCMsxTSOVXgIqfj/8nHE8jEk6ZH
   fAE2fVTmpmCCb+1s6ioSyqKDROiKLr/eDbWV4X+pfZj3MlbaJvAO8uUVG
   5IshS48TtDL0MwNoDUvHuGyq+kDtA0RzVfDfiaML5oWiHL01xap4MQ0HD
   A==;
X-CSE-ConnectionGUID: Odo81/UKTpmQL/LmmFvATA==
X-CSE-MsgGUID: PJMy3xVGRu+syXYgICIrVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71576745"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71576745"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 16:37:41 -0700
X-CSE-ConnectionGUID: QcxZYuG2QOyvuJ2rkRherg==
X-CSE-MsgGUID: 5O/Z75r0RRWd2IesMQAMfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="175779636"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 17 Sep 2025 16:37:34 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz1iN-0002ZT-2Q;
	Wed, 17 Sep 2025 23:37:31 +0000
Date: Thu, 18 Sep 2025 07:37:10 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <202509180721.GaBOMCkp-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-8-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
config: x86_64-randconfig-075-20250918 (https://download.01.org/0day-ci/archive/20250918/202509180721.GaBOMCkp-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509180721.GaBOMCkp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509180721.GaBOMCkp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: pkcs7_parse_message
   >>> referenced by pkcs7_kfuzz.c:21 (crypto/asymmetric_keys/tests/pkcs7_kfuzz.c:21)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_pkcs7_parse_message)
--
>> ld.lld: error: undefined symbol: rsa_parse_pub_key
   >>> referenced by rsa_helper_kfuzz.c:22 (crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:22)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_rsa_parse_pub_key)
--
>> ld.lld: error: undefined symbol: rsa_parse_priv_key
   >>> referenced by rsa_helper_kfuzz.c:37 (crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:37)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_rsa_parse_priv_key)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
