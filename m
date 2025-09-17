Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862026C3BF;
	Wed, 17 Sep 2025 03:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758081587; cv=none; b=eMzCn8lu9/cFF0awuKzDonnBkEGYvUENK6t8rLORVZz5ylSulb/LVOfTAPphaUmke9mx/9NX/yK/za2cy6026DFVeeM7GH7wFMZtSkirrSjTf1+R72AOl59CgL/hvCdbonc1IgK1nJ1ZzLcIUZhk2VbCLahndbYayQuF/wJeiE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758081587; c=relaxed/simple;
	bh=H9thyNiLTdBDPl30sbess+15GJm36k6HegAlHIfWnHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOr28zDj/n/vOQKdCGstLMOMSQbbW2S/PxZz52/ZFGokRJNVvoUMrlhdeo+Ttcgouz56r0eLXZvWFGgo96jhrT6iM4Be1NqEWh2QCay98WNcg8SeLkNPO/xu3jw7lsbaD/7DxlpvpIO6lLqwpliUyGmyJ98Ex5uqNC7fIsAz2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DBelvs2+; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DBelvs2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758081586; x=1789617586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H9thyNiLTdBDPl30sbess+15GJm36k6HegAlHIfWnHU=;
  b=DBelvs2+fS+ZAGbH8kAqbpxPFhJGtjk71UoA28vZSiSbP7IwWWMgNIFI
   huYn7ORuvDpUP64HZ3IeveXv44fizWvx5W2T5Np2/qny/s0ITxI+3tjo6
   qbCbITWXOY4pwEFhFZ8E4BzBxTH2GWFRNpQ3e4JCseIyz+p8YOl9n0/M7
   A4Zi4+bCXKJ98S75cd+BbcxIvCCA35vKSs/nszHijM0lYcYPBbIXDjN1e
   4nnxZyMfzsh5E0Iku/CadTJtaCaFOG44qTWbWqiKzRVXjHGqU1ux+wQMM
   mJiQ8ViET2f1Jz8j9ca65S96YKDG8kh8+TpMsJBUrKFIcV1Vc7zsp/vYp
   w==;
X-CSE-ConnectionGUID: aWy5kao1SNikqQlKRb5UkA==
X-CSE-MsgGUID: 4S2p1TIHSC+aBHXQoHeJMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="60305022"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="60305022"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 20:59:45 -0700
X-CSE-ConnectionGUID: 8r1RW9JuQCOoNSWzEvSMaQ==
X-CSE-MsgGUID: 7cId5LfgQUu8YUrX2ncqBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="180266969"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 16 Sep 2025 20:59:38 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyjKS-000127-0B;
	Wed, 17 Sep 2025 03:59:36 +0000
Date: Wed, 17 Sep 2025 11:59:20 +0800
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
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input
 processing
Message-ID: <202509171131.vod7tLWH-lkp@intel.com>
References: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-4-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 03/10] kfuzztest: implement core module and input processing
config: x86_64-randconfig-004-20250917 (https://download.01.org/0day-ci/archive/20250917/202509171131.vod7tLWH-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250917/202509171131.vod7tLWH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509171131.vod7tLWH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/kfuzztest/main.c:46 struct member 'num_invocations' not described in 'kfuzztest_state'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
