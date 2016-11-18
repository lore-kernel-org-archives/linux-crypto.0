From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Fri, 18 Nov 2016 08:55:04 +0100
Message-ID: <20161118075504.GA21827@Red>
References: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
 <CACXcFmmMc7U1Qz6A+mvMXVnfSmOmssydcmSugo21jrX3u-95Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        maxime.ripard@free-electrons.com, wens@csie.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36059 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbcKRHzJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 02:55:09 -0500
Content-Disposition: inline
In-Reply-To: <CACXcFmmMc7U1Qz6A+mvMXVnfSmOmssydcmSugo21jrX3u-95Qg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 17, 2016 at 08:07:09PM -0500, Sandy Harris wrote:
> Add Ted T'so to cc list. Shouldn't he be included on anything affecting
> the random(4) driver?
> 

Blindy used get_maintainer.pl, and since the file is in crypto, hw_random people were not set.
Note that get_maintainer.pl on drivers/char/hw_random/, does not give his address also.
My V2 patch will have them in CC/TO.

> On Tue, Oct 18, 2016 at 8:34 AM, Corentin Labbe
> <clabbe.montjoie@gmail.com> wrote:
> 
> > From: LABBE Corentin <clabbe.montjoie@gmail.com>
> >
> > The Security System have a PRNG.
> > This patch add support for it as an hwrng.
> 
> Which is it? A PRNG & a HW RNG are quite different things.
> It would, in general, be a fairly serious error to treat a PRNG
> as a HWRNG.
> 
> If it is just a prng (which it appears to be from a quick look
> at your code) then it is not clear it is useful since the
> random(4) driver already has two PRNGs. It might be
> but I cannot tell.

For me hwrng is a way to give user space an another way to get "random" data via /dev/hwrng.
The only impact of hwrng with random is that just after init some data of hwrng is used for having more entropy.

Grepping prng in drivers/char/hw_random/ and drivers/crypto show me some other PRNG used with hwrng.

Regards
Corentin Labbe
