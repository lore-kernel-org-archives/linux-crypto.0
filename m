From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 08/11] crypto: testmgr - check err on akcipher maxsize
Date: Tue, 23 May 2017 12:08:36 +0800
Message-ID: <20170523040836.GD12788@gondor.apana.org.au>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
 <1495033238-26016-9-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47872 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751821AbdEWEIw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 00:08:52 -0400
Content-Disposition: inline
In-Reply-To: <1495033238-26016-9-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 17, 2017 at 06:00:35PM +0300, Tudor Ambarus wrote:
> crypto_akcipher_maxsize() returns minimum length for output buffer
> or error code if key hasn't been set.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  crypto/testmgr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 6f5f3ed..87a4abd 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2150,6 +2150,11 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>  
>  	err = -ENOMEM;
>  	out_len_max = crypto_akcipher_maxsize(tfm);

Can this call be reached without a setkey or with a failed setkey?
If not we should not check for errors.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
