Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681A2C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 10:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiLBKV1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiLBKVU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 05:21:20 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DBDCE43E;
        Fri,  2 Dec 2022 02:21:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p13A6-003CL2-3U; Fri, 02 Dec 2022 18:20:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Dec 2022 18:20:54 +0800
Date:   Fri, 2 Dec 2022 18:20:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree,hisilicon - Fix dependencies to correct
 algorithm
Message-ID: <Y4nRhmvqyUz2lTrm@gondor.apana.org.au>
References: <20221125121811.88031-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125121811.88031-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 08:18:11PM +0800, Tianjia Zhang wrote:
> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
> the SM3 and SM4 stand-alone library and the algorithm implementation for
> the Crypto API into the same directory, and the corresponding relationship
> of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
> library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
> algorithm implementation for the Crypto API. Therefore, it is necessary
> for this module to depend on the correct algorithm.
> 
> Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: stable@vger.kernel.org # v5.19+
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  drivers/crypto/Kconfig           | 4 ++--
>  drivers/crypto/hisilicon/Kconfig | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
