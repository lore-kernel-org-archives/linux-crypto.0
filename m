From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: Questions about the Crypto API
Date: Tue, 6 Aug 2013 09:05:41 -0300
Message-ID: <20130806120540.GA364@oc8526070481.ibm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:54579 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3HFMFv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Aug 2013 08:05:51 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Tue, 6 Aug 2013 09:05:48 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 1AF103520060
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2013 08:05:46 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r76C1P5o987188
	for <linux-crypto@vger.kernel.org>; Tue, 6 Aug 2013 09:01:25 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r76C5j6s004278
	for <linux-crypto@vger.kernel.org>; Tue, 6 Aug 2013 09:05:45 -0300
Content-Disposition: inline
In-Reply-To: <20130806070010.GB19754@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Thanks for your answers.

On Tue, Aug 06, 2013 at 05:00:10PM +1000, Herbert Xu wrote:
> On Mon, Aug 05, 2013 at 05:25:57PM -0300, Marcelo Cerri wrote:
> >
> > My first doubt is regarding which kind of concurrency the Crypto API
> > allows. For example, can a single `struct crypto_tfm` be used by two
> > concurrent calls? I'm asking about that because I noticed that for
> 
> Yes.
> 
> > blkcipher the only implementation-specific context that can be used is
> > allocated inside the tfm struct.
> 
> Both blkcipher and ablkcipher are meant to be fully reentrant.
> So you must take necessary precautions if your implementation
> is not reentrant, e.g., by locking.

I was considering a spin lock for that, since the cryptographic
functions can be called from a softirq context. However I don't consider
a lock a good solution because that could be done without any locks if
it was possible to keep the current state separated for each operation
in progress.

> 
> > I'm working to fix some bugs in the NX driver (located in
> > drivers/crypto/nx), and one issue that we are facing is that NFS when
> > using Kerberos uses the same tfm with different kthreads. That causes
> > concurrent accesses to the internal data stored into the context and
> > incorrect results.
> > 
> > So my question here is: should this type of concurrency be handled by
> > the driver or a caller is not allowed to use the same tfm for concurrent
> > calls?
> 
> From what you've said NFS seems to be doing the right thing, so the
> bug would be in the driver.
> 
> > My second doubt is regarding the difference between ablkcipher and
> > blkcipher. I do understand their difference from caller's point of view.
> > But I'm not sure what are the consequences of implementing a driver
> > using one or another option.
> > 
> > For example, can a blkcipher implementation be used asynchronously and
> > vice versa?
> 
> In general which model you pick for drivers depend on what your
> hardware looks like.  For example, padlock-aes uses the blkcipher
> model because the hardware presents itself through a synchronous
> CPU instruction, while most other drivers use the ablkcipher
> interface because the underlying hardware completes asynchronously.
> 
> A blkcipher implementation is always available through both the
> blkcipher and the ablkcipher interface.  While an ablkcipher
> implementaiton can only be used through the ablkcipher interface.

Now a lot of things start to make sense :P

So is that the reason because some drivers implement an ablkcipher and
then re-implements the same algorithm as a blkcipher just using a wrapper
over the asynchronous version?

I saw it's possible to keep a context in an ablkcipher_request
structure. I'm assuming that multiple callers using the same tfm still
would have to use different requests. So do you think that implementing
it as an asynchronous block cipher would be an alternative to locks in
the NX driver?

Regards,
Marcelo
