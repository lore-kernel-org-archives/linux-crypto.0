From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel-sha: remove unnecessary static in
 atmel_sha_remove()
Date: Thu, 3 Aug 2017 14:11:31 +0800
Message-ID: <20170803061131.GA12257@gondor.apana.org.au>
References: <20170718230444.GA23140@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170718230444.GA23140@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
> Remove unnecessary static on local variable sha_dd. Such variable
> is initialized before being used, on every execution path throughout
> the function. The static has no benefit and, removing it reduces the
> object file size.
> 
> This issue was detected using Coccinelle and the following semantic patch:
> https://github.com/GustavoARSilva/coccinelle/blob/master/static/static_unused.cocci
> 
> In the following log you can see a significant difference in the object
> file size. This log is the output of the size command, before and after
> the code change:
> 
> before:
>   text    data     bss     dec     hex filename
>  30005   10264     128   40397    9dcd drivers/crypto/atmel-sha.o
> 
> after:
>   text    data     bss     dec     hex filename
>  29934   10208      64   40206    9d0e drivers/crypto/atmel-sha.o
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
