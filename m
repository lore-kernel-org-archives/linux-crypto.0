Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC6EC27C48
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Oct 2023 00:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjJ1AZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 20:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJ1AZG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 20:25:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240FA1B9;
        Fri, 27 Oct 2023 17:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698452704; x=1729988704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3btZhMeeHcq78slgVZVvUBLc3+r/j9Mw1EtMte4xFmU=;
  b=A0twDkLfa7AZwwasq7+AuRGbK+tZ5CTe4pP0hj1354BB6w3TW+LZgdzq
   zCaW7RqX120RCOOp8kaP6CcRtmpSFq1Z1qNDytNGCRJk79spsmZpRrzuC
   U66V9AsJ86hG/SjiYR92vbf6+ap7FF5X5mgNN/imc7fV8YYb31jcyNjpG
   IlPUwccoSPCSf1X0NgQiIuwpXfUKV0T57BuzGQu1R/tuCqORUYi+LYMN5
   B3KyUZC3Ed7bZUJwliBauWcLBa22Zjx+wDvwo54XMdNDwqACPSFYNwE2B
   21EpkUvb6CKQgncwjMgHZzG0W3FfbjKrqfNj+xGHdpocgXj7jAzWn0Eh4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="418978419"
X-IronPort-AV: E=Sophos;i="6.03,257,1694761200"; 
   d="scan'208";a="418978419"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 17:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="763381068"
X-IronPort-AV: E=Sophos;i="6.03,257,1694761200"; 
   d="scan'208";a="763381068"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 27 Oct 2023 17:25:01 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qwX8N-000BJ5-0F;
        Sat, 28 Oct 2023 00:24:59 +0000
Date:   Sat, 28 Oct 2023 08:24:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>
Cc:     oe-kbuild-all@lists.linux.dev, Vadim Fedorenko <vadfed@meta.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/2] bpf: add skcipher API support to TC/XDP
 programs
Message-ID: <202310280854.tycUngCC-lkp@intel.com>
References: <20231027172039.1365917-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027172039.1365917-1-vadfed@meta.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vadim,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/selftests-bpf-crypto-skcipher-algo-selftests/20231028-020332
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20231027172039.1365917-1-vadfed%40meta.com
patch subject: [PATCH bpf-next v2 1/2] bpf: add skcipher API support to TC/XDP programs
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20231028/202310280854.tycUngCC-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231028/202310280854.tycUngCC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310280854.tycUngCC-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/bpf/crypto.c:74: warning: Function parameter or member 'palgo' not described in 'bpf_crypto_skcipher_ctx_create'
>> kernel/bpf/crypto.c:74: warning: Function parameter or member 'pkey' not described in 'bpf_crypto_skcipher_ctx_create'
>> kernel/bpf/crypto.c:74: warning: Function parameter or member 'err' not described in 'bpf_crypto_skcipher_ctx_create'
>> kernel/bpf/crypto.c:74: warning: Excess function parameter 'algo' description in 'bpf_crypto_skcipher_ctx_create'
>> kernel/bpf/crypto.c:74: warning: Excess function parameter 'key' description in 'bpf_crypto_skcipher_ctx_create'


vim +74 kernel/bpf/crypto.c

    58	
    59	/**
    60	 * bpf_crypto_skcipher_ctx_create() - Create a mutable BPF crypto context.
    61	 *
    62	 * Allocates a crypto context that can be used, acquired, and released by
    63	 * a BPF program. The crypto context returned by this function must either
    64	 * be embedded in a map as a kptr, or freed with bpf_crypto_skcipher_ctx_release().
    65	 *
    66	 * bpf_crypto_skcipher_ctx_create() allocates memory using the BPF memory
    67	 * allocator, and will not block. It may return NULL if no memory is available.
    68	 * @algo: bpf_dynptr which holds string representation of algorithm.
    69	 * @key:  bpf_dynptr which holds cipher key to do crypto.
    70	 */
    71	__bpf_kfunc struct bpf_crypto_skcipher_ctx *
    72	bpf_crypto_skcipher_ctx_create(const struct bpf_dynptr_kern *palgo,
    73				       const struct bpf_dynptr_kern *pkey, int *err)
  > 74	{
    75		struct bpf_crypto_skcipher_ctx *ctx;
    76		char *algo;
    77	
    78		if (__bpf_dynptr_size(palgo) > CRYPTO_MAX_ALG_NAME) {
    79			*err = -EINVAL;
    80			return NULL;
    81		}
    82	
    83		algo = __bpf_dynptr_data_ptr(palgo);
    84	
    85		if (!crypto_has_skcipher(algo, CRYPTO_ALG_TYPE_SKCIPHER, CRYPTO_ALG_TYPE_MASK)) {
    86			*err = -EOPNOTSUPP;
    87			return NULL;
    88		}
    89	
    90		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
    91		if (!ctx) {
    92			*err = -ENOMEM;
    93			return NULL;
    94		}
    95	
    96		memset(ctx, 0, sizeof(*ctx));
    97	
    98		ctx->tfm = crypto_alloc_sync_skcipher(algo, 0, 0);
    99		if (IS_ERR(ctx->tfm)) {
   100			*err = PTR_ERR(ctx->tfm);
   101			ctx->tfm = NULL;
   102			goto err;
   103		}
   104	
   105		*err = crypto_sync_skcipher_setkey(ctx->tfm, __bpf_dynptr_data_ptr(pkey),
   106						   __bpf_dynptr_size(pkey));
   107		if (*err)
   108			goto err;
   109	
   110		refcount_set(&ctx->usage, 1);
   111	
   112		return ctx;
   113	err:
   114		if (ctx->tfm)
   115			crypto_free_sync_skcipher(ctx->tfm);
   116		kfree(ctx);
   117	
   118		return NULL;
   119	}
   120	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
