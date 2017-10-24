From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v7 2/2] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 24 Oct 2017 13:27:43 +0200
Message-ID: <875af8c4-b2d5-2d24-962d-9e4db4652eee@partner.samsung.com>
References: <20171017112824.10231-1-k.konieczny@partner.samsung.com>
        <CGME20171017112846eucas1p17185d93eb5f837643c880357b3a8053b@eucas1p1.samsung.com>
        <20171017112824.10231-3-k.konieczny@partner.samsung.com>
        <f16aefe9-975b-e380-509e-452ed5333f11@mleia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vladimir Zapolskiy <vz@mleia.com>, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <f16aefe9-975b-e380-509e-452ed5333f11@mleia.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Vladimir,

Thank you for review, I will apply almost all of your remarks,
see answers below.

On 22.10.2017 12:18, Vladimir Zapolskiy wrote:
> Hi Kamil,
> 
> thank you for updates, I have just a few more comments.
> 
> On 10/17/2017 02:28 PM, Kamil Konieczny wrote:
>> [...]
>> - Select sw algorithms MD5, SHA1 and SHA256 in EXYNOS_HASH
>>   as they are nedded for fallback.
> 
> Typo, s/nedded/needed/

ok, Thank you for spotting this.

> [snip]
> 
>>  
>>  #include <linux/clk.h>
>>  #include <linux/crypto.h>
>> +#include <linux/delay.h>
> 
> I can not find which interfaces from linux/delay.h are needed.
> I suppose it should not be added.
> 
> [snip]

Yes, you are right, I will delete this 'include delay.h'

>> -static struct s5p_aes_dev *s5p_dev;
>> +/**
>> + * struct s5p_hash_reqctx - HASH request context
>> + * @dev:	Associated device
> 
> dev or dd?

dd

>> + * @op_update:	Current request operation (OP_UPDATE or OP_FINAL)
>> + * @digcnt:	Number of bytes processed by HW (without buffer[] ones)
>> + * @digest:	Digest message or IV for partial result
>> + * @nregs:	Number of HW registers for digest or IV read/write
>> + * @engine:	Bits for selecting type of HASH in SSS block
>> + * @sg:		sg for DMA transfer
>> + * @sg_len:	Length of sg for DMA transfer
>> + * @sgl[]:	sg for joining buffer and req->src scatterlist
>> + * @skip:	Skip offset in req->src for current op
>> + * @total:	Total number of bytes for current request
>> + * @finup:	Keep state for finup or final.
>> + * @error:	Keep track of error.
>> + * @bufcnt:	Number of bytes holded in buffer[]
>> + * @buffer[]:	For byte(s) from end of req->src in UPDATE op
>> + */
>> +struct s5p_hash_reqctx {
>> +	struct s5p_aes_dev	*dd;
>> +	bool			op_update;
>> +
> 
> [snip]
> 
>> +
>> +/**
>> + * s5p_hash_shash_digest() - calculate shash digest
>> + * @tfm:	crypto transformation
>> + * @flags:	tfm flags
>> + * @data:	input data
>> + * @len:	length of data
>> + * @out:	output buffer
>> + */
>> +static int s5p_hash_shash_digest(struct crypto_shash *tfm, u32 flags,
>> +				 const u8 *data, unsigned int len, u8 *out)
>> +{
>> +	SHASH_DESC_ON_STACK(shash, tfm);
> 
> Just for information, this line produces a spatch warning:
> 
>   drivers/crypto/s5p-sss.c:1534:9: warning: Variable length array is used.
> 
> I think it can be ignored.

I also think it can be ignored, it uses 104 bytes on stack in case of SHA256 ,
sizeof struct sha256_state for SW generic implementation, found in 
include/crypto/sha.h
 
>> +
>> +	shash->tfm = tfm;
>> +	shash->flags = flags & ~CRYPTO_TFM_REQ_MAY_SLEEP;
>> +
>> +	return crypto_shash_digest(shash, data, len, out);
>> +}
>> +
> 
> [snip]
> 
>> +/**
>> + * s5p_hash_final() - close up hash and calculate digest
>> + * @req:	AHASH request
>> + *
>> + * Note: in final req->src do not have any data, and req->nbytes can be
>> + * non-zero.
>> + *
>> + * If there were no input data processed yet and the buffered hash data is
>> + * less than BUFLEN (64) then calculate the final hash immediately by using
>> + * SW algorithm fallback.
>> + *
>> + * Otherwise enqueues the current AHASH request with OP_FINAL operation op
>> + * and finalize hash message in HW. Note that if digcnt!=0 then there were
>> + * previous update op, so there are always some buffered bytes in ctx->buffer,
>> + * which means that ctx->bufcnt!=0
>> + *
>> + * Returns:
>> + * 0 if the request has been processed immediately,
>> + * -EINPROGRESS if the operation has been queued for later execution or is set
>> + *		to processing by HW,
>> + * -EBUSY if queue is full and request should be resubmitted later, other
>> + *		negative values on error.
> 
> Do you want to add -EINVAL into the list also?

Here I made bad formatting, it should read:

* -EBUSY if queue is full and request should be resubmitted later,
* other	negative values on error.

I do not want to specify explicitly all error negative codes here, as it also uses
s5p_hash_enqueue and these return codes are referenced from other places. I intended
to listing success values, 0, -EINPROGRESS, then explaining -EBUSY, then adding all
other negative as error. The other values can be -EINVAL, -ENOMEM or maybe other, when
this module gets extended to HMAC implementation.

>> + */
>> +static int s5p_hash_final(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +
>> +	ctx->finup = true;
>> +	if (ctx->error)
>> +		return -EINVAL; /* uncompleted hash is not needed */
>> +
>> +	if (!ctx->digcnt && ctx->bufcnt < BUFLEN)
>> +		return s5p_hash_final_shash(req);
>> +
>> +	return s5p_hash_enqueue(req, false); /* HASH_OP_FINAL */
>> +}
>> +
> 
> [snip]
> 
>> +/**
>> + * s5p_hash_finup() - process last req->src and calculate digest
>> + * @req:	AHASH request containing the last update data
>> + *
>> + * Return values: see s5p_hash_final above.
>> + */
>> +static int s5p_hash_finup(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	int err1, err2;
>> +
>> +	ctx->finup = true;
>> +
>> +	err1 = s5p_hash_update(req);
>> +	if (err1 == -EINPROGRESS || err1 == -EBUSY)
>> +		return err1;
>> +
>> +	/*
>> +	 * final() has to be always called to cleanup resources even if
>> +	 * update() failed, except EINPROGRESS or calculate digest for small
>> +	 * size
>> +	 */
>> +	err2 = s5p_hash_final(req);
>> +
>> +	return err1 ?: err2;
> 
> See a note below.
> 
> [snip]
> 
>> +/**
>> + * s5p_hash_digest - calculate digest from req->src
>> + * @req:	AHASH request
>> + *
>> + * Return values: see s5p_hash_final above.
>> + */
>> +static int s5p_hash_digest(struct ahash_request *req)
>> +{
>> +	return s5p_hash_init(req) ?: s5p_hash_finup(req);
> 
> Now I got it, this ?: notation is invalid according to C99 and thus it
> confused me, but GCC has an extension to support it, so, it's up to you
> if you leave it as is or change it to comply with C99. If it ever causes
> any troubles, it'll be easy to fix, and I'm fine if you leave it as is,
> because it is understandable to GCC.
> 
> [snip]

I agree and I prefer to keep it in current shape, this patch is already big.

>> +/**
>> + * s5p_hash_import - import hash state
>> + * @req:	AHASH request
>> + * @in:		buffer with state to be imported from
>> + */
>> +static int s5p_hash_import(struct ahash_request *req, const void *in)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> +	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
>> +	const struct s5p_hash_reqctx *ctx_in = in;
>> +
>> +	memcpy(ctx, in, sizeof(*ctx) + BUFLEN);
>> +	if (ctx_in->bufcnt < 0 || ctx_in->bufcnt > BUFLEN) {
> 
> Now "ctx_in->bufcnt < 0" condition can be removed, moreover it
> will eliminate a warning reproted by the compiler:
> 
> drivers/crypto/s5p-sss.c:1748:21: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>   if (ctx_in->bufcnt < 0 || ctx_in->bufcnt > BUFLEN) {
>                      ^

You are right, I will drop first condition. BTW what compiler options are you using ?
This one was not reported by my compilation process.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
