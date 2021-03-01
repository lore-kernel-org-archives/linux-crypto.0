Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280ACC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 10:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E071E600CC
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 10:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhCAKd2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:33:28 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:53890 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhCAKdY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 05:33:24 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lGfqU-0003D7-Mj; Mon, 01 Mar 2021 21:32:11 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 01 Mar 2021 21:32:10 +1100
Date:   Mon, 1 Mar 2021 21:32:10 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     clabbe.montjoie@gmail.com, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, jernej.skrabec@siol.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ce: rename kfree() to kfree_sensitive()
Message-ID: <20210301103210.GA30054@gondor.apana.org.au>
References: <1614594641-35606-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614594641-35606-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 01, 2021 at 06:30:41PM +0800, Yang Li wrote:
> Rename kfree() to kfree_sensitive() to  make the intention of the API
> more explicit.
> 
> fixed the following coccicheck:
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:30:16-17: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 29)
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:42:16-17: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 41)
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:161:8-9: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 109)
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> index cfde9ee..8259d52 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> @@ -27,7 +27,7 @@ void sun8i_ce_prng_exit(struct crypto_tfm *tfm)
>  	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
>  
>  	memzero_explicit(ctx->seed, ctx->slen);
> -	kfree(ctx->seed);
> +	kfree_sensitive(ctx->seed);

Any reason why you're keeping the memzero?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
