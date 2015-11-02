From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_hash - Only export and import on
 sockets with data
Date: Mon, 2 Nov 2015 11:12:04 +0800
Message-ID: <20151102031204.GA7372@gondor.apana.org.au>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
 <2587504.xtsMOV5mei@myon.chronox.de>
 <20151101091119.GA3035@gondor.apana.org.au>
 <1470343.4RyZqhtxup@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47329 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbKBDMI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Nov 2015 22:12:08 -0500
Content-Disposition: inline
In-Reply-To: <1470343.4RyZqhtxup@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 01, 2015 at 12:07:12PM +0100, Stephan Mueller wrote:
> Am Sonntag, 1. November 2015, 17:11:19 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Sat, Oct 31, 2015 at 12:45:47AM +0100, Stephan Mueller wrote:
> > > Testing complete: patch solves the oops and allows to successfully perform
> > > HMAC even when having subsequent accepts and operating on those subsequent
> > > accepts.
> > 
> > Thanks Stephan!
> > 
> > Unfortunately my patch is incomplete as some other thread could
> > change ctx->more while we're in the middle of the accept call.
> > 
> > So here is an updated version.
> 
> Shouldn't that patch to into stable (and hopefully into 4.3) as well?

Yes it is going into stable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
