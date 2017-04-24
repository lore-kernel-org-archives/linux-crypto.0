From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Mon, 24 Apr 2017 11:01:50 +0200
Message-ID: <3234815.BdC1qsBGSt@tauon.chronox.de>
References: <2439869.UPpkkqdW7f@positron.chronox.de> <2572320.UaipMWf1ob@positron.chronox.de> <20170424084324.GA20473@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59254 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1167229AbdDXJB6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 05:01:58 -0400
In-Reply-To: <20170424084324.GA20473@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 24. April 2017, 10:43:24 CEST schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 21, 2017 at 06:35:07PM +0200, Stephan Müller wrote:
> > After checking again, IMHO that is no unreleated cleanup or even a cleanup
> > at all.
> > 
> > void *private used to be struct crypto_aead and is now struct aead_tfm.
> > struct crypto_aead is found in private->aead. Hence, the patch assigned
> > private to tfm and then obtained the struct crypto_aead pointer. As this
> > was not necessary before, it is a required extension IMHO.
> 
> Fair enough.
> 
> But what about the change in aead_sock_destruct? Can you explain why
> it is no longer possible to obtain the tfm from ctx->aead_req?
> 
> Thanks,

aead_request_set_callback(&ctx->aead_req) is set in aead_accept_parent_nokey. 
aead_accept_parent_nokey is only invoked from aead_accept_parent if the key 
was set.

My thought was: Let us assume a caller does not set a key, calls accept and 
then destruct. In this code path, ctx->aead_req is not initialized. Hence, I 
would think that only the path using struct aead_tfm is safe in any case.

But I see that aead_sock_destruct is also linked in by 
aead_accept_parent_nokey. Hence, my initial idea was not correct as the 
destruct path is only callable when the accept_nokey is invoked.

Shall I send an updated patch with aead_sock_destruct cleared?

Ciao
Stephan
