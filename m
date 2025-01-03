Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36BA1A8F9A
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2025 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735919974; cv=none; b=PuGZHbxmCHH4YQKewh5BqWnOV22Iu9ZC6CMp1qXInJS2ymZVyvOApiazhPpctIfBcoB0MJH5mhBgsz6ZEXBZI0oKtTVCVd8e4+8bXEmiMIb2TKlCsS3VheNMz1ql3A22pU05kIaBaHCVpdIJTeEXb0Xz9YA1FGHGDPwhNqBGNRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735919974; c=relaxed/simple;
	bh=2I0Q6K5lDZZESuPiwTMID9AHjYtJUZRT/bWgEkKrBms=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tsFCYgAK7rfqCDwAoyK++b9MJ0PNJl3CZU89+m8HsTB1ofJGq6KJufRY6CceYI6eL0ZX235plZnXKeflkCFZPWee8Uz2N4uj45tFQDJgiZnE9OJUowUjFfOKcKLjkfpLN7pV0B04+k2AikhZzxtJCO3B6m0HErGHkAcMxN1dF2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MCPR4U60; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MCPR4U60"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735919973; x=1767455973;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2I0Q6K5lDZZESuPiwTMID9AHjYtJUZRT/bWgEkKrBms=;
  b=MCPR4U60y2+y0u4Xl2o1m/oNrB2a4SmTF1BSIAORwInY1jhQ5o94qxSA
   gQjpYxNuKijfI0GeN0cMj2if66o5cXzFljxvEb1x5MnVtJeeOeyK4Q0eG
   fhJ26aMG79XNnuwbW1KKiqpiK3Rr7id8hcgAc1+sUf6yRVJ38NUto0EQL
   dSKKGsewHQEfoMa6sdsdKzA5YXKTr4uZl9pqThj++KKn0YJJC/Peqb5Yb
   HgNxz79wvNBy50Hnbpz6Cn3pARpGX/y+seTQfyFdv0Gb36/OUHLwddLCT
   QPJ1VxN9Go+ew7dFoefZ4kDb+TgOSpcqQZLWL8NkItqHrom81bItbvjf2
   w==;
X-CSE-ConnectionGUID: 5p3ZksbaStiLCZJunUA84w==
X-CSE-MsgGUID: WNO3jGbbTXuFmzz1ifLgjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="36046442"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36046442"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 07:59:32 -0800
X-CSE-ConnectionGUID: mhf/wNXiT7aaYRJNyC5anQ==
X-CSE-MsgGUID: 0c+jaZhvSLWIlqBBO35wEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="101657025"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 03 Jan 2025 07:59:30 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tTk5A-0009xj-0t;
	Fri, 03 Jan 2025 15:59:28 +0000
Date: Fri, 3 Jan 2025 23:59:08 +0800
From: kernel test robot <lkp@intel.com>
To: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [herbert-cryptodev-2.6:master 20/50] drivers/crypto/qce/sha.c:365:3:
 error: cannot jump from this goto statement to its label
Message-ID: <202501032355.vSmyIynw-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   4ebd9a5ca478673cfbb38795cc5b3adb4f35fe04
commit: ce8fd0500b741b3669c246cc604f1f2343cdd6fd [20/50] crypto: qce - use __free() for a buffer that's always freed
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250103/202501032355.vSmyIynw-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250103/202501032355.vSmyIynw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501032355.vSmyIynw-lkp@intel.com/

Note: the herbert-cryptodev-2.6/master HEAD 4ebd9a5ca478673cfbb38795cc5b3adb4f35fe04 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   In file included from drivers/crypto/qce/sha.c:8:
   In file included from include/linux/dma-mapping.h:8:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto statement to its label
     365 |                 goto err_free_ahash;
         |                 ^
   drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of variable with __attribute__((cleanup))
     373 |         u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
         |             ^
   4 warnings and 1 error generated.


vim +365 drivers/crypto/qce/sha.c

ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  329  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  330  static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  331  				 unsigned int keylen)
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  332  {
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  333  	unsigned int digestsize = crypto_ahash_digestsize(tfm);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  334  	struct qce_sha_ctx *ctx = crypto_tfm_ctx(&tfm->base);
c70e5f9403103c Gilad Ben-Yossef    2017-10-18  335  	struct crypto_wait wait;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  336  	struct ahash_request *req;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  337  	struct scatterlist sg;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  338  	unsigned int blocksize;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  339  	struct crypto_ahash *ahash_tfm;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  340  	int ret;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  341  	const char *alg_name;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  342  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  343  	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  344  	memset(ctx->authkey, 0, sizeof(ctx->authkey));
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  345  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  346  	if (keylen <= blocksize) {
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  347  		memcpy(ctx->authkey, key, keylen);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  348  		return 0;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  349  	}
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  350  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  351  	if (digestsize == SHA1_DIGEST_SIZE)
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  352  		alg_name = "sha1-qce";
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  353  	else if (digestsize == SHA256_DIGEST_SIZE)
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  354  		alg_name = "sha256-qce";
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  355  	else
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  356  		return -EINVAL;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  357  
85d7311f1908b9 Eric Biggers        2018-06-30  358  	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  359  	if (IS_ERR(ahash_tfm))
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  360  		return PTR_ERR(ahash_tfm);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  361  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  362  	req = ahash_request_alloc(ahash_tfm, GFP_KERNEL);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  363  	if (!req) {
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  364  		ret = -ENOMEM;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25 @365  		goto err_free_ahash;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  366  	}
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  367  
c70e5f9403103c Gilad Ben-Yossef    2017-10-18  368  	crypto_init_wait(&wait);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  369  	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
c70e5f9403103c Gilad Ben-Yossef    2017-10-18  370  				   crypto_req_done, &wait);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  371  	crypto_ahash_clear_flags(ahash_tfm, ~0);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  372  
ce8fd0500b741b Bartosz Golaszewski 2024-12-03  373  	u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
ce8fd0500b741b Bartosz Golaszewski 2024-12-03  374  					GFP_KERNEL);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  375  	if (!buf) {
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  376  		ret = -ENOMEM;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  377  		goto err_free_req;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  378  	}
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  379  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  380  	memcpy(buf, key, keylen);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  381  	sg_init_one(&sg, buf, keylen);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  382  	ahash_request_set_crypt(req, &sg, ctx->authkey, keylen);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  383  
c70e5f9403103c Gilad Ben-Yossef    2017-10-18  384  	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  385  
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  386  err_free_req:
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  387  	ahash_request_free(req);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  388  err_free_ahash:
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  389  	crypto_free_ahash(ahash_tfm);
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  390  	return ret;
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  391  }
ec8f5d8f6f76b9 Stanimir Varbanov   2014-06-25  392  

:::::: The code at line 365 was first introduced by commit
:::::: ec8f5d8f6f76b939f662d6e83041abecabef0a34 crypto: qce - Qualcomm crypto engine driver

:::::: TO: Stanimir Varbanov <svarbanov@mm-sol.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
