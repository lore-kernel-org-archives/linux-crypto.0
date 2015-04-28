From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Tue, 28 Apr 2015 09:10:47 +0800
Message-ID: <20150428011047.GB28820@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <3407264.GJDOVGtEDe@myon.chronox.de>
 <20150427082607.GA21590@gondor.apana.org.au>
 <2485784.4PBTOVspUY@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40229 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbbD1BKu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 21:10:50 -0400
Content-Disposition: inline
In-Reply-To: <2485784.4PBTOVspUY@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 27, 2015 at 04:34:19PM +0200, Stephan Mueller wrote:
>
> Why do you think that will not work? I thought that the code works when the 
> non-linear scatterlists are at least broken at an 8 byte boundary.

There is no guarantee that SG lists are set at 8-byte boundaries.
In fact, you need to be able to handle any SG list, including the
worst-case 1-byte per-entry SG lists.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
