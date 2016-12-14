From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Wed, 14 Dec 2016 07:03:40 +0100
Message-ID: <20161214060340.GA24050@Red>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au>
 <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au>
 <20161213141059.GB10647@Red>
 <20161214050551.GD9592@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35459 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbcLNGEP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 01:04:15 -0500
Content-Disposition: inline
In-Reply-To: <20161214050551.GD9592@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 14, 2016 at 01:05:51PM +0800, Herbert Xu wrote:
> On Tue, Dec 13, 2016 at 03:10:59PM +0100, Corentin Labbe wrote:
> >
> > I have found two solutions:
> 
> No we already have algif_rng so let's not confuse things even
> further by making hwrng take PRNGs.
> 

But algif_rng is not accessible from user space without any coding.
So no easy "random" data with some cat /dev/xxxx.

Clearly users of the 3 already intree hw_random PRNG will see that like a regresion.

Regards
Corentin Labbe
