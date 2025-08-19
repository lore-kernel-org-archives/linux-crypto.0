Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E3B2C2372;
	Tue, 19 Aug 2025 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619902; cv=none; b=HgYH2grUgGN+LLbZWeJeDMPuPN5qXA8b7lUJcAuSYyk0dc7YG5R4Pf8Sh4ccG97JPfD810vQihUBXNPBrQ71jr9Pw+0AcUpfuD+crNK5F9zr6UI/O3P1l1bjdEZ8sWu+DUldTc+O9hYq1e0+DFdAUGt8I5x563CxbEwx7koCorc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619902; c=relaxed/simple;
	bh=87YZPJZ5q3Sgkr3avnsaQR4tYHWxRSrg1im7qSOpZtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gm7JZaSto38sBgJExJdoarnqNtbl7KWAp0vSo0T+xrINfYRvH8TN7SSr23JL4HI1jfGfZC3rElb8zAcNG02/KpV1z1Y1dWhuQO2cxNFLn8ppOZVNsk47crzTdqB1IGrOyaEos0MkhY8/1iX2pRWiZU9XD8YA3+QajrYc5rzWe1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TG//Cigf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TG//Cigf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619901; x=1787155901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=87YZPJZ5q3Sgkr3avnsaQR4tYHWxRSrg1im7qSOpZtY=;
  b=TG//CigfKBL12ftbw48o4fcXIVYKd+nY7XkuV6/bFr93veWLXFV1yWMk
   9vg/3dRsa9ZLHZCEYnZTai9y3WDQ2Ou7CujtcGkS0YLrbqoetLxAsGZnJ
   ZGJuYcVSjqhoetG1g19b27OtcsrY9HQLNQXD/1D30KzRexafQLomFd+w6
   +qjzmjCQ66zUnK+qsnP+W8eWNbJgNAnutwFzVvwGTCQjUy5rS1pZeBVFL
   97HMWd6HW3sLvDyBOWTXYupKqejEaAyw8hLWZGw4LEh24fvL59rIKggQy
   SrgFZ1p1XsiLrCRL/wXmydPVDkJtMS++iGlRaY7nMU8ESjH4QCorElXZL
   A==;
X-CSE-ConnectionGUID: Y/cY2dolQvCDa06moCZWfA==
X-CSE-MsgGUID: jxvFz/oBQAWREiUamROkcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57726009"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57726009"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:11:40 -0700
X-CSE-ConnectionGUID: Ja443f0+T+Scnc8/lwfoOA==
X-CSE-MsgGUID: Gxr3e9e9RRSzCPklatT/iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167069883"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 19 Aug 2025 09:11:38 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoOvv-000H6R-2n;
	Tue, 19 Aug 2025 16:11:35 +0000
Date: Wed, 20 Aug 2025 00:10:33 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, davem@davemloft.net,
	leon@kernel.org, horms@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [PATCH net-next v4 13/14] octeontx2-pf: ipsec: Manage NPC rules
 and SPI-to-SA table entries
Message-ID: <202508200056.n3gONjJD-lkp@intel.com>
References: <20250819021507.323752-14-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819021507.323752-14-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250819-103300
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250819021507.323752-14-tanmay%40marvell.com
patch subject: [PATCH net-next v4 13/14] octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
config: sparc64-randconfig-002-20250819 (https://download.01.org/0day-ci/archive/20250820/202508200056.n3gONjJD-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250820/202508200056.n3gONjJD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508200056.n3gONjJD-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c: In function 'otx2_free_hw_resources':
>> drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:1809:3: error: implicit declaration of function 'cn10k_ipsec_inb_disable_flows'; did you mean 'cn10k_ipsec_inb_delete_flows'? [-Werror=implicit-function-declaration]
      cn10k_ipsec_inb_disable_flows(pf);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      cn10k_ipsec_inb_delete_flows
   cc1: some warnings being treated as errors


vim +1809 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

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
  1799		cn10k_ipsec_free_aura_ptrs(pf);
  1800	
  1801		otx2_free_cq_res(pf);
  1802	
  1803		/* Free all ingress bandwidth profiles allocated */
  1804		if (!otx2_rep_dev(pf->pdev))
  1805			cn10k_free_all_ipolicers(pf);
  1806	
  1807		/* Delete Inbound IPSec flows if any SA's are installed */
  1808		if (!list_empty(&pf->ipsec.inb_sw_ctx_list))
> 1809			cn10k_ipsec_inb_disable_flows(pf);
  1810	
  1811		mutex_lock(&mbox->lock);
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
