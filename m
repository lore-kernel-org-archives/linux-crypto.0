Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3895C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 12:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEFC61BF6
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 12:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhKPMzk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 07:55:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236372AbhKPMzj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 07:55:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E536D615A4;
        Tue, 16 Nov 2021 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637067162;
        bh=o1WtAZAgo7NnvkYIzkDGmVlb4BEVKi/y98HXaVyEhcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KC9olUBcxCYOG2Lngnhg30qkDLt11Ekr/Vu59d6YR+YPnsaDinCx5NtCPNyEZOvnV
         kGN+g0WpNKJZEPvnGOfdOVm6oaghhg+Lv5XR1OEQjmrzHhI+5W7fq7mA80RtSd77Ui
         YQdgNeP/T2/s6tcJyN494tRoLKlqgDcfbrWRncjo=
Date:   Tue, 16 Nov 2021 13:52:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] Replace memset() with memzero_explicit()
Message-ID: <YZOpl5mVVcG/s9w1@kroah.com>
References: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
 <YZObImtJITs1ZfUc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZObImtJITs1ZfUc@kroah.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 16, 2021 at 12:50:58PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 16, 2021 at 07:25:22PM +0800, Sandy Harris wrote:
> > Replace memset(address,0,bytes) which may be optimised away
> > with memzero_explicit(address,bytes) which resists
> > such optimisation
> > 
> > ---
> >  crypto/des_generic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/crypto/des_generic.c b/crypto/des_generic.c
> > index c85354a5e94c..105a32e7afea 100644
> > --- a/crypto/des_generic.c
> > +++ b/crypto/des_generic.c
> > @@ -30,7 +30,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
> >              err = 0;
> >      }
> >      if (err)
> > -        memset(dctx, 0, sizeof(*dctx));
> > +        memzero_explicit(dctx, sizeof(*dctx));
> >      return err;
> >  }
> > 
> > @@ -62,7 +62,7 @@ static int des3_ede_setkey(struct crypto_tfm *tfm,
> > const u8 *key,
> >              err = 0;
> >      }
> >      if (err)
> > -        memset(dctx, 0, sizeof(*dctx));
> > +        memzero_explicit(dctx, sizeof(*dctx));
> >      return err;
> >  }
> > 
> 
> Have you looked at the output of the compiler to see if this really is
> needed or not?

Oh wait, that's not a stack variable, how would this be optimized away
at all?  If it is, that's a HUGE compiler bug.

Is that really happening here?

thanks,

greg k-h
