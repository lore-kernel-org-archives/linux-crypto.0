Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2A2C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 22:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhLVWIp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:08:45 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58402 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhLVWIp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 17:08:45 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n09ms-0007Y5-A2; Thu, 23 Dec 2021 09:08:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Dec 2021 09:08:42 +1100
Date:   Thu, 23 Dec 2021 09:08:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcOh6jij1s6KA2ee@gondor.apana.org.au>
References: <YcN4S7NIV9F0XXPP@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcN4S7NIV9F0XXPP@pevik>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 22, 2021 at 08:11:07PM +0100, Petr Vorel wrote:
> Hi Herbert,
> 
> do I understand the crypto code correctly, that although crypto/testmgr.c in
> alg_test() returns -EINVAL for non-fips allowed algorithms (that means
> failing crypto API test) the API in crypto_alg_lookup() returns -ELIBBAD for
> failed test?
> 
> Why ELIBBAD and not ENOENT like for missing ciphers? To distinguish between
> missing cipher and disabled one due fips?

Correct.  ELIBBAD is returned for a failed self-test while ENOENT
means that there is no algorithm at all.

This matters if there is more than one provider of the same algorithm.
In that case ELIBBAD would only be returned if all failed the self-test.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
