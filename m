From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Tue, 28 Apr 2015 10:50:40 +0800
Message-ID: <20150428025040.GA29738@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <2485784.4PBTOVspUY@tauon>
 <20150428011047.GB28820@gondor.apana.org.au>
 <23448160.9Lv9TcfRHB@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40032 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbbD1Cuq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 22:50:46 -0400
Content-Disposition: inline
In-Reply-To: <23448160.9Lv9TcfRHB@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2015 at 04:35:57AM +0200, Stephan Mueller wrote:
>
> In this case, shouldn't we just have a loop where:
> 
> 1. from the given endpoint, we go a semiblock back
> 
> 2. now we see how many bytes we get when fetching the SG list till the end,
> 
> 3a. if answer from 2 is semiblock or larger -> fetch it and exit
> 
> 3b. if answer from 2 is less than a semiblock, fetch the available data, 
> advance to the next SGL and go to step 2 to try to fetch semiblock - obtained 
> data.

The problem is that the SG list is not designed to be walked over
backwards.  So you always have to start from the beginning and go
to the end, for every block.  There is no easy way of saying give
me the next SG.  You have to go back to the beginning and find it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
