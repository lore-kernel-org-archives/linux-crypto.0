From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: algif_hash - Only export and import on sockets with data
Date: Sun, 01 Nov 2015 12:07:12 +0100
Message-ID: <1470343.4RyZqhtxup@myon.chronox.de>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com> <2587504.xtsMOV5mei@myon.chronox.de> <20151101091119.GA3035@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34491 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbbKALHQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Nov 2015 06:07:16 -0500
In-Reply-To: <20151101091119.GA3035@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 1. November 2015, 17:11:19 schrieb Herbert Xu:

Hi Herbert,

> On Sat, Oct 31, 2015 at 12:45:47AM +0100, Stephan Mueller wrote:
> > Testing complete: patch solves the oops and allows to successfully perform
> > HMAC even when having subsequent accepts and operating on those subsequent
> > accepts.
> 
> Thanks Stephan!
> 
> Unfortunately my patch is incomplete as some other thread could
> change ctx->more while we're in the middle of the accept call.
> 
> So here is an updated version.

Shouldn't that patch to into stable (and hopefully into 4.3) as well?

-- 
Ciao
Stephan
