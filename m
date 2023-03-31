Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC618C76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 10:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCaKL0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 06:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCaKKp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 06:10:45 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CAF1D843;
        Fri, 31 Mar 2023 03:05:18 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1piBd5-00AlZZ-3l; Fri, 31 Mar 2023 18:05:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Mar 2023 18:05:07 +0800
Date:   Fri, 31 Mar 2023 18:05:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jayesh Choudhary <j-choudhary@ti.com>
Cc:     davem@davemloft.net, j-keerthy@ti.com, kristo@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul - Add CRYPTO_DES to CRYPTO_DEV_SA2UL
Message-ID: <ZCawU2ISLAFE6lUH@gondor.apana.org.au>
References: <20230324145812.315334-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324145812.315334-1-j-choudhary@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 24, 2023 at 08:28:12PM +0530, Jayesh Choudhary wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The SA2UL Crypto driver provides support for couple of
> DES3 algos "cbc(des3_ede)" and "ecb(des3_ede)", and enabling
> the crypto selftest throws the following errors (as seen on
> K3 J721E SoCs):
>   saul-crypto 4e00000.crypto: Error allocating fallback algo cbc(des3_ede)
>   alg: skcipher: failed to allocate transform for cbc-des3-sa2ul: -2
>   saul-crypto 4e00000.crypto: Error allocating fallback algo ecb(des3_ede)
>   alg: skcipher: failed to allocate transform for ecb-des3-sa2ul: -2
> 
> Fix this by selecting CRYPTO_DES which was missed while
> adding base driver support.
> 
> Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
