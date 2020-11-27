Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2A8C63798
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 05:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B032222A
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 05:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbgK0Fsx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 00:48:53 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33306 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgK0Fsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 00:48:53 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiWce-0000YS-J2; Fri, 27 Nov 2020 16:48:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 16:48:44 +1100
Date:   Fri, 27 Nov 2020 16:48:44 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: ks-sa-rng.c:undefined reference to
 `devm_platform_ioremap_resource'
Message-ID: <20201127054844.GB23521@gondor.apana.org.au>
References: <202011132311.XmkAgWg0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011132311.XmkAgWg0-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 11:02:13PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> commit: 90c4b29eb1e555fee66f8329a18cb8a070090ad6 hwrng: ks-sa - Enable COMPILE_TEST
> date:   12 months ago
> config: s390-randconfig-r022-20201113 (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90c4b29eb1e555fee66f8329a18cb8a070090ad6
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 90c4b29eb1e555fee66f8329a18cb8a070090ad6
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):

>    s390-linux-ld: drivers/char/hw_random/ks-sa-rng.o: in function `ks_sa_rng_probe':
> >> ks-sa-rng.c:(.text+0x2fa): undefined reference to `devm_platform_ioremap_resource'

---8<---
This patch adds a dependency for KEYSTONE on HAS_IOMEM and OF to
prevent COMPILE_TEST build failures.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index ab33a2e17cdf..9ff4fb3236f7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -508,6 +508,7 @@ config HW_RANDOM_NPCM
 
 config HW_RANDOM_KEYSTONE
 	depends on ARCH_KEYSTONE || COMPILE_TEST
+	depends on HAS_IOMEM && OF
 	default HW_RANDOM
 	tristate "TI Keystone NETCP SA Hardware random number generator"
 	help
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
