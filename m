From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 15:58:59 +0400
Message-ID: <20070622115859.GB29425@2ka.mipt.ru>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc> <20070605130731.GA4643@2ka.mipt.ru> <20070605150245.GA29400@2ka.mipt.ru> <20070622073448.GB27341@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46820 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbXFVL7X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 07:59:23 -0400
Content-Disposition: inline
In-Reply-To: <20070622073448.GB27341@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2007 at 03:34:48PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Tue, Jun 05, 2007 at 07:02:45PM +0400, Evgeniy Polyakov wrote:
> > 
> > Herbert, could you please elaborate how to provide a private pointer
> > into cra_init without searching via static lists of all devices?
> 
> The crypto_alg object should contain a back pointer to the device.
> In setkey, you have access to a tfm object which has a pointer to
> the crypto_alg object.

crypto_alg does not contain it, or do I miss something?

-- 
	Evgeniy Polyakov
