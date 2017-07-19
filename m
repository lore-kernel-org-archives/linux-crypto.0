From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Tue, 18 Jul 2017 17:52:34 -0700
Message-ID: <da15ba80-a3b1-0d79-47ea-5528c0d12b20@linux.intel.com>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
 <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
 <20170718054142.GA4764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, megha.dey@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:20034 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbdGSAwf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 20:52:35 -0400
In-Reply-To: <20170718054142.GA4764@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/17/2017 10:41 PM, Herbert Xu wrote:
> On Tue, Jun 27, 2017 at 05:26:13PM -0700, Megha Dey wrote:
>>
>> +static void completion_callback(struct mcryptd_skcipher_request_ctx *rctx,
>> +			    struct mcryptd_alg_cstate *cstate,
>> +			    int err)
>> +{
>> +	struct skcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
>> +
>> +       /* remove from work list and invoke completion callback */
>> +	spin_lock(&cstate->work_lock);
>> +	list_del(&rctx->waiter);
>> +	spin_unlock(&cstate->work_lock);
>> +
>> +	if (irqs_disabled())
>> +		rctx->complete(&req->base, err);
>> +	else {
>> +		local_bh_disable();
>> +		rctx->complete(&req->base, err);
>> +		local_bh_enable();
>> +	}
>> +}
> 
> The fact that you need to do this check means that this design is
> wrong.  You should always know what context you are in.
> 

I think you are right.  The irqs_disabled check is not necessary
as we only call this function in the context of the mcryptd thread.
When I wrote the original mb algorithms I was probably unsure
and put this check in as a precaution in other mb algorithms and
Megha did the same.

>> +/*
>> + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
>> + * scatter-gather walk.
>> + */
>> +static struct skcipher_alg aes_cbc_mb_alg = {
>> +	.base = {
>> +		.cra_name		= "cbc(aes)",
>> +		.cra_driver_name	= "cbc-aes-aesni-mb",
>> +		.cra_priority		= 500,
>> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
>> +		.cra_blocksize		= AES_BLOCK_SIZE,
>> +		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
>> +		.cra_module		= THIS_MODULE,
>> +	},
>> +	.min_keysize	= AES_MIN_KEY_SIZE,
>> +	.max_keysize	= AES_MAX_KEY_SIZE,
>> +	.ivsize		= AES_BLOCK_SIZE,
>> +	.setkey		= aes_set_key,
>> +	.encrypt	= mb_aes_cbc_encrypt,
>> +	.decrypt	= mb_aes_cbc_decrypt
>> +};
> 
> So this claims to be a sync algorithm.  Is this really the case?
> 
> Cheers,
> 
