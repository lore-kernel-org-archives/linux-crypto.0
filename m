Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409AEC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 04:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F05206CB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 04:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgF3EUt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 00:20:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32890 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgF3EUt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 00:20:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jq7l7-000895-Uf; Tue, 30 Jun 2020 14:20:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Jun 2020 14:20:37 +1000
Date:   Tue, 30 Jun 2020 14:20:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        kbuild-all@lists.01.org, Waleed Ziad <waleed94ziad@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] hwrng: ba431 - Add dependency on HAS_IOMEM
Message-ID: <20200630042037.GA22429@gondor.apana.org.au>
References: <202006292036.INytijnT%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006292036.INytijnT%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 29, 2020 at 08:46:38PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   c28e58ee9dadc99f79cf16ca805221feddd432ad
> commit: 0289e9be5dc26d84dda6fc5492f08ca1ff599744 [1846/4145] hwrng: ba431 - add support for BA431 hwrng
> config: s390-zfcpdump_defconfig (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 0289e9be5dc26d84dda6fc5492f08ca1ff599744
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    s390-linux-ld: drivers/char/hw_random/ba431-rng.o: in function `ba431_trng_probe':
> >> ba431-rng.c:(.text+0xd4): undefined reference to `devm_ioremap_resource'

This patch should fix the problem:

---8<---
The ba431 driver depends on HAS_IOMEM and this was missing from
the Kconfig file.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7b876dfdbaaf..edbaf6154764 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -76,6 +76,7 @@ config HW_RANDOM_ATMEL
 
 config HW_RANDOM_BA431
 	tristate "Silex Insight BA431 Random Number Generator support"
+	depends on HAS_IOMEM
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
