From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: [RFC 1/2] SPU-AES support (kernel side)
Date: Thu, 12 Jul 2007 09:37:16 +0200
Message-ID: <20070712073716.GB23840@Chamillionaire.breakpoint.cc>
References: <20070626230027.GA4581@Chamillionaire.breakpoint.cc> <20070712043613.GC18292@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35059 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbXGLHhS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2007 03:37:18 -0400
Content-Disposition: inline
In-Reply-To: <20070712043613.GC18292@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-07-12 12:36:13 [+0800]:

>On Wed, Jun 27, 2007 at 01:00:27AM +0200, Sebastian Siewior wrote:
>>
>> +static int enqueue_request(struct ablkcipher_request *req,
>> +		enum SPU_FUNCTIONS op_type)
>> +{
>> +	struct async_d_request *asy_d_ctx = ablkcipher_request_ctx(req);
>> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>> +	struct aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>> +	struct kspu_work_item *work = &asy_d_ctx->kspu_work;
>> +
>> +	asy_d_ctx->crypto_operation = op_type;
>> +	asy_d_ctx->progress = 0;
>> +	work->enqueue = aes_queue_work_items;
>> +
>> +	kspu_enqueue_work_item(ctx->spe_ctx->ctx, &asy_d_ctx->kspu_work);
>
>OK this is a software queue so we want to put a limit on it.
Limit means you want me to drop requests after a certain limit (i.e.
when my queue is full)?

>In fact, any reason why you couldn't juse use the existing
>crypto_enqueue_request interface here? That would also make
>that cast function unnecessary.
I would have to start an extra thread that removes requests from
crypto_enqueue_request and enqueues them into kspu_enqueue_work_item.
The later may be used not just for crypto requests but for all KSPU
users. I can't enqueue directly on the SPU in the first place because
this requires to hold a mutex (and then I need an endless queue for the
CRYPTO_TFM_REQ_MAY_BACKLOG requests anyway).

>
>Cheers,
>-- 

Cheers
Sebastian
