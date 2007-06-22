From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 20:37:31 +0800
Message-ID: <20070622123731.GB29919@gondor.apana.org.au>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc> <20070605130731.GA4643@2ka.mipt.ru> <20070605150245.GA29400@2ka.mipt.ru> <20070622073448.GB27341@gondor.apana.org.au> <20070622115859.GB29425@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3647 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752809AbXFVMhe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 08:37:34 -0400
Content-Disposition: inline
In-Reply-To: <20070622115859.GB29425@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2007 at 03:58:59PM +0400, Evgeniy Polyakov wrote:
>
> > The crypto_alg object should contain a back pointer to the device.
> > In setkey, you have access to a tfm object which has a pointer to
> > the crypto_alg object.
> 
> crypto_alg does not contain it, or do I miss something?

You're right that it's not there as such.  However, there's
nothing stopping you from allocating struct crypto_alg + ctx
and putting your pointer there.

To make this easier, I'll add a pointer to the API explicitly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
