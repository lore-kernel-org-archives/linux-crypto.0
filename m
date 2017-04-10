From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH v2] crypto: ahash - Fix EINPROGRESS notification callback
Date: Mon, 10 Apr 2017 11:37:59 +0200
Message-ID: <20170410093759.GA9169@bistromath.localdomain>
References: <20170410084450.GA7533@gondor.apana.org.au>
 <20170410092127.GA24816@bistromath.localdomain>
 <20170410092757.GA7750@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753122AbdDJJiD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 05:38:03 -0400
Content-Disposition: inline
In-Reply-To: <20170410092757.GA7750@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-04-10, 17:27:57 +0800, Herbert Xu wrote:
> On Mon, Apr 10, 2017 at 11:21:27AM +0200, Sabrina Dubroca wrote:
> >
> > > Cc: <vger@stable.kernel.org>
> > 
> > Should that be stable@vger.kernel.org?
> 
> Oops :)
> 
> > > Reported-by: Sabrina Dubroca <sdubroca@redhat.com>
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > The definition of ahash_request_flags() was missing, so I added:
> > 
> >     static inline u32 ahash_request_flags(struct ahash_request *req)
> >     {
> >            return req->base.flags;
> >     }
> > 
> > And with this, my tests seem fine.
> > 
> > Tested-by: Sabrina Dubroca <sd@queasysnail.net>
> > Could also you change the 'Reported-by:' to that email address?
> 
> OK, here is v2.

I did a quick rebuild+test, seems fine. Thanks!

-- 
Sabrina
