From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: img-hash: remove unnecessary static in
 img_hash_remove()
Date: Thu, 3 Aug 2017 14:11:48 +0800
Message-ID: <20170803061148.GA12295@gondor.apana.org.au>
References: <20170718230712.GA15507@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170718230712.GA15507@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
> Remove unnecessary static on local variable hdev. Such variable
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
>  14842    6464     128   21434    53ba drivers/crypto/img-hash.o
> 
> after:
>   text    data     bss     dec     hex filename
>  14789    6376      64   21229    52ed drivers/crypto/img-hash.o
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
