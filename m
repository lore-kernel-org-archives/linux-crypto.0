From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/2] crypto: engine: permit to enqueue ashash_request
Date: Wed, 7 Sep 2016 21:20:36 +0800
Message-ID: <20160907132036.GG17176@gondor.apana.org.au>
References: <1472644978-9003-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        baolin.wang@linaro.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53629 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756387AbcIGNUo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:20:44 -0400
Content-Disposition: inline
In-Reply-To: <1472644978-9003-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 31, 2016 at 02:02:56PM +0200, Corentin Labbe wrote:
> Hello
> 
> I wanted to use the crypto engine for my Allwinner crypto driver but something
> prevented me to use it: it cannot enqueue hash requests.
> This patch convert crypto engine to permit enqueuing of ahash_requests.
> It also convert the only driver using crypto engine.
> 
> The modifications against omap was only compile tested but the crypto engine with
> hash support was tested on two different offtree driver (sun4i-ss and sun8i-ce)
> 
> Regards
> 
> Changes since v1:
> - rebased on cryptodev for handling omap-des
> 
> Changes since v2:
> - Fusionned both patch
> - Renamed crypt_one_request to do_one_request
> - Test the type of request before processing it
> 
> Changes sunce v3
> - Add functions for each type (ablkcipher/ahash)
> 
> LABBE Corentin (2):
>   crypto: move crypto engine to its own header
>   crypto: engine: permit to enqueue ashash_request
> 
>  crypto/crypto_engine.c    | 187 ++++++++++++++++++++++++++++++++++++----------
>  drivers/crypto/omap-aes.c |   9 ++-
>  drivers/crypto/omap-des.c |   9 ++-
>  include/crypto/algapi.h   |  70 -----------------
>  include/crypto/engine.h   | 107 ++++++++++++++++++++++++++
>  5 files changed, 266 insertions(+), 116 deletions(-)
>  create mode 100644 include/crypto/engine.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
