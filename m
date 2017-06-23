From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH] crypto: brcm - Fix SHA3-512 algorithm failure
Date: Fri, 23 Jun 2017 14:03:56 +0530
Message-ID: <CAALAos8RaUGJWhh1wbi-Spteck2zOptV_FhZscWCh+8MV3cLNg@mail.gmail.com>
References: <1498200347-14580-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        linux-crypto@vger.kernel.org,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498200347-14580-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 23, 2017 at 12:15 PM, Raveendra Padasalagi
<raveendra.padasalagi@broadcom.com> wrote:
> In Broadcom SPU driver, due to missing break statement
> in spu2_hash_xlate() while mapping SPU2 equivalent
> SHA3-512 value, -EINVAL is chosen and hence leading to
> failure of SHA3-512 algorithm. This patch fixes the same.
>
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> ---
>  drivers/crypto/bcm/spu2.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
> index ef04c97..bf7ac62 100644
> --- a/drivers/crypto/bcm/spu2.c
> +++ b/drivers/crypto/bcm/spu2.c
> @@ -302,6 +302,7 @@ static int spu2_hash_mode_xlate(enum hash_mode hash_mode,
>                 break;
>         case HASH_ALG_SHA3_512:
>                 *spu2_type = SPU2_HASH_TYPE_SHA3_512;
> +               break;
>         case HASH_ALG_LAST:
>         default:
>                 err = -EINVAL;
> --
> 1.9.1
>

This should go in linux-stable too.

Please CC Linux stable and include "Fixes:".

Regards,
Anup
