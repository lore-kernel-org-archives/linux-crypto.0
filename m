From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: algif_akcipher user space interface
Date: Wed, 22 Jul 2015 20:55:18 +0200
Message-ID: <7336837.Ud0PiFKhfA@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <1537904.OY6iC43nQX@tachyon.chronox.de> <55AFBE4B.8080805@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47989 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbbGVSz2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 14:55:28 -0400
In-Reply-To: <55AFBE4B.8080805@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. Juli 2015, 09:01:15 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 07/21/2015 03:13 PM, Stephan Mueller wrote:
> > +static ssize_t akcipher_sendpage(struct socket *sock, struct page *page,
> > +				 int offset, size_t size, int flags)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct akcipher_ctx *ctx = ask->private;
> > +	int err = -EINVAL;
> > +
> > +	if (flags & MSG_SENDPAGE_NOTLAST)
> > +		flags |= MSG_MORE;
> > +
> > +	lock_sock(sk);
> > +
> > +	/*
> > +	 * We do not allow mixing of sendmsg and sendpage calls as this would
> > +	 * require a hairy memory management.
> > +	 *
> > +	 * This check also guards against double call of sendpage.
> > +	 * We require that the output buffer size must be provided with one
> > +	 * sendpage request as otherwise we cannot have a linear buffer 
required
> > +	 * by the akcipher API.
> > +	 */
> > +	if (ctx->req_data_ptr)
> > +		goto unlock;
> 
> Shouldn't we be more flexible and copy the data if it comes in chunks here
> too. The user doesn't really have control over this and it would look bad
> if splice would randomly fail for a valid buffer.

I concur with you. But we have only two options:

- either use SGLs which the current akcipher API does not do

- or do a memcpy of the sendpage data into the internal buffer

As the sendpage already has a speed penalty, I did not like the latter one. 
Based on my measurements for AEAD, Hash and skicpher, sendpage starts to 
become faster than sendmsg with input buffers > 8 to 16 kBytes (sendpage as at 
least 4 syscalls where sendmsg uses only two).

As our current akcipher API does not reach the mentioned limit, I opted to 
require one sendpage call.

But if we change the akcipher API to SGLs, I will lift that limit.

Thanks


-- 
Ciao
Stephan
