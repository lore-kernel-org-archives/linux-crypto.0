Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A10C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 04:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7618F20855
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 04:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgHUEYs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 00:24:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgHUEYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 00:24:48 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8ybb-0000Nz-SF; Fri, 21 Aug 2020 14:24:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 14:24:43 +1000
Date:   Fri, 21 Aug 2020 14:24:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     lenaptr@google.com, linux-crypto@vger.kernel.org,
        smueller@chronox.de, ardb@kernel.org, jeffv@google.com
Subject: Re: [PATCH v5] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200821042443.GA25695@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813193239.GA2470@sol.localdomain>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
>
> Since proto_ops are almost identical, and only one is used in a given kernel
> build, why not just do:
> 
> static struct proto_ops algif_rng_ops = {
>        ...
> #ifdef CONFIG_CRYPTO_USER_API_RNG_CAVP
>        .sendmsg        = rng_sendmsg,
> #else
>        .sendmsg        = sock_no_sendmsg,
> #endif
>        ...
> };
> 
> Similarly for .recvmsg(), although I don't understand what's wrong with just
> adding the lock_sock() instead...  The RNG algorithms do locking anyway, so it's
> not like that would regress the ability to recvmsg() in parallel.  Also,
> conditional locking depending on the kernel config makes it more difficult to
> find kernel bugs like deadlocks.

I want this to have minimal impact on anyone who's not using it.
After all, this is something that only Google is asking for.

Anyway, I wasn't looking for a compile-time ops switch, but a
run-time one.

I think what we can do is move the new newsock->ops assignment
in af_alg_accept up above the type->accept call which would then
allow it to be overridden by the accept call.

After that you could just change newsock->ops depending on whether
pctx->entropy is NULL or not in rng_accept_parent.

As for the proto_ops duplication I don't think it's that big a
deal, but if you're really bothered just create a macro for the
identical bits in the struct.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
