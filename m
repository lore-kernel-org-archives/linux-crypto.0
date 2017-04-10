From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: crypto: ahash - Fix EINPROGRESS notification callback
Date: Mon, 10 Apr 2017 11:21:27 +0200
Message-ID: <20170410092127.GA24816@bistromath.localdomain>
References: <20170410084450.GA7533@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752750AbdDJJVb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 05:21:31 -0400
Content-Disposition: inline
In-Reply-To: <20170410084450.GA7533@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-04-10, 16:44:50 +0800, Herbert Xu wrote:
> The ahash API modifies the request's callback function in order
> to clean up after itself in some corner cases (unaligned final
> and missing finup).
> 
> When the request is complete ahash will restore the original
> callback and everything is fine.  However, when the request gets
> an EBUSY on a full queue, an EINPROGRESS callback is made while
> the request is still ongoing.
> 
> In this case the ahash API will incorrectly call its own callback.
> 
> This patch fixes the problem by creating a temporary request
> object on the stack which is used to relay EINPROGRESS back to
> the original completion function.
> 
> This patch also adds code to preserve the original flags value.
> 
> Cc: <vger@stable.kernel.org>

Should that be stable@vger.kernel.org?

> Reported-by: Sabrina Dubroca <sdubroca@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

The definition of ahash_request_flags() was missing, so I added:

    static inline u32 ahash_request_flags(struct ahash_request *req)
    {
           return req->base.flags;
    }

And with this, my tests seem fine.

Tested-by: Sabrina Dubroca <sd@queasysnail.net>
Could also you change the 'Reported-by:' to that email address?


Thanks,

-- 
Sabrina
