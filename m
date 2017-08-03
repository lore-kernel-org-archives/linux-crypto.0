From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-sham: remove unnecessary static in
 omap_sham_remove()
Date: Thu, 3 Aug 2017 14:11:23 +0800
Message-ID: <20170803061122.GA12238@gondor.apana.org.au>
References: <20170718230311.GA24035@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58356 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdHCGL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:11:29 -0400
Content-Disposition: inline
In-Reply-To: <20170718230311.GA24035@embeddedgus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
> Remove unnecessary static on local variable dd. Such variable
> is initialized before being used, on every execution path throughout
> the function. The static has no benefit and, removing it reduces the
> object file size.
> 
> This issue was detected using Coccinelle and the following semantic patch:
> https://github.com/GustavoARSilva/coccinelle/blob/master/static/static_unused.cocci
> 
> In the following log you can see a difference in the object file size.
> This log is the output of the size command, before and after the code
> change:
> 
> before:
>   text    data     bss     dec     hex filename
>  26135   11944     128   38207    953f drivers/crypto/omap-sham.o
> 
> after:
>   text    data     bss     dec     hex filename
>  26084   11856      64   38004    9474 drivers/crypto/omap-sham.o
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
