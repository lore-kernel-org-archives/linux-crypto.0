Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F861AADB
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709707457; cv=none; b=WICWTgGFqq2VbiKzN5YEPs+OQ3TVWU4eAEi1ZpHY7TpnLcHqZp/Gpoe5q3A4Na/B1GEApT/KhrBeazIF6Yiz/TBFsNqmysmK6trc24zqxt6jhjDHyXz0nJsO42fttdZ8iJVFDkq9piQM7BMWcH6d/0chcRzGIX/s+c73tLVKNMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709707457; c=relaxed/simple;
	bh=h+zCD+OVKHxNt7Z/IR4iF60DxdKP9TTZsPWneMKEPuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEHg73Es2DmVmcPALO1WKoT36sXiRCU96wPPoeil4+2ftF1F6261CPE0TG5jGWSRkDYqx8bJvpTkeV0ntin8DX7WpSso0i6HcAre1sNoyJmXar6BYnHlqJogz2BOOdP+35EVp9KKWQnxIi1fSH+j7CE79xdIx5AViXF2mf1qUZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKx09csl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKx09csl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709707455; x=1741243455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h+zCD+OVKHxNt7Z/IR4iF60DxdKP9TTZsPWneMKEPuQ=;
  b=aKx09cslvOen9EIlICuN2Od1x2ENe7HwvVDzDA8XuzyQn5b3ZJ9bfp1H
   cR3aruCwfY4kpJL0y1eDgvv5h449Df+iYortqJ8EizfJScuF4LH0BFg8w
   Z7+wYxpLpqfjbkw1PV1Y8J7aK+tWs8GIk9iHWp0lqEWotgnXtJ3h6gXnT
   q7A85suWXTVl5nd5VHAS9PMnRYrxgTds3K+B64XOcmTl/D1ATG9nuTjGX
   dxtvL22jXkz9w0HDm98ttL2luhWIR0/91/0xU5NV63542MAEvi5YunJLn
   kzgBe4b5CN2CA3s8KKU10FsxZpC7rfG/COqvOh1Olsp03mcm1UhHEqfB7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4165134"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="4165134"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 22:44:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="10051678"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 05 Mar 2024 22:44:13 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rhl0c-0003zt-0B;
	Wed, 06 Mar 2024 06:44:10 +0000
Date: Wed, 6 Mar 2024 14:43:10 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202403061443.w2hFEVfJ-lkp@intel.com>
References: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.8-rc7 next-20240305]
[cannot apply to xilinx-xlnx/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240305-193337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20240305112831.3380896-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: i386-buildonly-randconfig-004-20240306 (https://download.01.org/0day-ci/archive/20240306/202403061443.w2hFEVfJ-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240306/202403061443.w2hFEVfJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403061443.w2hFEVfJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/dwc-spacc/spacc_ahash.c:271:9: warning: variable 'sgl_buffer' is uninitialized when used here [-Wuninitialized]
     271 |                                                   sgl_buffer,
         |                                                   ^~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:231:18: note: initialize the variable 'sgl_buffer' to silence this warning
     231 |         char *sgl_buffer;
         |                         ^
         |                          = NULL
   drivers/crypto/dwc-spacc/spacc_ahash.c:679:18: warning: variable 'priv' is uninitialized when used here [-Wuninitialized]
     679 |                                 spacc_close(&priv->spacc, tctx->handle);
         |                                              ^~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:666:25: note: initialize the variable 'priv' to silence this warning
     666 |         struct spacc_priv *priv;
         |                                ^
         |                                 = NULL
>> drivers/crypto/dwc-spacc/spacc_ahash.c:1008:6: warning: variable 'total_len' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1008 |         if (rc < 0)
         |             ^~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1057:28: note: uninitialized use occurs here
    1057 |         ctx->fb.hash_req.nbytes = total_len;
         |                                   ^~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1008:2: note: remove the 'if' if its condition is always false
    1008 |         if (rc < 0)
         |         ^~~~~~~~~~~
    1009 |                 goto fallback;
         |                 ~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1003:6: warning: variable 'total_len' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1004 |             req->nbytes > priv->max_msg_len)
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1057:28: note: uninitialized use occurs here
    1057 |         ctx->fb.hash_req.nbytes = total_len;
         |                                   ^~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1003:2: note: remove the 'if' if its condition is always false
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1004 |             req->nbytes > priv->max_msg_len)
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1005 |                 goto fallback;
         |                 ~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_ahash.c:1003:6: warning: variable 'total_len' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1057:28: note: uninitialized use occurs here
    1057 |         ctx->fb.hash_req.nbytes = total_len;
         |                                   ^~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1003:6: note: remove the '||' if its condition is always false
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_ahash.c:1003:6: warning: variable 'total_len' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |             ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1057:28: note: uninitialized use occurs here
    1057 |         ctx->fb.hash_req.nbytes = total_len;
         |                                   ^~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:1003:6: note: remove the '||' if its condition is always false
    1003 |         if (tctx->handle < 0 || !tctx->ctx_valid ||
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_ahash.c:985:19: note: initialize the variable 'total_len' to silence this warning
     985 |         int rc, total_len;
         |                          ^
         |                           = 0
   6 warnings generated.
--
   drivers/crypto/dwc-spacc/spacc_skcipher.c:149:16: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
     149 |         int err = -1, rc;
         |                       ^
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:176:40: warning: overlapping comparisons always evaluate to true [-Wtautological-overlap-compare]
     176 |         if (ctx->mode != CRYPTO_MODE_DES_ECB  ||
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
     177 |             ctx->mode != CRYPTO_MODE_DES_CBC  ||
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_skcipher.c:400:6: warning: variable 'ivsize' set but not used [-Wunused-but-set-variable]
     400 |         int ivsize;
         |             ^
   3 warnings generated.
--
   drivers/crypto/dwc-spacc/spacc_core.c:984:26: warning: unused variable 'names' [-Wunused-const-variable]
     984 | static const char *const names[] = {
         |                          ^~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:2835:56: warning: unused variable 'reg_names' [-Wunused-const-variable]
    2835 | static const struct { unsigned int addr; char *name; } reg_names[] = {
         |                                                        ^~~~~~~~~
   2 warnings generated.


vim +1008 drivers/crypto/dwc-spacc/spacc_ahash.c

6ad822cec22644 Pavitrakumar M 2024-03-05   981  
6ad822cec22644 Pavitrakumar M 2024-03-05   982  static int spacc_hash_digest(struct ahash_request *req)
6ad822cec22644 Pavitrakumar M 2024-03-05   983  {
6ad822cec22644 Pavitrakumar M 2024-03-05   984  	int final = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05   985  	int rc, total_len;
6ad822cec22644 Pavitrakumar M 2024-03-05   986  	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
6ad822cec22644 Pavitrakumar M 2024-03-05   987  	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
6ad822cec22644 Pavitrakumar M 2024-03-05   988  	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
6ad822cec22644 Pavitrakumar M 2024-03-05   989  	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
6ad822cec22644 Pavitrakumar M 2024-03-05   990  
6ad822cec22644 Pavitrakumar M 2024-03-05   991  	if (tctx->flag_ppp) {
6ad822cec22644 Pavitrakumar M 2024-03-05   992  		/* from finup */
6ad822cec22644 Pavitrakumar M 2024-03-05   993  		ctx->single_shot = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05   994  		ctx->final_part_pck = 1;
6ad822cec22644 Pavitrakumar M 2024-03-05   995  		final = 2;
6ad822cec22644 Pavitrakumar M 2024-03-05   996  	} else {
6ad822cec22644 Pavitrakumar M 2024-03-05   997  		/* direct single shot digest call */
6ad822cec22644 Pavitrakumar M 2024-03-05   998  		ctx->single_shot = 1;
6ad822cec22644 Pavitrakumar M 2024-03-05   999  		ctx->rem_len = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05  1000  		ctx->total_nents = sg_nents(req->src);
6ad822cec22644 Pavitrakumar M 2024-03-05  1001  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1002  
6ad822cec22644 Pavitrakumar M 2024-03-05 @1003  	if (tctx->handle < 0 || !tctx->ctx_valid ||
6ad822cec22644 Pavitrakumar M 2024-03-05  1004  	    req->nbytes > priv->max_msg_len)
6ad822cec22644 Pavitrakumar M 2024-03-05  1005  		goto fallback;
6ad822cec22644 Pavitrakumar M 2024-03-05  1006  
6ad822cec22644 Pavitrakumar M 2024-03-05  1007  	rc = spacc_hash_init_dma(tctx->dev, req, final);
6ad822cec22644 Pavitrakumar M 2024-03-05 @1008  	if (rc < 0)
6ad822cec22644 Pavitrakumar M 2024-03-05  1009  		goto fallback;
6ad822cec22644 Pavitrakumar M 2024-03-05  1010  
6ad822cec22644 Pavitrakumar M 2024-03-05  1011  	if (rc == 0)
6ad822cec22644 Pavitrakumar M 2024-03-05  1012  		return 0;
6ad822cec22644 Pavitrakumar M 2024-03-05  1013  
6ad822cec22644 Pavitrakumar M 2024-03-05  1014  	if (final) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1015  		if (ctx->total_nents) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1016  			/* INIT-UPDATE-UPDATE-FINUP/FINAL */
6ad822cec22644 Pavitrakumar M 2024-03-05  1017  			total_len = tctx->ppp_sgl[0].length;
6ad822cec22644 Pavitrakumar M 2024-03-05  1018  		} else if (req->src->length == 0 && ctx->total_nents == 0) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1019  			/* zero msg handling */
6ad822cec22644 Pavitrakumar M 2024-03-05  1020  			total_len = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05  1021  		} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1022  			/* handle INIT-FINUP sequence, process req->nbytes */
6ad822cec22644 Pavitrakumar M 2024-03-05  1023  			total_len = req->nbytes;
6ad822cec22644 Pavitrakumar M 2024-03-05  1024  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1025  
6ad822cec22644 Pavitrakumar M 2024-03-05  1026  		rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
6ad822cec22644 Pavitrakumar M 2024-03-05  1027  				&ctx->src, &ctx->dst, total_len,
6ad822cec22644 Pavitrakumar M 2024-03-05  1028  				0, total_len, 0, 0, 0);
6ad822cec22644 Pavitrakumar M 2024-03-05  1029  	} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1030  		rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
6ad822cec22644 Pavitrakumar M 2024-03-05  1031  				&ctx->src, &ctx->dst, req->nbytes,
6ad822cec22644 Pavitrakumar M 2024-03-05  1032  				0, req->nbytes, 0, 0, 0);
6ad822cec22644 Pavitrakumar M 2024-03-05  1033  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1034  
6ad822cec22644 Pavitrakumar M 2024-03-05  1035  	if (rc < 0) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1036  		spacc_hash_cleanup_dma(tctx->dev, req);
6ad822cec22644 Pavitrakumar M 2024-03-05  1037  		spacc_close(&priv->spacc, ctx->acb.new_handle);
6ad822cec22644 Pavitrakumar M 2024-03-05  1038  
6ad822cec22644 Pavitrakumar M 2024-03-05  1039  		if (rc != -EBUSY) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1040  			pr_debug("Failed to enqueue job, ERR: %d\n", rc);
6ad822cec22644 Pavitrakumar M 2024-03-05  1041  			return rc;
6ad822cec22644 Pavitrakumar M 2024-03-05  1042  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1043  
6ad822cec22644 Pavitrakumar M 2024-03-05  1044  		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
6ad822cec22644 Pavitrakumar M 2024-03-05  1045  			return -EBUSY;
6ad822cec22644 Pavitrakumar M 2024-03-05  1046  
6ad822cec22644 Pavitrakumar M 2024-03-05  1047  		goto fallback;
6ad822cec22644 Pavitrakumar M 2024-03-05  1048  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1049  
6ad822cec22644 Pavitrakumar M 2024-03-05  1050  	return -EINPROGRESS;
6ad822cec22644 Pavitrakumar M 2024-03-05  1051  
6ad822cec22644 Pavitrakumar M 2024-03-05  1052  fallback:
6ad822cec22644 Pavitrakumar M 2024-03-05  1053  	/* Start from scratch as init is not called before digest */
6ad822cec22644 Pavitrakumar M 2024-03-05  1054  	ctx->fb.hash_req.base = req->base;
6ad822cec22644 Pavitrakumar M 2024-03-05  1055  	ahash_request_set_tfm(&ctx->fb.hash_req, tctx->fb.hash);
6ad822cec22644 Pavitrakumar M 2024-03-05  1056  
6ad822cec22644 Pavitrakumar M 2024-03-05  1057  	ctx->fb.hash_req.nbytes = total_len;
6ad822cec22644 Pavitrakumar M 2024-03-05  1058  	ctx->fb.hash_req.src = req->src;
6ad822cec22644 Pavitrakumar M 2024-03-05  1059  	ctx->fb.hash_req.result = req->result;
6ad822cec22644 Pavitrakumar M 2024-03-05  1060  
6ad822cec22644 Pavitrakumar M 2024-03-05  1061  	return crypto_ahash_digest(&ctx->fb.hash_req);
6ad822cec22644 Pavitrakumar M 2024-03-05  1062  }
6ad822cec22644 Pavitrakumar M 2024-03-05  1063  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
