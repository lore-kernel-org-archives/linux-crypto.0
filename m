Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A2BC43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 04:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C4A21556
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 04:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgIGE7M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 00:59:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50656 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgIGE7L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 00:59:11 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kF9F3-0001ZP-Fy; Mon, 07 Sep 2020 14:58:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Sep 2020 14:58:57 +1000
Date:   Mon, 7 Sep 2020 14:58:57 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Keerthy <j-keerthy@ti.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: sa2ul.c:undefined reference to `crypto_authenc_extractkeys'
Message-ID: <20200907045857.GA11307@gondor.apana.org.au>
References: <202009071150.Sk8aGITA%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009071150.Sk8aGITA%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 11:12:53AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   f4d51dffc6c01a9e94650d95ce0104964f8ae822
> commit: d2c8ac187fc922e73930a1b2f6a211e27f595d01 crypto: sa2ul - Add AEAD algorithm support
> date:   7 weeks ago
> config: x86_64-randconfig-s022-20200907 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.2-191-g10164920-dirty
>         git checkout d2c8ac187fc922e73930a1b2f6a211e27f595d01
>         # save the attached .config to linux build tree
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: drivers/crypto/sa2ul.o: in function `sa_aead_setkey.constprop.0':
> >> sa2ul.c:(.text+0x3466): undefined reference to `crypto_authenc_extractkeys'

Thanks for the report.  This should fix it:

---8<---
The sa2ul driver uses crypto_authenc_extractkeys and therefore
must select CRYPTO_AUTHENC.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index aa3a4ed07a66..c2950127def6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -873,6 +873,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_AES
 	select CRYPTO_AES_ARM64
 	select CRYPTO_ALGAPI
+	select CRYPTO_AUTHENC
 	select HW_RANDOM
 	select SG_SPLIT
 	help
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
