From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUGFIX PATCH] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 09:47:07 +0200
Message-ID: <5180851.2L9GoHaKL8@tauon.chronox.de>
References: <1503474071-7049-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503474071-7049-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 23. August 2017, 09:41:11 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> 
>  	if (areq) {
> +		/*
> +		 * The crypto API expects us to set the req->info to the last
> +		 * ciphertext block. For encrypt, simply copy from the result.
> +		 * For decrypt, we must copy from a saved buffer since this
> +		 * could be an in-place decryption operation and the src is
> +		 * lost by this point.
> +		 */
> +		if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
> +			memcpy(req->info, req_ctx->backup_info, ivsize);
> +			kfree(req_ctx->backup_info);
> +		} else {
> +			scatterwalk_map_and_copy(req->info, req->dst,
> +						 (req->nbytes - ivsize),
> +						 ivsize, 0);
> +		}
> +
>  		ablkcipher_request_complete(areq, completion_error);
>  		return 0;
>  	}
> @@ -858,7 +876,6 @@ static int ssi_ablkcipher_encrypt(struct
> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
> ablkcipher_request_ctx(req); unsigned int ivsize =
> crypto_ablkcipher_ivsize(ablk_tfm);
> 
> -	req_ctx->backup_info = req->info;
>  	req_ctx->is_giv = false;
> 
>  	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
> req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
> @@ -871,8 +888,18 @@ static int ssi_ablkcipher_decrypt(struct
> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
> ablkcipher_request_ctx(req); unsigned int ivsize =
> crypto_ablkcipher_ivsize(ablk_tfm);
> 
> -	req_ctx->backup_info = req->info;
> +	/*
> +	 * Allocate and save the last IV sized bytes of the source, which will
> +	 * be lost in case of in-place decryption and might be needed for CTS.
> +	 */
> +	req_ctx->backup_info = kmalloc(ivsize, GFP_KERNEL);
> +	if (!req_ctx->backup_info)
> +		return -ENOMEM;

Are you sure you do not add a memleak here? You seem to unconditionally 
allocate memory but conditionally free it.

Ciao
Stephan
