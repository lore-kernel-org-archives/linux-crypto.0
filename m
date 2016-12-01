From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v4 1/1] crypto: add virtio-crypto driver
Date: Thu, 1 Dec 2016 12:23:46 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA14FBD6@DGGEMA505-MBX.china.huawei.com>
References: <1480423694-41736-1-git-send-email-arei.gonglei@huawei.com>
 <1480423694-41736-2-git-send-email-arei.gonglei@huawei.com>
 <20161130110932.GC2497@stefanha-x1.localdomain>
 <33183CC9F5247A488A2544077AF19020DA14EC02@DGGEMA505-MBX.china.huawei.com>
 <20161201115810.GC10441@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@h
To: Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg03-dlp ([45.249.212.189]:2428 "EHLO dggrg03-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752609AbcLAM2O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 07:28:14 -0500
In-Reply-To: <20161201115810.GC10441@stefanha-x1.localdomain>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> Subject: Re: [PATCH v4 1/1] crypto: add virtio-crypto driver
> 
> On Thu, Dec 01, 2016 at 02:27:19AM +0000, Gonglei (Arei) wrote:
> > > On Tue, Nov 29, 2016 at 08:48:14PM +0800, Gonglei wrote:
> > > > +static int virtio_crypto_alg_ablkcipher_init_session(
> > > > +		struct virtio_crypto_ablkcipher_ctx *ctx,
> > > > +		uint32_t alg, const uint8_t *key,
> > > > +		unsigned int keylen,
> > > > +		int encrypt)
> > > > +{
> > > > +	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
> > > > +	unsigned int tmp;
> > > > +	struct virtio_crypto *vcrypto = ctx->vcrypto;
> > > > +	int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT :
> > > VIRTIO_CRYPTO_OP_DECRYPT;
> > > > +	int err;
> > > > +	unsigned int num_out = 0, num_in = 0;
> > > > +
> > > > +	/*
> > > > +	 * Avoid to do DMA from the stack, switch to using
> > > > +	 * dynamically-allocated for the key
> > > > +	 */
> > > > +	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
> > > > +
> > > > +	if (!cipher_key)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	memcpy(cipher_key, key, keylen);
> > >
> > > Are there any rules on handling key material in the kernel?  This buffer
> > > is just kfreed later.  Do you need to zero it out before freeing it?
> > >
> > Good questions. For kernel crypto core, each cipher request should be freed
> > by skcipher_request_free(): zeroize and free request data structure.
> >
> > I need to use kzfree() for key as well. I'll also check other stuffs. Thanks.
> >
> > > > +
> > > > +	spin_lock(&vcrypto->ctrl_lock);
> > >
> > > The QAT accelerator driver doesn't spin while talking to the device in
> > > virtio_crypto_alg_ablkcipher_init_session().  I didn't find any other
> > > driver examples in the kernel tree, but this function seems like a
> > > weakness in the virtio-crypto device.
> > >
> > The control queues of virtio-net and virtio-console are also be locked
> > Please see:
> >  __send_control_msg() in virtio_console.c and virtio-net's control queue
> > protected by rtnl lock.
> >
> > I didn't want to protect session creations but the virtqueue's operations
> > like what other virtio devices do.
> >
> > > While QEMU is servicing the create session command this vcpu is blocked.
> > > The QEMU global mutex is held so no other vcpu can enter QEMU and the
> > > QMP monitor is also blocked.
> > >
> > > This is a scalability and performance problem.  Can you look at how QAT
> > > avoids this synchronous session setup?
> >
> > For QAT driver, the session creation is synchronous as well because it's a
> > plain software operation which can be completed ASAP.
> 
> I'm mentioning the vmexit and wait for request completion in a spinlock
> because the same type of issue has been a performance bottleneck with
> virtio guest driver in the past.
> 
> If there is a way to avoid spinning then that would be preferred.  It's
> basically a known anti-pattern for virtio guest drivers.
> 
Oh, sorry for my misunderstanding. ;)

> Could you initialize the session on the host side when the first
> asynchronous data is submitted for encryption/decryption instead of
> during init_session()?
> 
I remember I discuss this problem with Alex two/three moths
ago. In some scenarios, its indeed a performance problem, such as each request has
different algorithms or keys in HTTP connections. It's performance will be better
if we just use one data virtqueue to pass session and data to the backend at one time.

But for the batch cipher operations with the same algorithm, the performance is poor,
Because we can't do batch operations for those requests. That's the great function
of session operations on the control virtqueue. Refer to the our clients requirements
and the existing QAT driver, the scenario is even more in NFV.

As your mention here, It's hard to do this IMO, because the backend can't know
the previous session belongs to which requests if we don't pass the session_id
to the backend.

Regards,
-Gonglei
