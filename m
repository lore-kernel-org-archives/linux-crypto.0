From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Mon, 18 Jan 2016 07:22:55 -0800
Message-ID: <569D034F.5090905@gmail.com>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
 <1641011.7xuR0fALWB@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34078 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbcARPXF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:23:05 -0500
In-Reply-To: <1641011.7xuR0fALWB@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 01/17/2016 07:07 AM, Stephan Mueller wrote:
>> +static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
>> > +			      int flags)
>> > +{
>> > +	struct sock *sk = sock->sk;
>> > +	struct alg_sock *ask = alg_sk(sk);
>> > +	struct aead_ctx *ctx = ask->private;
>> > +	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
>> > +	struct aead_async_req *areq;
>> > +	struct aead_request *req = NULL;
>> > +	struct aead_sg_list *sgl = &ctx->tsgl;
>> > +	unsigned int as = crypto_aead_authsize(tfm);
>> > +	unsigned int reqlen = sizeof(*areq) + crypto_aead_reqsize(tfm) +
>> > +				crypto_aead_ivsize(tfm);
>> > +	int err = -ENOMEM, i;
>> > +	unsigned long used;
>> > +	size_t outlen;
>> > +	size_t usedpages = 0;
>> > +	unsigned int cnt = 0;
>> > +
>> > +	/* Limit number of IOV blocks to be accessed below */
>> > +	if (msg->msg_iter.nr_segs > RSGL_MAX_ENTRIES)
>> > +		return -ENOMSG;
>> > +
>> > +	lock_sock(sk);
>> > +
>> > +	if (ctx->more) {
>> > +		err = aead_wait_for_data(sk, flags);
>> > +		if (err)
>> > +			goto unlock;
>> > +	}
>> > +
>> > +	used = ctx->used;
>> > +	outlen = used;
>> > +
>> > +	if (!aead_sufficient_data(ctx))
>> > +		goto unlock;
>> > +
>> > +	req = kmalloc(reqlen, GFP_KERNEL);
> Shouldn't that be sock_kmalloc? If yes, we also need to use sock_kfree_s 
> above.

My understanding is that the sock_kmalloc is mainly used for allocations
of the user provided  data, because it keeps tracks of how much memory
is allocated by a socket, and makes sure that is will not exceed the
sysctl_optmem_max limit. Usually the internal structures, with fixed
size are allocated simply with kmalloc. I don't think that using
sock_kmalloc will give us any benefit here.

> 
>> +static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t
>> > ignored, +			int flags)
>> > +{
>> > +	return (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) ?
>> > +		aead_recvmsg_async(sock, msg, flags) :
>> > +		aead_recvmsg_sync(sock, msg, flags);
>> > +}
> The code in the aead_recvmsg_sync and _async is very very similar with the 
> exception of the areq handling.
> 
> What I am wondering, is it possible to consolidate both into one, considering 
> that the real difference according to my understanding is the 
> af_alg_wait_for_completion usage (in _sync) vs. the use of a self-written 
> callback (_async)?
> 

I agree that they are very similar, but I found it much easier to debug
when they are separate functions. I would prefer to keep them separate.
They are also separate in algif_skcipher. It makes it also easier to
read and understand.

>> +static void aead_wait(struct sock *sk)
>> > +{
>> > +	struct alg_sock *ask = alg_sk(sk);
>> > +	struct aead_ctx *ctx = ask->private;
>> > +	int ctr = 0;
>> > +
>> > +	while (atomic_read(&ctx->inflight) && ctr++ < 100)
>> > +		msleep(100);
> I know that same logic is applied to algif_skcipher. But isn't that a kind of 
> uninterruptible sleep? Do you see the potential that a process cannot 
> terminate the socket? For example, if a process makes the error of sending 
> asynchronously data to the kernel, but "forgets" all necessary recvmsg calls 
> and we do not decrease the inflight any more. In this case, wouldn't a kill -9 
> of that hanging process leave a zombie or not work at all?
> 

The inflight ctr is incremented only if an asynchronous request has been
successfully en-queued for processing. If a user forges to call recvmsg
then the function that increments it won't be even called.
>From the other hand we don't want to give the option to interrupt the
wait, because in a case, when we do have request being processed by some
hardware, and the user kills the process, causing the socket to be
freed, then we will get an Oops in the callback.
Thanks,

--
TS
