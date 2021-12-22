Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1B9C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 22:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhLVWbj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:31:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58404 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhLVWbj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 17:31:39 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0A8z-0007tj-B8; Thu, 23 Dec 2021 09:31:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Dec 2021 09:31:33 +1100
Date:   Thu, 23 Dec 2021 09:31:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-crypto@vger.kernel.org
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcOlw1UJizlngAEG@quark>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 22, 2021 at 04:25:07PM -0600, Eric Biggers wrote:
>
> Isn't it just an implementation detail that !fips_allowed is handled by the
> self-test?  Wouldn't it make more sense to report ENOENT for such algorithms?

ELIBBAD does not necessarily mean !fips_allowed, it could also
mean a specific implementation (or hardware) failed the self-test.

Yes, we could change ELIBBAD to something else in the case of
!fips_allowed, but it's certainly not a trivial change.

Please give a motivation for this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
