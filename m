From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH] crypto: ecdh: fix concurrency on ecdh_ctx
Date: Wed, 28 Jun 2017 14:20:18 +0300
Message-ID: <6d6b2a32-6801-5f8a-c373-1e85ae708620@microchip.com>
References: <1498129433-6874-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:47446 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdF1LUV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 07:20:21 -0400
In-Reply-To: <1498129433-6874-1-git-send-email-tudor.ambarus@microchip.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 22.06.2017 14:03, Tudor Ambarus wrote:
> ecdh_ctx contained static allocated data for the shared secret,
> for the public and private key.
> 
> When talking about shared secret and public key, they were
> doomed to concurrency issues because they could be shared by
> multiple crypto requests. The requests were generating specific
> data to the same zone of memory without any protection.
> 
> The private key was subject to concurrency problems because
> multiple setkey calls could fight to memcpy to the same zone
> of memory.
> 
> Shared secret and public key concurrency is fixed by allocating
> memory on heap for each request. In the end, the shared secret
> and public key are computed for each request, there is no reason
> to use shared memory.
> 
> Private key concurrency is fixed by allocating memory on heap
> for each setkey call, by memcopying the parsed/generated private
> key to the heap and by making the private key pointer from
> ecdh_ctx to point to the newly allocated data.
> 
> On all systems running Linux, loads from and stores to pointers
> are atomic, that is, if a store to a pointer occurs at the same
> time as a load from that same pointer, the load will return either
> the initial value or the value stored, never some bitwise mashup
> of the two.
> 
> With this, the private key will always point to a valid key,
> but to what setkey call it belongs, is the responsibility of the
> caller, as it is now in all crypto framework.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>   crypto/ecc.h  |  2 --
>   crypto/ecdh.c | 93 ++++++++++++++++++++++++++++++++++++++++++-----------------
>   2 files changed, 67 insertions(+), 28 deletions(-)
> 
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index e4fd449..b35855b 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -26,8 +26,6 @@
>   #ifndef _CRYPTO_ECC_H
>   #define _CRYPTO_ECC_H
>   
> -#define ECC_MAX_DIGITS	4 /* 256 */
> -
>   #define ECC_DIGITS_TO_BYTES_SHIFT 3
>   
>   /**
> diff --git a/crypto/ecdh.c b/crypto/ecdh.c
> index 61c7708..30d954d 100644
> --- a/crypto/ecdh.c
> +++ b/crypto/ecdh.c
> @@ -19,9 +19,7 @@
>   struct ecdh_ctx {
>   	unsigned int curve_id;
>   	unsigned int ndigits;
> -	u64 private_key[ECC_MAX_DIGITS];
> -	u64 public_key[2 * ECC_MAX_DIGITS];
> -	u64 shared_secret[ECC_MAX_DIGITS];
> +	const u64 *private_key;
>   };
>   
>   static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
> @@ -38,13 +36,31 @@ static unsigned int ecdh_supported_curve(unsigned int curve_id)
>   	}
>   }
>   
> +static int ecdh_gen_privkey(struct ecdh_ctx *ctx, u64 *private_key)
> +{
> +	int ret;
> +
> +	ret = ecc_gen_privkey(ctx->curve_id, ctx->ndigits, private_key);
> +	if (ret) {
> +		kzfree(private_key);

It's ugly to free a pointer that I received as a function argument.
I'll get rid of this function.

> +		return ret;
> +	}
> +
> +	ctx->private_key = private_key;
> +	return 0;
> +}
> +
>   static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
>   			   unsigned int len)
>   {
>   	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
> +	u64 *private_key;
>   	struct ecdh params;
>   	unsigned int ndigits;
>   
> +	/* clear the old private key, if any */
> +	kzfree(ctx->private_key);
> +
>   	if (crypto_ecdh_decode_key(buf, len, &params) < 0)
>   		return -EINVAL;
>   
> @@ -52,59 +68,82 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
>   	if (!ndigits)
>   		return -EINVAL;
>   
> +	private_key = kzalloc(ndigits << ECC_DIGITS_TO_BYTES_SHIFT, GFP_KERNEL);

kmalloc should suffice.

> +	if (!private_key)
> +		return -ENOMEM;
> +
>   	ctx->curve_id = params.curve_id;
>   	ctx->ndigits = ndigits;
>   
>   	if (!params.key || !params.key_size)
> -		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
> -				       ctx->private_key);
> +		return ecdh_gen_privkey(ctx, private_key);
>   
>   	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> -			     (const u64 *)params.key, params.key_size) < 0)
> +			     (const u64 *)params.key, params.key_size) < 0) {
> +		kzfree(private_key);
>   		return -EINVAL;
> +	}
>   
> -	memcpy(ctx->private_key, params.key, params.key_size);
> +	memcpy(private_key, params.key, params.key_size);
> +	ctx->private_key = private_key;
>   
>   	return 0;
>   }
>   
>   static int ecdh_compute_value(struct kpp_request *req)
>   {
> -	int ret = 0;
>   	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
>   	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
> -	size_t copied, nbytes;
> +	u64 *public_key;
> +	u64 *shared_secret = NULL;
> +	size_t copied, nbytes, public_key_sz;
>   	void *buf;
> +	int ret = -ENOMEM;
>   
>   	nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
> +	/* Public part is a point thus it has both coordinates */
> +	public_key_sz = 2 * nbytes;
> +
> +	public_key = kmalloc(public_key_sz, GFP_KERNEL);

It's wrong to assume that I can sleep while processing a request.
I will use the gfp_t flags from request.

> +	if (!public_key)
> +		return -ENOMEM;
>   
>   	if (req->src) {
> -		copied = sg_copy_to_buffer(req->src, 1, ctx->public_key,
> -					   2 * nbytes);
> -		if (copied != 2 * nbytes)
> -			return -EINVAL;
> +		shared_secret = kmalloc(nbytes, GFP_KERNEL);

same here

> +		if (!shared_secret)
> +			goto free_pubkey;
> +
> +		copied = sg_copy_to_buffer(req->src, 1, public_key,
> +					   public_key_sz);
> +		if (copied != public_key_sz) {
> +			ret = -EINVAL;
> +			goto free_all;
> +		}
>   
>   		ret = crypto_ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
> -						ctx->private_key,
> -						ctx->public_key,
> -						ctx->shared_secret);
> +						ctx->private_key, public_key,
> +						shared_secret);
>

While this comment has nothing to do with this patch, I see that
crypto_ecdh_shared_secret ends up in calling ecc_alloc_digits_space,
which allocates memory with GFP_KERNEL. I will make a patch to fix
that too.

ta
