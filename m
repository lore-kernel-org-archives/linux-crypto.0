Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C0EC761AF
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 01:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjDBB3v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Apr 2023 21:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBB3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2023 21:29:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D990E191F6
        for <linux-crypto@vger.kernel.org>; Sat,  1 Apr 2023 18:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680398988; x=1711934988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W/SmP22p0hn1435eIuv6dkRF92zCBjSdnRaI0sEkxUI=;
  b=GRyVUFAqoIh95nK1nURYiBQt302BfHs2MwElL3alfhpCaKCk7Az2VLi/
   jeFKV9AEuADzwBcT6c2VAmzC0BgaJMjyS6qVt5bkZARk46TLbRoUJfkO/
   5MZ3/UumLhOzkjO5bu29M2oTD1BLGcOzSkMIHUgt7WqfGmMMBA/bHZgyY
   8Y3Md7eQkjDNbNSVWUz8SFhWx6Vo4uXVEPssKp7ESuPmuldXg/F+wAyO5
   VdtoPrx4X8KRwS9HaJQHzC+xVDJrBvaJvUfyZH/JVzv2aFtNcYUp22jmJ
   uqqhfcjo3Aoj9pvhdAJxg6kWFdfIFmTcDN4nLCMW2Mbh4pN+3e+rgleD1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340420640"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="340420640"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 18:29:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="635696693"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="635696693"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 01 Apr 2023 18:29:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pimXR-000N9r-0L;
        Sun, 02 Apr 2023 01:29:45 +0000
Date:   Sun, 2 Apr 2023 09:29:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] crypto: hash - Remove maximum statesize limit
Message-ID: <202304020900.MhnE9RIZ-lkp@intel.com>
References: <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I love your patch! Yet something to improve:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on next-20230331]
[cannot apply to herbert-crypto-2.6/master linus/master v6.3-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-hash-Remove-maximum-statesize-limit/20230328-115842
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/ZCJllZQBWfjMCaoQ%40gondor.apana.org.au
patch subject: [PATCH] crypto: hash - Remove maximum statesize limit
config: x86_64-rhel-8.3-func (https://download.01.org/0day-ci/archive/20230402/202304020900.MhnE9RIZ-lkp@intel.com/config)
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
| Link: https://lore.kernel.org/oe-kbuild-all/202304020900.MhnE9RIZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   crypto/algif_hash.c: In function 'hash_accept':
>> crypto/algif_hash.c:238:20: error: 'HASH_MAX_STATESIZE' undeclared (first use in this function); did you mean 'HASH_MAX_DESCSIZE'?
     238 |         char state[HASH_MAX_STATESIZE];
         |                    ^~~~~~~~~~~~~~~~~~
         |                    HASH_MAX_DESCSIZE
   crypto/algif_hash.c:238:20: note: each undeclared identifier is reported only once for each function it appears in
   crypto/algif_hash.c:238:14: warning: unused variable 'state' [-Wunused-variable]
     238 |         char state[HASH_MAX_STATESIZE];
         |              ^~~~~


vim +238 crypto/algif_hash.c

fe869cdb89c95d Herbert Xu    2010-10-19  230  
cdfbabfb2f0ce9 David Howells 2017-03-09  231  static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
cdfbabfb2f0ce9 David Howells 2017-03-09  232  		       bool kern)
fe869cdb89c95d Herbert Xu    2010-10-19  233  {
fe869cdb89c95d Herbert Xu    2010-10-19  234  	struct sock *sk = sock->sk;
fe869cdb89c95d Herbert Xu    2010-10-19  235  	struct alg_sock *ask = alg_sk(sk);
fe869cdb89c95d Herbert Xu    2010-10-19  236  	struct hash_ctx *ctx = ask->private;
fe869cdb89c95d Herbert Xu    2010-10-19  237  	struct ahash_request *req = &ctx->req;
b68a7ec1e9a3ef Kees Cook     2018-08-07 @238  	char state[HASH_MAX_STATESIZE];
fe869cdb89c95d Herbert Xu    2010-10-19  239  	struct sock *sk2;
fe869cdb89c95d Herbert Xu    2010-10-19  240  	struct alg_sock *ask2;
fe869cdb89c95d Herbert Xu    2010-10-19  241  	struct hash_ctx *ctx2;
4afa5f96179274 Herbert Xu    2015-11-01  242  	bool more;
fe869cdb89c95d Herbert Xu    2010-10-19  243  	int err;
fe869cdb89c95d Herbert Xu    2010-10-19  244  
4afa5f96179274 Herbert Xu    2015-11-01  245  	lock_sock(sk);
4afa5f96179274 Herbert Xu    2015-11-01  246  	more = ctx->more;
4afa5f96179274 Herbert Xu    2015-11-01  247  	err = more ? crypto_ahash_export(req, state) : 0;
4afa5f96179274 Herbert Xu    2015-11-01  248  	release_sock(sk);
4afa5f96179274 Herbert Xu    2015-11-01  249  
fe869cdb89c95d Herbert Xu    2010-10-19  250  	if (err)
fe869cdb89c95d Herbert Xu    2010-10-19  251  		return err;
fe869cdb89c95d Herbert Xu    2010-10-19  252  
cdfbabfb2f0ce9 David Howells 2017-03-09  253  	err = af_alg_accept(ask->parent, newsock, kern);
fe869cdb89c95d Herbert Xu    2010-10-19  254  	if (err)
fe869cdb89c95d Herbert Xu    2010-10-19  255  		return err;
fe869cdb89c95d Herbert Xu    2010-10-19  256  
fe869cdb89c95d Herbert Xu    2010-10-19  257  	sk2 = newsock->sk;
fe869cdb89c95d Herbert Xu    2010-10-19  258  	ask2 = alg_sk(sk2);
fe869cdb89c95d Herbert Xu    2010-10-19  259  	ctx2 = ask2->private;
4afa5f96179274 Herbert Xu    2015-11-01  260  	ctx2->more = more;
4afa5f96179274 Herbert Xu    2015-11-01  261  
4afa5f96179274 Herbert Xu    2015-11-01  262  	if (!more)
4afa5f96179274 Herbert Xu    2015-11-01  263  		return err;
fe869cdb89c95d Herbert Xu    2010-10-19  264  
fe869cdb89c95d Herbert Xu    2010-10-19  265  	err = crypto_ahash_import(&ctx2->req, state);
fe869cdb89c95d Herbert Xu    2010-10-19  266  	if (err) {
fe869cdb89c95d Herbert Xu    2010-10-19  267  		sock_orphan(sk2);
fe869cdb89c95d Herbert Xu    2010-10-19  268  		sock_put(sk2);
fe869cdb89c95d Herbert Xu    2010-10-19  269  	}
fe869cdb89c95d Herbert Xu    2010-10-19  270  
fe869cdb89c95d Herbert Xu    2010-10-19  271  	return err;
fe869cdb89c95d Herbert Xu    2010-10-19  272  }
fe869cdb89c95d Herbert Xu    2010-10-19  273  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
