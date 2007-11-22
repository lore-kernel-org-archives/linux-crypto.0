From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Thu, 22 Nov 2007 15:05:00 +0300
Message-ID: <20071122120500.GF28024@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au> <20071122111711.GC2444@2ka.mipt.ru> <20071122112613.GB8781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52729 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXKVMFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:05:16 -0500
Content-Disposition: inline
In-Reply-To: <20071122112613.GB8781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 07:26:13PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Thu, Nov 22, 2007 at 02:17:11PM +0300, Evgeniy Polyakov wrote:
> >
> > > +	spin_lock_bh(&ctx->lock);
> > 
> > Crypto hardware can access iv in interrupt context and thus this can get
> > wrong data.
> 
> This lock only guards against other callers of this function.
> It doesn't care about how you do the underlying encryption.
> You can do it in softirq context, hardirq context, or offload
> it to the moon :)

What if dm-crypt will use the same interface (or other bulk-processing
user) will use it with software crypto? Or was it specially designed for
ipsec only?

> > Are you sure that crypto operation has to be limited to be performed
> > with turned off bottom halves? I believe this is a huge limitation for
> > those ablkcipher devices which are not async actually...
> 
> This only applies to givcrypt which is only used by IPsec where
> we already do everything under a bh lock :)
> 
> New users should specify the IV generator explicitly as is done
> in dm-crypt.

I.e. it is an ipsec helper only and should not be used by other users?

-- 
	Evgeniy Polyakov
