Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792477139;
	b=PI5zRV9gLnSRcHBwGR8a+rG561HDJpSTy6sAxo1PuLjn1MogCBHdIooF4YvIbK+1Ains
	 Mnf5vTuc+8B9MU9fiQhOPSgYvirLXOLAKobVU3qQY/E4Iju/XX1wxDl620z99Al/RUc6E
	 8J8nVXWt2lLjrLyT97rDoI9TN9XHT9lGSv69ei6XbKRTzEeEE+Y9eg4cMF0fXeqfFpwbP
	 cKv3I2TngEbj0HkzIe0/q74aTNoj19q+MapWzCbCKR49UACfQRhqawnbumWBetvjo5qy8
	 KPqlNlkAoY54aFmI6donpTMDTdT8Y0X0m9ZpW9989ASn0yGXTFaHlvsJhr4hTy5dhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792477139;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=kee20r/AyPGCIktuThCT6WONXXBjev7vFyID8Ot4siA=;
	b=IwIMKMbJ8N+n2AGl8JyF4af3ZIoeQzQCrpW5tl9tbbhWdW/kJY5giBq+T5RBxYzdRGhA
	 0hVhvrYLuIui5vLK63N/QT30kEXdRUtX758QkbYW9S96GXcMVg91ySKuWIpApUrtCq5t+
	 rzO+Mct9n1m592NDzIde6yQqExWs3HGwoKQZogD2hgREMErj0kXvsdyvIO80OCQwVBBRk
	 fVoXA99Nkk+OhBgJRTUhPD2sWP8Aj2B+c3S8ACB9q3revDKzOr9K7pUm7FU/ok/xFY2L5
	 odKEUwGNMqR/iK30ZbtkKmAWywhyHgvB/ukO1Z97+yEAmK6zsvmshwEvYOInfaiuaCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AHQPYEdy;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEBF606A31B;
	Tue, 20 Oct 2026 06:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CEBF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AHQPYEdy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792477139; x=1824013139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qDKr2vY1Dhmm9olWNb8x7UfBNH7cWLW/nYwD4mVBTLA=;
  b=AHQPYEdyGhoKYd29SJkd8yOtpWYB0MQEExZTVV0Yf/ot/ls85AMMFL4l
   kSLICwKZTlht8La31/UFUPaHB18s9W/eJNLc4TGqYsIR2E5jx3gSdW9Q7
   OXgZvKy7GNn2RaD4+QjfCd2gMds4obd4/Y2D0A1w3a5me/0M0jbllI/kA
   rDVpVpZtJaOlSFJSbRGeikdPGSbHYPT841tWxKbm3u/T1Khje0IxrMJKB
   IWuA3VcgZIr5cLmyWUpqUMdRiWgD9T3d23R0p/poTrYRnZszS7kAZKy4i
   gpfybJV5FnbU8hT6mp9zPm4ngqaV0O7T0ejEIrHDAjo5pTO8q2wjVztWh
   A==;
X-CSE-ConnectionGUID: wAIb/qt4QDueZoqGikssGw==
X-CSE-MsgGUID: wJiyPJQ/SLaDWi7TQmkAgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1053855"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1053855"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 23:18:57 -0700
X-CSE-ConnectionGUID: +dCFFBLOTPuMrjfimLsO8Q==
X-CSE-MsgGUID: f+VqWcetQaqRy5Gm6axtvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3031426"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Oct 2026 23:18:53 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJ3BR-00000000MzK-1UHr;
	Tue, 20 Oct 2026 06:18:49 +0000
Date: Tue, 20 Oct 2026 14:17:57 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, krzk@kernel.org, conor+dt@kernel.org,
	ruud.derwig@gf.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v26 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Message-ID: <202610201456.wUxEh6Wc-lkp@intel.com>
References: <20261019162457.1000115-5-pavitrakumarm@vayavyalabs.com>
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
In-Reply-To: <20261019162457.1000115-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-Managutte/dt-bindings-crypto-Document-support-for-SPAcc/20261019-215454
base:   178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4
patch link:    https://lore.kernel.org/r/20261019162457.1000115-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v26 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20261020/202610201456.wUxEh6Wc-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610201456.wUxEh6Wc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610201456.wUxEh6Wc-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/dwc-spacc/spacc_ahash.c: In function 'spacc_unregister_hash_algs':
>> drivers/crypto/dwc-spacc/spacc_ahash.c:827:9: error: expected declaration or statement at end of input
     827 |         return 0;
         |         ^~~~~~


vim +827 drivers/crypto/dwc-spacc/spacc_ahash.c

756cf2497ce591 Pavitrakumar Managutte 2026-10-19  812  
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  813  int spacc_unregister_hash_algs(struct spacc_priv *priv)
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  814  {
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  815  	struct spacc_alg *salg, *tmp;
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  816  
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  817  	if (!priv)
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  818  		return 0;
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  819  
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  820  	guard(mutex)(&priv->hash_alg_mutex);
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  821  
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  822  	list_for_each_entry_safe(salg, tmp, &priv->hash_alg_list, list) {
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  823  		list_del(&salg->list);
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  824  		crypto_engine_unregister_ahash(&salg->alg.hash);
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  825  	}
756cf2497ce591 Pavitrakumar Managutte 2026-10-19  826  
756cf2497ce591 Pavitrakumar Managutte 2026-10-19 @827  	return 0;

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
