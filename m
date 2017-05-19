From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v2 9/9] crypto: ccp - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 15:32:09 -0500
Message-ID: <5f959f00-ca3b-0515-d743-33b251fb4b18@amd.com>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
 <20170519065331.27670-10-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org"
        <linux-mediatek@lists.infradead.org>,
        "qat-linux@intel.com" <qat-linux@intel.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "boris.brezillon@free-electrons.com"
        <boris.brezillon@free-electrons.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "giovanni.cabiddu@intel.com" <giovanni.cabiddu@intel.com>,
        "salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0042.outbound.protection.outlook.com ([104.47.34.42]:43405
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750943AbdESUcS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 16:32:18 -0400
In-Reply-To: <20170519065331.27670-10-clabbe.montjoie@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/19/2017 1:53 AM, Corentin Labbe wrote:
> This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
> define.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/ccp-crypto-sha.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c 
> b/drivers/crypto/ccp/ccp-crypto-sha.c
> index 6b46eea94932..ce97b3868f4a 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -18,6 +18,7 @@
>   #include <linux/crypto.h>
>   #include <crypto/algapi.h>
>   #include <crypto/hash.h>
> +#include <crypto/hmac.h>
>   #include <crypto/internal/hash.h>
>   #include <crypto/sha.h>
>   #include <crypto/scatterwalk.h>
> @@ -308,8 +309,8 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, 
> const u8 *key,
>           }
> 
>           for (i = 0; i < block_size; i++) {
> -               ctx->u.sha.ipad[i] = ctx->u.sha.key[i] ^ 0x36;
> -               ctx->u.sha.opad[i] = ctx->u.sha.key[i] ^ 0x5c;
> +               ctx->u.sha.ipad[i] = ctx->u.sha.key[i] ^ HMAC_IPAD_VALUE;
> +               ctx->u.sha.opad[i] = ctx->u.sha.key[i] ^ HMAC_OPAD_VALUE;
>           }
> 
>           sg_init_one(&ctx->u.sha.opad_sg, ctx->u.sha.opad, block_size);
> -- 
> 2.13.0
> 
