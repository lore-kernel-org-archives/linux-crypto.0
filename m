From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Linux CryptoAPI Userspace API proposal
Date: Tue, 20 May 2008 12:00:43 +0800
Message-ID: <20080520040043.GA7156@gondor.apana.org.au>
References: <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc> <20080514121855.GA14949@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com> <20080514160941.GA7419@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720DDA@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57148 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbYETEBN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 00:01:13 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604720DDA@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 15, 2008 at 01:16:03PM -0700, Loc Ho wrote:
> 
> Linux Crypto User Space Interface Requirement:
> 
> 1. Support crypto and hashing/digest
> 2. Flexible to support compression in the future
> 3. Flexible to support PKA (public key acceleration) in the future

I think extensibility as you've noted is really important.

As the crypto API is really an algorithm API, please make this
interface generic enough so that adding new (potentially non-crypto)
operations is easy.

> 4. A file descriptor per algorithms
> 5. Key and algorithm attributes provided by user space application
> (caller)

I would say that a file descriptor per tfm would make more sense.

> 8. Support cancel a pending operation for user space caller

We don't need to be able to cancel a specific operation.  The
ability to free a tfm and thereby flushing all requests associated
with it should be enough.

> 3. The type of algorithm, key, and other attributes are selected via IO
> control call. This will be a single call.

Being a single call doesn't matter too much here because this is
the slow path.

> 5. Interface for per operation (such as encrypt, decrypt, compress, PKA,
> and hashing)

It might be useful to consider an interface that allowed in-place
operations.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
