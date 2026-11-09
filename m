Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794262701;
	b=Rxa8nrfLVZKMPi4O4bALBqSx4TbBC+9biTFllh8N8mz9GV1DVrM7QU3Y13aXQ/c0adQe
	 ZMkuAJYjgwwRHLsRDtBrgQqYl/S0vNLWC4c+UYuVBROKaLG8VcjrVDmp9kRwVhPBD400v
	 WTD79BJd9jlhNU7GfQ1mIyKWgb3IuxD+cJGW0HqPrt0K+OHCy9FbdaJ8z4udngwfJDZqd
	 ImaCJy+bbYMt5Ly+y88DFcyz4XX/2bZhXPU7hwk35cWqOwfp3p7HeuJOfzd6cGosNn1Rk
	 R77/FU6F2Qwx7H61EqxfJRvABDt3CqjWekUGL7aW/wvGhqBEv7h2eomwA4kfuw4HdhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262701;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=c9eJFkB1A2V/YM9JwIyEGfv/PGOIESHseQrXfeJUqyE=;
	b=HD1Wa2OGitCLNk1wx14yUOeO/985aova7romkNJXk0NgF5jMpZxHhKKySmKyJEcj5JJ3
	 Iz0ES+qAa66rk5+k8EGBpU8UMNQNgJ92aRdB0aISiLXju1vJcSOP0acOLC9KIPpJxj9Re
	 rmMbuHIgH64C5AhJQtkt+9YR0aUgSHgziuAzdk8jVbnDA/OzuIKf6dGtW2/U4G6mO9pt2
	 GSM1lDwLKhupsABpjgX9LVGoM5lvEyseQPF6w4CB5auwXe8IY8FIcVRW/akFTK2iohRWN
	 miEGAGTAlXwePlepesGfaKHIye5cKcJU9vnyj735vx3bKXkbc6BMEJCXrl01I3XMfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqs0Wigu;
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB7F606A325;
	Mon,  9 Nov 2026 22:18:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AB7F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqs0Wigu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794262701; x=1825798701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aK30euBbuDTMMaEp6ls7Vv/1SJLD5Mq+6g69iv5YITc=;
  b=fqs0Wiguve1RNqiD28X1sK8POY3mt/rL89mAUGJTZk37AC6koc1xT4pb
   +Hx7p1S1X5PrfrGe/bUjUGXCxXiILBHtP6JiCDZR8N6nL5Yjp7Ex1l6EH
   27D5XCXWWCOO/kUKnC2TfklY8TA6HrScKX+C1bovXjvyYTu02wZSYh4zs
   IJuFBFk+hIrBffrx/9muz7lYw1tscOR8+DsiYVYKbstODssVJp13zCIKA
   7qLsKg6w7OLYzxetp25G1tKhXxP/D2NqhlTJDZZ/JtcDYHgB0eddInqTo
   EheFYf3mGutaLw8WyVXAjOJ0BRA5SB864SCdbB0WJZYnvtw+QlSz5Np2f
   g==;
X-CSE-ConnectionGUID: g3WeQ/92Tq+gT6s3KG2qFw==
X-CSE-MsgGUID: yOF/G8iXTDOps3QRhog+7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2891784"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2891784"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 14:18:20 -0800
X-CSE-ConnectionGUID: uRWsm7i9QwiwhY7dhOj8yA==
X-CSE-MsgGUID: sRE96BBBQGe1ftnOsgoHNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7851116"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 09 Nov 2026 14:18:18 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQXgs-00000000vQl-3fQU;
	Mon, 09 Nov 2026 22:18:14 +0000
Date: Tue, 10 Nov 2026 06:17:59 +0800
From: kernel test robot <lkp@intel.com>
To: Chenghai Huang <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, linwenkai6@hisilicon.com
Subject: Re: [PATCH 2/4] crypto: engine - add acomp support
Message-ID: <202611100606.eXBh5Nlt-lkp@intel.com>
References: <20261109073556.2517351-3-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109073556.2517351-3-huangchenghai2@huawei.com>

Hi Chenghai,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on linus/master v7.4-rc2 next-20261109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chenghai-Huang/crypto-engine-clear-busy-and-recheck-running-in-the-retry-pump-loop/20261109-153553
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20261109073556.2517351-3-huangchenghai2%40huawei.com
patch subject: [PATCH 2/4] crypto: engine - add acomp support
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20261110/202611100606.eXBh5Nlt-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project fc9576e3b179738d99c5babe5cd9d6c1f883e0db)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611100606.eXBh5Nlt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611100606.eXBh5Nlt-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: crypto/crypto_engine.ko: symbol 'crypto_register_acomp' undefined!
>> ERROR: modpost: crypto/crypto_engine.ko: symbol 'crypto_unregister_acomp' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
