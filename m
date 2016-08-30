From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 4/4] crypto: qce: If total text size is zero, return
 pre-computed digest
Date: Tue, 30 Aug 2016 18:02:42 +0200
Message-ID: <7f71762d-f570-e4d4-723c-fc2dc821ab6e@gmail.com>
References: <20160830155353.19500-1-voker57@gmail.com>
 <20160830155353.19500-5-voker57@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
To: Iaroslav Gridin <voker57@gmail.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33984 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755847AbcH3QCq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2016 12:02:46 -0400
In-Reply-To: <20160830155353.19500-5-voker57@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30/08/2016 17:53, Iaroslav Gridin wrote:
> From: Voker57 <voker57@gmail.com>
> 
> If total data amount to hash is zero, we cannot submit it to QCE,
> since it locks up on zero-sized updates. So, return pre-computed
> SHA256/SHA1 hash.
> Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
> ---
>  drivers/crypto/qce/sha.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index f199f28..c627b5d 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -80,6 +80,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
>  	struct qce_sha_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
>  	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
>  	struct qce_device *qce = tmpl->qce;
> +	unsigned int digestsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
>  	unsigned long flags = rctx->flags;
>  	int ret;
>  
> @@ -91,6 +92,29 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
>  		rctx->authklen = AES_KEYSIZE_128;
>  	}
>  
> +	if (!req->nbytes) {
> +		/* Only way that can happen is if total size of digest is zero
> +		 * So since QCE gets stuck on zero-sized texts, we return
> +		 * pre-calculated hash
> +		 */
> +		if (digestsize == SHA1_DIGEST_SIZE) {
> +			memcpy(rctx->digest,
> +			       "\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09",
> +			       SHA1_DIGEST_SIZE);
> +		} else if (digestsize == SHA256_DIGEST_SIZE) {
> +			memcpy(rctx->digest,
> +			       "\xe3\xb0\xc4\x42\x98\xfc\x1c\x14\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24\x27\xae\x41\xe4\x64\x9b\x93\x4c\xa4\x95\x99\x1b\x78\x52\xb8\x55",
> +			       SHA256_DIGEST_SIZE);

Hello

You could use sha1_zero_message_hash/sha256_zero_message_hash declared in crypto/sha.h

Regards
