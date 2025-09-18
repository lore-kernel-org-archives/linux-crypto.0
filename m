Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A501E25FA;
	Thu, 18 Sep 2025 03:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758165543; cv=none; b=lR6zLNdS4sAplXOUlTdd/Dmk0mH93rKV0G/KRhscC4bbentjcmxRFFnfwE0KYQEyGI+rcQBFOPZJNnSwR+HfxWtZQKwOCE7xMkKqUUkSLiX17dR5z4qTe+XqnYPY4N/s23o+bc9oRbrQHRxo692IjcpxmiY2K8kJvrpHGzB3snE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758165543; c=relaxed/simple;
	bh=F5lh9XX2wr6nkkLJ+ixkgrNSuR5uHERQJKhZx7YZtOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkfRKIpo2+pFmTDJJw7GXX9QiPIZV9Ux1/Vb2z//MraxXT4Ggsyp9ri6my89D5Hs9Si3CXd9Xa/2kvRG6MLOcQDf/c2SKDnKxJp8NtSMAthUGERb9G+jAFJr4nQb3ZSkLXkDxHKVb5qMLiWrN56/K1bWoDcLl/JBIvovwgnht6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HT15zk2u; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HT15zk2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758165542; x=1789701542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F5lh9XX2wr6nkkLJ+ixkgrNSuR5uHERQJKhZx7YZtOw=;
  b=HT15zk2upXskmw0bS82X57RLKjEjuG5MrcU55wsVBmhzlUYtzsxhSBSP
   BmqxoHHRpmBznmPxleUVcSa0h3gu0cDWNFbWJ+JjaWVpWLFVeLqGGZd2w
   /H803woe0ZEHbvuwVxSbmAQGHf/XOroD5VKMcAA4hyOs0rKDHHqIHWZFM
   UBfbJ/FRMc9pZJ58Sq3ZKHxfNw/WRGkZMBYQFzVzPlZdA1ideqBzNfhnw
   wC/vlzf+YrvrISVVuV0wUzL6/BAKf26GRrZmWBD28HzQ8M8OHtlH3uBjE
   Wm2uG6fucoG6TSA/qNyI+stb6Lx0DlhKevhbgtkzqflEaktOOk6PRf0/z
   w==;
X-CSE-ConnectionGUID: F3x9MXKBR0C5Qx/uNDFwng==
X-CSE-MsgGUID: IgKDntNOToW4q5GpQUxXXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71166101"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71166101"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 20:19:01 -0700
X-CSE-ConnectionGUID: 3G2x57egTrGvbePk9Tt6tg==
X-CSE-MsgGUID: VibjPdNIQKS4LH6sSyukmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="174709563"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 17 Sep 2025 20:18:55 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz5Aa-0002hL-0s;
	Thu, 18 Sep 2025 03:18:52 +0000
Date: Thu, 18 Sep 2025 11:17:59 +0800
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
Subject: Re: [PATCH v1 06/10] kfuzztest: add KFuzzTest sample fuzz targets
Message-ID: <202509181042.zCqqD9To-lkp@intel.com>
References: <20250916090109.91132-7-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-7-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-7-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 06/10] kfuzztest: add KFuzzTest sample fuzz targets
config: x86_64-randconfig-r112-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181042.zCqqD9To-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181042.zCqqD9To-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181042.zCqqD9To-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> samples/kfuzztest/overflow_on_nested_buffer.c:63:1: sparse: sparse: symbol '__fuzz_test__test_overflow_on_nested_buffer' was not declared. Should it be static?
--
>> samples/kfuzztest/underflow_on_buffer.c:53:1: sparse: sparse: symbol '__fuzz_test__test_underflow_on_buffer' was not declared. Should it be static?

vim +/__fuzz_test__test_overflow_on_nested_buffer +63 samples/kfuzztest/overflow_on_nested_buffer.c

    53	
    54	/**
    55	 * The KFuzzTest input format specifies that struct nested buffers should
    56	 * be expanded as:
    57	 *
    58	 * | a | b | pad[8] | *a | pad[8] | *b |
    59	 *
    60	 * where the padded regions are poisoned. We expect to trigger a KASAN report by
    61	 * overflowing one byte into the `a` buffer.
    62	 */
  > 63	FUZZ_TEST(test_overflow_on_nested_buffer, struct nested_buffers)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
