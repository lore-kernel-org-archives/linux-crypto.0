From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: add SPDX identifier
Date: Sat, 30 Dec 2017 09:21:09 +0100
Message-ID: <20171230082109.ckm5mwkgusz233ro@gauss3.secunet.de>
References: <1513856130-7843-1-git-send-email-thrust73@gmail.com>
 <20171228065327.GA9066@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Cheah Kok Cheong <thrust73@gmail.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pombredanne@nexb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:41084 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdL3IVL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Dec 2017 03:21:11 -0500
Content-Disposition: inline
In-Reply-To: <20171228065327.GA9066@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 28, 2017 at 05:53:27PM +1100, Herbert Xu wrote:
> Cheah Kok Cheong <thrust73@gmail.com> wrote:
> > Add SPDX license identifier according to the type of license text found
> > in the file.
> > 
> > Cc: Philippe Ombredanne <pombredanne@nexb.com>
> > Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
> > ---
> > kernel/padata.c | 1 +
> > 1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/padata.c b/kernel/padata.c
> > index e265953..eb9a9d9 100644
> > --- a/kernel/padata.c
> > +++ b/kernel/padata.c
> > @@ -1,3 +1,4 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > /*
> >  * padata.c - generic interface to process data streams in parallel
> >  *
> 
> Steffen, are you OK with this patch?

Yes, I'm ok with this.

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
