Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777AC2BE647;
	Fri, 16 Jan 2026 08:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768551595; cv=none; b=KC8MD8e709TwoSns338A2EPjXKI5glX1lbds5ZMjJ+XiYsThKrbkMLIGsD1izypGiyKTZ1uvijg79Sn1kTwuTjss/R2qOIvarviYTGQcoCVaPdqaZ2nBbkFCzMCNPsGOaGq25fpOHkGW6e+ts5gzL86NVtR3y9q2LKfiN4PAdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768551595; c=relaxed/simple;
	bh=FIqaEFJuQgc+rWWsTpzH/blOyNA+3RSdsMtLGqNPISw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeM4FTkxK3wk8F2XT7h0wQByrddNjfKDHgNsKSd9C9Oa5Eg3bINbR77Vhgaid6OFpyNCkOAD1Z8xj9bz2DXTOFBZvVRQaFj5MxUzT+7ov3Ve0Ey0BlFcsqFy0PFcDkxXShiSwEKxd+mNfxL/ljuA3a5Wq9FYx1oS3u21aJdQsak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yavdjouh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yavdjouh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768551592; x=1800087592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FIqaEFJuQgc+rWWsTpzH/blOyNA+3RSdsMtLGqNPISw=;
  b=YavdjouhxJ9I+kGzc/rwUS4ZD3fl/zBh6xHXlIOVHNfDdwSiKOhPc3Sz
   xYCymailbNgI6MzY+XvTDka3SbvjdyPDRyLRoUv7AsqhCXNwDlb2Tb9Pz
   YcjFeI8zbg0Ry0Nhm7n2kKb3MAuS6CQaRu7P1LX5iaBwYWgbnvW/Q3lVF
   qMtjJjKfhE3b39KAy/DnCVw9azyz5H2Sumr1l+eiSMgMJHvlOk5ksHxPX
   XYodfxzjrHqcs5G5GFJD82xzAbtRN7Jj7WXwh8P91b11biZypFUimZKvz
   ukSQEa6ooWxJL3KuFMhjXaZvp1J38plDHEbps7Y/i6qwTtNr89Wo8xDBk
   Q==;
X-CSE-ConnectionGUID: 9IP18DoKT22nMedC+THJGA==
X-CSE-MsgGUID: vUWnFVKBQYi7C3EXkA7jeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="95344066"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="95344066"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:19:50 -0800
X-CSE-ConnectionGUID: vgfZb7cHQv6tYL9XRpKkVA==
X-CSE-MsgGUID: NbC/FfxPQcWNkIR8eFa4oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209327047"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 16 Jan 2026 00:19:47 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgf3Y-00000000KZQ-1EoK;
	Fri, 16 Jan 2026 08:19:44 +0000
Date: Fri, 16 Jan 2026 16:19:21 +0800
From: kernel test robot <lkp@intel.com>
To: Jianpeng Chang <jianpeng.chang.cn@windriver.com>, horia.geanta@nxp.com,
	pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, leitao@debian.org,
	kuba@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
Message-ID: <202601161604.ynMta3vK-lkp@intel.com>
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>

Hi Jianpeng,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.19-rc5 next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jianpeng-Chang/crypto-caam-fix-netdev-memory-leak-in-dpaa2_caam_probe/20260116-094800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260116014455.2575351-1-jianpeng.chang.cn%40windriver.com
patch subject: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
config: x86_64-buildonly-randconfig-004-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161604.ynMta3vK-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161604.ynMta3vK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601161604.ynMta3vK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/caam/caamalg_qi2.c:5132:19: error: array type 'cpumask_var_t' (aka 'struct cpumask[1]') is not assignable
    5132 |         priv->clean_mask = clean_mask;
         |         ~~~~~~~~~~~~~~~~ ^
   1 error generated.


vim +5132 drivers/crypto/caam/caamalg_qi2.c

  5007	
  5008	static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
  5009	{
  5010		struct device *dev = &ls_dev->dev;
  5011		struct dpaa2_caam_priv *priv;
  5012		struct dpaa2_caam_priv_per_cpu *ppriv;
  5013		cpumask_var_t clean_mask;
  5014		int err, cpu;
  5015		u8 i;
  5016	
  5017		err = -ENOMEM;
  5018		if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
  5019			goto err_cpumask;
  5020	
  5021		priv = dev_get_drvdata(dev);
  5022	
  5023		priv->dev = dev;
  5024		priv->dpsec_id = ls_dev->obj_desc.id;
  5025	
  5026		/* Get a handle for the DPSECI this interface is associate with */
  5027		err = dpseci_open(priv->mc_io, 0, priv->dpsec_id, &ls_dev->mc_handle);
  5028		if (err) {
  5029			dev_err(dev, "dpseci_open() failed: %d\n", err);
  5030			goto err_open;
  5031		}
  5032	
  5033		err = dpseci_get_api_version(priv->mc_io, 0, &priv->major_ver,
  5034					     &priv->minor_ver);
  5035		if (err) {
  5036			dev_err(dev, "dpseci_get_api_version() failed\n");
  5037			goto err_get_vers;
  5038		}
  5039	
  5040		dev_info(dev, "dpseci v%d.%d\n", priv->major_ver, priv->minor_ver);
  5041	
  5042		if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
  5043			err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
  5044			if (err) {
  5045				dev_err(dev, "dpseci_reset() failed\n");
  5046				goto err_get_vers;
  5047			}
  5048		}
  5049	
  5050		err = dpseci_get_attributes(priv->mc_io, 0, ls_dev->mc_handle,
  5051					    &priv->dpseci_attr);
  5052		if (err) {
  5053			dev_err(dev, "dpseci_get_attributes() failed\n");
  5054			goto err_get_vers;
  5055		}
  5056	
  5057		err = dpseci_get_sec_attr(priv->mc_io, 0, ls_dev->mc_handle,
  5058					  &priv->sec_attr);
  5059		if (err) {
  5060			dev_err(dev, "dpseci_get_sec_attr() failed\n");
  5061			goto err_get_vers;
  5062		}
  5063	
  5064		err = dpaa2_dpseci_congestion_setup(priv, ls_dev->mc_handle);
  5065		if (err) {
  5066			dev_err(dev, "setup_congestion() failed\n");
  5067			goto err_get_vers;
  5068		}
  5069	
  5070		priv->num_pairs = min(priv->dpseci_attr.num_rx_queues,
  5071				      priv->dpseci_attr.num_tx_queues);
  5072		if (priv->num_pairs > num_online_cpus()) {
  5073			dev_warn(dev, "%d queues won't be used\n",
  5074				 priv->num_pairs - num_online_cpus());
  5075			priv->num_pairs = num_online_cpus();
  5076		}
  5077	
  5078		for (i = 0; i < priv->dpseci_attr.num_rx_queues; i++) {
  5079			err = dpseci_get_rx_queue(priv->mc_io, 0, ls_dev->mc_handle, i,
  5080						  &priv->rx_queue_attr[i]);
  5081			if (err) {
  5082				dev_err(dev, "dpseci_get_rx_queue() failed\n");
  5083				goto err_get_rx_queue;
  5084			}
  5085		}
  5086	
  5087		for (i = 0; i < priv->dpseci_attr.num_tx_queues; i++) {
  5088			err = dpseci_get_tx_queue(priv->mc_io, 0, ls_dev->mc_handle, i,
  5089						  &priv->tx_queue_attr[i]);
  5090			if (err) {
  5091				dev_err(dev, "dpseci_get_tx_queue() failed\n");
  5092				goto err_get_rx_queue;
  5093			}
  5094		}
  5095	
  5096		i = 0;
  5097		for_each_online_cpu(cpu) {
  5098			u8 j;
  5099	
  5100			j = i % priv->num_pairs;
  5101	
  5102			ppriv = per_cpu_ptr(priv->ppriv, cpu);
  5103			ppriv->req_fqid = priv->tx_queue_attr[j].fqid;
  5104	
  5105			/*
  5106			 * Allow all cores to enqueue, while only some of them
  5107			 * will take part in dequeuing.
  5108			 */
  5109			if (++i > priv->num_pairs)
  5110				continue;
  5111	
  5112			ppriv->rsp_fqid = priv->rx_queue_attr[j].fqid;
  5113			ppriv->prio = j;
  5114	
  5115			dev_dbg(dev, "pair %d: rx queue %d, tx queue %d\n", j,
  5116				priv->rx_queue_attr[j].fqid,
  5117				priv->tx_queue_attr[j].fqid);
  5118	
  5119			ppriv->net_dev = alloc_netdev_dummy(0);
  5120			if (!ppriv->net_dev) {
  5121				err = -ENOMEM;
  5122				goto err_alloc_netdev;
  5123			}
  5124			cpumask_set_cpu(cpu, clean_mask);
  5125			ppriv->net_dev->dev = *dev;
  5126	
  5127			netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
  5128						 dpaa2_dpseci_poll,
  5129						 DPAA2_CAAM_NAPI_WEIGHT);
  5130		}
  5131	
> 5132		priv->clean_mask = clean_mask;
  5133		return 0;
  5134	
  5135	err_alloc_netdev:
  5136		free_dpaa2_pcpu_netdev(priv, clean_mask);
  5137	err_get_rx_queue:
  5138		dpaa2_dpseci_congestion_free(priv);
  5139	err_get_vers:
  5140		dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
  5141	err_open:
  5142		free_cpumask_var(clean_mask);
  5143	err_cpumask:
  5144		return err;
  5145	}
  5146	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
