Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792495930;
	b=hmU0cYGaGkszbFb0mHnWjj7iq5lG+J47POavtZ05ke9pdwS5QBZTFIV4Qopr+hFwxoU2
	 7NRgfpt29kMe2Sualc8NPeRNRlYTu4s5MEiDaDrggwO71Z8IOtKnzQL/ZFld0p8MGRyDg
	 Hk2Dhgi6G4GrHkI56RtLpNftMfja0q1pxl+8f4KePzpFJmyItAygZS8vCMX0hXcKoNsv8
	 cb2vstwCFWGpS9TnMeDkA3FQ+v7Kf9qTfFO33vUXzUkR4e3NalPjUkglk69rgyIIqOlQE
	 tm/NwsETAilUw+Iyks8zcupkPJ94qAhVtFIQJn6eQCGdM2tQKHbZ2XRJSndh0BvHmKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495930;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Mgf339TQwuPr8j2J99LXGWXR6zRjUM8zAg5og24Ycnw=;
	b=cHSJFCT1GTjO7DRvfIFPL42KfOAI+yxV/IzNB8Dbupn5QrEX5ZmiiFjoAsIKkmQwWpK3
	 Ii7cvey4D09Ym/c4Ztu/ZbSV282wjym2/6Xhd+GK2xJpDagtdSHuQcfIxRdrxcAz84rST
	 OAYl1PVNvJlaE20wEaQx3GK8m7+MwogOpGVY3U/abjLrbFrXkjofEnydSBUymGFejQm2P
	 j+O/fFkpicm07g+bqtnj1SwiQBGMLjGSOLPSq8oMYToPBhKNMBuaO1oW6r7+Usu2v+wiK
	 PHRRKhptqIuJAIGcvqbeKXZlA2NIFPr43mjbI10hrlIH+K1kJnF0LhCZHF0lrTCCzhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=O1E7GCgh;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBC0606A31D;
	Tue, 20 Oct 2026 11:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDBC0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=O1E7GCgh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792495930; x=1824031930;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nayHupzZTkRbxRCVzEKooOScyNX1Xe35sNlMf97+PR8=;
  b=O1E7GCghq+/EWJAZ6HKrFsHP3V4JvTcnIhprW6Kmu2KmPEFLatI3n106
   rvM1/1O1bYZaPdJKisLPhKb+ykw5fscQO2SoPv2FOqaw60zN1b/14ZQS+
   swATcI4/eoP7P5yf8G+FWOly0WzKPp/a4QVGGEOnIgdfuLUgX4DvSwr+h
   4/+M2IbqVcmu9sk4p3F58Nxuwb21k6SCsI9pm7uRVtTX42+8o+P8uPBmW
   y4Ffs6kwfLbsb8cdTcnbwP+PKVQVZ6QoXmKJMsgNiO/lMiXqX/owTaxE2
   t435mJ4lxQQV3CQku8EgoBf5n6z3G6mplvZtOaOK1eWY7BFD/43IHuYjl
   w==;
X-CSE-ConnectionGUID: uw+6K3qEQySrpsuwyGJoHg==
X-CSE-MsgGUID: BZdbETTcQzCPJZdI2g+vWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1194619"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1194619"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 04:32:09 -0700
X-CSE-ConnectionGUID: KCuaApEWSaqTzd376Dup4Q==
X-CSE-MsgGUID: EB9Zs3RdQmWcphZHno1sBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2747223"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 20 Oct 2026 04:32:05 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJ84Y-00000000NPi-3A5l;
	Tue, 20 Oct 2026 11:32:02 +0000
Date: Tue, 20 Oct 2026 19:31:53 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, krzk@kernel.org,
	conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v26 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Message-ID: <202610201938.pmiyNP1i-lkp@intel.com>
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
config: sparc64-allmodconfig (https://download.01.org/0day-ci/archive/20261020/202610201938.pmiyNP1i-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610201938.pmiyNP1i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610201938.pmiyNP1i-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/dwc-spacc/spacc_ahash.c:827:11: error: expected '}'
     827 |         return 0;
         |                  ^
   drivers/crypto/dwc-spacc/spacc_ahash.c:814:1: note: to match this '{'
     814 | {
         | ^
   1 error generated.


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
