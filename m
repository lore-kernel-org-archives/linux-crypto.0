From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Tue, 28 Apr 2015 04:35:57 +0200
Message-ID: <23448160.9Lv9TcfRHB@myon.chronox.de>
References: <1515730.LIeS5qas5m@myon.chronox.de> <2485784.4PBTOVspUY@tauon> <20150428011047.GB28820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34562 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbbD1Cqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 22:46:48 -0400
In-Reply-To: <20150428011047.GB28820@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. April 2015, 09:10:47 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Apr 27, 2015 at 04:34:19PM +0200, Stephan Mueller wrote:
> > Why do you think that will not work? I thought that the code works when
> > the
> > non-linear scatterlists are at least broken at an 8 byte boundary.
> 
> There is no guarantee that SG lists are set at 8-byte boundaries.
> In fact, you need to be able to handle any SG list, including the
> worst-case 1-byte per-entry SG lists.

In this case, shouldn't we just have a loop where:

1. from the given endpoint, we go a semiblock back

2. now we see how many bytes we get when fetching the SG list till the end,

3a. if answer from 2 is semiblock or larger -> fetch it and exit

3b. if answer from 2 is less than a semiblock, fetch the available data, 
advance to the next SGL and go to step 2 to try to fetch semiblock - obtained 
data.

-- 
Ciao
Stephan
