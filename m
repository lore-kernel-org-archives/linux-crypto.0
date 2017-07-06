From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 4.13
Date: Thu, 6 Jul 2017 10:19:18 +0800
Message-ID: <20170706021918.GA5608@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170705130124.GA3755@gondor.apana.org.au>
 <CA+55aFybPA7zJYfT=Dd38tVW8mFE4hv0=hBkdGrXNtdO9zMWiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35168 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdGFCTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2017 22:19:47 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFybPA7zJYfT=Dd38tVW8mFE4hv0=hBkdGrXNtdO9zMWiw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 05, 2017 at 01:02:59PM -0700, Linus Torvalds wrote:
>
> That stupid CNN55XX driver was added with a default of "m"?
> 
> WTF? Hell no. We don't add random new drivers and default them on -
> and we do so even less when they are for very unusual hardware.

Sorry, I'll make sure the default gets removed.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
