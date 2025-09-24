Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B722D5425;
	Wed, 24 Sep 2025 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758706157; cv=none; b=a9468d/WQaDeOa2ujnjI0J9sL+RUgrCmBSYNRBQVJ1lip4zNNcIlIigHx2KPiOy+Hyo9yKSTKiCYOXvWpSZQT/sGJyVIFwfTLctyb1ADUaeSpT2TbzckBjix4E4I0qmi8WZyCA3ZfPJk0IGs3VG7OD7qAAbk+4pFnjYg5Pw35TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758706157; c=relaxed/simple;
	bh=yMSkQplP3rHZaWo2oMDZguxX9qzRed9Ka3XpCLi17Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYCQ1bpr6i/hhZXC+hcWcP/0QsylLF/KLCsN2Npqu9Ibuxrv7n44q1C/7Pse8E6oZI/6+23Nqos19faTsVS0BV4grnVf6RKUP7feYVZEFTLLtSAS/AUWvmTZvAJFEnBftEKuHwYJjR6ftVdyn0N144Rnc+QBm3b/0tJbWJjv+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UP/8GIUv; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UP/8GIUv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758706152; x=1790242152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yMSkQplP3rHZaWo2oMDZguxX9qzRed9Ka3XpCLi17Ng=;
  b=UP/8GIUv3ojPGmVsTemU3IaFaVkXNZiPi3C3bMfMvO8bxvrHfB0qZh/1
   VTEqK/AzpTFsvNqI0ujVsvfZgCgmqENpl0YpUr9vRmcLK5SfGFpz3K0rh
   bhzS2F6S/jlj8u/EzdUz8XDN2k/BqkCP51RJ9LnYlclNhqJztHZiCNjD+
   T8NHyRhqgsRhGFKwJD5IauvJeu47KXneYcXdy1bWK3Wk9KhPa3ROavb1H
   f5Z7xe6pgZERAwwb+MDXOR0dWWWJkqe4QI4d0FuVpwzHzq9Krj+SnLV9+
   RMA/SFvffHCCDO9SbLUP74WXXmGGLt+4Rf2VOYxrIpY6in1kA7ERmYaI4
   Q==;
X-CSE-ConnectionGUID: He1Z25QsTNKwU5EkboLmUQ==
X-CSE-MsgGUID: htwreu49TEeLL2UUNTWi0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60702490"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="60702490"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 02:29:12 -0700
X-CSE-ConnectionGUID: AoNF+o4URPO9+pRaHhaaHQ==
X-CSE-MsgGUID: /rwmqYRdQFCX2ffO479rtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="182159717"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 24 Sep 2025 02:29:04 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1Lo5-000409-2y;
	Wed, 24 Sep 2025 09:29:01 +0000
Date: Wed, 24 Sep 2025 17:28:49 +0800
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
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for
 parse_xy()
Message-ID: <202509241655.GL49TRF9-lkp@intel.com>
References: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc7 next-20250923]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250919-225911
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250919145750.3448393-9-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
config: x86_64-randconfig-008-20250924 (https://download.01.org/0day-ci/archive/20250924/202509241655.GL49TRF9-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250924/202509241655.GL49TRF9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509241655.GL49TRF9-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kfuzztest_parse_and_relocate" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "record_invocation" [drivers/auxdisplay/charlcd.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
