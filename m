Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48492 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfARK5I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:57:08 -0500
Date: Fri, 18 Jan 2019 18:56:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Stefan Agner <stefan@agner.ch>, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: brcm - Fix some set-but-not-used warning
Message-ID: <20190118105654.p355fqvz4hhva33h@gondor.apana.org.au>
References: <1545968644-191671-1-git-send-email-yuehaibing@huawei.com>
 <1547014278-93847-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547014278-93847-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 09, 2019 at 06:11:18AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/bcm/cipher.c: In function 'handle_ahash_req':
> drivers/crypto/bcm/cipher.c:720:15: warning:
>  variable 'chunk_start' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/bcm/cipher.c: In function 'spu_rx_callback':
> drivers/crypto/bcm/cipher.c:1679:31: warning:
>  variable 'areq' set but not used [-Wunused-but-set-variable]
> 
> drivers/crypto/bcm/cipher.c:1678:22: warning:
>  variable 'ctx' set but not used [-Wunused-but-set-variable]
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> ---
> v2: add Fixes tag
> ---
>  drivers/crypto/bcm/cipher.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
