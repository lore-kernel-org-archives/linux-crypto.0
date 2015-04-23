From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Thu, 23 Apr 2015 03:40:14 +0200
Message-ID: <5183479.mzYUciQITD@myon.chronox.de>
References: <6218629.uO4632Hmli@myon.chronox.de> <1821606.i9q3K48O5i@myon.chronox.de> <20150423013928.GD16834@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34281 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbbDWBlN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:41:13 -0400
In-Reply-To: <20150423013928.GD16834@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. April 2015, 09:39:28 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Apr 22, 2015 at 02:44:08PM +0200, Stephan Mueller wrote:
> > > Where does this 8-byte alignment requirement come from?
> > 
> > Well, I am accessing the data in 8-byte chunks. Moreover, in the
> > scatterwalk copy functions, I search through the scatterlists in 8 byte
> > increments. If, say, a scatterwalk is not a multiple of 8 bytes, the
> > scatterwalk logic will not process the last chunk of memory.
> 
> Alignment refers to whether the address can handle a load of a
> given size by the CPU, it does not mean that the length will
> be a multiple of the alignment.  Alignment is only required if
> you do a load of the given size.
> 
> For example if you read a u64 then on many architectures that
> will require an alignment of 8.  Vice versa if you only do byte
> loads then you do not need to specify the alignment.
> 
> I don't see any u64 loads in your code.

Ok, I will remove it.
> 
> Cheers,


-- 
Ciao
Stephan
