From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 1/4] camellia: 64-bit optimization
Date: Thu, 22 Nov 2007 14:29:36 -0800
Message-ID: <200711221429.36309.vda.linux@googlemail.com>
References: <200711210022.28510.vda.linux@googlemail.com> <200711210023.49410.vda.linux@googlemail.com> <20071122122528.GA9556@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:25866 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbXKVW3o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:29:44 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2478480rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:29:43 -0800 (PST)
In-Reply-To: <20071122122528.GA9556@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 22 November 2007 04:25, Herbert Xu wrote:
> On Wed, Nov 21, 2007 at 12:23:49AM -0800, Denys Vlasenko wrote:
> > On Wednesday 21 November 2007 00:22, Denys Vlasenko wrote:
> > > Patches start from 5 because pathches 1..4 are already
> > > in cryptodev-2.6.
> > >
> > > camellia5:
> > >         adds 64-bit key setup, it is used if BITS_PER_LONG is 64.
> >
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
>
> Denys, I really appreciate your work in cleaning this algorithm up.
>
> However, I just can't accept 600 lines of new code just to do setkey
> faster/smaller on 64-bit platforms.  You know, some people have to
> study these files line-by-line in order have them pass government
> certifications and such.

480 lines after all patches are applied.

> OK I went back and looked at the figures, so we're talking about
> either 1K extra on 64-bit if we use the 32-bit version or 2K extra
> on 32-bit if we went for the 64-bit version.
>
> Either way it doesn't seem to be a big deal.  So how about just
> picking one and sticking with it?

"No big deal" approach resulted in thish module having 30k of code.
I cut it down to 20-18k.

In aic7xxx driver, similarly, I rediced size from 300k to 200k.
Still not in mainline. This is depressing.

I am an -Os guy and for me 1k out of 20k module doesn't sound too small.

I will rework and repost patches so that 64-bit code is added by last
patch, feel free to not apply it.
--
vda
