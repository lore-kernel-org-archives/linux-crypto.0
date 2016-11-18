From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 17 Nov 2016 20:07:09 -0500
Message-ID: <CACXcFmmMc7U1Qz6A+mvMXVnfSmOmssydcmSugo21jrX3u-95Qg@mail.gmail.com>
References: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        maxime.ripard@free-electrons.com, wens@csie.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34611 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbcKRBHK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 20:07:10 -0500
In-Reply-To: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Ted T'so to cc list. Shouldn't he be included on anything affecting
the random(4) driver?

On Tue, Oct 18, 2016 at 8:34 AM, Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:

> From: LABBE Corentin <clabbe.montjoie@gmail.com>
>
> The Security System have a PRNG.
> This patch add support for it as an hwrng.

Which is it? A PRNG & a HW RNG are quite different things.
It would, in general, be a fairly serious error to treat a PRNG
as a HWRNG.

If it is just a prng (which it appears to be from a quick look
at your code) then it is not clear it is useful since the
random(4) driver already has two PRNGs. It might be
but I cannot tell.
