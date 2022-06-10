Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BEDC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jun 2022 09:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349015AbiFJJVN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349067AbiFJJUT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jun 2022 05:20:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9F1304B5B;
        Fri, 10 Jun 2022 02:17:14 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzalN-005MgJ-Nu; Fri, 10 Jun 2022 19:17:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:17:06 +0800
Date:   Fri, 10 Jun 2022 17:17:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     clabbe.montjoie@gmail.com, davem@davemloft.net,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        liwei391@huawei.com
Subject: Re: [PATCH] crypto: sun8i-ss - fix a NULL vs IS_ERR() check in
 sun8i_ss_hashkey
Message-ID: <YqMMEsIDhqKcZmhr@gondor.apana.org.au>
References: <20220602072234.54593-1-wupeng58@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602072234.54593-1-wupeng58@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 02, 2022 at 07:22:34AM +0000, Peng Wu wrote:
> The crypto_alloc_shash() function never returns NULL. It returns error
> pointers.
> 
> Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
