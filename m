Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AC9C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 05:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhL0FvK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 00:51:10 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58608 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhL0FvK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 00:51:10 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n1iuU-0005Hm-2c; Mon, 27 Dec 2021 16:51:03 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Dec 2021 16:51:01 +1100
Date:   Mon, 27 Dec 2021 16:51:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-crypto@vger.kernel.org
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YclURQzYKqCMHWx6@gondor.apana.org.au>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
 <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
 <YcOqoGOLfNTZh/ZF@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcOqoGOLfNTZh/ZF@quark>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 22, 2021 at 04:45:52PM -0600, Eric Biggers wrote:
>
> Some of the LTP tests check for ENOENT to determine whether an algorithm is
> intentionally unavailable, as opposed to it failing due to some other error.
> There is code in the kernel that does this same check too, e.g.
> fs/crypto/keysetup.c and block/blk-crypto-fallback.c.
> 
> The way that ELIBBAD is overloaded to mean essentially the same thing as ENOENT,
> but only in some cases, is not expected.
> 
> It would be more logical for ELIBBAD to be restricted to actual test failures.
> 
> If it is too late to change, then fine, but it seems like a bug to me.

For the purpose of identifying FIPS-disabled algorithm (as opposed
to an algorithm that's not enabled in the kernel at all), I think
it is perfectly safe to use ELIBBAD instead of ENOENT in user-space.

Remember that ELIBBAD means that every kernel implementation of
the given algorithm has failed.  Since we would never allow a
generic algorithm to be merged into the kernel unless it passed
its own self-test, this is extremely unlikely unless the algorithm
has been disabled by FIPS.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
