Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9428E572;
	Thu, 19 Jun 2025 23:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750375200; cv=none; b=o/HRhWMp5Iv3tt0yGJPx8lrVn4Y87DSZKQNnHv6dzMXME+GYti4hLWY7/K0IKXg/2o3V5v4d4qeokRwgX3AMHLOJ6xLH6mW1ssTPCKAIh3bSf4c3iLPxYXMrG2dBNM3NX/AsNE6L8SyjfaWJdPkr62glXO6EcAaXrIr7r96Ovy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750375200; c=relaxed/simple;
	bh=CxdGK0OibitOqYT8eMdM1IZnZXdC/S5mh0+1mj4678A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqcebDIg7PD9s9XRnWgNrPFsiiiyxVrY7ms828jNmwwxw828xbArIeKUfw3f6q1SGJWBtuEHYQwVXy445budPw6LNzBHq35ZTWhnoB/gHQCsR2FGr80AIPq+hFZpsYeIuf9se4+KK793MCraD3qBU/RxKFeMbfA/DGtVtG/KZiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kjyiYV/8; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kjyiYV/8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750375199; x=1781911199;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CxdGK0OibitOqYT8eMdM1IZnZXdC/S5mh0+1mj4678A=;
  b=kjyiYV/8Z9bPUCa7w6PHU9r2D4lRPZTcEjRPVRftX95laos8OhcSdL0u
   LQNiREcpECikP2+juQeG+xbOgvUUcfsCxYQk5/ghiqmJgLu5T34jEHP2J
   2Z7uMKgXNd4X/FAiKoyp6PKOv+yScjL9CRsG/nZaX+3bUcf6vF6IFRHMh
   bqqXzSbu++rp0tpTi/BlM2COnJpxW7mOKkBP2OqvbD4hf0WGa0JujzrZp
   H3Sj6vCuohWqCiNZ7QkvJCeCslKHnfjpl2SEbjasaGm0ss5smhSt/yfkn
   5ylsqKysFG72W0tDFAI5z6rZRRB2Muu+D8aVYOExaG8G4rc+Ffzu3D082
   A==;
X-CSE-ConnectionGUID: t1sUXCg0RLifV7Tf8950XQ==
X-CSE-MsgGUID: 93n3DzlHTo6jjdhunQJY9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="63322424"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="63322424"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 16:19:58 -0700
X-CSE-ConnectionGUID: WoC9UC3MSEKOOdL9mMYJgg==
X-CSE-MsgGUID: hsdlFGskR72XT1zpBkFaRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="151068828"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Jun 2025 16:19:56 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uSOXy-000LAS-02;
	Thu, 19 Jun 2025 23:19:54 +0000
Date: Fri, 20 Jun 2025 07:19:34 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, davem@davemloft.net,
	leon@kernel.org, horms@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [PATCH net-next v2 13/14] octeontx2-pf: ipsec: Manage NPC rules
 and SPI-to-SA table entries
Message-ID: <202506200609.aTq7YfBa-lkp@intel.com>
References: <20250618113020.130888-14-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-14-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250618-193646
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250618113020.130888-14-tanmay%40marvell.com
patch subject: [PATCH net-next v2 13/14] octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
config: um-randconfig-002-20250620 (https://download.01.org/0day-ci/archive/20250620/202506200609.aTq7YfBa-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 875b36a8742437b95f623bab1e0332562c7b4b3f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250620/202506200609.aTq7YfBa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506200609.aTq7YfBa-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1175:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1175 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   In file included from drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:22:
   In file included from drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h:35:
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h:404:22: warning: no previous prototype for function 'cn10k_ipsec_process_cpt_metapkt' [-Wmissing-prototypes]
     404 | struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
         |                      ^
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h:404:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     404 | struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
         | ^
         | static 
>> drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:1808:3: error: call to undeclared function 'cn10k_ipsec_inb_disable_flows'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1808 |                 cn10k_ipsec_inb_disable_flows(pf);
         |                 ^
   drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:1808:3: note: did you mean 'cn10k_ipsec_inb_delete_flows'?
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h:413:1: note: 'cn10k_ipsec_inb_delete_flows' declared here
     413 | cn10k_ipsec_inb_delete_flows(struct otx2_nic *pfvf)
         | ^
   2 warnings and 1 error generated.


vim +/cn10k_ipsec_inb_disable_flows +1808 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

  1772	
  1773		if (!otx2_rep_dev(pf->pdev))
  1774			otx2_clean_qos_queues(pf);
  1775	
  1776		mutex_lock(&mbox->lock);
  1777		/* Disable backpressure */
  1778		if (!is_otx2_lbkvf(pf->pdev))
  1779			otx2_nix_config_bp(pf, false);
  1780		mutex_unlock(&mbox->lock);
  1781	
  1782		/* Disable RQs */
  1783		otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
  1784	
  1785		/*Dequeue all CQEs */
  1786		for (qidx = 0; qidx < qset->cq_cnt; qidx++) {
  1787			cq = &qset->cq[qidx];
  1788			if (cq->cq_type == CQ_RX)
  1789				otx2_cleanup_rx_cqes(pf, cq, qidx);
  1790			else
  1791				otx2_cleanup_tx_cqes(pf, cq);
  1792		}
  1793		otx2_free_pending_sqe(pf);
  1794	
  1795		otx2_free_sq_res(pf);
  1796	
  1797		/* Free RQ buffer pointers*/
  1798		otx2_free_aura_ptr(pf, AURA_NIX_RQ);
  1799	
  1800		otx2_free_cq_res(pf);
  1801	
  1802		/* Free all ingress bandwidth profiles allocated */
  1803		if (!otx2_rep_dev(pf->pdev))
  1804			cn10k_free_all_ipolicers(pf);
  1805	
  1806		/* Delete Inbound IPSec flows if any SA's are installed */
  1807		if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
> 1808			cn10k_ipsec_inb_disable_flows(pf);
  1809	
  1810		mutex_lock(&mbox->lock);
  1811	
  1812		/* Reset NIX LF */
  1813		free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
  1814		if (free_req) {
  1815			free_req->flags = NIX_LF_DISABLE_FLOWS;
  1816			if (!(pf->flags & OTX2_FLAG_PF_SHUTDOWN))
  1817				free_req->flags |= NIX_LF_DONT_FREE_TX_VTAG;
  1818			if (otx2_sync_mbox_msg(mbox))
  1819				dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
  1820		}
  1821		mutex_unlock(&mbox->lock);
  1822	
  1823		/* Disable NPA Pool and Aura hw context */
  1824		otx2_ctx_disable(mbox, NPA_AQ_CTYPE_POOL, true);
  1825		otx2_ctx_disable(mbox, NPA_AQ_CTYPE_AURA, true);
  1826		otx2_aura_pool_free(pf);
  1827	
  1828		mutex_lock(&mbox->lock);
  1829		/* Reset NPA LF */
  1830		req = otx2_mbox_alloc_msg_npa_lf_free(mbox);
  1831		if (req) {
  1832			if (otx2_sync_mbox_msg(mbox))
  1833				dev_err(pf->dev, "%s failed to free npalf\n", __func__);
  1834		}
  1835		mutex_unlock(&mbox->lock);
  1836	}
  1837	EXPORT_SYMBOL(otx2_free_hw_resources);
  1838	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
