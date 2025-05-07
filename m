Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2620B1F4;
	Wed,  7 May 2025 10:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746612254; cv=none; b=ayN5UTCAUp7bCmclS/2rtOxaRz9ll2KL1pdYTXr1f0XQjUE7Gz36+jpLug08/WYr4ZbYq0nwseOLqHsS5z5Qqiuwusx4Uf78wvStgppfPpMYIH710mogiUIP0LEr4mKCf+ou1lO8hIRZuf3zWXhJPIH4QalQ1bDuVXZpmf7c5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746612254; c=relaxed/simple;
	bh=iUuS42Uclw9FLIubzIFhbyfjGtzW0hUtKf7lNPTgtgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj3hqkifYpwdpU6H5SS1Q4H4hdG01Q0edivVTK7AhIp07iCfWwHfL963kVtd3mIlCuJ+JPpXTHWljDn4x7593eHX4KbIGKStlEqAeCNEr9cKOVJwdiARxghngo1wg0OqZ93H6bZyWUsIoPWfLlNgCc+yHvOaiFEHLhsuTtj0O8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cEX+Oco9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cEX+Oco9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746612252; x=1778148252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iUuS42Uclw9FLIubzIFhbyfjGtzW0hUtKf7lNPTgtgs=;
  b=cEX+Oco9cAt1sLOmTSsKIGRae9wpLW02sliWiEoV0FvVB+1RJw3xyO47
   fojwDsdtKBOSlY/EcUFqxiHjERVw0VAuqZnFhfUCYgrVi+KlIZRMrunPF
   z6DEVBvEgQggjdDDxRa9z5r8oBzWrLvcjc7/+XdXSU2iq9bNXrFYdaJVL
   MR/m02iFGd29sooUul15pEftpCTGQvl83pz5RwwuENq4sATxnOcX7ARLu
   uZxhZqDtAv4e+fYfdsrHo7e4AnYE0gWoBRyeRNWQRlhtmvPw4EU8lafGb
   /Z09YUfpC6aR2v3EYtY+6fJ3r6/bxtLt4L8sEpG2kJcDcCIX5yGEzxYOq
   A==;
X-CSE-ConnectionGUID: tTVUZIHfRAqkW+UxodhgmA==
X-CSE-MsgGUID: Pu7PSK5sR92TviCHg3unjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="59730221"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="59730221"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 03:04:11 -0700
X-CSE-ConnectionGUID: PSOJ5DJ7R72t6hsb+akvyA==
X-CSE-MsgGUID: OSW7vIWNT0+TQ5dev9D0YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="135816401"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 May 2025 03:04:05 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCbdC-0007Ys-1g;
	Wed, 07 May 2025 10:04:02 +0000
Date: Wed, 7 May 2025 18:03:45 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, bbrezillon@kernel.org,
	arno@natisbad.org, schalla@marvell.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, sgoutham@marvell.com, lcherian@marvell.com,
	gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
	sbhatta@marvell.com, andrew+netdev@lunn.ch, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, bbhushan2@marvell.com,
	bhelgaas@google.com, pstanner@redhat.com,
	gregkh@linuxfoundation.org, peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com, Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [net-next PATCH v1 10/15] octeontx2-pf: ipsec: Setup NIX HW
 resources for inbound flows
Message-ID: <202505071739.xTGCCtUx-lkp@intel.com>
References: <20250502132005.611698-11-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-11-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250502-213203
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250502132005.611698-11-tanmay%40marvell.com
patch subject: [net-next PATCH v1 10/15] octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250507/202505071739.xTGCCtUx-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505071739.xTGCCtUx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505071739.xTGCCtUx-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:488:6: warning: variable 'pool' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     488 |         if (err)
         |             ^~~
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:512:23: note: uninitialized use occurs here
     512 |         qmem_free(pfvf->dev, pool->stack);
         |                              ^~~~
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:488:2: note: remove the 'if' if its condition is always false
     488 |         if (err)
         |         ^~~~~~~~
     489 |                 goto pool_fail;
         |                 ~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:466:24: note: initialize the variable 'pool' to silence this warning
     466 |         struct otx2_pool *pool;
         |                               ^
         |                                = NULL
   1 warning generated.


vim +488 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

   461	
   462	static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
   463	{
   464		struct otx2_hw *hw = &pfvf->hw;
   465		int stack_pages, pool_id;
   466		struct otx2_pool *pool;
   467		int err, ptr, num_ptrs;
   468		dma_addr_t bufptr;
   469	
   470		num_ptrs = 256;
   471		pool_id = pfvf->ipsec.inb_ipsec_pool;
   472		stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
   473	
   474		mutex_lock(&pfvf->mbox.lock);
   475	
   476		/* Initialize aura context */
   477		err = cn10k_ipsec_ingress_aura_init(pfvf, pool_id, pool_id, num_ptrs);
   478		if (err)
   479			goto fail;
   480	
   481		/* Initialize pool */
   482		err = otx2_pool_init(pfvf, pool_id, stack_pages, num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
   483		if (err)
   484			goto fail;
   485	
   486		/* Flush accumulated messages */
   487		err = otx2_sync_mbox_msg(&pfvf->mbox);
 > 488		if (err)
   489			goto pool_fail;
   490	
   491		/* Allocate pointers and free them to aura/pool */
   492		pool = &pfvf->qset.pool[pool_id];
   493		for (ptr = 0; ptr < num_ptrs; ptr++) {
   494			err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, ptr);
   495			if (err) {
   496				err = -ENOMEM;
   497				goto pool_fail;
   498			}
   499			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
   500		}
   501	
   502		/* Initialize RQ and map buffers from pool_id */
   503		err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq, pool_id);
   504		if (err)
   505			goto pool_fail;
   506	
   507		mutex_unlock(&pfvf->mbox.lock);
   508		return 0;
   509	
   510	pool_fail:
   511		mutex_unlock(&pfvf->mbox.lock);
   512		qmem_free(pfvf->dev, pool->stack);
   513		qmem_free(pfvf->dev, pool->fc_addr);
   514		page_pool_destroy(pool->page_pool);
   515		devm_kfree(pfvf->dev, pool->xdp);
   516		pool->xsk_pool = NULL;
   517	fail:
   518		otx2_mbox_reset(&pfvf->mbox.mbox, 0);
   519		return err;
   520	}
   521	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
