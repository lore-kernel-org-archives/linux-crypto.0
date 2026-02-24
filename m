Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157B73A784C;
	Tue, 24 Feb 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771948674; cv=none; b=LQFvr07PTxOKRzEWYaB3vgw824vmi9gAdjEaD0ylk0RNZrx+etXOP8k0WX28aOSyqNpsVNySh8qcSwP7i99goOkkYL3gg0avW5qc+DDcAYeqfpybOkHQ8BGGDnt8TKqqim8qe+2FxlWkKDLiKzrQMOE/0nAbAUszryoyF6fhwPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771948674; c=relaxed/simple;
	bh=peko8qqw7xpPBO1H1CwH2xIk2NKoKD/7MDtPqjalTrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjXtiPURArwNsSuTL7S80NR3NiesAdDlVo0U4vkJ3sqlvPpyBn1T5n866F8mEqw2eCLEvoKZok1t11a7WRigRgoiCeCLUwtpkO/YnS0y7U7rhj9dGAzGeAlONkf+JCq/Mq1+hGSil31swJa33drcy2B+WDNavC9S6AkgJF7xzEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3VbSvTk; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3VbSvTk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771948670; x=1803484670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=peko8qqw7xpPBO1H1CwH2xIk2NKoKD/7MDtPqjalTrU=;
  b=R3VbSvTkNsLmex6WPlythsd8V/OF8zId7a1oSu6GcoxueZPsUecsOuCA
   td4jbZ38fwqIAzA1FdZ9RChHSnP0APns3vg4nuYIIvvHAqqB8fFaJ1Ylz
   RP5pMieKJGVIIvl5H7hAxWgn4B1PS4VoM55lQz374BRKpNWNSz7lwVcQK
   N0dnoBJkNEy9PeApaGS+IbZEMIpyMMV3CbaqtBgcwqSGgjUTLLDVCJoHz
   pvVosT30kn/Swzx0meIpZ2TrxIGLve8vL45GazXXlv+2Ts8FMq5ENO+Kb
   IIip5jxbOQrrxmsE+hjGn/zmPPU+HhX9QjRy77IprM9TrH8eLWJj7rnDR
   g==;
X-CSE-ConnectionGUID: LmNAnTdwQ9KGcKu1Rjlvug==
X-CSE-MsgGUID: eTvqeZc/RcOeD1yNJ+DG+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="73145933"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="73145933"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 07:57:49 -0800
X-CSE-ConnectionGUID: 5Sjr5vFHSCSeIiT6465xwg==
X-CSE-MsgGUID: lO2LsTrRTzSn/Sannmn3hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="220056335"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 24 Feb 2026 07:57:47 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vuunA-0000000027x-2QeM;
	Tue, 24 Feb 2026 15:57:44 +0000
Date: Tue, 24 Feb 2026 23:57:37 +0800
From: kernel test robot <lkp@intel.com>
To: Shawn Lin <shawn.lin@rock-chips.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Philipp Stanner <phasta@kernel.org>, linux-pci@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: Re: [PATCH 17/37] crypto: safexcel: Replace pci_alloc_irq_vectors()
 with pcim_alloc_irq_vectors()
Message-ID: <202602242339.UGFAC9fD-lkp@intel.com>
References: <1771861910-88163-1-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1771861910-88163-1-git-send-email-shawn.lin@rock-chips.com>

Hi Shawn,

kernel test robot noticed the following build errors:

[auto build test ERROR on pci/next]
[also build test ERROR on pci/for-linus andi-shyti/i2c/i2c-host drm-misc/drm-misc-next linus/master v7.0-rc1 next-20260223]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shawn-Lin/PCI-MSI-Add-Devres-managed-IRQ-vectors-allocation/20260224-161502
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/1771861910-88163-1-git-send-email-shawn.lin%40rock-chips.com
patch subject: [PATCH 17/37] crypto: safexcel: Replace pci_alloc_irq_vectors() with pcim_alloc_irq_vectors()
config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260224/202602242339.UGFAC9fD-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260224/202602242339.UGFAC9fD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602242339.UGFAC9fD-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/inside-secure/safexcel.c: In function 'safexcel_probe_generic':
>> drivers/crypto/inside-secure/safexcel.c:1599:23: error: implicit declaration of function 'pcim_alloc_irq_vectors'; did you mean 'pci_alloc_irq_vectors'? [-Wimplicit-function-declaration]
    1599 |                 ret = pcim_alloc_irq_vectors(pci_pdev,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
         |                       pci_alloc_irq_vectors


vim +1599 drivers/crypto/inside-secure/safexcel.c

  1381	
  1382	/*
  1383	 * Generic part of probe routine, shared by platform and PCI driver
  1384	 *
  1385	 * Assumes IO resources have been mapped, private data mem has been allocated,
  1386	 * clocks have been enabled, device pointer has been assigned etc.
  1387	 *
  1388	 */
  1389	static int safexcel_probe_generic(void *pdev,
  1390					  struct safexcel_crypto_priv *priv,
  1391					  int is_pci_dev)
  1392	{
  1393		struct device *dev = priv->dev;
  1394		u32 peid, version, mask, val, hiaopt, hwopt, peopt;
  1395		int i, ret, hwctg;
  1396	
  1397		priv->context_pool = dmam_pool_create("safexcel-context", dev,
  1398						      sizeof(struct safexcel_context_record),
  1399						      1, 0);
  1400		if (!priv->context_pool)
  1401			return -ENOMEM;
  1402	
  1403		/*
  1404		 * First try the EIP97 HIA version regs
  1405		 * For the EIP197, this is guaranteed to NOT return any of the test
  1406		 * values
  1407		 */
  1408		version = readl(priv->base + EIP97_HIA_AIC_BASE + EIP197_HIA_VERSION);
  1409	
  1410		mask = 0;  /* do not swap */
  1411		if (EIP197_REG_LO16(version) == EIP197_HIA_VERSION_LE) {
  1412			priv->hwconfig.hiaver = EIP197_VERSION_MASK(version);
  1413		} else if (EIP197_REG_HI16(version) == EIP197_HIA_VERSION_BE) {
  1414			/* read back byte-swapped, so complement byte swap bits */
  1415			mask = EIP197_MST_CTRL_BYTE_SWAP_BITS;
  1416			priv->hwconfig.hiaver = EIP197_VERSION_SWAP(version);
  1417		} else {
  1418			/* So it wasn't an EIP97 ... maybe it's an EIP197? */
  1419			version = readl(priv->base + EIP197_HIA_AIC_BASE +
  1420					EIP197_HIA_VERSION);
  1421			if (EIP197_REG_LO16(version) == EIP197_HIA_VERSION_LE) {
  1422				priv->hwconfig.hiaver = EIP197_VERSION_MASK(version);
  1423				priv->flags |= SAFEXCEL_HW_EIP197;
  1424			} else if (EIP197_REG_HI16(version) ==
  1425				   EIP197_HIA_VERSION_BE) {
  1426				/* read back byte-swapped, so complement swap bits */
  1427				mask = EIP197_MST_CTRL_BYTE_SWAP_BITS;
  1428				priv->hwconfig.hiaver = EIP197_VERSION_SWAP(version);
  1429				priv->flags |= SAFEXCEL_HW_EIP197;
  1430			} else {
  1431				return -ENODEV;
  1432			}
  1433		}
  1434	
  1435		/* Now initialize the reg offsets based on the probing info so far */
  1436		safexcel_init_register_offsets(priv);
  1437	
  1438		/*
  1439		 * If the version was read byte-swapped, we need to flip the device
  1440		 * swapping Keep in mind here, though, that what we write will also be
  1441		 * byte-swapped ...
  1442		 */
  1443		if (mask) {
  1444			val = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
  1445			val = val ^ (mask >> 24); /* toggle byte swap bits */
  1446			writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
  1447		}
  1448	
  1449		/*
  1450		 * We're not done probing yet! We may fall through to here if no HIA
  1451		 * was found at all. So, with the endianness presumably correct now and
  1452		 * the offsets setup, *really* probe for the EIP97/EIP197.
  1453		 */
  1454		version = readl(EIP197_GLOBAL(priv) + EIP197_VERSION);
  1455		if (((priv->flags & SAFEXCEL_HW_EIP197) &&
  1456		     (EIP197_REG_LO16(version) != EIP197_VERSION_LE) &&
  1457		     (EIP197_REG_LO16(version) != EIP196_VERSION_LE)) ||
  1458		    ((!(priv->flags & SAFEXCEL_HW_EIP197) &&
  1459		     (EIP197_REG_LO16(version) != EIP97_VERSION_LE)))) {
  1460			/*
  1461			 * We did not find the device that matched our initial probing
  1462			 * (or our initial probing failed) Report appropriate error.
  1463			 */
  1464			dev_err(priv->dev, "Probing for EIP97/EIP19x failed - no such device (read %08x)\n",
  1465				version);
  1466			return -ENODEV;
  1467		}
  1468	
  1469		priv->hwconfig.hwver = EIP197_VERSION_MASK(version);
  1470		hwctg = version >> 28;
  1471		peid = version & 255;
  1472	
  1473		/* Detect EIP206 processing pipe */
  1474		version = readl(EIP197_PE(priv) + + EIP197_PE_VERSION(0));
  1475		if (EIP197_REG_LO16(version) != EIP206_VERSION_LE) {
  1476			dev_err(priv->dev, "EIP%d: EIP206 not detected\n", peid);
  1477			return -ENODEV;
  1478		}
  1479		priv->hwconfig.ppver = EIP197_VERSION_MASK(version);
  1480	
  1481		/* Detect EIP96 packet engine and version */
  1482		version = readl(EIP197_PE(priv) + EIP197_PE_EIP96_VERSION(0));
  1483		if (EIP197_REG_LO16(version) != EIP96_VERSION_LE) {
  1484			dev_err(dev, "EIP%d: EIP96 not detected.\n", peid);
  1485			return -ENODEV;
  1486		}
  1487		priv->hwconfig.pever = EIP197_VERSION_MASK(version);
  1488	
  1489		hwopt = readl(EIP197_GLOBAL(priv) + EIP197_OPTIONS);
  1490		hiaopt = readl(EIP197_HIA_AIC(priv) + EIP197_HIA_OPTIONS);
  1491	
  1492		priv->hwconfig.icever = 0;
  1493		priv->hwconfig.ocever = 0;
  1494		priv->hwconfig.psever = 0;
  1495		if (priv->flags & SAFEXCEL_HW_EIP197) {
  1496			/* EIP197 */
  1497			peopt = readl(EIP197_PE(priv) + EIP197_PE_OPTIONS(0));
  1498	
  1499			priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
  1500						  EIP197_HWDATAW_MASK;
  1501			priv->hwconfig.hwcfsize = ((hiaopt >> EIP197_CFSIZE_OFFSET) &
  1502						   EIP197_CFSIZE_MASK) +
  1503						  EIP197_CFSIZE_ADJUST;
  1504			priv->hwconfig.hwrfsize = ((hiaopt >> EIP197_RFSIZE_OFFSET) &
  1505						   EIP197_RFSIZE_MASK) +
  1506						  EIP197_RFSIZE_ADJUST;
  1507			priv->hwconfig.hwnumpes	= (hiaopt >> EIP197_N_PES_OFFSET) &
  1508						  EIP197_N_PES_MASK;
  1509			priv->hwconfig.hwnumrings = (hiaopt >> EIP197_N_RINGS_OFFSET) &
  1510						    EIP197_N_RINGS_MASK;
  1511			if (hiaopt & EIP197_HIA_OPT_HAS_PE_ARB)
  1512				priv->flags |= EIP197_PE_ARB;
  1513			if (EIP206_OPT_ICE_TYPE(peopt) == 1) {
  1514				priv->flags |= EIP197_ICE;
  1515				/* Detect ICE EIP207 class. engine and version */
  1516				version = readl(EIP197_PE(priv) +
  1517					  EIP197_PE_ICE_VERSION(0));
  1518				if (EIP197_REG_LO16(version) != EIP207_VERSION_LE) {
  1519					dev_err(dev, "EIP%d: ICE EIP207 not detected.\n",
  1520						peid);
  1521					return -ENODEV;
  1522				}
  1523				priv->hwconfig.icever = EIP197_VERSION_MASK(version);
  1524			}
  1525			if (EIP206_OPT_OCE_TYPE(peopt) == 1) {
  1526				priv->flags |= EIP197_OCE;
  1527				/* Detect EIP96PP packet stream editor and version */
  1528				version = readl(EIP197_PE(priv) + EIP197_PE_PSE_VERSION(0));
  1529				if (EIP197_REG_LO16(version) != EIP96_VERSION_LE) {
  1530					dev_err(dev, "EIP%d: EIP96PP not detected.\n", peid);
  1531					return -ENODEV;
  1532				}
  1533				priv->hwconfig.psever = EIP197_VERSION_MASK(version);
  1534				/* Detect OCE EIP207 class. engine and version */
  1535				version = readl(EIP197_PE(priv) +
  1536					  EIP197_PE_ICE_VERSION(0));
  1537				if (EIP197_REG_LO16(version) != EIP207_VERSION_LE) {
  1538					dev_err(dev, "EIP%d: OCE EIP207 not detected.\n",
  1539						peid);
  1540					return -ENODEV;
  1541				}
  1542				priv->hwconfig.ocever = EIP197_VERSION_MASK(version);
  1543			}
  1544			/* If not a full TRC, then assume simple TRC */
  1545			if (!(hwopt & EIP197_OPT_HAS_TRC))
  1546				priv->flags |= EIP197_SIMPLE_TRC;
  1547			/* EIP197 always has SOME form of TRC */
  1548			priv->flags |= EIP197_TRC_CACHE;
  1549		} else {
  1550			/* EIP97 */
  1551			priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
  1552						  EIP97_HWDATAW_MASK;
  1553			priv->hwconfig.hwcfsize = (hiaopt >> EIP97_CFSIZE_OFFSET) &
  1554						  EIP97_CFSIZE_MASK;
  1555			priv->hwconfig.hwrfsize = (hiaopt >> EIP97_RFSIZE_OFFSET) &
  1556						  EIP97_RFSIZE_MASK;
  1557			priv->hwconfig.hwnumpes	= 1; /* by definition */
  1558			priv->hwconfig.hwnumrings = (hiaopt >> EIP197_N_RINGS_OFFSET) &
  1559						    EIP197_N_RINGS_MASK;
  1560		}
  1561	
  1562		/* Scan for ring AIC's */
  1563		for (i = 0; i < EIP197_MAX_RING_AIC; i++) {
  1564			version = readl(EIP197_HIA_AIC_R(priv) +
  1565					EIP197_HIA_AIC_R_VERSION(i));
  1566			if (EIP197_REG_LO16(version) != EIP201_VERSION_LE)
  1567				break;
  1568		}
  1569		priv->hwconfig.hwnumraic = i;
  1570		/* Low-end EIP196 may not have any ring AIC's ... */
  1571		if (!priv->hwconfig.hwnumraic) {
  1572			dev_err(priv->dev, "No ring interrupt controller present!\n");
  1573			return -ENODEV;
  1574		}
  1575	
  1576		/* Get supported algorithms from EIP96 transform engine */
  1577		priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
  1578					    EIP197_PE_EIP96_OPTIONS(0));
  1579	
  1580		/* Print single info line describing what we just detected */
  1581		dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x/%x(alg:%08x)/%x/%x/%x\n",
  1582			 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hwnumpes,
  1583			 priv->hwconfig.hwnumrings, priv->hwconfig.hwnumraic,
  1584			 priv->hwconfig.hiaver, priv->hwconfig.hwdataw,
  1585			 priv->hwconfig.hwcfsize, priv->hwconfig.hwrfsize,
  1586			 priv->hwconfig.ppver, priv->hwconfig.pever,
  1587			 priv->hwconfig.algo_flags, priv->hwconfig.icever,
  1588			 priv->hwconfig.ocever, priv->hwconfig.psever);
  1589	
  1590		safexcel_configure(priv);
  1591	
  1592		if (IS_ENABLED(CONFIG_PCI) && priv->data->version == EIP197_DEVBRD) {
  1593			/*
  1594			 * Request MSI vectors for global + 1 per ring -
  1595			 * or just 1 for older dev images
  1596			 */
  1597			struct pci_dev *pci_pdev = pdev;
  1598	
> 1599			ret = pcim_alloc_irq_vectors(pci_pdev,
  1600						     priv->config.rings + 1,
  1601						     priv->config.rings + 1,
  1602						     PCI_IRQ_MSI | PCI_IRQ_MSIX);
  1603			if (ret < 0) {
  1604				dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
  1605				return ret;
  1606			}
  1607		}
  1608	
  1609		/* Register the ring IRQ handlers and configure the rings */
  1610		priv->ring = devm_kcalloc(dev, priv->config.rings,
  1611					  sizeof(*priv->ring),
  1612					  GFP_KERNEL);
  1613		if (!priv->ring)
  1614			return -ENOMEM;
  1615	
  1616		for (i = 0; i < priv->config.rings; i++) {
  1617			char wq_name[9] = {0};
  1618			int irq;
  1619			struct safexcel_ring_irq_data *ring_irq;
  1620	
  1621			ret = safexcel_init_ring_descriptors(priv,
  1622							     &priv->ring[i].cdr,
  1623							     &priv->ring[i].rdr);
  1624			if (ret) {
  1625				dev_err(dev, "Failed to initialize rings\n");
  1626				goto err_cleanup_rings;
  1627			}
  1628	
  1629			priv->ring[i].rdr_req = devm_kcalloc(dev,
  1630				EIP197_DEFAULT_RING_SIZE,
  1631				sizeof(*priv->ring[i].rdr_req),
  1632				GFP_KERNEL);
  1633			if (!priv->ring[i].rdr_req) {
  1634				ret = -ENOMEM;
  1635				goto err_cleanup_rings;
  1636			}
  1637	
  1638			ring_irq = devm_kzalloc(dev, sizeof(*ring_irq), GFP_KERNEL);
  1639			if (!ring_irq) {
  1640				ret = -ENOMEM;
  1641				goto err_cleanup_rings;
  1642			}
  1643	
  1644			ring_irq->priv = priv;
  1645			ring_irq->ring = i;
  1646	
  1647			irq = safexcel_request_ring_irq(pdev,
  1648							EIP197_IRQ_NUMBER(i, is_pci_dev),
  1649							is_pci_dev,
  1650							i,
  1651							safexcel_irq_ring,
  1652							safexcel_irq_ring_thread,
  1653							ring_irq);
  1654			if (irq < 0) {
  1655				dev_err(dev, "Failed to get IRQ ID for ring %d\n", i);
  1656				ret = irq;
  1657				goto err_cleanup_rings;
  1658			}
  1659	
  1660			priv->ring[i].irq = irq;
  1661			priv->ring[i].work_data.priv = priv;
  1662			priv->ring[i].work_data.ring = i;
  1663			INIT_WORK(&priv->ring[i].work_data.work,
  1664				  safexcel_dequeue_work);
  1665	
  1666			snprintf(wq_name, 9, "wq_ring%d", i);
  1667			priv->ring[i].workqueue =
  1668				create_singlethread_workqueue(wq_name);
  1669			if (!priv->ring[i].workqueue) {
  1670				ret = -ENOMEM;
  1671				goto err_cleanup_rings;
  1672			}
  1673	
  1674			priv->ring[i].requests = 0;
  1675			priv->ring[i].busy = false;
  1676	
  1677			crypto_init_queue(&priv->ring[i].queue,
  1678					  EIP197_DEFAULT_RING_SIZE);
  1679	
  1680			spin_lock_init(&priv->ring[i].lock);
  1681			spin_lock_init(&priv->ring[i].queue_lock);
  1682		}
  1683	
  1684		atomic_set(&priv->ring_used, 0);
  1685	
  1686		ret = safexcel_hw_init(priv);
  1687		if (ret) {
  1688			dev_err(dev, "HW init failed (%d)\n", ret);
  1689			goto err_cleanup_rings;
  1690		}
  1691	
  1692		ret = safexcel_register_algorithms(priv);
  1693		if (ret) {
  1694			dev_err(dev, "Failed to register algorithms (%d)\n", ret);
  1695			goto err_cleanup_rings;
  1696		}
  1697	
  1698		return 0;
  1699	
  1700	err_cleanup_rings:
  1701		for (i = 0; i < priv->config.rings; i++) {
  1702			if (priv->ring[i].irq)
  1703				irq_set_affinity_hint(priv->ring[i].irq, NULL);
  1704			if (priv->ring[i].workqueue)
  1705				destroy_workqueue(priv->ring[i].workqueue);
  1706		}
  1707	
  1708		return ret;
  1709	}
  1710	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
