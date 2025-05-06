Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361252236F0
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 07:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746516347; cv=none; b=jfoY1o6WeZVktyXPuSDJq3B08uBZUDDaEOy7syX+XrP4ZftcaDrM9Qi31VOMeWwVdlMeuUJ9gp7glc47eoSlgEr3VRNZdFin11tSzSH72ZC1RVOYUlBoK/DDxMhwxjpTP909RJ1uRwRiImEdOBIhThhRS3VQIUU5JteCRdtoQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746516347; c=relaxed/simple;
	bh=IQ2g0vfjS7LsZoWEsSyywdKste1NDyx+b2TdQtbkkbI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AhA3JNtOyinaOOtrTffKZb8UsGxTscvcOQC8pLs5pV1Hnh1eBulM9q0AvVZir9yl+hRhHFTzePF4L2NPjuxrdCJOUhrZtSRiEAlFB2gOHaeWQHQsmf8mKMJE7x4kIjTd3PaPcTt9QgI6jr8w6U9pf5YCv/WJqe3mKvUVxPBM/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jQy8B9So; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQy8B9So"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746516345; x=1778052345;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IQ2g0vfjS7LsZoWEsSyywdKste1NDyx+b2TdQtbkkbI=;
  b=jQy8B9SoYGrE7AJLIxVCguysNLmD2KDfHc41DqzOYD1WHDAwZN/abpQ6
   BNOa/QKgq+tSBsoikRo0wlhIgEp2BVX1DqGSPw9uFfr7N94FDvXi0wuIu
   R0hj27uvZXLmdXQojznXWwck+H6Gd1Z40JVPBwe4V7ZLNgJtyS3Pvz/P8
   WKePyIWQH5Kf6cVe/J8msNzLdtyQ1HPFpWTkldkTATfJNKarMU45dJbVs
   yShypI+ne8dch47uTGMTkZA9a7I0wcbt/qjI0QbOqlpM+4N9q1cU6mTQr
   Sid+bWyABNbBIDgbLxdudARzQT8pADkYKZnZS8T/RIfxXSi2mOon3mcse
   Q==;
X-CSE-ConnectionGUID: Ch+Sst9TTC+PZwfOR2DcWA==
X-CSE-MsgGUID: 7qVMsn9rRI+i3DHc7NECRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="48299155"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="48299155"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 00:25:45 -0700
X-CSE-ConnectionGUID: wX6htsutTjaL97/A+YS/7g==
X-CSE-MsgGUID: TeqHJ+RxQmKZxQoFwNMbuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="136048567"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2025 00:25:44 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCCgQ-0006M6-02;
	Tue, 06 May 2025 07:25:42 +0000
Date: Tue, 6 May 2025 15:24:51 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 12/70] crypto/chacha20poly1305.c:155:
 undefined reference to `poly1305_init'
Message-ID: <202505061528.81rDmpF9-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   43d9d3e84ee1bc1ca98a964e0963bab39de36a44
commit: 10a6d72ea355b730aa9702da0fd36aef0898a80e [12/70] crypto: lib/poly1305 - Use block-only interface
config: x86_64-randconfig-004-20250506 (https://download.01.org/0day-ci/archive/20250506/202505061528.81rDmpF9-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250506/202505061528.81rDmpF9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505061528.81rDmpF9-lkp@intel.com/

Note: the herbert-cryptodev-2.6/master HEAD 43d9d3e84ee1bc1ca98a964e0963bab39de36a44 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   ld: crypto/chacha20poly1305.o: in function `poly_hash':
>> crypto/chacha20poly1305.c:155: undefined reference to `poly1305_init'
>> ld: crypto/chacha20poly1305.c:162: undefined reference to `poly1305_update'
   ld: crypto/chacha20poly1305.c:168: undefined reference to `poly1305_update'
   ld: crypto/chacha20poly1305.c:176: undefined reference to `poly1305_update'
   ld: crypto/chacha20poly1305.c:182: undefined reference to `poly1305_update'
   ld: crypto/chacha20poly1305.c:186: undefined reference to `poly1305_update'
>> ld: crypto/chacha20poly1305.c:188: undefined reference to `poly1305_final'


vim +155 crypto/chacha20poly1305.c

71ebc4d1b27d34 Martin Willi 2015-06-01  129  
a298765e28adae Herbert Xu   2025-04-28  130  static int poly_hash(struct aead_request *req)
71ebc4d1b27d34 Martin Willi 2015-06-01  131  {
71ebc4d1b27d34 Martin Willi 2015-06-01  132  	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
a298765e28adae Herbert Xu   2025-04-28  133  	const void *zp = page_address(ZERO_PAGE(0));
a298765e28adae Herbert Xu   2025-04-28  134  	struct scatterlist *sg = req->src;
a298765e28adae Herbert Xu   2025-04-28  135  	struct poly1305_desc_ctx desc;
a298765e28adae Herbert Xu   2025-04-28  136  	struct scatter_walk walk;
a298765e28adae Herbert Xu   2025-04-28  137  	struct {
a298765e28adae Herbert Xu   2025-04-28  138  		union {
a298765e28adae Herbert Xu   2025-04-28  139  			struct {
a298765e28adae Herbert Xu   2025-04-28  140  				__le64 assoclen;
a298765e28adae Herbert Xu   2025-04-28  141  				__le64 cryptlen;
a298765e28adae Herbert Xu   2025-04-28  142  			};
a298765e28adae Herbert Xu   2025-04-28  143  			u8 u8[16];
a298765e28adae Herbert Xu   2025-04-28  144  		};
a298765e28adae Herbert Xu   2025-04-28  145  	} tail;
76cadf2244518d Eric Biggers 2019-06-02  146  	unsigned int padlen;
a298765e28adae Herbert Xu   2025-04-28  147  	unsigned int total;
71ebc4d1b27d34 Martin Willi 2015-06-01  148  
a298765e28adae Herbert Xu   2025-04-28  149  	if (sg != req->dst)
a298765e28adae Herbert Xu   2025-04-28  150  		memcpy_sglist(req->dst, sg, req->assoclen);
71ebc4d1b27d34 Martin Willi 2015-06-01  151  
71ebc4d1b27d34 Martin Willi 2015-06-01  152  	if (rctx->cryptlen == req->cryptlen) /* encrypting */
a298765e28adae Herbert Xu   2025-04-28  153  		sg = req->dst;
747909223397e1 Herbert Xu   2015-07-16  154  
a298765e28adae Herbert Xu   2025-04-28 @155  	poly1305_init(&desc, rctx->key);
a298765e28adae Herbert Xu   2025-04-28  156  	scatterwalk_start(&walk, sg);
71ebc4d1b27d34 Martin Willi 2015-06-01  157  
a298765e28adae Herbert Xu   2025-04-28  158  	total = rctx->assoclen;
a298765e28adae Herbert Xu   2025-04-28  159  	while (total) {
a298765e28adae Herbert Xu   2025-04-28  160  		unsigned int n = scatterwalk_next(&walk, total);
71ebc4d1b27d34 Martin Willi 2015-06-01  161  
a298765e28adae Herbert Xu   2025-04-28 @162  		poly1305_update(&desc, walk.addr, n);
a298765e28adae Herbert Xu   2025-04-28  163  		scatterwalk_done_src(&walk, n);
a298765e28adae Herbert Xu   2025-04-28  164  		total -= n;
71ebc4d1b27d34 Martin Willi 2015-06-01  165  	}
71ebc4d1b27d34 Martin Willi 2015-06-01  166  
76cadf2244518d Eric Biggers 2019-06-02  167  	padlen = -rctx->assoclen % POLY1305_BLOCK_SIZE;
a298765e28adae Herbert Xu   2025-04-28  168  	poly1305_update(&desc, zp, padlen);
71ebc4d1b27d34 Martin Willi 2015-06-01  169  
a298765e28adae Herbert Xu   2025-04-28  170  	scatterwalk_skip(&walk, req->assoclen - rctx->assoclen);
71ebc4d1b27d34 Martin Willi 2015-06-01  171  
a298765e28adae Herbert Xu   2025-04-28  172  	total = rctx->cryptlen;
a298765e28adae Herbert Xu   2025-04-28  173  	while (total) {
a298765e28adae Herbert Xu   2025-04-28  174  		unsigned int n = scatterwalk_next(&walk, total);
71ebc4d1b27d34 Martin Willi 2015-06-01  175  
a298765e28adae Herbert Xu   2025-04-28  176  		poly1305_update(&desc, walk.addr, n);
a298765e28adae Herbert Xu   2025-04-28  177  		scatterwalk_done_src(&walk, n);
a298765e28adae Herbert Xu   2025-04-28  178  		total -= n;
71ebc4d1b27d34 Martin Willi 2015-06-01  179  	}
71ebc4d1b27d34 Martin Willi 2015-06-01  180  
a298765e28adae Herbert Xu   2025-04-28  181  	padlen = -rctx->cryptlen % POLY1305_BLOCK_SIZE;
a298765e28adae Herbert Xu   2025-04-28  182  	poly1305_update(&desc, zp, padlen);
71ebc4d1b27d34 Martin Willi 2015-06-01  183  
a298765e28adae Herbert Xu   2025-04-28  184  	tail.assoclen = cpu_to_le64(rctx->assoclen);
a298765e28adae Herbert Xu   2025-04-28  185  	tail.cryptlen = cpu_to_le64(rctx->cryptlen);
a298765e28adae Herbert Xu   2025-04-28  186  	poly1305_update(&desc, tail.u8, sizeof(tail));
a298765e28adae Herbert Xu   2025-04-28  187  	memzero_explicit(&tail, sizeof(tail));
a298765e28adae Herbert Xu   2025-04-28 @188  	poly1305_final(&desc, rctx->tag);
71ebc4d1b27d34 Martin Willi 2015-06-01  189  
a298765e28adae Herbert Xu   2025-04-28  190  	if (rctx->cryptlen != req->cryptlen)
a298765e28adae Herbert Xu   2025-04-28  191  		return chacha_decrypt(req);
71ebc4d1b27d34 Martin Willi 2015-06-01  192  
a298765e28adae Herbert Xu   2025-04-28  193  	memcpy_to_scatterwalk(&walk, rctx->tag, sizeof(rctx->tag));
a298765e28adae Herbert Xu   2025-04-28  194  	return 0;
71ebc4d1b27d34 Martin Willi 2015-06-01  195  }
71ebc4d1b27d34 Martin Willi 2015-06-01  196  

:::::: The code at line 155 was first introduced by commit
:::::: a298765e28adaea199f722142c10dae7e24dedf8 crypto: chacha20poly1305 - Use lib/crypto poly1305

:::::: TO: Herbert Xu <herbert@gondor.apana.org.au>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
