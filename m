Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25F23D294;
	Tue, 13 Jan 2026 02:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768270716; cv=none; b=bEZQBirO7k69z7S0dnw+MX+Mv+Dy1ax4Uh7E4CV0EUh9aWncjonfsQGL2+FRt+8prkSK26Mf6AxJySBNiNHmFl7GEsT+seZrPONZg6agSMAGr35J8igcpBmSfXv+FSdXus37aiei/OH3+8kV7TRKAVOdy0yyEhDXAgyw3Hwaa/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768270716; c=relaxed/simple;
	bh=Yec0sfDxBI6Ht33ZuzbnIrm9kfnOv8pNuShawqEPPNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0tMnVX4tqYlc0pzQEvJ2kRGyj4xDzhhI0fmcFHMuI6UmecItoomiYcIpq7Q8Wqr1LbhHSy++k8/mtmzy/ptN35Cm3JWwoAxPSg9FBkktmPFzkhI7mQYdbnLQxoCi3exLtX4HodKqmXTPD87wRptiimJV+aowvEwDM5kDt9+Yyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgyZlt7/; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgyZlt7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768270715; x=1799806715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yec0sfDxBI6Ht33ZuzbnIrm9kfnOv8pNuShawqEPPNo=;
  b=LgyZlt7/BI/1T7cWm2DoaiWjW9fgA4KjbSJootIc/8u092yadXdDQq2W
   QoXKAlj/IB8Fhzj3uTBKCK8+VXhUQkmINjt9QxxKizkTso2Ai7pfCr1Mo
   f1OoTCtj+szVlxmkgsgJAbTJc30mARu6ODxxLdJsCJkthm1oH9hHseAUc
   gGm6eY1v1hqO+3YsCpy52v00Z5dj4LJSn17DoAoS4Z/5eInEZd2PQHJnL
   ZdQ2PVNK8lsMa1oKRj22F9Yri1OvC9YMr2yAUh7sRbdE+HE1oaLrlyaIf
   uXAR9bJm1Ik1SqQ2MrOLJ0QLFYveXR/4+HDafGY+R9/pBijgc6RD6Fwq6
   Q==;
X-CSE-ConnectionGUID: rAx8gbO9Qaau7GM0qXFuVw==
X-CSE-MsgGUID: ha13WdRvT5iyQeeZ/ISFyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="73184143"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="73184143"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 18:18:35 -0800
X-CSE-ConnectionGUID: wNJWnrmuQbep4LDKovdUiQ==
X-CSE-MsgGUID: sb3tkOFtS0Gig7MufspTXg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 12 Jan 2026 18:18:19 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfTz6-00000000E68-3fEh;
	Tue, 13 Jan 2026 02:18:16 +0000
Date: Tue, 13 Jan 2026 10:17:53 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	ebiggers@kernel.org, elver@google.com, gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	mcgrof@kernel.org, rmoar@google.com, shuah@kernel.org
Subject: Re: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
Message-ID: <202601130828.lXrl0Ijb-lkp@intel.com>
References: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.19-rc5 next-20260109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/kfuzztest-add-user-facing-API-and-data-structures/20260113-033045
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260112192827.25989-5-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260113/202601130828.lXrl0Ijb-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601130828.lXrl0Ijb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601130828.lXrl0Ijb-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 function parameter 'buf' not described in 'underflow_on_buffer'
>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 function parameter 'buflen' not described in 'underflow_on_buffer'
>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 expecting prototype for test_underflow_on_buffer(). Prototype was for underflow_on_buffer() instead

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
