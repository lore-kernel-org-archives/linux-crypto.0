From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: caam - fix printk recursion for long error
	texts
Date: Wed, 4 May 2011 15:28:40 +1000
Message-ID: <20110504052840.GA7258@gondor.apana.org.au>
References: <20110502182917.4400d8e2.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Steve Cornelius <sec@pobox.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42559 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1EDF2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2011 01:28:45 -0400
Content-Disposition: inline
In-Reply-To: <20110502182917.4400d8e2.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 02, 2011 at 06:29:17PM -0500, Kim Phillips wrote:
> during recent descriptor development, an Invalid Sequence Command
> error triggered a:
> 
> BUG: recent printk recursion!
> 
> due to insufficient memory allocated for the error text.
> 
> The Invalid Sequence Command error text is the longest.
> The length of the maximum error string is computed as
> the sum of:
> 
> "DECO: ": 6
> "jump tgt desc idx 255: ": 23
> Invalid Sequence Command text: 272
> zero termination character: 1
> 
> i.e, 302 characters.
> 
> Define this maximum error string length in error.h and fix
> caam_jr_strstatus callsites.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
