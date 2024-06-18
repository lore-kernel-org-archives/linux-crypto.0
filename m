Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE06D1B9;
	Tue, 18 Jun 2024 07:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718696386; cv=none; b=qgVifls1M5LWBJYq3Z19GyhTZ7EgXobIDsAPyDn4wl3EHE7Jbo97WKZg+VzYG5I1R0spuvtJHNbHp+oq+/0wKcEOUJmg/5HAd6wIPnZrsGiOdL8bi1/6HENL1qv52gBlLqEri+qQVv6BvCckhi5Hd0EOkBd1A0l33MsrKB2cAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718696386; c=relaxed/simple;
	bh=OjKlfNpd7OTHedF4ooTljpuB/fy48tL79BH5283OL2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8xPx5yGW8WLSXkSFJ2uMGzNu2cJZ/y0z+eMcgkhAEjr+E9IfzBWkesv6jeN6EfyGbZofyuUxeLqtZ4XMc87RnTf6yKVUWvpwBRRDsR63NwR54VyYkxlcs/ZkMcXRlPq9pJrlRGDccfqrIwPNSm5fYPLnZ6pB4oX55U68/hy9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAulVbrO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAulVbrO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718696383; x=1750232383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OjKlfNpd7OTHedF4ooTljpuB/fy48tL79BH5283OL2c=;
  b=LAulVbrOjdfYS2fk4hIsGQOY2QNFumUYSL5QsQ0tCDO3MPCxOVoTOBFU
   T+63+X02Jf0TOjcbfu7zSADriPpxty3209Nz9JzUOhpkKze6ye4uWYtta
   GlxjknogH9gM4h2VrLxON4MJRfQ66vOZuTYYWWM1g3UgqknIMX8yq4aIl
   BE8953DY2/0kLJLZp5fNJB3maGO8jOeC/Zm0792tQn4pIzBQurQS7vd4J
   vx27f1lOJN2tSPmnBMLAxQO/Mg7zwAIZJxJUmLJCvGHCBGgdwGSVFGbIP
   6WjmGijsGXbMZ2zg67ihShJQun4HjP4o7xYPNNBn4lLUdZndLRFnw/fBQ
   Q==;
X-CSE-ConnectionGUID: qJCOoPSJRWydcAM/clWPmg==
X-CSE-MsgGUID: TkrBEcBDTRKzsX1vH3rQ5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="33026728"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="33026728"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 00:39:42 -0700
X-CSE-ConnectionGUID: ZH26BE4mRAesZDWo1QDSVg==
X-CSE-MsgGUID: dOhvDB2lRZezr651awkCQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="45998161"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 18 Jun 2024 00:39:38 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sJTRI-0005JJ-1Z;
	Tue, 18 Jun 2024 07:39:36 +0000
Date: Tue, 18 Jun 2024 15:39:21 +0800
From: kernel test robot <lkp@intel.com>
To: Andre Przywara <andre.przywara@arm.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor
 address fields
Message-ID: <202406181436.RZPPffYb-lkp@intel.com>
References: <20240616220719.26641-3-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240616220719.26641-3-andre.przywara@arm.com>

Hi Andre,

kernel test robot noticed the following build warnings:

[auto build test WARNING on sunxi/sunxi/for-next]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.10-rc4 next-20240617]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andre-Przywara/dt-bindings-crypto-sun8i-ce-Add-compatible-for-H616/20240617-061144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git sunxi/for-next
patch link:    https://lore.kernel.org/r/20240616220719.26641-3-andre.przywara%40arm.com
patch subject: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor address fields
config: loongarch-randconfig-r111-20240618 (https://download.01.org/0day-ci/archive/20240618/202406181436.RZPPffYb-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240618/202406181436.RZPPffYb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406181436.RZPPffYb-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 @@
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse:     expected unsigned int [usertype] value
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse:     got restricted __le32

vim +175 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c

   167	
   168		mutex_lock(&ce->mlock);
   169	
   170		v = readl(ce->base + CE_ICR);
   171		v |= 1 << flow;
   172		writel(v, ce->base + CE_ICR);
   173	
   174		reinit_completion(&ce->chanlist[flow].complete);
 > 175		writel(sun8i_ce_desc_addr(ce, ce->chanlist[flow].t_phy),
   176		       ce->base + CE_TDQ);
   177	
   178		ce->chanlist[flow].status = 0;
   179		/* Be sure all data is written before enabling the task */
   180		wmb();
   181	
   182		/* Only H6 needs to write a part of t_common_ctl along with "1", but since it is ignored
   183		 * on older SoCs, we have no reason to complicate things.
   184		 */
   185		v = 1 | ((le32_to_cpu(ce->chanlist[flow].tl->t_common_ctl) & 0x7F) << 8);
   186		writel(v, ce->base + CE_TLR);
   187		mutex_unlock(&ce->mlock);
   188	
   189		wait_for_completion_interruptible_timeout(&ce->chanlist[flow].complete,
   190				msecs_to_jiffies(ce->chanlist[flow].timeout));
   191	
   192		if (ce->chanlist[flow].status == 0) {
   193			dev_err(ce->dev, "DMA timeout for %s (tm=%d) on flow %d\n", name,
   194				ce->chanlist[flow].timeout, flow);
   195			err = -EFAULT;
   196		}
   197		/* No need to lock for this read, the channel is locked so
   198		 * nothing could modify the error value for this channel
   199		 */
   200		v = readl(ce->base + CE_ESR);
   201		switch (ce->variant->esr) {
   202		case ESR_H3:
   203			/* Sadly, the error bit is not per flow */
   204			if (v) {
   205				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
   206				err = -EFAULT;
   207				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
   208					       cet, sizeof(struct ce_task), false);
   209			}
   210			if (v & CE_ERR_ALGO_NOTSUP)
   211				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
   212			if (v & CE_ERR_DATALEN)
   213				dev_err(ce->dev, "CE ERROR: data length error\n");
   214			if (v & CE_ERR_KEYSRAM)
   215				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
   216			break;
   217		case ESR_A64:
   218		case ESR_D1:
   219		case ESR_H5:
   220		case ESR_R40:
   221			v >>= (flow * 4);
   222			v &= 0xF;
   223			if (v) {
   224				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
   225				err = -EFAULT;
   226				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
   227					       cet, sizeof(struct ce_task), false);
   228			}
   229			if (v & CE_ERR_ALGO_NOTSUP)
   230				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
   231			if (v & CE_ERR_DATALEN)
   232				dev_err(ce->dev, "CE ERROR: data length error\n");
   233			if (v & CE_ERR_KEYSRAM)
   234				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
   235			break;
   236		case ESR_H6:
   237			v >>= (flow * 8);
   238			v &= 0xFF;
   239			if (v) {
   240				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
   241				err = -EFAULT;
   242				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
   243					       cet, sizeof(struct ce_task), false);
   244			}
   245			if (v & CE_ERR_ALGO_NOTSUP)
   246				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
   247			if (v & CE_ERR_DATALEN)
   248				dev_err(ce->dev, "CE ERROR: data length error\n");
   249			if (v & CE_ERR_KEYSRAM)
   250				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
   251			if (v & CE_ERR_ADDR_INVALID)
   252				dev_err(ce->dev, "CE ERROR: address invalid\n");
   253			if (v & CE_ERR_KEYLADDER)
   254				dev_err(ce->dev, "CE ERROR: key ladder configuration error\n");
   255			break;
   256		}
   257	
   258		return err;
   259	}
   260	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
