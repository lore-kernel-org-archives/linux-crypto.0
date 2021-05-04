Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977B9C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 19:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62698613CD
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 19:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhEDThT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 May 2021 15:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhEDThS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 May 2021 15:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29962611AB;
        Tue,  4 May 2021 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620156983;
        bh=i6ahxh9OSb47tZNJ3wX/lTlF8AtbCiuqhyjEP+7mDXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i2/tEJKGx/t7vVYrKQXdzpcUOf9xN1dWL0X+F8tLc4izoqKStv4C9sq+i/QfErnSX
         6538DCyAJ704el1BQZSThgpzVfqbvhzmjGwnO0J3Zq6aiRTYYL+39b9FrOrHB5iUdn
         4xtnB7KEFxe1H0K3mjYRfdVQsaHI5mvnERa6ePQdCOjjLa0acBnVliBzBS48UTGItM
         yYef3jXv+1LSdcYMswe/ztk3tf2UyDcFWitVGZEMnnvElDZBt0ZaI5TgGCon5i1r9u
         CtVHLr7gjzWypJF+uCB7JHcNDQu42bVaEJk5OgtOUxsHtE43NkvSgKC0GWzwqXCWvc
         wdjpHbt94vwsQ==
Date:   Tue, 4 May 2021 12:36:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: arc4: Implement a version optimized for
 memory usage
Message-ID: <YJGiNcorcgAcmAnb@gmail.com>
References: <c52bd8972c9763c3fac685d7c6af3c46a23a1477.1619983555.git.christophe.jaillet@wanadoo.fr>
 <YJF8/oaWUqZsWfOb@gmail.com>
 <d523902e-744c-1291-aee8-9be734f2a3ce@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d523902e-744c-1291-aee8-9be734f2a3ce@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 04, 2021 at 07:59:38PM +0200, Christophe JAILLET wrote:
> Le 04/05/2021 à 18:57, Eric Biggers a écrit :
> > On Sun, May 02, 2021 at 09:29:46PM +0200, Christophe JAILLET wrote:
> > > +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> > > +#define S_type	u8
> > > +#else
> > > +#define S_type	u32
> > > +#endif
> > > +
> > >   struct arc4_ctx {
> > > -	u32 S[256];
> > > +	S_type S[256];
> > >   	u32 x, y;
> > >   };
> > 
> > Is it actually useful to keep both versions?  It seems we could just use the u8
> > version everywhere.  Note that there aren't actually any unaligned memory
> > accesses, so choosing the version conditionally on
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS seems odd.  What are you trying to
> > determine by checking that?
> 
> Hi, this is a bad interpretation from me.
> 
> I thought that S[1] would likely use an odd address and would trigger an
> unaligned access. But as we would read only 1 byte, this is not the case.
> 
> Looking at [1], we have : "At this point, it should be clear that accessing
> a single byte (u8 or char) will never cause an unaligned access, because all
> memory addresses are evenly divisible by one."
> 
> 
> I wanted to avoid potential performance cost related to using char (i.e u8)
> instead of int (i.e. u32).
> On some architecture this could require some shift or masking or whatever to
> "unpack" the values of S.
> 
> 
> [1]:
> https://www.kernel.org/doc/html/latest/core-api/unaligned-memory-access.html
> 
> CJ
> 

arc4 is an insecure cipher which is only supported for use in legacy protocols.
So we don't really need to worry about optimizing performance on every
architecture.  If the byte-based version is *usually* faster as well as uses
less memory, we probably should just use it everywhere.

- Eric
