From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 2/2] crypto: algif - change algif_skcipher to be asynchronous
Date: Tue, 10 Mar 2015 11:26:22 -0700
Message-ID: <54FF374E.4020809@intel.com>
References: <20150309205514.9648.701.stgit@tstruk-mobl1> <20150309205525.9648.96093.stgit@tstruk-mobl1> <26409073.mC6eRvfGxi@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbbCJS3V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 14:29:21 -0400
In-Reply-To: <26409073.mC6eRvfGxi@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 03/10/2015 12:41 AM, Stephan Mueller wrote:
>> +#define GET_SREQ(areq, ctx) (struct skcipher_async_req *)((char *)areq
>> >+ \ +	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req)))
>> >+
>> >+#define GET_REQ_SIZE(ctx) \
>> >+	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req))
>> >+
>> >+#define GET_IV_SIZE(ctx) \
>> >+	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(&ctx->req))
> Wouldn't be an inline function better?

This is rather an ideological question ;)

>> +	INIT_LIST_HEAD(&sreq->list);
>> >+	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
> Why do you use kcalloc here and not kmalloc (why is there a memset 
> needed considering that sg_init_table is called?
> 

This is not only because of the list, but also because of the af_alg_sgl and scatterlists inside the skcipher_async_rsgl struct
I will need to zero them all anyway so it's easier to just use kcalloc().

>> +		if (i == tx_nents) {
>> >+			struct scatterlist *tmp;
>> >+			int x;
>> >+			/* Ran out of tx slots in async request
>> >+			 * need to expand */
>> >+			tmp = kcalloc(tx_nents * 2, sizeof(*tmp),
>> >+				      GFP_KERNEL);
> Why is the memory increased by a factor of two?

The scenario here is as follows - one has written some amount of data, say 64 bytes. We have built an src sgl in skcipher_sendpage() or skcipher_sendmsg(), and now one is calling aio_read(), which triggers the skcipher_recvmsg_async(), and wants to read let's say 128 bytes. We process the first 64 bytes, and by process I mean we put it to the async req, and we get block on:
if (!ctx->used)
	skcipher_wait_for_data(sk, flags);

Then the user writes more data, form a separate thread, and we proceed farther, but because we have only allocated just enough sgl space for the first 64 bytes of src data in the async request, we need to allocate more now. We don't know how much data has been requested in the aio_read() until we reach the end of the iov_iter, so we just want to make it big enough.

> 
> Could you please point me to the logic that limits the allocation to 
> prevent user space eating up kernel memory?

To submit an aio read request you need to provide a valid ptr & size or a valid iov vector. This is validated in fs/aio.c
This becomes the encryption destination buffer.
The src buffer for encryption is built in sendmsg()/sendpage() functions.
These are processed and freed every time the skcipher_recvmsg_async() is called or in the skcipher_async_cb().

> 
> Same as above: Why do you use kcalloc here and not kmalloc (why is there 
> a memset needed considering that sg_init_table is called?
> 

Same as above i.e. because of the af_alg_sgl and scatterlists inside the skcipher_async_rsgl struct.

>> >+			if (!tmp)
>> >+				goto free;
>> >+
>> >+			sg_init_table(tmp, tx_nents * 2);
>> >+			for (x = 0; x < tx_nents; x++)
>> >+				sg_set_page(&tmp[x], sg_page(&sreq-
>> >tsg[x]),
>> >+					    sreq->tsg[x].length,
>> >+					    sreq->tsg[x].offset);
>> >+			kfree(sreq->tsg);
> It seems I miss a point here, but the code is freeing the existing sreg-
>> >tsg scatterlist just to replace it with the scatterlist that is twice 
> as big. The kernel had to fill the scatterlist that is twice as big with 
> seemingly the same data we already filled our list with (according to 
> the sg_set_page call below).
> 
> If I understand that right, isn't that unnecessary work? Why not just 
> allocate just one chunk of memory for a scatterlist holding the new 
> data, fill it and chain it with the existing scatterlist?
> 

That's a valid point, but as I said, the situation is that someone supplied X bytes of plain text for encryption, and tried to read/encrypt Y bytes where Y > X.
At this point we don't know how big the Y is so, we can loop through the whole iov_iter allocating new sgls and linking them together,
or just allocate "big enough" buffer once and try to proceed until this new buffer runs out.
Keep in mind that this situation only occurs when one tries to read more than has been written, followed by a subsequent write that supplies more data.
This whole situation is far from optimal.

>> +		if (list_empty(&sreq->list)) {
>> >+			rsgl = &sreq->first_sgl;
>> >+			list_add_tail(&rsgl->list, &sreq->list);
>> >+		} else {
>> >+			rsgl = kzalloc(sizeof(*rsgl), GFP_KERNEL);
> Why is kzalloc called? Shouldn't kmalloc suffice?
> 

You are correct, in this case it will be better to use kmalloc. af_alg_make_sg() does all the initialization.

>> +	err = ctx->enc ? crypto_ablkcipher_encrypt(req) :
>> >+			 crypto_ablkcipher_decrypt(req);
>> >+	if (err == -EINPROGRESS) {
>> >+		atomic_inc(&ctx->inflight);
>> >+		err = -EIOCBQUEUED;
>> >+		goto unlock;
>> >+	}
> To avoid races, shouldn't the atomic_inc of inflight happen before the 
> encryption / decryption call?
> 

We only increase it when the request has been enqueued to be processed asynchronously, and decrease it in the asynch callback, which is safe.
Incrementing it before will require an else block here that will just decrement it for any other case and that is an overhead.
Also using atomic type guarantees that there will not be any race conditions.

>> +	while (atomic_read(&ctx->inflight) && ctr++ < 100)
>> >+		msleep(100);
> What is the reason for taking 100? Why not 50 or 200?

This is an arbitrary value. We want to wait for any outstanding request before we close the socket.
We don't want to wait too long, but we also want to make sure that we do get all responses back.
At this point there should be no outstanding requests really, but if there are any we will wait between 100ms and 10 sec, which should cater for all cases.

Thanks for taking the time to review my patch and for all your feedback.
I'll send a v3 that uses kmalloc instead of kzalloc to allocate the rsgl.
Regards,
Tadeusz
