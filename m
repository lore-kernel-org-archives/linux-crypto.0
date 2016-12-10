From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: scatterwalk_map_and_copy incorrect optimization
Date: Sat, 10 Dec 2016 16:11:07 +0800
Message-ID: <20161210081107.GA32765@gondor.apana.org.au>
References: <CAHmME9rq9NjawkZw6wQpWsrY58ZgyRutBKT5UL7RA+8Pv2GOew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers@google.com,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41550 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751194AbcLJILU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Dec 2016 03:11:20 -0500
Content-Disposition: inline
In-Reply-To: <CAHmME9rq9NjawkZw6wQpWsrY58ZgyRutBKT5UL7RA+8Pv2GOew@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hah, looks like I missed [1] by a couple weeks. Looks like it's been
> settled then.
> 
> Is this a stable@ candidate?

Not really since it shouldn't cause any problems unless the stack
is vmalloced.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
