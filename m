From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: make the seed() function optional
Date: Sat, 7 Oct 2017 11:33:18 +0800
Message-ID: <20171007033318.GA29712@gondor.apana.org.au>
References: <20170913200915.20738-1-malat@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: prasannatsmkumar@gmail.com, malat@debian.org,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mathieu Malaterre <malat@debian.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57264 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbdJGDdu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 23:33:50 -0400
Content-Disposition: inline
In-Reply-To: <20170913200915.20738-1-malat@debian.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mathieu Malaterre <malat@debian.org> wrote:
> This makes it simplier for driver author to not provide the seed() function
> in case of a pseudo RNG where the seed operation is a no-op.
> 
> Document that the seed() function pointer is optional in header.
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>
> ---
> The PRNG as found on Ingenic JZ4780 is one such example. This is found on a
> MIPS Creator CI20 SoC.

So how does it seed itself? This also contradicts with the JZ4780
driver that's currently in the patch queue as it does contain a
seed function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
