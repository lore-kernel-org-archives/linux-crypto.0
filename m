Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A1EC43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 06:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C7921582
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 06:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIRG6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 02:58:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRG6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 02:58:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJALO-0002oF-Pt; Fri, 18 Sep 2020 16:58:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 16:58:06 +1000
Date:   Fri, 18 Sep 2020 16:58:06 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pvanleeuwen@rambus.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net
Subject: Re: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Message-ID: <20200918065806.GA9698@gondor.apana.org.au>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 10:19:44AM +0200, Pascal van Leeuwen wrote:
>
> @@ -921,9 +943,20 @@ static int safexcel_ahash_cra_init(struct crypto_tfm *tfm)
>  	ctx->base.send = safexcel_ahash_send;
>  	ctx->base.handle_result = safexcel_handle_result;
>  	ctx->fb_do_setkey = false;
> +	ctx->req_align = cache_line_size() - 1;

So the alignment is just L1_CACHE_BYTES, which is a constant.
Why don't you just put that into the struct and then simply align
the whole struct? To get the aligned ctx, you can make a wrapper
around ahash_request_ctx that does the aligning for you.

Have a look at drivers/crypto/padlock-aes.c which does something
similar for the tfm ctx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
