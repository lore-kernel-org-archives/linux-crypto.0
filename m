From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue handling
Date: Thu, 5 Mar 2015 11:35:23 +0200
Message-ID: <54F8235B.5080301@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-6-git-send-email-mort@bork.org>
 <20150303182332.546523088b5891a776880c0f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Martin Hicks <mort@bork.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:44928
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767AbbCEJfh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 04:35:37 -0500
In-Reply-To: <20150303182332.546523088b5891a776880c0f@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/4/2015 2:23 AM, Kim Phillips wrote:
> On Tue,  3 Mar 2015 08:21:37 -0500
> Martin Hicks <mort@bork.org> wrote:
> 
>> @@ -1170,6 +1237,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>>  						     edesc->dma_len,
>>  						     DMA_BIDIRECTIONAL);
>>  	edesc->req.desc = &edesc->desc;
>> +	/* A copy of the crypto_async_request to use the crypto_queue backlog */
>> +	memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_request));
> 
> this seems backward, or, at least can be done more efficiently IMO:
> talitos_cra_init should set the tfm's reqsize so the rest of
> the driver can wholly embed its talitos_edesc (which should also
> wholly encapsulate its talitos_request (i.e., not via a pointer))
> into the crypto API's request handle allocation.  This
> would absorb and eliminate the talitos_edesc kmalloc and frees, the
> above memcpy, and replace the container_of after the
> crypto_dequeue_request with an offset_of, right?
> 
> When scatter-gather buffers are needed, we can assume a slower-path
> and make them do their own allocations, since their sizes vary
> depending on each request.  Of course, a pointer to those
> allocations would need to be retained somewhere in the request
> handle.

Unfortunately talitos_edesc structure size is most of the times
variable. Its exact size can only be established at "request time", and
not at "tfm init time".

Fixed size would be sizeof(talitos_edesc).
Below are factors that influence the variable part, i.e. link_tbl in
talitos_edesc:
- whether any assoc / src / dst data is scattered
- icv_stashing (case when ICV checking is done in SW)

Still we'd be better with:
-crypto API allocates request + request context (i.e.
sizeof(talitos_edesc) + any alignment required)
-talitos driver allocates variable part of talitos_edesc (if needed)

instead of:
-crypto API allocates request
-talitos driver allocates talitos_edesc (fixed + variable)
-memcopy of the req.base (crypto_async_request) into talitos_edesc

both in terms of performance and readability.

At first look, the driver wouldn't change that much:
-talitos_cra_init() callback would have to set tfm.reqsize to
sizeof(talitos_edesc) + padding and also add the CRYPTO_TFM_REQ_DMA
indication in tfm.crt_flags
-talitos_edesc_alloc() logic would be pretty much the same, but would
allocate memory only for the link_tbl

I'm willing to do these changes if needed.

> 
> Only potential problem is getting the crypto API to set the GFP_DMA
> flag in the allocation request, but presumably a
> CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.

Right. And this flag would apply only to request __ctx[].

Herbert, would this be an acceptable addition to crypto API?

Thanks,
Horia
