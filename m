From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - Add top-level skcipher interface
Date: Sun, 23 Aug 2015 20:16:45 +0200
Message-ID: <2086835.vbcqvJ9BvG@tachyon.chronox.de>
References: <20150820072055.GA27176@gondor.apana.org.au> <3197252.zpooAnFuUp@tauon.atsec.com> <20150821092754.GA6854@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48144 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbbHWSQw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Aug 2015 14:16:52 -0400
In-Reply-To: <20150821092754.GA6854@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. August 2015, 17:27:54 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Aug 21, 2015 at 11:24:08AM +0200, Stephan Mueller wrote:
> > If I understand the patch set correctly, a caller uses the skcipher API
> > and
> > the API sets up the synchronous or asynchronous callbacks depending on the
> > chosen cipher implementation.
> > 
> > Now, does a caller always need to create an skcipher_request and always
> > need the async logic of providing a callback function and the like, even
> > though a synchronous cipher is chosen? I.e. the caller has no means to
> > use a synchronous cipher operation any more.
> > 
> > It looks to me like that, but I would like to confirm.
> 
> No you can still use it synchronously.  When allocating it you
> should do this:
> 
> 	crypto_alloc_skcipher(name, 0, CRYPTO_ALG_ASYNC)
> 
> When setting up the request just leave the callback and data as
> NULL.

Thank you. The sync and async skcipher API:

Tested-by: Stephan Mueller <smueller@chronox.de>

-- 
Ciao
Stephan
