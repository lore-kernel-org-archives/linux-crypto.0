From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4]     crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sat, 27 Feb 2016 14:45:34 +0000
Message-ID: <20160227144534.GA7588@gondor.apana.org.au>
References: <56D0361B.8040301@gmail.com>
 <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 26, 2016 at 12:44:08PM +0100, Milan Broz wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
>     commit dd504589577d8e8e70f51f997ad487a4cb6c026f upstream.
> 
>     Some cipher implementations will crash if you try to use them
>     without calling setkey first.  This patch adds a check so that
>     the accept(2) call will fail with -ENOKEY if setkey hasn't been
>     done on the socket yet.
> 
>     Cc: stable@vger.kernel.org
>     Reported-by: Dmitry Vyukov <dvyukov@google.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>     Tested-by: Dmitry Vyukov <dvyukov@google.com>
>     [backported to 4.1 by Milan Broz <gmazyland@gmail.com>]

Ack to all four patches.

Thanks Milan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
