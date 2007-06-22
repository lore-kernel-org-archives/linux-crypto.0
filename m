From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 17:32:06 +0400
Message-ID: <20070622133205.GA28828@2ka.mipt.ru>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc> <20070605130731.GA4643@2ka.mipt.ru> <20070605150245.GA29400@2ka.mipt.ru> <20070622073448.GB27341@gondor.apana.org.au> <20070622115859.GB29425@2ka.mipt.ru> <20070622123731.GB29919@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48701 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXFVNcV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 09:32:21 -0400
Content-Disposition: inline
In-Reply-To: <20070622123731.GB29919@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2007 at 08:37:31PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Fri, Jun 22, 2007 at 03:58:59PM +0400, Evgeniy Polyakov wrote:
> >
> > > The crypto_alg object should contain a back pointer to the device.
> > > In setkey, you have access to a tfm object which has a pointer to
> > > the crypto_alg object.
> > 
> > crypto_alg does not contain it, or do I miss something?
> 
> You're right that it's not there as such.  However, there's
> nothing stopping you from allocating struct crypto_alg + ctx
> and putting your pointer there.

Argh, I understand now. I will create an access wrapper in HIFN driver
for such access for now, if there will be some API changes it will be
possible to rewrite.

-- 
	Evgeniy Polyakov
