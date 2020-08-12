Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06875C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF2F207F7
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHLMdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:33:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52918 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbgHLMdO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 08:33:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k5pwN-0006uu-6q; Wed, 12 Aug 2020 22:33:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Aug 2020 22:33:11 +1000
Date:   Wed, 12 Aug 2020 22:33:11 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: af_alg - fix uninitialized ctx->init
Message-ID: <20200812123311.GA21384@gondor.apana.org.au>
References: <20200812092232.364991-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092232.364991-1-omosnace@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 12, 2020 at 11:22:32AM +0200, Ondrej Mosnacek wrote:
> This new member of struct af_alg_ctx was not being initialized before
> use, leading to random errors. Found via libkcapi testsuite.
> 
> Cc: Stephan Mueller <smueller@chronox.de>
> Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  crypto/algif_aead.c     | 1 +
>  crypto/algif_skcipher.c | 1 +
>  2 files changed, 2 insertions(+)

Thanks for the patch.

> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index d48d2156e6210..9b5bd0ff3c47d 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -563,6 +563,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
>  	ctx->more = 0;
>  	ctx->merge = 0;
>  	ctx->enc = 0;
> +	ctx->init = 0;
>  	ctx->aead_assoclen = 0;
>  	crypto_init_wait(&ctx->wait);

This isn't necessary because there is a memset on ctx already.

> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index a51ba22fef58f..0de035b991943 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -350,6 +350,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
>  	ctx->more = 0;
>  	ctx->merge = 0;
>  	ctx->enc = 0;
> +	ctx->init = 0;
>  	crypto_init_wait(&ctx->wait);

We should add a memset here for skcipher and get rid of these
zero assignments.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
