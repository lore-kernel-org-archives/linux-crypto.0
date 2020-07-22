Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99B9C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 15:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B301D22CAF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595433548;
	bh=Sik9EDg9/EYvGlKmpDWAs+el6Z98mlU2O09h3CSpS38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vmBC3E1zuQ2DIeWfaRYeJxeVsgWt4Nyw3PywWJ7KQGwzNXILEq6Z+xBKbFEqw4n2w
	 fytUcWXfLWdG4w3tSpePRMZRnUYMtS6Zm6Ob7y/4uW8/6O6s4q6dImIZIikUjuObA6
	 YHw7I0tt7uuKSZah+WTUx2dZKvuEo0+20S7BxV5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGVP7I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 11:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgGVP7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 11:59:07 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D38722BEF;
        Wed, 22 Jul 2020 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595433547;
        bh=Sik9EDg9/EYvGlKmpDWAs+el6Z98mlU2O09h3CSpS38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mMUZf1ITzrNrKb+ap2VL57h582o5mbchmG9R/ouX1yJK9qt+k6a1QDUWRDsJdSUZl
         i/5JnTvC//qKR+rh0CMsUsRik53V1RHBlVErjuezOf/b7iLzZv24GKJO31z8SEIl/l
         8f8p5o6YnaRhgOvZAcpYul2GyRlETp4Re0/w+Xtk=
Date:   Wed, 22 Jul 2020 08:59:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200722155905.GA789@sol.localdomain>
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
 <20200716164028.1805047-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716164028.1805047-1-lenaptr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 05:40:28PM +0100, Elena Petrova wrote:
> Extending the userspace RNG interface:
>   1. adding ALG_SET_DRBG_ENTROPY setsockopt option for entropy input;
>   2. using sendmsg syscall for specifying the additional data.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Can you add more details to the commit message?  E.g. why this is needed.

Also please use imperative tense, e.g. "Extend the userspace RNG interface".

>  static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  		       int flags)
>  {
> @@ -65,6 +80,7 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	int genlen = 0;
>  	u8 result[MAXSIZE];
>  
> +	lock_sock(sock->sk);
>  	if (len == 0)
>  		return 0;

This returns without unlocking the socket.

>  	if (len > MAXSIZE)
> @@ -82,16 +98,45 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	 * seeding as they automatically seed. The X9.31 DRNG will return
>  	 * an error if it was not seeded properly.
>  	 */
> -	genlen = crypto_rng_get_bytes(ctx->drng, result, len);
> +	genlen = crypto_rng_generate(ctx->drng, ctx->addtl, ctx->addtl_len,
> +				     result, len);
>  	if (genlen < 0)
>  		return genlen;

Likewise.

>  
>  	err = memcpy_to_msg(msg, result, len);
>  	memzero_explicit(result, len);
> +	rng_reset_addtl(ctx);
> +	release_sock(sock->sk);
>  
>  	return err ? err : len;
>  }
>  
> +static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> +{
> +	int err;
> +	struct alg_sock *ask = alg_sk(sock->sk);
> +	struct rng_ctx *ctx = ask->private;
> +
> +	lock_sock(sock->sk);
> +	if (len > MAXSIZE)
> +		len = MAXSIZE;
> +
> +	rng_reset_addtl(ctx);
> +	ctx->addtl = kmalloc(len, GFP_KERNEL);
> +	if (!ctx->addtl)
> +		return -ENOMEM;

Likewise.

> +
> +	err = memcpy_from_msg(ctx->addtl, msg, len);
> +	if (err) {
> +		rng_reset_addtl(ctx);
> +		return err;

Likewise.
