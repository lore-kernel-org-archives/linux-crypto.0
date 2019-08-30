Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074F9C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE79521874
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfH3IZ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:25:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59702 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfH3IZ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:25:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i3cDe-0005jc-1a; Fri, 30 Aug 2019 18:25:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2019 18:25:16 +1000
Date:   Fri, 30 Aug 2019 18:25:16 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     davem@davemloft.net, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, liguozhu@hisilicon.com,
        john.garry@huawei.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: hisilicon: select CRYPTO_LIB_DES while
 compiling SEC driver
Message-ID: <20190830082516.GJ8033@gondor.apana.org.au>
References: <affd8de1-ae35-a1d0-534a-d9cdfac90de8@huawei.com>
 <20190828080740.43244-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828080740.43244-1-maowenan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 28, 2019 at 04:07:40PM +0800, Mao Wenan wrote:
> When CRYPTO_DEV_HISI_SEC=y, below compilation error is found after 
> 'commit 894b68d8be4b ("crypto: hisilicon/des - switch to new verification routines")':
> 
> drivers/crypto/hisilicon/sec/sec_algs.o: In function `sec_alg_skcipher_setkey_des_cbc':
> sec_algs.c:(.text+0x11f0): undefined reference to `des_expand_key'
> drivers/crypto/hisilicon/sec/sec_algs.o: In function `sec_alg_skcipher_setkey_des_ecb':
> sec_algs.c:(.text+0x1390): undefined reference to `des_expand_key'
> make: *** [vmlinux] Error 1
> 
> This because DES library has been moved to lib/crypto in this commit 
> '04007b0e6cbb ("crypto: des - split off DES library from generic DES cipher driver")'.
> Fix this by selecting CRYPTO_LIB_DES in CRYPTO_DEV_HISI_SEC.
> 
> Fixes: 04007b0e6cbb ("crypto: des - split off DES library from generic DES cipher driver")
> Fixes: 894b68d8be4b ("crypto: hisilicon/des - switch to new verification routines")
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  v2: remove fix tag 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver") 
>  drivers/crypto/hisilicon/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
