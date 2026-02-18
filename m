Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C645340A41;
	Wed, 18 Feb 2026 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436408; cv=none; b=X2ZuBDid6trWxd8PR4Ar5xa2JHxWrHStBt+4pNt9ky2V+4x6NtWE+6rxs3mHsbZcHvOmv/ViL8LdgIq9U/irXZv+XTHrrDz4Kvg94cCmYwAheKjmQgEiUc+39D/SxAwheBfbfTRubvr9kO/wvbaz7g86jpB3aHxNJfSh1xYsuZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436408; c=relaxed/simple;
	bh=gN7xzSDynnuIkXjLbXibgC4QIHlz87O2ZPWCcAcpXwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOgV+exVK6xxyAIMTSKjm0V1e5cOX9c62gvvAD+NG8i2N9nJV7mxhaCNKjrU1pKVdbaSd7ujzYuqpn8bpsooO5S+tsdVI8c0CDT1AcW9dAL9VMMOON0CwWQNxtlfLwbF4bLFoTpILikNI0VvbjnPtuLXIqw7VU4oDhCTsd+eUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHJjhvgg; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHJjhvgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771436406; x=1802972406;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gN7xzSDynnuIkXjLbXibgC4QIHlz87O2ZPWCcAcpXwM=;
  b=gHJjhvggVHqgs6bwlyHQhBf9SC2UaeRHjGoEov1SfSsq1Gs9n7gvNX0W
   qHDrl7EZiD+zK3AaEIRa5sxM62kvnmn+zFeZkgxUQpJXZIRYDWx0ujYrk
   9sZF1aOfPYHRg0u5KFXwi44/K40Re1ZGhHdKWWA7feuw2GsUpdPMF9LEk
   Z6WujzKxXdHj6yNjbm4UTgHzmXZqhLxqE1xlLlHsXE9KsPqcPct8PTrJz
   PHHLg1RjQBBhUrrjbAoRtkVmCqkeNTSsbrg1kZmrYNvl0yADUH1OjlfzS
   Qol4wBvGp+y6ok7ppzAHX9TtqtG6xuGxY+qW472XZdqUZ5yFNAFupxWLb
   A==;
X-CSE-ConnectionGUID: vsGpRNYESMKjfeWDCDLGWg==
X-CSE-MsgGUID: v2BfbavGTimc5WhUZAP9EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="90102695"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="90102695"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 09:40:06 -0800
X-CSE-ConnectionGUID: I7gzG4PNTECvIqmDd9mD6w==
X-CSE-MsgGUID: +/xxbq81QXW7yDhhNlkuTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="213015939"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 18 Feb 2026 09:40:02 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vslWp-000000012aM-48ID;
	Wed, 18 Feb 2026 17:39:59 +0000
Date: Thu, 19 Feb 2026 01:39:36 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, krzk+dt@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v9 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Message-ID: <202602190145.feNzO6kD-lkp@intel.com>
References: <20260218125805.615525-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218125805.615525-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 0ce90934c0a6baac053029ad28566536ae50d604]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-Managutte/dt-bindings-crypto-Document-support-for-SPAcc/20260218-210308
base:   0ce90934c0a6baac053029ad28566536ae50d604
patch link:    https://lore.kernel.org/r/20260218125805.615525-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v9 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260219/202602190145.feNzO6kD-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260219/202602190145.feNzO6kD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602190145.feNzO6kD-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/dwc-spacc/spacc_device.c: In function 'spacc_init_device':
>> drivers/crypto/dwc-spacc/spacc_device.c:35:13: warning: variable 'oldmode' set but not used [-Wunused-but-set-variable]
      35 |         int oldmode;
         |             ^~~~~~~


vim +/oldmode +35 drivers/crypto/dwc-spacc/spacc_device.c

80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   27  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   28  static int spacc_init_device(struct platform_device *pdev)
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   29  {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   30  	void __iomem *baseaddr;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   31  	struct pdu_info   info;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   32  	struct spacc_priv *priv;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   33  	int err = 0;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   34  	int ret = 0;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  @35  	int oldmode;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   36  	int irq_num;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   37  	int irq_ret;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   38  	const u64 oldtimer = SPACC_OLD_TIMER;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   39  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   40  	/* initialize DDT DMA pools based on this device's resources */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   41  	if (pdu_mem_init(&pdev->dev)) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   42  		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   43  		return -ENOMEM;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   44  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   45  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   46  	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   47  	if (!priv) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   48  		err = -ENOMEM;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   49  		goto free_ddt_mem_pool;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   50  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   51  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   52  	/* default to little-endian */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   53  	priv->spacc.config.big_endian	 = false;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   54  	priv->spacc.config.little_endian = true;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   55  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   56  	priv->spacc.config.oldtimer = oldtimer;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   57  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   58  	/* Set the SPAcc internal counter value from kernel config */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   59  	priv->spacc.config.timer = (u64)CONFIG_CRYPTO_DEV_SPACC_INTERNAL_COUNTER;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   60  	dev_dbg(&pdev->dev, "SPAcc internal counter set to: %llu\n",
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   61  		priv->spacc.config.timer);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   62  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   63  	baseaddr = devm_platform_ioremap_resource(pdev, 0);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   64  	if (IS_ERR(baseaddr)) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   65  		dev_err(&pdev->dev, "Unable to map iomem\n");
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   66  		err = PTR_ERR(baseaddr);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   67  		goto free_ddt_mem_pool;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   68  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   69  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   70  	pdu_get_version(baseaddr, &info);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   71  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   72  	ret = spacc_init(baseaddr, &priv->spacc, &info);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   73  	if (ret < 0) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   74  		dev_err(&pdev->dev, "Failed to initialize SPAcc device\n");
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   75  		err = ret;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   76  		goto free_ddt_mem_pool;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   77  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   78  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   79  	/* Set the priority from kernel config */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   80  	priv->spacc.config.priority = CONFIG_CRYPTO_DEV_SPACC_PRIORITY;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   81  	dev_dbg(&pdev->dev, "VSPACC priority set from config: %u\n",
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   82  		priv->spacc.config.priority);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   83  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   84  	/* Set the priority for this virtual SPAcc instance */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   85  	spacc_set_priority(&priv->spacc, priv->spacc.config.priority);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   86  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   87  	/* Initialize crypto engine */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   88  	priv->engine = crypto_engine_alloc_init(&pdev->dev, true);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   89  	if (!priv->engine) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   90  		dev_err(&pdev->dev, "Could not allocate crypto engine\n");
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   91  		err = -ENOMEM;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   92  		goto free_spacc_ctx;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   93  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   94  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   95  	err = crypto_engine_start(priv->engine);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   96  	if (err) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   97  		dev_err(&pdev->dev, "Could not start crypto engine\n");
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   98  		goto free_engine;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18   99  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  100  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  101  	priv->spacc_wq = alloc_workqueue("spacc_workqueue", WQ_UNBOUND, 0);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  102  	if (!priv->spacc_wq) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  103  		err = -ENOMEM;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  104  		goto free_engine;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  105  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  106  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  107  	INIT_WORK(&priv->pop_jobs, spacc_pop_jobs);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  108  	spacc_irq_glbl_disable(&priv->spacc);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  109  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  110  	priv->spacc.dptr = &pdev->dev;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  111  	platform_set_drvdata(pdev, priv);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  112  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  113  	irq_num = platform_get_irq(pdev, 0);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  114  	if (irq_num < 0) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  115  		err = irq_num;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  116  		goto free_spacc_workq;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  117  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  118  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  119  	/* determine configured maximum message length */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  120  	priv->max_msg_len = priv->spacc.config.max_msg_size;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  121  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  122  	irq_ret = devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  123  			     IRQF_SHARED, dev_name(&pdev->dev),
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  124  			     &pdev->dev);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  125  	if (irq_ret) {
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  126  		dev_err(&pdev->dev, "Failed to request IRQ : %d\n", irq_ret);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  127  		err = irq_ret;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  128  		goto free_spacc_workq;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  129  	}
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  130  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  131  	priv->spacc.irq_cb_stat = spacc_stat_process;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  132  	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  133  	oldmode			= priv->spacc.op_mode;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  134  	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  135  
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  136  	/* Enable STAT and CMD interrupts */
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  137  	SPACC_IRQ_STAT_CLEAR_STAT(&priv->spacc); //added to clear the fifo
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  138  	spacc_irq_stat_enable(&priv->spacc, 1);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  139  	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  140  	spacc_irq_stat_wd_disable(&priv->spacc);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  141  	spacc_irq_glbl_enable(&priv->spacc);
80e3d20d74a76e Pavitrakumar Managutte 2026-02-18  142  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
