Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614D19E992;
	Mon, 24 Nov 2025 03:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763954745; cv=none; b=N26xsKQOMSfAN2T4sUrkFcVGResOYHO8P/MWmxpovg4Xmm9qAYdwxNjPOqiV2wEwt1BNJvF5aKyEyV04t5TQmix1u33yJrkZGlAcAePRf+5WmYn20I+PXsPSGLM+pDAcCGtUnuCKRzXCElhVE6l6EaYcKEwZgBBxMiLO/tX6hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763954745; c=relaxed/simple;
	bh=i22ePF6npWiHiIedKts/JfnzX/R9LZSEhRvznbbsMRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3LAJArbLT8KigsWwW8EknjOnv+i3HvMP+I4hnCbvNhSnDSMKsv/HbTGTCAkUNIKvbwyDPVpyGimvDB8NOJHrVvRm6piEh22zbdBVSX6VPpnilhBww1vnOSiUvY77YdbjKelziMr2Esic11heHoHJwim4sUcqNrYjv8OKzpblWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avbpOxXg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avbpOxXg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763954744; x=1795490744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i22ePF6npWiHiIedKts/JfnzX/R9LZSEhRvznbbsMRE=;
  b=avbpOxXg3J8hAyGOJ8U6b5bkqCvLzO0KbDcjgRbucKrUgGARldNov3ct
   7BcbRg+ybyK8sdd1CBjZqBObMZeQgxtF60tPhAkMlSRB78BMDwNnu7uJR
   pj66AFMWUYsLKGHmx4ExQtN0log0ER/ADbtL+k4uwlEKDi6L1kLFkTCCN
   10y8YUp0Axus98Dju3LEDQfcYfH4AlpqY+7RIu3oCrjmAIQYFfS8BtT43
   ilszQ4rVWz7IctazMrb+hq8gHZp8/vBX76LjxgOJPeZChqX1Zogte4/xY
   SwDaXROhMhDLX5xHexpxAbAkx2sJ6T5QuNQK3w9WsugDoxEeApuhRjqyF
   w==;
X-CSE-ConnectionGUID: L7eqadeFQn+nuEdQrXqXQw==
X-CSE-MsgGUID: 38gkmiRFSpqLVBe5XBJfjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="77313829"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="77313829"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 19:25:43 -0800
X-CSE-ConnectionGUID: fHAB4WDMS3WhKfepXnAZVQ==
X-CSE-MsgGUID: GnkPCyRtTzChDqEhZbVWlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="192455284"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 23 Nov 2025 19:25:41 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNNCs-000000000LZ-1OuX;
	Mon, 24 Nov 2025 03:25:38 +0000
Date: Mon, 24 Nov 2025 11:24:44 +0800
From: kernel test robot <lkp@intel.com>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev, John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	"(open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER)" <linux-crypto@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lars Francke <lars.francke@gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
Message-ID: <202511241129.nHe3PLR3-lkp@intel.com>
References: <20251119205942.3411155-3-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119205942.3411155-3-superm1@kernel.org>

Hi Mario,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.18-rc7 next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello-AMD/platform-x86-amd-pmf-Prevent-TEE-errors-after-hibernate/20251120-050203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20251119205942.3411155-3-superm1%40kernel.org
patch subject: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
config: i386-randconfig-004-20251124 (https://download.01.org/0day-ci/archive/20251124/202511241129.nHe3PLR3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251124/202511241129.nHe3PLR3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511241129.nHe3PLR3-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "tee_restore" [drivers/crypto/ccp/ccp.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
