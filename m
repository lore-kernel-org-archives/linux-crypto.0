Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8AC27587E;
	Sun,  7 Dec 2025 06:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765089573; cv=none; b=SpJBQiRRxGQDej1lsR4EJ2riw8LHbLhA/La74U2QanxvHDPpC2Bi+goXKYbo5cqNxJu+0OJygZxZQqniJTi69Sxj0jb3GPG0NdoIhqvUe993d56MmRGMSpj1a5oAYnrNrmQAyQkd4jPN//wCu3qLjgsdAlrFDLnd+F/q53/pn+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765089573; c=relaxed/simple;
	bh=pbE+100Y1YKroKAkTYk/uLmS8PZhwbDp1hFCivCCkvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwvFLujkEhd77JPg9LsGOnmGV+ngCLwL5la8Q1kQWwcRxiJnKnjH8cXZjQGPw3OfXDsGXm9P/FnIKgpJXelpkJzsGK4xgV60vfA+yGaXEesxXdlqb/WORz0PjWS6DthC+Vp8Mk9IKenG6zDzklRRHur737jomE9K0ZmQDLjAaHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aumQThne; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aumQThne"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765089572; x=1796625572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pbE+100Y1YKroKAkTYk/uLmS8PZhwbDp1hFCivCCkvg=;
  b=aumQThnep0QKElQIKSMJALKTsqNlLMQDv2JDUhF6RSn/a+NJjOSt0eNL
   w7HslBNzHJ4N0wOhj/bi66zBlqBKXDBftX1RHS/k4h0KfsV4tgk44uwxH
   bQdT9L/Htp0Y+VFrNjzvosOEEjTrwIVNranfEGakuvIXgdYwvPOokhops
   HEGpYkM+FCgkNlyEQgn5BrkEK9KB1NBBbVmDtcGuu3PjpJpnraZNpry6D
   GpccUuqGA2mzJ6qym6JbD/WWb1yXoADcRN+vOPW0ba0SfosH0cJk9y0m3
   UhDSnLMWbqP3f3qlPGNU3ILGqtOf/TqFb8iyG7SAQxm5XcXk07SsGhKoq
   A==;
X-CSE-ConnectionGUID: yXAuQ3CXQCC0cml4L+oYXQ==
X-CSE-MsgGUID: 5sArmSzkQPy4pRYTiLpXvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="84665649"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="84665649"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 22:39:31 -0800
X-CSE-ConnectionGUID: ZwBl5cWrTguiEMdSvIKppQ==
X-CSE-MsgGUID: hkd5k31qTfOs9Ov9tTdBXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="200096334"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 06 Dec 2025 22:39:25 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vS8QU-00000000J37-3Oir;
	Sun, 07 Dec 2025 06:39:22 +0000
Date: Sun, 7 Dec 2025 14:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	andy.shevchenko@gmail.com, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Subject: Re: [PATCH 05/10] tools: add kfuzztest-bridge utility
Message-ID: <202512071413.502tHWLT-lkp@intel.com>
References: <20251204141250.21114-6-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204141250.21114-6-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.18]
[cannot apply to next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20251204-222307
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20251204141250.21114-6-ethan.w.s.graham%40gmail.com
patch subject: [PATCH 05/10] tools: add kfuzztest-bridge utility
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251207/202512071413.502tHWLT-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512071413.502tHWLT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512071413.502tHWLT-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/.renames.txt: warning: ignored by one of the .gitignore files
>> tools/testing/kfuzztest-bridge/kfuzztest-bridge: warning: ignored by one of the .gitignore files

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
