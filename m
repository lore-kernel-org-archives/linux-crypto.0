Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C24C48BE5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jun 2021 06:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 991A861059
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jun 2021 06:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhFOGRL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Jun 2021 02:17:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50660 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhFOGRK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jun 2021 02:17:10 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lt2Li-0007Jz-Se; Tue, 15 Jun 2021 14:14:58 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lt2Lc-0001v2-A7; Tue, 15 Jun 2021 14:14:52 +0800
Date:   Tue, 15 Jun 2021 14:14:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: sa2ul - Remove unused auth_len variable
Message-ID: <20210615061452.GA5622@gondor.apana.org.au>
References: <202106030304.crsT6r76-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106030304.crsT6r76-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 03, 2021 at 03:53:14AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   231bc539066760aaa44d46818c85b14ca2f56d9f
> commit: 00c9211f60db2dead16856f81a3e6ab86b31f275 crypto: sa2ul - Fix DMA mapping API usage
> date:   8 months ago
> config: arm64-randconfig-r005-20210601 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project d41cb6bb2607fa5c7a9df2b3dab361353657d225)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=00c9211f60db2dead16856f81a3e6ab86b31f275
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 00c9211f60db2dead16856f81a3e6ab86b31f275
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/crypto/sa2ul.c:1674:6: warning: variable 'auth_len' set but not used [-Wunused-but-set-variable]
>            u16 auth_len;
>                ^
>    1 warning generated.

Thanks for the report.  This variable is indeed unused.

---8<---
This patch removes the unused auth_len variable from
sa_aead_dma_in_callback.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 51bb69bc573c..544d7040cfc5 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1698,7 +1698,6 @@ static void sa_aead_dma_in_callback(void *data)
 	size_t pl, ml;
 	int i;
 	int err = 0;
-	u16 auth_len;
 	u32 *mdptr;
 
 	sa_sync_from_device(rxd);
@@ -1711,13 +1710,10 @@ static void sa_aead_dma_in_callback(void *data)
 	for (i = 0; i < (authsize / 4); i++)
 		mdptr[i + 4] = swab32(mdptr[i + 4]);
 
-	auth_len = req->assoclen + req->cryptlen;
-
 	if (rxd->enc) {
 		scatterwalk_map_and_copy(&mdptr[4], req->dst, start, authsize,
 					 1);
 	} else {
-		auth_len -= authsize;
 		start -= authsize;
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
