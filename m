From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] hash import and request initialization
Date: Wed, 27 Dec 2017 14:35:00 +1100
Message-ID: <20171227033500.GA32764@gondor.apana.org.au>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au>
 <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
 <20171226104010.GA28275@gondor.apana.org.au>
 <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48820 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbdL0DfL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 22:35:11 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 26, 2017 at 02:21:53PM +0200, Gilad Ben-Yossef wrote:
> 
> See how SKCIPHER_REQUEST_ON_STACK is being used with an asymmetric skcipher
> in drivers/md/dm-integrity.c

That's just broken.  SKCIPHER_REQUEST_ON_STACK is only meant for
sync algorithms and this code needs to be changed to either do the
proper request allocation or switch over to allocating sync
algorithms.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
