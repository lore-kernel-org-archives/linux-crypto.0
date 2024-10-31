Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A361D07A1
	for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730413799; cv=none; b=X0nRKs5PMGSQhzUGgFf1Wwfbjgoj9xXyOC7v24YyYSNW6jiezChM5KS7q6ZvzJBgOdqfcK9N9PE7SOgvL2fppJWR/Bqxn8QIRPFmr2AqcuvBHoz21yZnBW9X/5jUgpidFnu5zoWmsvQmB3KZl8AWTQNXtebqQrETanM/tjCPXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730413799; c=relaxed/simple;
	bh=gfExzRVIiCsyBcfiuxmk8/vB7AsepBEklgDEmIrCP1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOEKgN0AZJboXGActiqaeGo/F3LGqJWifBTRJKhlKFu7QV3FqIsXHj3JfD6uG9ZDpezczNpbdO7mzproCTDOYKkb4zk6q+g/zA7NB1LADbJmght4MDdhuezA0T2iOr+gBmZDNnipPcHVtAhC68d9rV759xyI2/+5gcWwIM3efcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QiniLUTI; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QiniLUTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730413792; x=1761949792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gfExzRVIiCsyBcfiuxmk8/vB7AsepBEklgDEmIrCP1Q=;
  b=QiniLUTIyGx/WZRLo0mJ5JktSdhHke+QOJ50qFTyqkov0M2NAaghSNGa
   RKKnOIVgUkekbN/8A8Lyq/CiLmbuzJzYioQqAa0r05BPXro9JZeMlp0Fl
   6SAvj+JctelcyvsxlaWR+iU7m0k53E+Nc2cIbKWos6bm2s9QV7f0rz720
   Sh5cYsZyHFfzBF89ShGnCSzCRWd85ZbTbxdONHIBYc7ecgUEbZ5VK1q9n
   0iNQHTYLn1eqGCynAOW2HFIVqWtUdzYHqngxrqFjsskq2z307xo6JbNdq
   m+8ICohRtU+R+bPQY9qqtPgUZbwuLL7kN/CwAVjV8ydZpubWKdFDrqRx4
   Q==;
X-CSE-ConnectionGUID: kj1wA3sOSTWGo3gRw/GLQg==
X-CSE-MsgGUID: m1rofBRVRWm9ym1igcQTbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17816412"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="17816412"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 15:29:51 -0700
X-CSE-ConnectionGUID: ps6G4aFvSR6uDDj7adBmiQ==
X-CSE-MsgGUID: Uc3Tl58ZSquREg+QHg3feg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="83587919"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 31 Oct 2024 15:29:50 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6dfn-000gn0-0y;
	Thu, 31 Oct 2024 22:29:47 +0000
Date: Fri, 1 Nov 2024 06:29:31 +0800
From: kernel test robot <lkp@intel.com>
To: Harald Freudenberger <freude@linux.ibm.com>, dengler@linux.ibm.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, hca@linux.ibm.com
Cc: oe-kbuild-all@lists.linux.dev,
	linux390-list@tuxmaker.boeblingen.de.ibm.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <202411010609.n8fzUWMm-lkp@intel.com>
References: <20241030162235.363533-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030162235.363533-4-freude@linux.ibm.com>

Hi Harald,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on s390/features linus/master v6.12-rc5 next-20241031]
[cannot apply to herbert-crypto-2.6/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harald-Freudenberger/crypto-api-Adjust-HASH_MAX_DESCSIZE-for-phmac-context-on-s390/20241031-002930
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241030162235.363533-4-freude%40linux.ibm.com
patch subject: [PATCH v1 3/3] s390/crypto: New s390 specific shash phmac
config: s390-randconfig-r053-20241101 (https://download.01.org/0day-ci/archive/20241101/202411010609.n8fzUWMm-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411010609.n8fzUWMm-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> arch/s390/crypto/phmac_s390.c:165:16-23: WARNING opportunity for kmemdup

vim +165 arch/s390/crypto/phmac_s390.c

   152	
   153	static inline int s390_phmac_sha2_setkey(struct crypto_shash *tfm,
   154						 const u8 *key, unsigned int keylen)
   155	{
   156		struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
   157		int rc = -ENOMEM;
   158	
   159		if (tfm_ctx->keylen) {
   160			kfree_sensitive(tfm_ctx->key);
   161			tfm_ctx->key = NULL;
   162			tfm_ctx->keylen = 0;
   163		}
   164	
 > 165		tfm_ctx->key = kmalloc(keylen, GFP_KERNEL);
   166		if (!tfm_ctx->key)
   167			goto out;
   168		memcpy(tfm_ctx->key, key, keylen);
   169		tfm_ctx->keylen = keylen;
   170	
   171		rc = phmac_convert_key(tfm_ctx);
   172		if (rc)
   173			goto out;
   174	
   175		rc = -EINVAL;
   176		switch (crypto_shash_digestsize(tfm)) {
   177		case SHA224_DIGEST_SIZE:
   178		case SHA256_DIGEST_SIZE:
   179			if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_512)
   180				goto out;
   181			break;
   182		case SHA384_DIGEST_SIZE:
   183		case SHA512_DIGEST_SIZE:
   184			if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_1024)
   185				goto out;
   186			break;
   187		default:
   188			goto out;
   189		}
   190		rc = 0;
   191	
   192	out:
   193		pr_debug("rc=%d\n", rc);
   194		return rc;
   195	}
   196	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
