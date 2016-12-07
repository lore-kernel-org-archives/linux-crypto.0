From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Wed, 7 Dec 2016 20:09:00 +0800
Message-ID: <20161207120900.GC20680@gondor.apana.org.au>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43466 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751225AbcLGMJa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 07:09:30 -0500
Content-Disposition: inline
In-Reply-To: <20161205125738.GA13525@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 05, 2016 at 01:57:38PM +0100, Corentin Labbe wrote:
>
> So how to expose PRNG to user space ? or more generally how to "use" a PRNG ?

We do have the algif_rng interface.

> I found hisi-rng, crypto4xx_ and exynos-rng which seems to be PRNG used as hwrng.

Thanks for checking.  Patches to remove these are welcome.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
