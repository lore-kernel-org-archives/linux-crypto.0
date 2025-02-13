Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAAE207676;
	Thu, 13 Feb 2025 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739428010; cv=none; b=q4bhOnKtaRCPxMLqCxHDdsQ2NceMoYkINBVGM6vz4tyTGPtauoXENNZoZy0dNae9uoVAeMThL0RyalTa8MZYvdXxhfjLivMFynfXnN8OJBKoSwFv51aqy1+rAkul6jPokaRTdPxzm0XBCYHBarhtoRC/YjDQsy3gGiU1J3Dx/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739428010; c=relaxed/simple;
	bh=oZmU0KoHrhWM8blSSbz/XJuHot3imuYgtI96UTpgbXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTfmR3RB/55bEQrMTKjcjqjh1laQbn3XtuWEU3fmkA5QdqdLQg/jvzD4LWFDIDGzRsLhyG9TZn7hHnFygSX6HeaFqofkBRf4PTSmvDHy1jFAfuKpE+Y9TwqsxDcdF4RBgI9FyVkQoD//T9dW+ef8vHHTGGaY3MiTqJQ1XWFdiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PwbklkDq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PwbklkDq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739428009; x=1770964009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oZmU0KoHrhWM8blSSbz/XJuHot3imuYgtI96UTpgbXg=;
  b=PwbklkDqWCVT4hAh4YcoX/khr4ZEHq37dPr85QR5RPiNgMp52iZz2qpR
   LSlQ3iKbuqb8YKq7ttCFXMmrE87BL7h3A5Xaig2ZplxFqCyxUea4F/PBO
   PqlbkY/KyMUsJ5F0UCf1IzMmhba8KOwjYWFzJZmObFUjL2ocpOUEzLwgD
   2GTWhIGy37omU55wQ+GQpAm+B3SeInMShJP6pGY3FptubzL3K5g4xpLNV
   Dy32r91UV0aXvHXRXcWODK8gv/wQeAzD8jOAsavhiI2C7zge/k3NmbyMK
   Wo2g94cbc++U/EOqOO7pxEfsQwxWQr7eo2v9Ud5Vr7w9+Sxg8cLMOru1K
   Q==;
X-CSE-ConnectionGUID: 0V5VmEmSSlOGFJtHcdSy2w==
X-CSE-MsgGUID: cWarmFWUSSamNeCo49gHBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="62581474"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="62581474"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 22:26:48 -0800
X-CSE-ConnectionGUID: MVmFH9VdTAOgkleN2g4fhg==
X-CSE-MsgGUID: dH9zWk9SR8qJaIs02IqDxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143992862"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 12 Feb 2025 22:26:45 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiSgN-0016dl-0g;
	Thu, 13 Feb 2025 06:26:43 +0000
Date: Thu, 13 Feb 2025 14:26:11 +0800
From: kernel test robot <lkp@intel.com>
To: Akhil R <akhilrajeev@nvidia.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH v2 06/10] crypto: tegra: Fix HASH intermediate result
 handling
Message-ID: <202502131419.R9s0l3RE-lkp@intel.com>
References: <20250211171713.65770-7-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211171713.65770-7-akhilrajeev@nvidia.com>

Hi Akhil,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-crypto-2.6/master]
[also build test WARNING on herbert-cryptodev-2.6/master linus/master v6.14-rc2 next-20250212]
[cannot apply to tegra/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Akhil-R/crypto-tegra-Use-separate-buffer-for-setkey/20250212-012434
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
patch link:    https://lore.kernel.org/r/20250211171713.65770-7-akhilrajeev%40nvidia.com
patch subject: [PATCH v2 06/10] crypto: tegra: Fix HASH intermediate result handling
config: nios2-randconfig-r112-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131419.R9s0l3RE-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250213/202502131419.R9s0l3RE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131419.R9s0l3RE-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
>> drivers/crypto/tegra/tegra-se-hash.c:258:41: sparse: sparse: cast to restricted __be32
   drivers/crypto/tegra/tegra-se-hash.c: note: in included file (through include/uapi/linux/swab.h, include/linux/swab.h, include/uapi/linux/byteorder/little_endian.h, ...):
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini

vim +258 drivers/crypto/tegra/tegra-se-hash.c

   214	
   215	static int tegra_se_insert_hash_result(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
   216				      struct tegra_sha_reqctx *rctx)
   217	{
   218		u32 *res = (u32 *)rctx->intr_res.buf;
   219		int i = 0, j;
   220	
   221		cpuvaddr[i++] = 0;
   222		cpuvaddr[i++] = host1x_opcode_setpayload(HASH_RESULT_REG_COUNT);
   223		cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_HASH_RESULT);
   224	
   225		for (j = 0; j < HASH_RESULT_REG_COUNT; j++) {
   226			int idx = j;
   227	
   228			/*
   229			 * The initial, intermediate and final hash value of SHA-384, SHA-512
   230			 * in SHA_HASH_RESULT registers follow the below layout of bytes.
   231			 *
   232			 * +---------------+------------+
   233			 * | HASH_RESULT_0 | B4...B7    |
   234			 * +---------------+------------+
   235			 * | HASH_RESULT_1 | B0...B3    |
   236			 * +---------------+------------+
   237			 * | HASH_RESULT_2 | B12...B15  |
   238			 * +---------------+------------+
   239			 * | HASH_RESULT_3 | B8...B11   |
   240			 * +---------------+------------+
   241			 * |            ......          |
   242			 * +---------------+------------+
   243			 * | HASH_RESULT_14| B60...B63  |
   244			 * +---------------+------------+
   245			 * | HASH_RESULT_15| B56...B59  |
   246			 * +---------------+------------+
   247			 *
   248			 */
   249			if (ctx->alg == SE_ALG_SHA384 || ctx->alg == SE_ALG_SHA512)
   250				idx = (j % 2) ? j - 1 : j + 1;
   251	
   252			/* For SHA-1, SHA-224, SHA-256, SHA-384, SHA-512 the initial
   253			 * intermediate and final hash value when stored in
   254			 * SHA_HASH_RESULT registers, the byte order is NOT in
   255			 * little-endian.
   256			 */
   257			if (ctx->alg <= SE_ALG_SHA512)
 > 258				cpuvaddr[i++] = be32_to_cpu(res[idx]);
   259			else
   260				cpuvaddr[i++] = res[idx];
   261		}
   262	
   263		return i;
   264	}
   265	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
