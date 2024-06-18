Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E40B157E94;
	Tue, 18 Jun 2024 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717956; cv=none; b=fpCTG6CUqV63QAsrwyJGv1Lf/OQ+Whi09TyWqMOqXx2iyvMIhDJVFGxWG4yWvl6itlaUeTUAJ7IvC5ybQie3beKkaea+LSL0HhkIarY7eS8PDfiukRZ9dB1sebKXcncUHtKhwxxajmxxAuB5AYR9b98ewdIRIbU44eWmzKsKTug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717956; c=relaxed/simple;
	bh=iAfRy8gkHYKnalZbae1lHo5/Dx4Sx6rI8FqrdYS6OF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlhuL402wxM4PR6UpNVn7oovSnfk/4aXsGU2W4Xd5o06RxiAgBDXmzXAyTK4hMenmeuHYoxqNdE+zYdTDeT8pb513GlazEGbajujSJ2J6uf7LWj70Fb57p04JFDSqOLQJMl7w3yuY+GokpQbllxYQNbCwmLbn/pPoUuHa1wjyoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PDzdwsew; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PDzdwsew"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718717954; x=1750253954;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iAfRy8gkHYKnalZbae1lHo5/Dx4Sx6rI8FqrdYS6OF8=;
  b=PDzdwsewue07fR43kpqd7So1QBtIcdwwGgjE+PT/+fnfc5+x6IPjnjKU
   tMkC9/NOWWsZbJ9op7hRwvPQ3AjVJSohBOos/OiuhEKK01T5FZL9cXcyh
   UHjen4eBAQCZgXKXvM4xBoY4Eq8HzRRGVff/5N6PkwYqjCph0t0Tyro2u
   Nq7YZ1roRtQkovxp4eMYFFBR3sBd+xrcxO4EGbjgZKU6iGrGeJPdarT8S
   K/txLXMot++svJ54SaQH2OAq9EKhvyB3/fja0Jp7at2Oy41zKzF3tq+Rg
   JOjPSCRCHS49fBGgCzo42pjcNFH2pB7M5cLaN0I1Yamj79Re5ns0vHhaF
   w==;
X-CSE-ConnectionGUID: ixoCZCBkQ9CBlJ3HVNA2ZQ==
X-CSE-MsgGUID: VsSgCxLdTb+QKEktooc4sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15307207"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15307207"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 06:39:13 -0700
X-CSE-ConnectionGUID: lgsvN0plTlGnaOetNYulWw==
X-CSE-MsgGUID: ovIT9vj4SKOSTSKkvw7Z9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="72306808"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 18 Jun 2024 06:38:54 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sJZ2x-0005Yb-2h;
	Tue, 18 Jun 2024 13:38:51 +0000
Date: Tue, 18 Jun 2024 21:38:35 +0800
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
Message-ID: <202406182149.eAIruF9N-lkp@intel.com>
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
config: mips-randconfig-r121-20240618 (https://download.01.org/0day-ci/archive/20240618/202406182149.eAIruF9N-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 78ee473784e5ef6f0b19ce4cb111fb6e4d23c6b2)
reproduce: (https://download.01.org/0day-ci/archive/20240618/202406182149.eAIruF9N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406182149.eAIruF9N-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __le32 @@
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse:     expected unsigned int [usertype] val
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
