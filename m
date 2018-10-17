Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37446 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeJQOPS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:15:18 -0400
Date: Wed, 17 Oct 2018 14:17:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kees Cook <keescook@chromium.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
Message-ID: <20181017061741.qr23stkwqf36fet6@gondor.apana.org.au>
References: <20181008191712.GA12892@embeddedor.com>
 <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
 <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 16, 2018 at 09:44:02PM +0200, Gustavo A. R. Silva wrote:
> Hi all,
> 
> On 10/9/18 12:20 AM, Kees Cook wrote:
> > On Mon, Oct 8, 2018 at 12:17 PM, Gustavo A. R. Silva
> > <gustavo@embeddedor.com> wrote:
> >> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
> >> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
> >> sizeof(*priv->ring[i].rdr_req).
> >>
> >> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
> >> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
> >> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> 
> 
> Friendly ping. Who can take this?

Well I tried to take it but it doesn't apply against cryptodev.
So I presume this can go into the tree that carried the change
which it depended on?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
