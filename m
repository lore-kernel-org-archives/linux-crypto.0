From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chacha20 - use rol32() macro from bitops.h
Date: Fri, 12 Jan 2018 23:23:18 +1100
Message-ID: <20180112122318.GB21636@gondor.apana.org.au>
References: <20180101000245.3670-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:54558 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933149AbeALMxa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 07:53:30 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by norbury.hmeau.com with esmtp (Exim 4.80 #3 (Debian))
        id 1eZypo-0006Wi-3w
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 23:53:24 +1100
Content-Disposition: inline
In-Reply-To: <20180101000245.3670-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 31, 2017 at 06:02:45PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For chacha20_block(), use the existing 32-bit left-rotate function
> instead of defining one ourselves.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
