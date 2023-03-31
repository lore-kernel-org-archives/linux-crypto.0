Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3819C76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 12:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCaMr2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 08:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjCaMrW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 08:47:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394EE20C2C
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 05:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680266818; x=1711802818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vi/GMhI0cSx/xT+5Tcr6BC25IJGipEWrLrBUzaJaBVk=;
  b=FgA3WQMXNzqlayKJDVpNyS2XbeN/jXWFa/ibFtFQW8Kii/mWkH0JK/8r
   gJ9Z0a6piYEhB0lBnlXt0jQpNNf6bs6N4Dw2jYrK0GpD+xQzT1y15m62N
   tbhn8WksDkLAFiKaurL1yAILX49beTwsDchePYA3UiPhPGYKwS372K+WL
   kM/oRSQjRN7Wg0HoZDha0O4N+jSi6iHu4uqhG93UMkMF0HbgksaYu1a4c
   S8DAfREetImTqig5G3ud7P+wsbD7bb7L2MFPgcCkrzecBFzQ7ISH4Ru/z
   stZN0mLd07XSTzlmdXWDrwFxtqdsxqjX2ISujXkHcppbdDgKuLX1ILC4B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="325408689"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="325408689"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 05:46:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="828702135"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="828702135"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 31 Mar 2023 05:46:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1piE9M-000Lmk-2A;
        Fri, 31 Mar 2023 12:46:36 +0000
Date:   Fri, 31 Mar 2023 20:45:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] crypto: hash - Remove maximum statesize limit
Message-ID: <202303312021.84WtsA4u-lkp@intel.com>
References: <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I love your patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20230331]
[cannot apply to herbert-crypto-2.6/master linus/master v6.3-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-hash-Remove-maximum-statesize-limit/20230328-115842
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/ZCJllZQBWfjMCaoQ%40gondor.apana.org.au
patch subject: [PATCH] crypto: hash - Remove maximum statesize limit
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20230331/202303312021.84WtsA4u-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/5258657ff30097b887ac972b95a5563918f4448f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Herbert-Xu/crypto-hash-Remove-maximum-statesize-limit/20230328-115842
        git checkout 5258657ff30097b887ac972b95a5563918f4448f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303312021.84WtsA4u-lkp@intel.com/

All warnings (new ones prefixed by >>):

   crypto/algif_hash.c: In function 'hash_accept':
   crypto/algif_hash.c:238:20: error: 'HASH_MAX_STATESIZE' undeclared (first use in this function); did you mean 'HASH_MAX_DESCSIZE'?
     238 |         char state[HASH_MAX_STATESIZE];
         |                    ^~~~~~~~~~~~~~~~~~
         |                    HASH_MAX_DESCSIZE
   crypto/algif_hash.c:238:20: note: each undeclared identifier is reported only once for each function it appears in
>> crypto/algif_hash.c:238:14: warning: unused variable 'state' [-Wunused-variable]
     238 |         char state[HASH_MAX_STATESIZE];
         |              ^~~~~


vim +/state +238 crypto/algif_hash.c

fe869cdb89c95d0 Herbert Xu    2010-10-19  230  
cdfbabfb2f0ce98 David Howells 2017-03-09  231  static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
cdfbabfb2f0ce98 David Howells 2017-03-09  232  		       bool kern)
fe869cdb89c95d0 Herbert Xu    2010-10-19  233  {
fe869cdb89c95d0 Herbert Xu    2010-10-19  234  	struct sock *sk = sock->sk;
fe869cdb89c95d0 Herbert Xu    2010-10-19  235  	struct alg_sock *ask = alg_sk(sk);
fe869cdb89c95d0 Herbert Xu    2010-10-19  236  	struct hash_ctx *ctx = ask->private;
fe869cdb89c95d0 Herbert Xu    2010-10-19  237  	struct ahash_request *req = &ctx->req;
b68a7ec1e9a3efa Kees Cook     2018-08-07 @238  	char state[HASH_MAX_STATESIZE];
fe869cdb89c95d0 Herbert Xu    2010-10-19  239  	struct sock *sk2;
fe869cdb89c95d0 Herbert Xu    2010-10-19  240  	struct alg_sock *ask2;
fe869cdb89c95d0 Herbert Xu    2010-10-19  241  	struct hash_ctx *ctx2;
4afa5f961792745 Herbert Xu    2015-11-01  242  	bool more;
fe869cdb89c95d0 Herbert Xu    2010-10-19  243  	int err;
fe869cdb89c95d0 Herbert Xu    2010-10-19  244  
4afa5f961792745 Herbert Xu    2015-11-01  245  	lock_sock(sk);
4afa5f961792745 Herbert Xu    2015-11-01  246  	more = ctx->more;
4afa5f961792745 Herbert Xu    2015-11-01  247  	err = more ? crypto_ahash_export(req, state) : 0;
4afa5f961792745 Herbert Xu    2015-11-01  248  	release_sock(sk);
4afa5f961792745 Herbert Xu    2015-11-01  249  
fe869cdb89c95d0 Herbert Xu    2010-10-19  250  	if (err)
fe869cdb89c95d0 Herbert Xu    2010-10-19  251  		return err;
fe869cdb89c95d0 Herbert Xu    2010-10-19  252  
cdfbabfb2f0ce98 David Howells 2017-03-09  253  	err = af_alg_accept(ask->parent, newsock, kern);
fe869cdb89c95d0 Herbert Xu    2010-10-19  254  	if (err)
fe869cdb89c95d0 Herbert Xu    2010-10-19  255  		return err;
fe869cdb89c95d0 Herbert Xu    2010-10-19  256  
fe869cdb89c95d0 Herbert Xu    2010-10-19  257  	sk2 = newsock->sk;
fe869cdb89c95d0 Herbert Xu    2010-10-19  258  	ask2 = alg_sk(sk2);
fe869cdb89c95d0 Herbert Xu    2010-10-19  259  	ctx2 = ask2->private;
4afa5f961792745 Herbert Xu    2015-11-01  260  	ctx2->more = more;
4afa5f961792745 Herbert Xu    2015-11-01  261  
4afa5f961792745 Herbert Xu    2015-11-01  262  	if (!more)
4afa5f961792745 Herbert Xu    2015-11-01  263  		return err;
fe869cdb89c95d0 Herbert Xu    2010-10-19  264  
fe869cdb89c95d0 Herbert Xu    2010-10-19  265  	err = crypto_ahash_import(&ctx2->req, state);
fe869cdb89c95d0 Herbert Xu    2010-10-19  266  	if (err) {
fe869cdb89c95d0 Herbert Xu    2010-10-19  267  		sock_orphan(sk2);
fe869cdb89c95d0 Herbert Xu    2010-10-19  268  		sock_put(sk2);
fe869cdb89c95d0 Herbert Xu    2010-10-19  269  	}
fe869cdb89c95d0 Herbert Xu    2010-10-19  270  
fe869cdb89c95d0 Herbert Xu    2010-10-19  271  	return err;
fe869cdb89c95d0 Herbert Xu    2010-10-19  272  }
fe869cdb89c95d0 Herbert Xu    2010-10-19  273  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
