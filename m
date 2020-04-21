Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E57C54FC9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 05:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21562084D
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 05:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgDUFme (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 01:42:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48748 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgDUFme (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 01:42:34 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jQlfd-0001gy-FQ; Tue, 21 Apr 2020 15:42:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Apr 2020 15:42:09 +1000
Date:   Tue, 21 Apr 2020 15:42:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kbuild test robot <lkp@intel.com>
Cc:     Hadar Gat <hadar.gat@arm.com>, kbuild-all@lists.01.org,
        linux-crypto@vger.kernel.org
Subject: hwrng: cctrng - Add dependency on HAS_IOMEM
Message-ID: <20200421054209.GB30356@gondor.apana.org.au>
References: <202004202145.t2vRqPRr%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202004202145.t2vRqPRr%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 20, 2020 at 09:56:47PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   3357b61177a7f34267256098b29a7f4992af40f3
> commit: a583ed310bb6b514e717c11a30b5a7bc3a65d1b1 [7/26] hwrng: cctrng - introduce Arm CryptoCell driver
> config: um-kunit_defconfig (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce:
>         git checkout a583ed310bb6b514e717c11a30b5a7bc3a65d1b1
>         # save the attached .config to linux build tree
>         make ARCH=um 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    /usr/bin/ld: drivers/char/hw_random/cctrng.o: in function `cctrng_probe':
> >> cctrng.c:(.text+0x36f): undefined reference to `devm_ioremap_resource'
>    collect2: error: ld returned 1 exit status

This should fix the problem:

---8<---
The cctrng doesn't compile without HAS_IOMEM so we should depend
on it.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 848f26f78dc1..0c99735df694 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -476,6 +476,7 @@ config HW_RANDOM_KEYSTONE
 
 config HW_RANDOM_CCTRNG
 	tristate "Arm CryptoCell True Random Number Generator support"
+	depends on HAS_IOMEM
 	default HW_RANDOM
 	help
 	  This driver provides support for the True Random Number
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
