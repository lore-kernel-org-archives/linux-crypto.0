From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mediatek - Add empty messages check in GCM mode
Date: Tue, 22 Aug 2017 15:01:44 +0800
Message-ID: <20170822070144.GA5989@gondor.apana.org.au>
References: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Ryder Lee <ryder.lee@mediatek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38052 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754602AbdHVHCJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:02:09 -0400
Content-Disposition: inline
In-Reply-To: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 16, 2017 at 07:19:48PM +0800, Ryder Lee wrote:
> Currently, empty messages are not supported in GCM mode, hence add
> a check to prevent producing incorrect results.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  drivers/crypto/mediatek/mtk-aes.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
> index 9e845e8..efe4e63 100644
> --- a/drivers/crypto/mediatek/mtk-aes.c
> +++ b/drivers/crypto/mediatek/mtk-aes.c
> @@ -928,8 +928,13 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
>  static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
>  {
>  	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
> +	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
>  	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
>  
> +	/* Empty messages are not supported yet */
> +	if (!gctx->textlen && !req->assoclen)
> +		return -EINVAL

Your patch does not compile.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
