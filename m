From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 10/29]
 arch/x86/crypto/sha256_ssse3_glue.c:172:19: error: 'X86_FEATURE_SHA_NI'
 undeclared
Date: Fri, 18 Sep 2015 23:17:57 +0800
Message-ID: <20150918151757.GA10835@gondor.apana.org.au>
References: <201509182205.JCClhKfv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim <tim.c.chen@linux.intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53143 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbbIRPSH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 11:18:07 -0400
Content-Disposition: inline
In-Reply-To: <201509182205.JCClhKfv%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 10:36:07PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   dcde21287f931b6cee61825306db6a5665566f66
> commit: a3476db1b524f2e2d869b001c56ba9ce353d860e [10/29] crypto: x86/sha - Add build support for Intel SHA Extensions optimized SHA1 and SHA256
> config: x86_64-randconfig-x015-09141022 (attached as .config)
> reproduce:
>   git checkout a3476db1b524f2e2d869b001c56ba9ce353d860e
>   # save the attached .config to linux build tree
>   make ARCH=x86_64 

Tim, I've rolled back all your patches as they depend on a patch
that has not yet been merged.

Please resubmit them when the prerequisite is ready.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
