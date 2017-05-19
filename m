From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 4/9] crypto: marvell - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 11:17:24 +0200
Message-ID: <20170519111724.3933c91d@bbrezillon>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
        <20170519065331.27670-5-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com, arno@natisbad.org,
        matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
        salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:47776 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdESJR2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 05:17:28 -0400
In-Reply-To: <20170519065331.27670-5-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 19 May 2017 08:53:26 +0200
Corentin Labbe <clabbe.montjoie@gmail.com> wrote:

> This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
> define.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/hash.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 77c0fb936f47..e61b08566093 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -12,6 +12,7 @@
>   * by the Free Software Foundation.
>   */
>  
> +#include <crypto/hmac.h>
>  #include <crypto/md5.h>
>  #include <crypto/sha.h>
>  
> @@ -1164,8 +1165,8 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
>  	memcpy(opad, ipad, blocksize);
>  
>  	for (i = 0; i < blocksize; i++) {
> -		ipad[i] ^= 0x36;
> -		opad[i] ^= 0x5c;
> +		ipad[i] ^= HMAC_IPAD_VALUE;
> +		opad[i] ^= HMAC_OPAD_VALUE;
>  	}
>  
>  	return 0;
