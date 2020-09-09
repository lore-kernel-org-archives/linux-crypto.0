Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C46C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 04:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B925F21D43
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 04:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599626158;
	bh=je5OA9iAHkvXkpmZ+WvCM+zHsYTFCH8f3LiqiwGOrNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DKek1OQqbTSWdPRqHB3sP5Q7I2LdXhujvSJWR2Nhnx839d/ctF6I9mDQS1McWrt5t
	 1eOQq4/92s3RNbqdvj++LqAIO+m3DVk7c3Z4T5mXLR2ty9Uyz5Yx887yLnq2TslPUQ
	 AcFi1ogXR8WSY2P3+yy70fyBxq0DbP/f1EINR53U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgIIEf5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 00:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgIIEf5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 00:35:57 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FCD20758;
        Wed,  9 Sep 2020 04:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599626156;
        bh=je5OA9iAHkvXkpmZ+WvCM+zHsYTFCH8f3LiqiwGOrNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1w5ve+edGLAT2nehtd7dJtNqTvtB+ux5Y1IBrNfx40qWcTjiB0aADs04LS6T2JPQ0
         qlNb4DdsSpLS8ncWZe8uldart0i0jxHYTIByWnOxkYiFNMjpgziG1DN+QCSB0838j1
         aKBAonfCPTMXBD6ylDnMx/UQC3aIZ6wmO1tuCC/E=
Date:   Tue, 8 Sep 2020 21:35:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Subject: Re: [PATCH v6] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200909043554.GA8311@sol.localdomain>
References: <20200821042443.GA25695@gondor.apana.org.au>
 <20200908170403.2625295-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200908170403.2625295-1-lenaptr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 08, 2020 at 06:04:03PM +0100, Elena Petrova wrote:
> Extend the user-space RNG interface:
>   1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
>   2. Add additional data input via sendmsg syscall.
> 
> This allows DRBG to be tested with test vectors, for example for the
> purpose of CAVP testing, which otherwise isn't possible.
> 
> To prevent erroneous use of entropy input, it is hidden under
> CRYPTO_USER_API_RNG_CAVP config option and requires CAP_SYS_ADMIN to
> succeed.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> Acked-by: Stephan Müller <smueller@chronox.de>

This doesn't compile for me.  Can you rebase this onto the latest
"master" branch from
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git?

> +static void rng_reset_addtl(struct rng_ctx *ctx)
>  {
> -	struct sock *sk = sock->sk;
> -	struct alg_sock *ask = alg_sk(sk);
> -	struct rng_ctx *ctx = ask->private;
> -	int err;
> +	kzfree(ctx->addtl);
> +	ctx->addtl = NULL;
> +	ctx->addtl_len = 0;
> +}

kzfree() has been renamed to kfree_sensitive(); see commit 453431a54934
("mm, treewide: rename kzfree() to kfree_sensitive()").
So please use kfree_sensitive() rather than kzfree(), in all three places.

Note, kzfree() won't actually cause a compilation error since it's still
#define'd to kfree_sensitive().  But that #define probably will go away soon.

> +static int rng_test_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> +{
> +	int err;
> +	struct alg_sock *ask = alg_sk(sock->sk);
> +	struct rng_ctx *ctx = ask->private;
> +
> +	lock_sock(sock->sk);
> +	if (len > MAXSIZE)
> +		len = MAXSIZE;

Since this function only supports providing the additional data all at once, not
incrementally, shouldn't it return an error code if the length is too long,
rather than truncate the length?

> +	/*
> +	 * Non NULL pctx->entropy means that CAVP test has been initiated on
> +	 * this socket, replace proto_ops algif_rng_ops with algif_rng_test_ops.
> +	 */
> +	if (pctx->entropy)
> +		sk->sk_socket->ops = algif_rng_test_ops;

This means that providing additional data on a "request socket" via sendmsg will
only work if ALG_SET_DRBG_ENTROPY was used on the "algorithm socket" earlier.
If that's intentional, it needs to be mentioned in the documentation.

>  static const struct af_alg_type algif_type_rng = {
> @@ -169,6 +319,9 @@ static const struct af_alg_type algif_type_rng = {
>  	.release	=	rng_release,
>  	.accept		=	rng_accept_parent,
>  	.setkey		=	rng_setkey,
> +#if IS_ENABLED(CONFIG_CRYPTO_USER_API_RNG_CAVP)
> +	.setentropy	=	rng_setentropy,
> +#endif

Since CRYPTO_USER_API_RNG_CAVP is now a bool rather than a tristate, this should
use '#ifdef CONFIG_CRYPTO_USER_API_RNG_CAVP' instead of
'IS_ENABLED(CONFIG_CRYPTO_USER_API_RNG_CAVP)'.

- Eric
