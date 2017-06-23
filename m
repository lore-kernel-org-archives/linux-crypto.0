From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH] crypto: brcm - software fallback for cryptlen zero
Date: Fri, 23 Jun 2017 14:04:15 +0530
Message-ID: <CAALAos_08725iw7o8KUn4GOaK=yzycPe=ic5Rnsa54M=+dejeQ@mail.gmail.com>
References: <1498206130-15188-1-git-send-email-raveendra.padasalagi@broadcom.com>
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
In-Reply-To: <1498206130-15188-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 23, 2017 at 1:52 PM, Raveendra Padasalagi
<raveendra.padasalagi@broadcom.com> wrote:
> Zero length payload requests are not handled in
> Broadcom SPU2 engine, so this patch adds conditional
> check to fallback to software implementation for AES-GCM
> and AES-CCM algorithms.
>
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> ---
>  drivers/crypto/bcm/cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index cc0d5b9..6c80863 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -2625,7 +2625,7 @@ static int aead_need_fallback(struct aead_request *req)
>          */
>         if (((ctx->cipher.mode == CIPHER_MODE_GCM) ||
>              (ctx->cipher.mode == CIPHER_MODE_CCM)) &&
> -           (req->assoclen == 0)) {
> +           ((req->assoclen == 0) || (req->cryptlen == 0))) {
>                 if ((rctx->is_encrypt && (req->cryptlen == 0)) ||
>                     (!rctx->is_encrypt && (req->cryptlen == ctx->digestsize))) {
>                         flow_log("AES GCM/CCM needs fallback for 0 len req\n");
> --
> 1.9.1
>

This should go in linux-stable too.

Please CC Linux stable and include "Fixes:".

Regards,
Anup
