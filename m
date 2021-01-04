Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42D5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 06:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8F420DD4
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 06:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbhADGQf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 01:16:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49106 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbhADGQe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 01:16:34 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kwJ9d-0001df-Qq; Mon, 04 Jan 2021 17:15:47 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 04 Jan 2021 17:15:45 +1100
Date:   Mon, 4 Jan 2021 17:15:45 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: crypto: stm32 - Fix last sparse warning in
 stm32_cryp_check_ctr_counter
Message-ID: <20210104061545.GA18641@gondor.apana.org.au>
References: <202012291139.8JYuVQ00-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202012291139.8JYuVQ00-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 29, 2020 at 11:26:45AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   dea8dcf2a9fa8cc540136a6cd885c3beece16ec3
> commit: bbb2832620ac4e136416aa97af7310636422dea9 crypto: stm32 - Fix sparse warnings
> date:   4 months ago
> config: arm-randconfig-s032-20201220 (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-184-g1b896707-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bbb2832620ac4e136416aa97af7310636422dea9
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout bbb2832620ac4e136416aa97af7310636422dea9
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=arm 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> "sparse warnings: (new ones prefixed by >>)"
> >> drivers/crypto/stm32/stm32-cryp.c:1232:47: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] *[assigned] iv @@     got unsigned int [usertype] * @@
>    drivers/crypto/stm32/stm32-cryp.c:1232:47: sparse:     expected restricted __be32 [usertype] *[assigned] iv
>    drivers/crypto/stm32/stm32-cryp.c:1232:47: sparse:     got unsigned int [usertype] *

This patch should fix the problem.

---8<---
This patch changes the cast in stm32_cryp_check_ctr_counter from
u32 to __be32 to match the prototype of stm32_cryp_hw_write_iv
correctly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 2670c30332fa..2a4793176c71 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1229,7 +1229,7 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 		cr = stm32_cryp_read(cryp, CRYP_CR);
 		stm32_cryp_write(cryp, CRYP_CR, cr & ~CR_CRYPEN);
 
-		stm32_cryp_hw_write_iv(cryp, (u32 *)cryp->last_ctr);
+		stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->last_ctr);
 
 		stm32_cryp_write(cryp, CRYP_CR, cr);
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
