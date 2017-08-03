From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel-tdes: remove unnecessary static in
 atmel_tdes_remove()
Date: Thu, 3 Aug 2017 14:11:40 +0800
Message-ID: <20170803061140.GA12276@gondor.apana.org.au>
References: <20170718230550.GA11042@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170718230550.GA11042@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
> Remove unnecessary static on local variable tdes_dd. Such variable
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
>  17079    8704     128   25911    6537 drivers/crypto/atmel-tdes.o
> 
> after:
>   text    data     bss     dec     hex filename
>  17039    8616      64   25719    6477 drivers/crypto/atmel-tdes.o
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
